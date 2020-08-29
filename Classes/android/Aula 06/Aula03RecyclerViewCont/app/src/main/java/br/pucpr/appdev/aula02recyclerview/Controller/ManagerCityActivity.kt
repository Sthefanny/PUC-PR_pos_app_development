package br.pucpr.appdev.aula02recyclerview.Controller

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import androidx.recyclerview.widget.LinearLayoutManager
import br.pucpr.appdev.aula02recyclerview.Model.City
import br.pucpr.appdev.aula02recyclerview.Model.DataStore
import br.pucpr.appdev.aula02recyclerview.R
import br.pucpr.appdev.aula02recyclerview.View.CityAdapter
import br.pucpr.appdev.aula02recyclerview.View.ContactAdapter
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.activity_manager_city.*
import kotlinx.android.synthetic.main.activity_manager_city.toolbar

class ManagerCityActivity : AppCompatActivity() {

    var position = 0
    var type = 0
    lateinit var adapter: ContactAdapter
    val REQUEST_CODE_ADD = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_manager_city)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "Gerenciar Cidade"

        type = intent.getIntExtra("type", 1)

        if (type == 2) {

            position = intent.getIntExtra("position", 0)
            val city = DataStore.getCity(position)

            txtCity.setText(city.name)
            txtPeople.setText(city.people.toString())

            val layoutManager = LinearLayoutManager(this)
            rcvContacts.layoutManager = layoutManager
            adapter = ContactAdapter(DataStore.getContacts(city))
            rcvContacts.adapter = adapter
        }
        else {
            layContacts.visibility = View.INVISIBLE
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {

        menuInflater.inflate(R.menu.menu_manager_city, menu)

        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {

        when(item.itemId) {
            R.id.mnuSave -> {

                val city = City(txtCity.text.toString(), txtPeople.text.toString().toInt())

                if (type == 1) {

                    DataStore.addCity(city)
                }
                else if (type == 2) {

                    DataStore.editCity(city, position)
                }

                val intent = Intent().apply {
                    putExtra("cityName", city.name)
                }
                setResult(Activity.RESULT_OK, intent)
                finish()
            }
            android.R.id.home -> {
                finish()
            }
        }

        return super.onOptionsItemSelected(item)
    }

    fun btnAddContactOnClick(view: View) {
        val city = DataStore.getCity(position)

        val intent = Intent(this, ContactActivity::class.java).apply {
            putExtra("city", city.id)
        }
        startActivityForResult(intent, REQUEST_CODE_ADD)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == REQUEST_CODE_ADD && resultCode == Activity.RESULT_OK) {
            adapter.notifyDataSetChanged()
        }
    }
}
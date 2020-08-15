package br.pucpr.appdev.aula02recyclerview.Controller

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.widget.ArrayAdapter
import br.pucpr.appdev.aula02recyclerview.Model.City
import br.pucpr.appdev.aula02recyclerview.Model.DataStore
import br.pucpr.appdev.aula02recyclerview.R
import kotlinx.android.synthetic.main.activity_manager_city.*

class ManagerCityActivity : AppCompatActivity() {

    var position = 0
    var type = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_manager_city)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "Gerenciar Cidade"

        var adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, DataStore.states)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)

        spnState.adapter = adapter
        spnState.setSelection(0, false)

        type = intent.getIntExtra("type", 1)

        if (type == 2) {

            position = intent.getIntExtra("position", 0)
            val city = DataStore.getCity(position)

            txtCity.setText(city.name)
            spnState.setSelection(city.state, true)
            txtPeople.setText(city.people.toString())
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

                city.state = spnState.selectedItemPosition

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
}
package br.pucpr.appdev.aula02recyclerview.Controller

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import br.pucpr.appdev.aula02recyclerview.Controller.Interfaces.LoadReceiverDelegate
import br.pucpr.appdev.aula02recyclerview.Model.City
import br.pucpr.appdev.aula02recyclerview.Model.DataStore
import br.pucpr.appdev.aula02recyclerview.R
import kotlinx.android.synthetic.main.activity_manager_city.*

class ManagerCityActivity : AppCompatActivity(), LoadReceiverDelegate {

    var position = 0
    var type = 0
    var cityName = ""

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
                cityName = city.name

                if (type == 1) {

                    DataStore.addCity(city, this)
                }
                else if (type == 2) {
                    city.id = DataStore.getCity(position).id
                    DataStore.editCity(city, position, this)
                }
            }
            android.R.id.home -> {
                finish()
            }
        }

        return super.onOptionsItemSelected(item)
    }

    override fun setStatus(status: Boolean) {
        if (status) {
            val intent = Intent().apply {
                putExtra("cityName", cityName)
            }
            setResult(RESULT_OK, intent)
        }
        else {
            setResult(RESULT_CANCELED)
        }

        finish()
    }
}
package br.com.sthefanny.aula02menuapp.Controller

import android.app.Activity
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import br.com.sthefanny.aula02menuapp.Model.City
import br.com.sthefanny.aula02menuapp.Model.DataStore
import br.com.sthefanny.aula02menuapp.R
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

        type = intent.getIntExtra("type", 1)

        if (type == 2) {
            position = intent.getIntExtra("position", 0)
            val city = DataStore.getCity(position)

            txtCity.setText(city.name)
            txtPeople.setText(city.people.toString())
        }
    }


    fun AddEditPokemonButton(view: View) {}
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
}
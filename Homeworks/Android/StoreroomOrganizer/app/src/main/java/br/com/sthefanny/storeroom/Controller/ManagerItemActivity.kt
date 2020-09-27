package br.com.sthefanny.storeroom.Controller

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import br.com.sthefanny.storeroom.Controller.Interfaces.LoadReceiverDelegate
import br.com.sthefanny.storeroom.Model.DataStore
import br.com.sthefanny.storeroom.Model.Item
import br.com.sthefanny.storeroom.R
import kotlinx.android.synthetic.main.activity_manager_item.*
import kotlinx.android.synthetic.main.rcv_items.*

class ManagerItemActivity : AppCompatActivity(), LoadReceiverDelegate {

    var position = 0
    var type = 0
    var name = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_manager_item)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "Gerenciar Cidade"

        type = intent.getIntExtra("type", 1)

        if (type == 2) {

            position = intent.getIntExtra("position", 0)
            val city = DataStore.getItem(position)

            txtCity.setText(city.name)
            txtPeople.setText(city.quantity.toString())
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {

        menuInflater.inflate(R.menu.menu_manager_item, menu)

        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {

        when(item.itemId) {
            R.id.mnuSave -> {

                val item = Item(imgItem.toString(), txtCity.text.toString(), txtQuantity.text.toString().toInt())
                name = item.name

                if (type == 1) {

                    DataStore.addItem(item, this)
                }
                else if (type == 2) {
                    item.id = DataStore.getItem(position).id
                    DataStore.editCity(item, position, this)
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
                putExtra("name", name)
            }
            setResult(RESULT_OK, intent)
        }
        else {
            setResult(RESULT_CANCELED)
        }

        finish()
    }
}
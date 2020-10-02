package br.com.sthefanny.storeroom.Controller

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import br.com.sthefanny.storeroom.Controller.Interfaces.LoadReceiverDelegate
import br.com.sthefanny.storeroom.Model.DataStore
import br.com.sthefanny.storeroom.Model.Store
import br.com.sthefanny.storeroom.R
import kotlinx.android.synthetic.main.activity_manager_store.*
import kotlinx.android.synthetic.main.rcv_stores.*

class ManagerStoreActivity : AppCompatActivity(), LoadReceiverDelegate {

    var position = 0
    var type = 0
    var name = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_manager_store)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "Gerenciar Itens na Dispensa"

        type = intent.getIntExtra("type", 1)

        if (type == 2) {

            position = intent.getIntExtra("position", 0)
            val city = DataStore.getItemFromStore(position)

            txtCity.setText(city.productName)
            txtPeople.setText(city.quantity.toString())
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {

        menuInflater.inflate(R.menu.menu_manager_store, menu)

        return true
    }

    override fun onOptionsItemSelected(store: MenuItem): Boolean {

        when(store.itemId) {
            R.id.mnuSave -> {

                val store = Store(0, txtProductName.text.toString(), txtQuantity.text.toString().toInt(), txtUnitMeasurement.text.toString().toInt())
                name = store.productName

                if (type == 1) {

                    DataStore.addItemToStore(store, this)
                }
                else if (type == 2) {
                    store.id = DataStore.getItemFromStore(position).id
                    DataStore.editItemFromStore(store, position, this)
                }
            }
            android.R.id.home -> {
                finish()
            }
        }

        return super.onOptionsItemSelected(store)
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
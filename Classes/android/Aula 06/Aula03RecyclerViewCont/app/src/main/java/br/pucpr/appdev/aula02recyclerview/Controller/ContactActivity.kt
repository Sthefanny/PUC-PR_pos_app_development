package br.pucpr.appdev.aula02recyclerview.Controller

import android.app.Activity
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import br.pucpr.appdev.aula02recyclerview.Model.Contact
import br.pucpr.appdev.aula02recyclerview.Model.DataStore
import br.pucpr.appdev.aula02recyclerview.R
import kotlinx.android.synthetic.main.activity_contact.*

class ContactActivity : AppCompatActivity() {

    var city: Long = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_contact)

        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "Adicionar Contato"

        city = intent.getLongExtra("city", 0)
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {

        menuInflater.inflate(R.menu.menu_manager_city, menu)

        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {

        when(item.itemId) {
            R.id.mnuSave -> {

                val contact = Contact(txtName.text.toString(), txtPhone.text.toString(), city.toInt())

                DataStore.addContact(contact)

                setResult(Activity.RESULT_OK)
                finish()
            }
            android.R.id.home -> {
                finish()
            }
        }

        return super.onOptionsItemSelected(item)
    }
}
package br.com.sthefanny.storeroom.Controller

import android.content.Intent
import android.content.res.Resources
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.ArrayAdapter
import androidx.appcompat.app.AppCompatActivity
import br.com.sthefanny.storeroom.Controller.Interfaces.LoadReceiverDelegate
import br.com.sthefanny.storeroom.Model.DataStore
import br.com.sthefanny.storeroom.Model.Product
import br.com.sthefanny.storeroom.Model.Store
import br.com.sthefanny.storeroom.Model.UnitMeasurementEnum
import br.com.sthefanny.storeroom.R
import kotlinx.android.synthetic.main.activity_manager_store.*


class ManagerStoreActivity : AppCompatActivity(), LoadReceiverDelegate {

    var position = 0
    var type = 0
    var name = ""
    lateinit var adapterProducts: ArrayAdapter<Product>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_manager_store)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "Gerenciar Itens na Dispensa"

        val res: Resources = resources
        val weight: UnitMeasurementEnum = UnitMeasurementEnum.WEIGHT
        val pack: UnitMeasurementEnum = UnitMeasurementEnum.PACK
        val weightLocalized = res.getString(res.getIdentifier(weight.name, "string", packageName))
        val packLocalized = res.getString(res.getIdentifier(pack.name, "string", packageName))

        var listUnit: MutableList<String> = arrayListOf()
        listUnit.add(weightLocalized)
        listUnit.add(packLocalized)

        var adapterUnit = ArrayAdapter(
            this,
            android.R.layout.simple_spinner_item,
            listUnit
        )
        adapterUnit.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)

        spnUnitMeasurement.adapter = adapterUnit
        spnUnitMeasurement.setSelection(0, false)

        adapterProducts = ArrayAdapter(
            this,
            android.R.layout.simple_spinner_item,
            DataStore.products
        )
        adapterProducts.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)

        spnProducts.adapter = adapterProducts
        spnProducts.setSelection(0, false)

//        spnProducts.setOnItemSelectedListener(object : OnItemSelectedListener {
//            override fun onItemSelected(
//                parent: AdapterView<*>?,
//                view: View?,
//                position: Int,
//                id: Long
//            ) {
//                val product: Product = parent?.getSelectedItem() as Product
//                displayUserData(product)
//            }
//
//            override fun onNothingSelected(parent: AdapterView<*>?) {}
//        })

        type = intent.getIntExtra("type", 1)

        if (type == 2) {

            position = intent.getIntExtra("position", 0)
            val store = DataStore.getItemFromStore(position)
            val product = DataStore.getProductById(store.productId)

            name = product?.name ?: ""

            txtQuantity.setText(store.quantity.toString())
            var selectedProduct = adapterProducts.getPosition(product)
            spnProducts.setSelection(selectedProduct, false)
            spnUnitMeasurement.setSelection(store.unitMeasurement, false)
        }
    }

//    fun getSelectedUser(v: View?) {
//        val product: Product = spnProducts.getSelectedItem() as Product
//        displayUserData(product)
//    }
//
//    private fun displayUserData(product: Product) {
//        val name: String = product.name
//        val id: Int = product.id
//        val productData = name
//        Toast.makeText(this, productData, Toast.LENGTH_LONG).show()
//    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {

        menuInflater.inflate(R.menu.menu_manager_store, menu)

        return true
    }

    override fun onOptionsItemSelected(store: MenuItem): Boolean {

        when(store.itemId) {
            R.id.mnuSave -> {

                val store = Store(0, "", txtQuantity.text.toString().toInt(), 1)
                name = store.productName

                if (type == 1) {

                    DataStore.addItemToStore(store, this)
                } else if (type == 2) {
                    store.id = DataStore.getItemFromStore(position).id

                    val product: Product = spnProducts.getSelectedItem() as Product

                    store.productId = product.id

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

    fun quantityIncreaseOnClick(view: View) {
        var quantity: Int = txtQuantity.text.toString().toInt()
        var newQuantity = quantity + 1

        txtQuantity.setText(newQuantity.toString())
    }

    fun quantityDecreaseOnClick(view: View) {
        var quantity: Int = txtQuantity.text.toString().toInt()
        var newQuantity = quantity - 1

        if (newQuantity >= 0){
            txtQuantity.setText(newQuantity.toString())
        }
    }
}
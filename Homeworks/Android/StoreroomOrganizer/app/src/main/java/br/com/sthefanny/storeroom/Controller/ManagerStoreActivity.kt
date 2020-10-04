package br.com.sthefanny.storeroom.Controller

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.ArrayAdapter
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import br.com.sthefanny.storeroom.Model.*
import br.com.sthefanny.storeroom.R
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.activity_manager_store.*
import kotlinx.android.synthetic.main.activity_manager_store.txtQuantity
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.OutputStream
import java.util.*


class ManagerStoreActivity : AppCompatActivity() {

    var position = 0
    var type = 0
    var name = ""
    val REQUEST_IMAGE_CAPTURE = 3
    val IMAGE_PICK_CODE = 4
    lateinit var bitmap: Bitmap
    lateinit var adapterProducts: ArrayAdapter<Product>
    var imageAdded: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_manager_store)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "Gerenciar Itens na Dispensa"

        var adapterUnit = ArrayAdapter(
            this,
            android.R.layout.simple_spinner_item,
            DataStore.unitMeasurements
        )
        adapterUnit.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)

        spnUnitMeasurement.adapter = adapterUnit
        spnUnitMeasurement.setSelection(0, false)

        DataStore.products.add(0, Product("Escolha ou crie um novo"))

        adapterProducts = ArrayAdapter(
            this,
            android.R.layout.simple_spinner_item,
            DataStore.products
        )
        adapterProducts.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)

        spnProducts.adapter = adapterProducts
        spnProducts.setSelection(0, false)

        type = intent.getIntExtra("type", 1)

        if (type == 2) {

            position = intent.getIntExtra("position", 0)
            val store = DataStore.getItemFromStore(position)
            val product = DataStore.getProductById(store.productId)

            name = product?.name ?: ""

            txtQuantity.setText(store.quantity.toString())
            var selectedProduct = adapterProducts.getPosition(product)
            spnProducts.setSelection(selectedProduct, false)
            spnUnitMeasurement.setSelection(store.unitMea, false)

            val imageUrl = "${DataStore.baseUrl}${store.imageUrl}"
            Picasso.get().load(Uri.parse(imageUrl)).into(imvImagem)
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {

        menuInflater.inflate(R.menu.menu_manager_store, menu)

        return true
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_IMAGE_CAPTURE && resultCode == RESULT_OK) {
            val imageBitmap = data?.extras?.get("data") as Bitmap
            imvImagem.setImageBitmap(imageBitmap)
            bitmap = imageBitmap
            imageAdded = true
        }
        if (resultCode == Activity.RESULT_OK && requestCode == IMAGE_PICK_CODE){
            imvImagem.setImageURI(data?.data)
            bitmap = (imvImagem.drawable as BitmapDrawable).bitmap
            imageAdded = true
        }
    }

    override fun onOptionsItemSelected(store: MenuItem): Boolean {

        when(store.itemId) {
            R.id.mnuSave -> {
                imageAdded = false
                val product: Product = spnProducts.getSelectedItem() as Product
                val unitMea: UnitMeasurement = spnUnitMeasurement.getSelectedItem() as UnitMeasurement
                var productId: Int = 0

                val unitMeasurement = unitMea.id

                if (product.id > 0) {
                    productId = product.id
                }

                var productName =  name
                if (txtProduct.text.isNotEmpty()){
                    productName = txtProduct.text.toString()
                }

                val store = Store(productId, productName, txtQuantity.text.toString().toInt(), unitMeasurement, "")

                if (type == 1) {
                    DataStore.addItemToStore(store) {responseModel -> handleAddItemToStore(responseModel)}
                } else if (type == 2) {
                    store.id = DataStore.getItemFromStore(position).id

                    val product: Product = spnProducts.getSelectedItem() as Product
                    val unitMea: UnitMeasurement = spnUnitMeasurement.getSelectedItem() as UnitMeasurement

                    store.productId = product.id
                    store.unitMea = unitMea.id

                    DataStore.editItemFromStore(store){responseModel -> handleAddItemToStore(responseModel)}
                }
            }
            android.R.id.home -> {
                finish()
            }
        }

        return super.onOptionsItemSelected(store)
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

    fun takePictureOnClick(view: View) {
        dispatchTakePictureIntent()
    }

    fun galleryOnClick(view: View) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M){
            if (checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) ==
                PackageManager.PERMISSION_DENIED){
                //permission denied
                val permissions = arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE);
                //show popup to request runtime permission
                requestPermissions(permissions, PERMISSION_CODE);
            }
            else{
                //permission already granted
                pickImageFromGallery();
            }
        }
        else{
            //system OS is < Marshmallow
            pickImageFromGallery();
        }
    }

    private fun pickImageFromGallery() {
        //Intent to pick image
        val intent = Intent(Intent.ACTION_PICK)
        intent.type = "image/*"
        startActivityForResult(intent, IMAGE_PICK_CODE)
    }

    private fun dispatchTakePictureIntent() {
        Intent(MediaStore.ACTION_IMAGE_CAPTURE).also { takePictureIntent ->
            takePictureIntent.resolveActivity(packageManager)?.also {
                startActivityForResult(takePictureIntent, REQUEST_IMAGE_CAPTURE)
            }
        }
    }

    companion object {
        //image pick code
        private val IMAGE_PICK_CODE = 1000;
        //Permission code
        private val PERMISSION_CODE = 1001;
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        when(requestCode){
            PERMISSION_CODE -> {
                if (grantResults.size >0 && grantResults[0] ==
                    PackageManager.PERMISSION_GRANTED){
                    //permission from popup granted
                    pickImageFromGallery()
                }
                else{
                    //permission from popup denied
                    Toast.makeText(this, "Permission denied", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

    private fun bitmapToFile(bitmap:Bitmap): Uri {
        // Get the context wrapper
        val wrapper = ContextWrapper(applicationContext)

        // Initialize a new file instance to save bitmap object
        var file = wrapper.getDir("Images", Context.MODE_PRIVATE)
        file = File(file,"${UUID.randomUUID()}.jpg")

        try{
            // Compress the bitmap and save in jpg format
            val stream: OutputStream = FileOutputStream(file)
            bitmap.compress(Bitmap.CompressFormat.JPEG,100,stream)
            stream.flush()
            stream.close()
        }catch (e: IOException){
            e.printStackTrace()
        }

        // Return the saved bitmap uri
        return Uri.parse(file.absolutePath)
    }

    private fun getFileFromImage(): File {
        val uri = bitmapToFile(bitmap)
        var file = File(uri.getPath())
        return file
    }

    private fun handleAddItemToStore(responseModel: ResponseModel) {
        if (responseModel.hasError != null && responseModel.hasError!!) {
            Toast.makeText(this, responseModel.error, Toast.LENGTH_SHORT).show()
        }
        else if (responseModel.hasSuccess != null && responseModel.hasSuccess!!) {
            if(imageAdded){
                var file = getFileFromImage()
                responseModel.createdId?.let { DataStore.addImageToStore(it, file) {responseModel -> handleAddImageToItem(responseModel)} }
            }
            else {
                setResultAndFinish()
            }
        }
    }

    private fun handleAddImageToItem(responseModel: ResponseModel) {
        if (responseModel.hasError != null && responseModel.hasError!!) {
            Toast.makeText(this, responseModel.error, Toast.LENGTH_SHORT).show()
        }
        else if (responseModel.hasSuccess != null && responseModel.hasSuccess!!) {
//            Toast.makeText(this, responseModel.success, Toast.LENGTH_SHORT).show()
            setResultAndFinish()
        }
    }

    private fun setResultAndFinish() {
        val intent = Intent().apply {
            putExtra("name", name)
        }
        setResult(RESULT_OK, intent)

        finish()
    }
}
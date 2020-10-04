package br.com.sthefanny.storeroom.Controller

import android.app.Activity
import android.content.DialogInterface
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.GestureDetector
import android.view.Menu
import android.view.MenuItem
import android.view.MotionEvent
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import br.com.sthefanny.storeroom.Model.*
import br.com.sthefanny.storeroom.R
import br.com.sthefanny.storeroom.View.StoreAdapter
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.android.synthetic.main.activity_main.toolbar
import kotlinx.android.synthetic.main.activity_manager_store.*

class MainActivity : AppCompatActivity() {

    val REQUEST_CODE_ADD = 1
    val REQUERT_CODE_UPDATE = 2
    var productName: String = ""

    private var adapter: StoreAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)

        DataStore.loadAllProducts {responseModel -> handleResult(responseModel)}

        fab.setOnClickListener {
            val intent = Intent(this@MainActivity, ManagerStoreActivity::class.java).apply {
                putExtra("type", 1)
            }
            startActivityForResult(intent, REQUEST_CODE_ADD)
        }

        val gestureDetector = GestureDetector(this, object : GestureDetector.SimpleOnGestureListener() {

            override fun onSingleTapConfirmed(e: MotionEvent?): Boolean {

                e?.let {

                    val view = rcvStores.findChildViewUnder(e.x, e.y)
                    view?.let {

                        val position = rcvStores.getChildAdapterPosition(view)
                        val store = DataStore.getItemFromStore(position)

                        val intent = Intent(this@MainActivity, ManagerStoreActivity::class.java).apply {
                            putExtra("type", 2)
                            putExtra("position", position)
                        }
                        startActivityForResult(intent, REQUERT_CODE_UPDATE)
                    }

                }

                return super.onSingleTapConfirmed(e)
            }

            override fun onLongPress(e: MotionEvent?) {
                super.onLongPress(e)

                e?.let {

                    val view = rcvStores.findChildViewUnder(e.x, e.y)
                    view?.let {

                        val position = rcvStores.getChildAdapterPosition(view)
                        val store = DataStore.getItemFromStore(position)

                        val dialog = AlertDialog.Builder(this@MainActivity)
                        dialog.setTitle("Organizador de Despensa")
                        dialog.setMessage("Tem certeza que deseja excluir este produto?")
                        dialog.setPositiveButton("Excluir", DialogInterface.OnClickListener { dialog, which ->
                            productName = store.product
                            DataStore.removeItemFromStore(position){responseModel -> handleRemoveitem(responseModel)}
                        })
                        dialog.setNegativeButton("Cancelar", null)
                        dialog.show()
                    }

                }
            }
        })

        rcvStores.addOnItemTouchListener(object : RecyclerView.OnItemTouchListener {
            override fun onTouchEvent(rv: RecyclerView, e: MotionEvent) {
                TODO("Not yet implemented")
            }

            override fun onInterceptTouchEvent(rv: RecyclerView, e: MotionEvent): Boolean {

                val child = rv.findChildViewUnder(e.x, e.y);

                return (child != null && gestureDetector.onTouchEvent(e))
            }

            override fun onRequestDisallowInterceptTouchEvent(disallowIntercept: Boolean) {
                TODO("Not yet implemented")
            }

        })
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {

        menuInflater.inflate(R.menu.menu_manager_list, menu)

        return true
    }

    fun updateCollapsinTitle() {

        collapsingToolbar.title = "${getString(R.string.collapsinTitle)} (${DataStore.stores.size})"
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        var name = ""
        data?.let {

            name = data.getStringExtra("name").toString()
        } ?: run {

            name = "Erro de nome"
        }

        if (requestCode == REQUEST_CODE_ADD) {

            if (resultCode == Activity.RESULT_OK) {

                Snackbar.make(layMain, "Produto adicionado: ${name}", Snackbar.LENGTH_LONG).show()
                adapter!!.notifyDataSetChanged()
                updateCollapsinTitle()
                DataStore.loadAllProducts {responseModel -> handleResult(responseModel)}
            }
        }

        if (requestCode == REQUERT_CODE_UPDATE) {

            if (resultCode == Activity.RESULT_OK) {

                Snackbar.make(layMain, "Produto alterado: ${name}", Snackbar.LENGTH_LONG).show()
                adapter!!.notifyDataSetChanged()
                DataStore.loadAllProducts {responseModel -> handleResult(responseModel)}
            }
        }
    }

    override fun onOptionsItemSelected(store: MenuItem): Boolean {

        when(store.itemId) {
            R.id.mnuLogout -> {
                val dialog = AlertDialog.Builder(this@MainActivity)
                dialog.setTitle("Organizador de Despensa")
                dialog.setMessage("Tem certeza que deseja deslogar do aplicativo?")
                dialog.setPositiveButton("Deslogar", DialogInterface.OnClickListener { dialog, which ->
                    DataStore.logoutUser {responseModel -> handleLogout(responseModel)}
                })
                dialog.setNegativeButton("Cancelar", null)
                dialog.show()
            }
            android.R.id.home -> {
                finish()
            }
        }

        return super.onOptionsItemSelected(store)
    }

    private fun handleResult(responseModel: ResponseModel) {
        if (responseModel.hasError != null && responseModel.hasError!!) {
            Toast.makeText(this, responseModel.error, Toast.LENGTH_SHORT).show()
        }
        else if (responseModel.hasSuccess != null && responseModel.hasSuccess!!) {
            DataStore.loadAllItemsFromStore{responseModel -> handleStoreResult(responseModel)}
        }
    }

    private fun handleStoreResult(responseModel: ResponseModel) {
        if (responseModel.hasError != null && responseModel.hasError!!) {
            Toast.makeText(this, responseModel.error, Toast.LENGTH_SHORT).show()
        }
        else if (responseModel.hasSuccess != null && responseModel.hasSuccess!!) {
            val layoutManager = LinearLayoutManager(this)
            rcvStores.layoutManager = layoutManager
            adapter = StoreAdapter(DataStore.stores)
            rcvStores.adapter = adapter

            updateCollapsinTitle()
        }
    }

    private fun handleRemoveitem(responseModel: ResponseModel) {
        if (responseModel.hasError != null && responseModel.hasError!!) {
            Toast.makeText(this, responseModel.error, Toast.LENGTH_SHORT).show()
        }
        else if (responseModel.hasSuccess != null && responseModel.hasSuccess!!) {
            adapter!!.notifyDataSetChanged()
            Snackbar.make(layMain, "Produto excluído: $productName", Snackbar.LENGTH_LONG).show()
            updateCollapsinTitle()

            DataStore.loadAllItemsFromStore{responseModel -> handleStoreResult(responseModel)}
        }
    }

    private fun handleLogout(responseModel: ResponseModel) {
        if (responseModel.hasError != null && responseModel.hasError!!) {
            Toast.makeText(this, responseModel.error, Toast.LENGTH_SHORT).show()
        }
        else if (responseModel.hasSuccess != null && responseModel.hasSuccess!!) {
            val intent = Intent(this@MainActivity, LoginActivity::class.java)
            finish()
            startActivity(intent)
        }
    }

}
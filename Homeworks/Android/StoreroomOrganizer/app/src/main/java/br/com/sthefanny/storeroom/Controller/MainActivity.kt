package br.com.sthefanny.storeroom.Controller

import android.app.Activity
import android.content.DialogInterface
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.GestureDetector
import android.view.MotionEvent
import androidx.appcompat.app.AlertDialog
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import br.com.sthefanny.storeroom.Controller.Interfaces.LoadReceiverDelegate
import br.com.sthefanny.storeroom.Model.DataStore
import br.com.sthefanny.storeroom.R
import br.com.sthefanny.storeroom.View.StoreAdapter
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity(), LoadReceiverDelegate {

    val REQUEST_CODE_ADD = 1
    val REQUERT_CODE_UPDATE = 2

    private var adapter: StoreAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)

        DataStore.loadAllItemsFromStore(this)

        DataStore.loadAllProducts(this)

        fab.setOnClickListener {
            val intent = Intent(this@MainActivity, ManagerStoreActivity::class.java).apply {
                putExtra("type", 1)
            }
            startActivityForResult(intent, REQUEST_CODE_ADD)
        }

        val layoutManager = LinearLayoutManager(this)
        rcvStores.layoutManager = layoutManager
        adapter = StoreAdapter(DataStore.stores)
        rcvStores.adapter = adapter

        updateCollapsinTitle()

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
                            DataStore.removeItemFromStore(position, this@MainActivity)
                            adapter!!.notifyDataSetChanged()
                            Snackbar.make(layMain, "Produto excluído: ${store.productName}", Snackbar.LENGTH_LONG).show()
                            updateCollapsinTitle()
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
                DataStore.loadAllItemsFromStore(this)
                DataStore.loadAllProducts(this)
            }
        }

        if (requestCode == REQUERT_CODE_UPDATE) {

            if (resultCode == Activity.RESULT_OK) {

                Snackbar.make(layMain, "Produto alterado: ${name}", Snackbar.LENGTH_LONG).show()
                adapter!!.notifyDataSetChanged()
                DataStore.loadAllItemsFromStore(this)
                DataStore.loadAllProducts(this)
            }
        }
    }

    override fun setStatus(status: Boolean) {
        if (status) {
            adapter!!.notifyDataSetChanged()
        }
        else {
            Log.d("Error!", "Algo deu errado!!!")
        }
    }
}
package br.pucpr.appdev.aula02recyclerview.Controller

import android.app.Activity
import android.content.DialogInterface
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.GestureDetector
import android.view.MotionEvent
import android.widget.Switch
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import br.pucpr.appdev.aula02recyclerview.Model.DataStore
import br.pucpr.appdev.aula02recyclerview.R
import br.pucpr.appdev.aula02recyclerview.View.CityAdapter
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    val REQUEST_CODE_ADD = 1
    val REQUERT_CODE_UPDATE = 2

    private var adapter: CityAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)

        fab.setOnClickListener {
            val intent = Intent(this@MainActivity, ManagerCityActivity::class.java).apply {
                putExtra("type", 1)
            }
            startActivityForResult(intent, REQUEST_CODE_ADD)
        }

        val layoutManager = LinearLayoutManager(this)
        rcvCities.layoutManager = layoutManager
        adapter = CityAdapter(DataStore.cities)
        rcvCities.adapter = adapter

        updateCollapsinTitle()

        val gestureDetector = GestureDetector(this, object : GestureDetector.SimpleOnGestureListener() {

            override fun onSingleTapConfirmed(e: MotionEvent?): Boolean {

                e?.let {

                    val view = rcvCities.findChildViewUnder(e.x, e.y)
                    view?.let {

                        val position = rcvCities.getChildAdapterPosition(view)
                        val city = DataStore.getCity(position)

                        val intent = Intent(this@MainActivity, ManagerCityActivity::class.java).apply {
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

                    val view = rcvCities.findChildViewUnder(e.x, e.y)
                    view?.let {

                        val position = rcvCities.getChildAdapterPosition(view)
                        val city = DataStore.getCity(position)

                        val dialog = AlertDialog.Builder(this@MainActivity)
                        dialog.setTitle("App Cidades")
                        dialog.setMessage("Tem certeza que deseja excluir esta cidade?")
                        dialog.setPositiveButton("Excluir", DialogInterface.OnClickListener { dialog, which ->
                            DataStore.removeCity(position)
                            adapter!!.notifyDataSetChanged()
                            Snackbar.make(layMain, "Cidade excluída: ${city.name}", Snackbar.LENGTH_LONG).show()
                            updateCollapsinTitle()
                        })
                        dialog.setNegativeButton("Cancelar", null)
                        dialog.show()
                    }

                }
            }
        })

        rcvCities.addOnItemTouchListener(object : RecyclerView.OnItemTouchListener {
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

        collapsingToolbar.title = "${getString(R.string.collapsinTitle)} (${DataStore.cities.size})"
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        var cityName = ""
        data?.let {

            cityName = data.getStringExtra("cityName")
        } ?: run {

            cityName = "Erro de nome"
        }

        if (requestCode == REQUEST_CODE_ADD) {

            if (resultCode == Activity.RESULT_OK) {

                Snackbar.make(layMain, "Cidade adicionada: ${cityName}", Snackbar.LENGTH_LONG).show()
                adapter!!.notifyDataSetChanged()
                updateCollapsinTitle()
            }
        }

        if (requestCode == REQUERT_CODE_UPDATE) {

            if (resultCode == Activity.RESULT_OK) {

                Snackbar.make(layMain, "Cidade alterada: ${cityName}", Snackbar.LENGTH_LONG).show()
                adapter!!.notifyDataSetChanged()
            }
        }
    }
}
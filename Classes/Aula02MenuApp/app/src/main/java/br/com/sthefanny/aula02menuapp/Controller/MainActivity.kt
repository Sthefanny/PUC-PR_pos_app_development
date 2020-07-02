package br.com.sthefanny.aula02menuapp.Controller

import android.app.Activity
import android.content.DialogInterface
import android.content.Intent
import android.graphics.Color
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
import br.com.sthefanny.aula02menuapp.Model.DataStore
import br.com.sthefanny.aula02menuapp.R
import br.com.sthefanny.aula02menuapp.View.CityAdapter
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    val REQUEST_CODE_ADD = 1
    val REQUEST_CODE_UPDATE = 2

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

        val gestureDetector = GestureDetector(this, object: GestureDetector.SimpleOnGestureListener() {
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
                        startActivityForResult(intent, REQUEST_CODE_UPDATE)
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
                            Snackbar.make(layMain, "Cidade excluída: ${city.name}", Snackbar.LENGTH_SHORT).show()
                            updateCollapsinTitle()
                        })
                        dialog.setNegativeButton("Cancelar", null)
                        dialog.show()
                    }
                }
            }
        })

        rcvCities.addOnItemTouchListener(object: RecyclerView.OnItemTouchListener {
            override fun onTouchEvent(rv: RecyclerView, e: MotionEvent) {
                TODO("Not yet implemented")
            }

            override fun onInterceptTouchEvent(rv: RecyclerView, e: MotionEvent): Boolean {
                val child = rv.findChildViewUnder(e.x, e.y)

                return (child != null && gestureDetector.onTouchEvent(e))
            }

            override fun onRequestDisallowInterceptTouchEvent(disallowIntercept: Boolean) {
                TODO("Not yet implemented")
            }

        })
    }

    fun updateCollapsinTitle() {
        collapsingToolbar.title = "${getString(R.string.collapsingTitle)} (${DataStore.cities.size} cidades)"
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
                Snackbar.make(layMain, "Cidade adicionada: $cityName", Snackbar.LENGTH_SHORT).show()
                adapter!!.notifyDataSetChanged()
            }
        }

        if (requestCode == REQUEST_CODE_UPDATE) {
            if (resultCode == Activity.RESULT_OK) {
                Snackbar.make(layMain, "Cidade alterada: $cityName", Snackbar.LENGTH_SHORT).show()
                adapter!!.notifyDataSetChanged()
            }
        }

        updateCollapsinTitle()
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.menu_main, menu)

        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        when (item.itemId) {
            R.id.mnuAbout -> {
                val dialog = AlertDialog.Builder(this)
                dialog.setTitle("Menu App")
                dialog.setMessage("Desenvolvido por: Stel")
                dialog.setPositiveButton("Ok", null)
                dialog.show()
            }
            R.id.mnuBlue -> layMain.setBackgroundColor(Color.BLUE)
            R.id.mnuGreen -> layMain.setBackgroundColor(Color.GREEN)
            R.id.mnuRed -> layMain.setBackgroundColor(Color.RED)
            R.id.mnuWhite -> layMain.setBackgroundColor(Color.WHITE)
        }

        return true
    }

    override fun onBackPressed() {
        val dialog = AlertDialog.Builder(this)
        dialog.setTitle("Menu App")
        dialog.setMessage("Tem certeza que deseja sair do aplicativo?")
        dialog.setPositiveButton("Sim", DialogInterface.OnClickListener { dialog, which ->
            super.onBackPressed()
        })
        dialog.setNegativeButton("Não", null)
        dialog.show()
    }
}
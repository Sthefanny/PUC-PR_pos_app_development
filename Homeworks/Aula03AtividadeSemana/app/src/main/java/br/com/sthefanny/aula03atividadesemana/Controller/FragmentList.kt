package br.com.sthefanny.aula03atividadesemana.Controller

import android.app.Activity
import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.view.*
import androidx.appcompat.app.AlertDialog
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.navigation.Navigation
import androidx.navigation.findNavController
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import br.com.sthefanny.aula03atividadesemana.Model.DataStore
import br.com.sthefanny.aula03atividadesemana.R
import br.com.sthefanny.aula03atividadesemana.View.PokemonAdapter
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.google.android.material.snackbar.Snackbar
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.fragment_add_edit.*
import kotlinx.android.synthetic.main.fragment_list_list.*
import java.lang.Exception

/**
 * A fragment representing a list of Items.
 */
class FragmentList : Fragment() {

    val REQUEST_CODE_ADD = 1
    val REQUEST_CODE_UPDATE = 2

    private var layoutManager: RecyclerView.LayoutManager? = null
    var adapter: PokemonAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_list_list, container, false)

        layoutManager = LinearLayoutManager(activity)
        adapter = PokemonAdapter(DataStore.pokemons)

        val fab = view.findViewById<FloatingActionButton>(R.id.fab)

        var bundle = bundleOf("type" to REQUEST_CODE_ADD)

        fab.setOnClickListener(Navigation.createNavigateOnClickListener(R.id.action_fragment_list_to_fragmentAddEdit, bundle))

        return view
    }

    override fun onViewCreated(itemView: View, savedInstanceState: Bundle?) {
        super.onViewCreated(itemView, savedInstanceState)

        rcvPokemons.layoutManager = layoutManager
        rcvPokemons.adapter = adapter

        if (arguments != null) {

            try {
                var pokemonName = arguments?.getString("pokemonName")!!
                var requestCode = arguments?.getInt("requestCode")!!

                if (pokemonName != null && pokemonName.isNotEmpty()) {

                    if (requestCode == REQUEST_CODE_ADD) {
                        Snackbar.make(layList, "Pokemon adicionado: $pokemonName", Snackbar.LENGTH_SHORT).show()
                        adapter!!.notifyDataSetChanged()
                    }

                    if (requestCode == REQUEST_CODE_UPDATE) {
                        Snackbar.make(layList, "Pokemon alterado: $pokemonName", Snackbar.LENGTH_SHORT).show()
                        adapter!!.notifyDataSetChanged()
                    }
                }
                updateCollapsinTitle()
            }
            catch (e: Exception) {}
        }

        updateCollapsinTitle()

        val gestureDetector = GestureDetector(activity?.baseContext, object: GestureDetector.SimpleOnGestureListener() {
            override fun onSingleTapConfirmed(e: MotionEvent?): Boolean {
                e?.let {
                    val view = rcvPokemons.findChildViewUnder(e.x, e.y)
                    view?.let {
                        val position = rcvPokemons.getChildAdapterPosition(view)

                        val action = FragmentListDirections.actionFragmentListToFragmentAddEdit(REQUEST_CODE_UPDATE, position)
                        findNavController().navigate(action)
                    }
                }

                return super.onSingleTapConfirmed(e)
            }

            override fun onLongPress(e: MotionEvent?) {
                super.onLongPress(e)

                e?.let {
                    val view = rcvPokemons.findChildViewUnder(e.x, e.y)
                    view?.let {
                        val position = rcvPokemons.getChildAdapterPosition(view)
                        val pokemon = DataStore.getPokemon(position)

                        val dialog = AlertDialog.Builder(this@FragmentList.requireContext())
                        dialog.setTitle("App Pokemons")
                        dialog.setMessage("Tem certeza que deseja excluir este pokemon?")
                        dialog.setPositiveButton("Excluir", DialogInterface.OnClickListener { dialog, which ->
                            DataStore.removePokemon(position)
                            adapter!!.notifyDataSetChanged()
                            Snackbar.make(layList, "Pokemon excluído: ${pokemon.name}", Snackbar.LENGTH_SHORT).show()
                            updateCollapsinTitle()
                        })
                        dialog.setNegativeButton("Cancelar", null)
                        dialog.show()
                    }
                }
            }
        })

        rcvPokemons.addOnItemTouchListener(object: RecyclerView.OnItemTouchListener {
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
        collapsingToolbar.title = "${getString(R.string.collapsingTitle)} (${DataStore.pokemons.size})"
    }
}
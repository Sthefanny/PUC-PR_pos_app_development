package br.com.sthefanny.aula03atividadesemana.Controller

import android.app.Activity
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.*
import android.view.inputmethod.InputMethodManager
import androidx.appcompat.app.AlertDialog
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.core.widget.addTextChangedListener
import androidx.navigation.Navigation
import androidx.navigation.Navigation.findNavController
import androidx.navigation.fragment.findNavController
import br.com.sthefanny.aula03atividadesemana.Model.DataStore
import br.com.sthefanny.aula03atividadesemana.Model.Pokemon
import br.com.sthefanny.aula03atividadesemana.R
import com.google.android.material.snackbar.Snackbar
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.fragment_add_edit.*
import kotlinx.android.synthetic.main.fragment_add_edit.toolbar
import kotlinx.android.synthetic.main.fragment_list_list.*

class FragmentAddEdit : Fragment() {

    var position = 0
    var type = 0

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        return inflater.inflate(R.layout.fragment_add_edit, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)


        btnAddEdit.setOnClickListener { view ->
            addEditPokemonButton(view)
        }

        txtNumber.onFocusChangeListener = View.OnFocusChangeListener { _, hasFocus ->
            if (!hasFocus){
            Picasso.get().load("https://assets.pokemon.com/assets/cms2/img/pokedex/full/${txtNumber.text}.png").into(imgImage)
            }
        }

        toolbar.title = "Gerenciar Pokemon"

        type = arguments?.getInt("type")!!


        btnAddEdit.text = "Adicionar"

        if (type == 2) {

            btnAddEdit.text = "Editar"

            if (arguments?.getInt("position") != null) {
                position = arguments?.getInt("position")!!
                val pokemon = DataStore.getPokemon(position)

                txtNumber.setText(pokemon.number)
                txtName.setText(pokemon.name)

                if (pokemon.image != null) {
                    Picasso.get().load(pokemon.image).into(imgImage);
                }
                else {
                    Picasso.get().load("https://assets.pokemon.com/assets/cms2/img/pokedex/full/${txtNumber}.png").into(imgImage);
                }
            }
        }
    }

    private fun addEditPokemonButton(view: View) {
        if (txtNumber.text.isNotEmpty() && txtName.text.isNotEmpty()) {
            val pokemon = Pokemon(txtNumber.text.toString(), txtName.text.toString(), "https://assets.pokemon.com/assets/cms2/img/pokedex/full/${txtNumber.text}.png")

            if (type == 1) {
                DataStore.addPokemon(pokemon)
            }
            else if (type == 2) {
                DataStore.editPokemon(pokemon, position)
            }

            hideKeyboard()

            val action = FragmentAddEditDirections.actionFragmentAddEditToFragmentList(pokemon.name, type)
            findNavController().navigate(action)
        }
        else {
            Snackbar.make(view, "Campos número e nome são obrigatórios.", Snackbar.LENGTH_LONG).show()
        }
    }



    private fun hideKeyboard() {
        val inputManager: InputMethodManager = activity?.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager

        val currentFocusedView = requireActivity().currentFocus
        if (currentFocusedView != null) {
            inputManager.hideSoftInputFromWindow(
                currentFocusedView.windowToken,
                InputMethodManager.HIDE_NOT_ALWAYS
            )
        }
    }
}
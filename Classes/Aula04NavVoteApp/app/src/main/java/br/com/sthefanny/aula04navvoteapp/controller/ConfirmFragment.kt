package br.com.sthefanny.aula04navvoteapp.controller

import android.os.Bundle
import android.view.*
import androidx.fragment.app.Fragment
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.core.os.bundleOf
import androidx.navigation.fragment.findNavController
import br.com.sthefanny.aula04navvoteapp.R
import br.com.sthefanny.aula04navvoteapp.model.Candidate
import br.com.sthefanny.aula04navvoteapp.model.DataStore

class ConfirmFragment : Fragment() {

    lateinit var candidate: Candidate
    var position = -1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setHasOptionsMenu(true)
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val view = inflater.inflate(R.layout.fragment_confirm, container, false)

        (context as MainActivity).changeTitle("Confirma o seu voto?")

        position = requireArguments().getInt("position")
        candidate = DataStore.getCandidate(position)

        val txtName = view.findViewById<TextView>(R.id.txtName)
        val txtId = view.findViewById<TextView>(R.id.txtId)
        val imgCandidate = view.findViewById<ImageView>(R.id.imgCandidate)

        txtName.text = candidate.name
        txtId.text = candidate.id
        imgCandidate.setImageResource(candidate.image)

        return view
    }

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        super.onCreateOptionsMenu(menu, inflater)

        inflater.inflate(R.menu.menu_confirm, menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {

        when(item.itemId) {
            R.id.mnuSave -> {
                candidate.votes += 1
                val bundle = bundleOf("position" to position)
                findNavController().navigate(R.id.action_confirmFragment_to_voteFragment, bundle)
            }
            android.R.id.home -> {
                findNavController().popBackStack()
            }
        }

        return true
    }
}
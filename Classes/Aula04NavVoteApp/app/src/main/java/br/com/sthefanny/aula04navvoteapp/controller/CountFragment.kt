package br.com.sthefanny.aula04navvoteapp.controller

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.viewpager2.widget.ViewPager2
import br.com.sthefanny.aula04navvoteapp.R
import br.com.sthefanny.aula04navvoteapp.model.DataStore
import br.com.sthefanny.aula04navvoteapp.view.CountAdapter

class CountFragment : Fragment() {

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val view = inflater.inflate(R.layout.fragment_count, container, false)

        (context as MainActivity).changeTitle("Apuração")

        val pgrCandidate = view.findViewById<ViewPager2>(R.id.pgrCandidate)
        val pgrAdapter = CountAdapter(DataStore.candidates)
        pgrCandidate.adapter = pgrAdapter
        pgrCandidate.orientation = ViewPager2.ORIENTATION_HORIZONTAL

        return view
    }
}
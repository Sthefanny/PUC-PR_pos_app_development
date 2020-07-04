package br.com.sthefanny.aula04navvoteapp.controller

import android.os.Bundle
import android.view.*
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import br.com.sthefanny.aula04navvoteapp.R
import br.com.sthefanny.aula04navvoteapp.model.DataStore
import br.com.sthefanny.aula04navvoteapp.view.CandidateAdapter

class VoteFragment : Fragment() {

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_vote, container, false)

        (context as MainActivity).changeTitle("Cédula Eleitoral")

        var highlight = -1

        arguments?.getInt("position")?.let {
            highlight = it
        }

        val rcvCandidate = view.findViewById<RecyclerView>(R.id.rcvCandidates)
        val layoutManager = LinearLayoutManager(context)
        rcvCandidate.layoutManager = layoutManager
        var adapter = CandidateAdapter(DataStore.candidates, highlight)
        rcvCandidate.adapter = adapter

        val gestureDetector = GestureDetector(context, object : GestureDetector.SimpleOnGestureListener() {

            override fun onSingleTapConfirmed(e: MotionEvent?): Boolean {

                e?.let {
                    val view = rcvCandidate.findChildViewUnder(e.x, e.y)
                    view?.let {
                        val position = rcvCandidate.getChildAdapterPosition(view)
                        val candidate = DataStore.getCandidate(position)

                        val bundle = bundleOf("position" to position)
                        findNavController().navigate(R.id.action_voteFragment_to_confirmFragment, bundle)
                    }
                }

                return super.onSingleTapConfirmed(e)
            }

        })

        rcvCandidate.addOnItemTouchListener(object : RecyclerView.OnItemTouchListener {
            override fun onTouchEvent(rv: RecyclerView, e: MotionEvent) {}

            override fun onInterceptTouchEvent(rv: RecyclerView, e: MotionEvent): Boolean {
                var child = rv.findChildViewUnder(e.x, e.y)

                return (child != null && gestureDetector.onTouchEvent(e))
            }

            override fun onRequestDisallowInterceptTouchEvent(disallowIntercept: Boolean) {}

        })

        return view
    }
}
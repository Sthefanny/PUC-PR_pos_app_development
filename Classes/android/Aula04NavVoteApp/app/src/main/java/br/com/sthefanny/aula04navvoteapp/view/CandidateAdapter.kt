package br.com.sthefanny.aula04navvoteapp.view

import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import br.com.sthefanny.aula04navvoteapp.R
import br.com.sthefanny.aula04navvoteapp.model.Candidate
import kotlinx.android.synthetic.main.rcv_candidates.view.*

class CandidateAdapter(var candidates: MutableList<Candidate>, var highlight: Int) : RecyclerView.Adapter<CandidateAdapter.CandidateHolder>() {

    inner class CandidateHolder(view: View) : RecyclerView.ViewHolder(view) {

        var layCandidate: LinearLayout
        var imgCandidate: ImageView
        var txtName: TextView
        var txtId: TextView

        init {
            layCandidate = view.findViewById(R.id.layCandidate)
            imgCandidate = view.findViewById(R.id.imgCandidate)
            txtName = view.findViewById(R.id.txtName)
            txtId = view.findViewById(R.id.txtId)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CandidateHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.rcv_candidates, parent, false)

        return CandidateHolder(view)
    }

    override fun getItemCount(): Int {
        return candidates.size
    }

    override fun onBindViewHolder(holder: CandidateHolder, position: Int) {
        val candidate = candidates[position]

        holder.imgCandidate.setImageResource(candidate.image)
        holder.txtName.text = candidate.name
        holder.txtId.text = candidate.id

        if (highlight > -1 && highlight == position) {
            holder.layCandidate.setBackgroundColor(Color.rgb(255, 255, 200))
        }

    }

}
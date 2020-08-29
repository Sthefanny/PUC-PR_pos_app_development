package br.com.sthefanny.aula04navvoteapp.view

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import br.com.sthefanny.aula04navvoteapp.R
import br.com.sthefanny.aula04navvoteapp.model.Candidate

class CountAdapter(var candidates: MutableList<Candidate>) : RecyclerView.Adapter<CountAdapter.CandidateHolder>() {
    inner class CandidateHolder(view: View) : RecyclerView.ViewHolder(view) {
        val txtName: TextView
        val imgCandidate: ImageView
        val txtCount: TextView

        init {
            txtName = view.findViewById(R.id.txtName)
            imgCandidate = view.findViewById(R.id.imgCandidate)
            txtCount = view.findViewById(R.id.txtCount)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CandidateHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.pgr_candidate, parent, false)

        return CandidateHolder(view)
    }

    override fun getItemCount(): Int {
        return candidates.size
    }

    override fun onBindViewHolder(holder: CandidateHolder, position: Int) {
        val candidade = candidates[position]

        holder.txtName.text = candidade.name
        holder.imgCandidate.setImageResource(candidade.image)
        holder.txtCount.text = candidade.votes.toString()
    }
}
package br.com.sthefanny.aula04navvoteapp.model

import br.com.sthefanny.aula04navvoteapp.R

object DataStore {

    var candidates: MutableList<Candidate> = arrayListOf()
        private set

    init {
        candidates.add(Candidate("Lula", 0, "PT", R.drawable.lula))
        candidates.add(Candidate("Karina", 0, "PM", R.drawable.kb))
        candidates.add(Candidate("Ronaldinho", 0, "PJ", R.drawable.r10))
    }

    fun getCandidate(position: Int): Candidate {
        return candidates[position]
    }

}
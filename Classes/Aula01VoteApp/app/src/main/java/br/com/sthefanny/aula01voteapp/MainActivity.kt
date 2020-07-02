package br.com.sthefanny.aula01voteapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Toast
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    val votesList = mutableListOf(0, 0, 0)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    fun btnVoteOnClick(view: View) {
        when(grpVote.checkedRadioButtonId) {
            R.id.optKb -> votesList[0]++
            R.id.optLula -> votesList[1]++
            R.id.optR10 -> votesList[2]++
            else -> {
                Toast.makeText(this, "Escolha uma das opções de voto", Toast.LENGTH_LONG).show()
            }
        }

        Toast.makeText(this, "Votos KB:${votesList[0]}, Lula:${votesList[1]}, R10:${votesList[2]}", Toast.LENGTH_SHORT).show()
    }
}

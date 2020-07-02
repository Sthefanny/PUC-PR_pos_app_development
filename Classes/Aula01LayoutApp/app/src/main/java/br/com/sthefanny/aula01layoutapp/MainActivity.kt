package br.com.sthefanny.aula01layoutapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Toast
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    fun btnMessageOnClick(view: View) {
        Toast.makeText(this, "Olá, " + txtName.text, Toast.LENGTH_LONG).show()
    }
}

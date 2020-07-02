package br.com.sthefanny.pucprprimeiroapp

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.Toast

class MainActivity : AppCompatActivity() {

    private var button: Button? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        button = Button(this)
        button?.setText("Clique aqui!!!")

        setContentView(button)

        //button?.setOnClickListener(object: View.OnClickListener {
        //    override fun onClick(v: View?) {
        //          Toast.makeText(this@MainActivity, "Olá Mundo!!!", Toast.LENGTH_SHORT).show()
        //    }
        //})

        button?.setOnClickListener {
            Toast.makeText(this, "Olá Mundo!!!", Toast.LENGTH_SHORT).show()
        }



        button?.setOnLongClickListener {
            Toast.makeText(this@MainActivity, "Long press!!!", Toast.LENGTH_LONG).show()
            //return@setOnLongClickListener true
            true
        }
    }
}

package br.com.sthefanny.aula03atividadesemana.Controller

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.view.inputmethod.InputMethodManager
import androidx.appcompat.app.AppCompatActivity
import br.com.sthefanny.aula03atividadesemana.R
import br.com.sthefanny.aula03atividadesemana.View.PokemonAdapter


class MainActivity : AppCompatActivity() {

    private var adapter: PokemonAdapter? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }
}
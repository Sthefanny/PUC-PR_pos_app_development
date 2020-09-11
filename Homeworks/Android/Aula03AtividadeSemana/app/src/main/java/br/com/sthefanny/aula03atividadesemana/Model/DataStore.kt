package br.com.sthefanny.aula03atividadesemana.Model

import android.content.Context
import android.util.Log
import br.com.sthefanny.aula03atividadesemana.R
import java.io.File
import java.io.IOException

object DataStore {

    var login = "teste@teste.com"
        private set
    var password = "123456"
        private set

    var pokemons: MutableList<Pokemon> = arrayListOf()
        private set

    private var database: PokemonDatabase? = null

    fun setContext(context: Context) {
        database = PokemonDatabase(context)
        database?.let {
            pokemons = it.getAllPokemons()
        }
    }

    fun getPokemon(position: Int): Pokemon {
        return pokemons.get(position)
    }

    fun addPokemon(pokemon: Pokemon) {
        val id = database?.addPokemon(pokemon) ?: return

        pokemon.id = id
        pokemons.add(pokemon)
        Log.d("SQLite!", "1 pokemon incluído com sucesso!!!")
    }

    fun editPokemon(pokemon: Pokemon, position: Int) {
        pokemon.id = pokemons[position].id
        val count = database?.editPokemon(pokemon) ?: return

        pokemons.set(position, pokemon)
        Log.d("SQLite!", "1 pokemon editado com sucesso!!!")
    }

    fun removePokemon(position: Int) {
        val count = database?.removePokemon(pokemons[position])

        pokemons.removeAt(position)
        Log.d("SQLite!", "$count pokemon(s) excluído(s) com sucesso!!!")
    }

    fun clearPokemons(position: Int) {
        val count = database?.clearPokemons() ?: return
        pokemons.clear()
        Log.d("SQLite!", "$count pokemon(s) excluído(s) com sucesso!!!")
    }
}
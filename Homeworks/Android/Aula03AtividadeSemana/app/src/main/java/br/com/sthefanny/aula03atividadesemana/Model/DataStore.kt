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

    private var context: Context? = null

    fun setContext(value: Context) {
        context = value
        loadData()
    }

//    init {
//        addPokemon(Pokemon("001", "Bulbasaur", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png"))
//        addPokemon(Pokemon("002", "Ivysaur", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/002.png"))
//        addPokemon(Pokemon("003", "Venusaur", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/003.png"))
//        addPokemon(Pokemon("004", "Charmander", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/004.png"))
//        addPokemon(Pokemon("005", "Charmeleon", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/005.png"))
//        addPokemon(Pokemon("006", "Charizard", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/006.png"))
//        addPokemon(Pokemon("007", "Squirtle", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/007.png"))
//        addPokemon(Pokemon("008", "Wartortle", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/008.png"))
//        addPokemon(Pokemon("009", "Blastoise", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/009.png"))
//    }

    fun getPokemon(position: Int): Pokemon {
        return pokemons.get(position)
    }

    fun addPokemon(city: Pokemon) {
        pokemons.add(city)
        saveData()
    }

    fun editPokemon(city: Pokemon, position: Int) {
        pokemons.set(position, city)
        saveData()
    }

    fun removePokemon(position: Int) {
        pokemons.removeAt(position)
        saveData()
    }

    fun clearPokemons(position: Int) {
        pokemons.clear()
        saveData()
    }

    fun loadData() {
        val context = context ?: return
        val file = File(context!!.filesDir.absolutePath + "/${context.getString(R.string.filename_pokemons)}")

        if (file.exists()) {
            file.bufferedReader().use {
                val iterator = it.lineSequence().iterator()
                while (iterator.hasNext()) {
                    var line = iterator.next()
                    var items = line.split("|")
                    var number = items[0]
                    val name = items[1]
                    val image = items[2]

                    var pokemon = Pokemon(number, name, image)
                    addPokemon(pokemon)
                }
            }
        }
        else {
            loadInitialData()
        }
    }

    fun saveData() {
        val context = context ?: return
        val file = File(context!!.filesDir.absolutePath + "/${context.getString(R.string.filename_pokemons)}")

        if (!file.exists()) {
            file.createNewFile()
        }
        else {
            file.writeText("")
        }

        file.printWriter().use {
            for (pokemon in pokemons) {
                var line = "${pokemon.number}|${pokemon.name}|${pokemon.image}"
                it.println(line)
            }
        }
    }

    fun loadInitialData() {
        val context = context ?: return

        try {
            val file = context.assets.open(context.getString(R.string.filename_pokemons))

            file.bufferedReader().use {
                val iterator = it.lineSequence().iterator()
                while (iterator.hasNext()) {
                    var line = iterator.next()
                    var items = line.split("|")
                    var number = items[0]
                    val name = items[1]
                    val image = items[2]

                    var pokemon = Pokemon(number, name, image)
                    addPokemon(pokemon)
                }
            }
        }
        catch (e: IOException) {
            Log.d("Pokedex", "Pokemon não localizado: ${e.localizedMessage}")
            return
        }

        saveData()
    }
}
package br.com.sthefanny.aula03atividadesemana.Model

import android.content.Context

object DataStore {

    var pokemons: MutableList<Pokemon> = arrayListOf()
        private set

    private var myContext: Context? = null

    fun setContext(value: Context) {
        myContext = value
    }

    init {
        addPokemon(Pokemon("001", "Bulbasaur", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png"))
        addPokemon(Pokemon("002", "Ivysaur", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/002.png"))
        addPokemon(Pokemon("003", "Venusaur", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/003.png"))
        addPokemon(Pokemon("004", "Charmander", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/004.png"))
        addPokemon(Pokemon("005", "Charmeleon", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/005.png"))
        addPokemon(Pokemon("006", "Charizard", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/006.png"))
        addPokemon(Pokemon("007", "Squirtle", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/007.png"))
        addPokemon(Pokemon("008", "Wartortle", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/008.png"))
        addPokemon(Pokemon("009", "Blastoise", "https://assets.pokemon.com/assets/cms2/img/pokedex/full/009.png"))
    }

    fun getPokemon(position: Int): Pokemon {
        return pokemons.get(position)
    }

    fun addPokemon(city: Pokemon) {
        pokemons.add(city)
    }

    fun editPokemon(city: Pokemon, position: Int) {
        pokemons.set(position, city)
    }

    fun removePokemon(position: Int) {
        pokemons.removeAt(position)
    }

    fun clearPokemons(position: Int) {
        pokemons.clear()
    }
}
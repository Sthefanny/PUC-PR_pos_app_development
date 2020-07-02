package br.com.sthefanny.aula02menuapp.Model

import android.content.Context

object DataStore {

    var cities: MutableList<City> = arrayListOf()
        private set

    private var myContext: Context? = null

    fun setContext(value: Context) {
        myContext = value
    }

    init {
        addCity(City("Curitiba", 1750000))
        addCity(City("São Paulo", 1200000))
        addCity(City("Campinas", 900000))
        addCity(City("Porto Alegre", 110000))
        addCity(City("Santo Antônio da Amoreira", 100000))
        addCity(City("Cambará", 200000))
    }

    fun getCity(position: Int): City {
        return cities.get(position)
    }

    fun addCity(city: City) {
        cities.add(city)
    }

    fun editCity(city: City, position: Int) {
        cities.set(position, city)
    }

    fun removeCity(position: Int) {
        cities.removeAt(position)
    }

    fun clearCities(position: Int) {
        cities.clear()
    }

}
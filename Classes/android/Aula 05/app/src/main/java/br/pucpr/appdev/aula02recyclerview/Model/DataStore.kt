package br.pucpr.appdev.aula02recyclerview.Model

import android.content.Context
import android.util.Log
import br.pucpr.appdev.aula02recyclerview.R
import java.io.File
import java.io.IOException

object DataStore {

    var login = "teste@teste.com"
        private set
    var password = "123456"
        private set

    var cities: MutableList<City> = arrayListOf()
        private set

    var states: MutableList<String> = arrayListOf()
        private set

    private var context: Context? = null

    fun setContext(value: Context) {
        context = value
        loadData()
        loadStates()
    }

    fun getCity(position: Int): City {
        return cities.get(position)
    }

    fun addCity(city: City) {
        cities.add(city)
        saveData()
    }

    fun editCity(city: City, position: Int) {
        cities.set(position, city)
        saveData()
    }

    fun removeCity(position: Int) {
        cities.removeAt(position)
        saveData()
    }

    fun clearCities() {
        cities.clear()
        saveData()
    }

    fun loadData() {
        val context = context ?: return
        val file = File(context!!.filesDir.absolutePath + "/${context.getString(R.string.filename_cities)}")

        if (file.exists()) {
            file.bufferedReader().use {
                val iterator = it.lineSequence().iterator()
                while (iterator.hasNext()) {
                    val name = iterator.next()
                    var state = iterator.next().toInt()
                    val people = iterator.next().toInt()

                    var city = City(name, people)
                    city.state = state
                    addCity(city)
                }
            }
        }
        else {
            loadInitialData()
        }
    }

    fun loadStates() {
        val context = context ?: return

        try {
            val file = context.assets.open(context.getString(R.string.filename_states))

            file.bufferedReader().use {
                val iterator = it.lineSequence().iterator()
                while (iterator.hasNext()) {
                    val name = iterator.next()
                    states.add(name)
                }
            }
        }
        catch (e: IOException) {
            Log.d("Aula05", "Arquivo não localizado: ${e.localizedMessage}")
            return
        }
    }

    fun saveData() {
        val context = context ?: return
        val file = File(context!!.filesDir.absolutePath + "/${context.getString(R.string.filename_cities)}")

        if (!file.exists()) {
            file.createNewFile()
        }
        else {
            file.writeText("")
        }

        file.printWriter().use {
            for (city in cities) {
                it.println(city.name)
                it.println(city.state)
                it.println(city.people)
            }
        }
    }

    fun loadInitialData() {
        val context = context ?: return

        try {
            val file = context.assets.open(context.getString(R.string.filename_cities))

            file.bufferedReader().use {
                val iterator = it.lineSequence().iterator()
                while (iterator.hasNext()) {
                    val name = iterator.next()
                    var state = iterator.next().toInt()
                    val people = iterator.next().toInt()

                    var city = City(name, people)
                    city.state = state
                    addCity(city)
                }
            }
        }
        catch (e: IOException) {
            Log.d("Aula05", "Arquivo não localizado: ${e.localizedMessage}")
            return
        }

        saveData()
    }
}
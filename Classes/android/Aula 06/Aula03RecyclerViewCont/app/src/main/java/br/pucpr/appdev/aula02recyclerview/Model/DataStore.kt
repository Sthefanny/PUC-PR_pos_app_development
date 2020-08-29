package br.pucpr.appdev.aula02recyclerview.Model

import android.content.Context
import android.util.Log

object DataStore {

    var cities: MutableList<City> = arrayListOf()
        private set

    var contacts: MutableList<Contact> = arrayListOf()
        private set

    private var database: CityDatabase? = null

    fun setContext(context: Context) {
        database = CityDatabase(context)
        database?.let {
            cities = it.getAllCities()
        }
    }

    fun getCity(position: Int): City {
        return cities.get(position)
    }

    fun addCity(city: City) {
        val id = database?.addCity(city) ?: return

        city.id = id
        cities.add(city)
        Log.d("SQLite!", "1 registro incluído com sucesso!!!")
    }

    fun editCity(city: City, position: Int) {
        city.id = cities[position].id
        val count = database?.editCity(city) ?: return

        cities.set(position, city)
        Log.d("SQLite!", "1 registro editado com sucesso!!!")
    }

    fun removeCity(position: Int) {
        val count = database?.removeCity(cities[position])

        cities.removeAt(position)
        Log.d("SQLite!", "$count registro(s) excluído(s) com sucesso!!!")
    }

    fun clearCities() {
        val count = database?.clearCities() ?: return
        cities.clear()
        Log.d("SQLite!", "$count registro(s) excluído(s) com sucesso!!!")
    }

    private fun loadContacts(cityId: Int) {
        database?.let {
            contacts = it.getContactsFromCityId(cityId)
        }
    }

    fun getContacts(city: City): MutableList<Contact> {
        loadContacts(city.id.toInt())
        return contacts
    }

    fun addContact(contact: Contact) {
        val id = database?.addContact(contact) ?: return

        contact.id = id
        contacts.add(contact)
        Log.d("SQLite!", "1 registro incluído com sucesso!!!")
    }
}
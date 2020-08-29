package br.pucpr.appdev.aula02recyclerview.Model

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log

class CityDatabase(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        const val DATABASE_VERSION = 2
        const val DATABASE_NAME = "cities.db"

        const val DB_TABLE_CITIES = "cities"
        const val DB_TABLE_CONTACTS = "contacts"

        const val DB_FIELD_ID = "id"
        const val DB_FIELD_NAME = "name"
        const val DB_FIELD_PEOPLE = "people"
        const val DB_FIELD_PHONE = "phone"
        const val DB_FIELD_CITY = "city"

        const val sqlCreateCities = "CREATE TABLE IF NOT EXISTS $DB_TABLE_CITIES (" +
                "$DB_FIELD_ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "$DB_FIELD_NAME TEXT, " +
                "$DB_FIELD_PEOPLE INTEGER);"

        const val sqlCreateContact = "CREATE TABLE IF NOT EXISTS $DB_TABLE_CONTACTS(" +
                "$DB_FIELD_ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "$DB_FIELD_NAME TEXT, " +
                "$DB_FIELD_PHONE TEXT, " +
                "$DB_FIELD_CITY INTEGER);"

        const val sqlDropContacts = "DROP TABLE IF EXISTS $DB_TABLE_CONTACTS"

    }

    override fun onCreate(db: SQLiteDatabase?) {
        val db = db ?: return

        db.execSQL(sqlCreateCities)
        db.execSQL(sqlCreateContact)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        val db = db ?: return

        if (oldVersion == 1 && newVersion == 2) {
                db.execSQL(sqlCreateContact)
            }
    }

    override fun onDowngrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        val db = db ?: return

        if (oldVersion == 2 && newVersion == 1) {
                db.execSQL(sqlDropContacts)
            }
    }

    fun getAllCities(): MutableList<City> {
        var cities = arrayListOf<City>()

        val db = readableDatabase

        val cursor = db.query(DB_TABLE_CITIES, null, null, null, null, null, DB_FIELD_NAME)

        with(cursor) {
            while (moveToNext()) {
                val id = getInt(getColumnIndex(DB_FIELD_ID))
                val name = getString(getColumnIndex(DB_FIELD_NAME))
                val people = getInt(getColumnIndex(DB_FIELD_PEOPLE))
                val city = City(name, people)
                city.id = id.toLong()
                cities.add(city)
            }
        }

        return cities
    }

    fun addCity(city: City): Long {
        val db = writableDatabase

        val values = ContentValues().apply {
            put(DB_FIELD_NAME, city.name)
            put(DB_FIELD_PEOPLE, city.people)
        }

        val id = db.insert(DB_TABLE_CITIES, "", values)

        db.close()

        return id
    }

    fun editCity(city: City): Int {
        val db = writableDatabase

        val values = ContentValues().apply {
            put(DB_FIELD_NAME, city.name)
            put(DB_FIELD_PEOPLE, city.people)
        }

        val selection = "$DB_FIELD_ID = ?"
        val selectionArgs = arrayOf(city.id.toString())
        val count = db.update(DB_TABLE_CITIES, values, selection, selectionArgs)

        db.close()

        return count
    }

    fun removeCity(city: City): Int {
        val db = writableDatabase

        val sqlClearContacts = "DELETE FROM $DB_TABLE_CONTACTS WHERE $DB_FIELD_CITY = ${city.id}"
        db.execSQL(sqlClearContacts)

        val selection = "$DB_FIELD_ID = ?"
        val selectionArgs = arrayOf(city.id.toString())
        val count = db.delete(DB_TABLE_CITIES, selection, selectionArgs)

        db.close()

        return count
    }

    fun clearCities(): Int {
        val db = writableDatabase

        val count = db.delete(DB_TABLE_CITIES, null, null)

        db.close()

        return count
    }

    fun getContactsFromCityId(cityId: Int): MutableList<Contact> {
        var contacts = arrayListOf<Contact>()

        val db = readableDatabase

//        val cursor = db.query(DB_TABLE_CONTACTS,
//            null,
//            "$DB_FIELD_CITY = ?",
//            arrayOf(cityId.toString()),
//            null,
//            null,
//            DB_FIELD_NAME)
//
//        with(cursor) {
//            while (moveToNext()) {
//                val id = getInt(getColumnIndex(DB_FIELD_ID))
//                val name = getString(getColumnIndex(DB_FIELD_NAME))
//                val phone = getString(getColumnIndex(DB_FIELD_PHONE))
//                val contact = Contact(name, phone, cityId)
//                contact.id = id.toLong()
//                contacts.add(contact)
//            }
//        }

        val sqlQuery = "SELECT " +
                "$DB_TABLE_CONTACTS.$DB_FIELD_ID, $DB_TABLE_CONTACTS.$DB_FIELD_NAME, $DB_TABLE_CONTACTS.$DB_FIELD_PHONE, " +
                "$DB_TABLE_CITIES.$DB_FIELD_NAME AS city " +
                "FROM $DB_TABLE_CONTACTS, $DB_TABLE_CITIES " +
                "WHERE $DB_TABLE_CONTACTS.$DB_FIELD_CITY = $DB_TABLE_CITIES.$DB_FIELD_ID " +
                "AND $DB_TABLE_CONTACTS.$DB_FIELD_CITY = ? " +
                "ORDER BY $DB_TABLE_CONTACTS.$DB_FIELD_NAME"

        val cursor = db.rawQuery(sqlQuery, arrayOf(cityId.toString()))

        with(cursor) {
            while (moveToNext()) {
                val id = getInt(getColumnIndex(DB_FIELD_ID))
                val name = getString(getColumnIndex(DB_FIELD_NAME))
                val phone = getString(getColumnIndex(DB_FIELD_PHONE))
                val contact = Contact(name, phone, cityId)
                contact.id = id.toLong()
                contacts.add(contact)
                Log.d("SQLite!", getString(getColumnIndex("city")))
            }
        }

        return contacts
    }

    fun addContact(contact: Contact): Long {
        val db = writableDatabase

        val values = ContentValues().apply {
            put(DB_FIELD_NAME, contact.name)
            put(DB_FIELD_PHONE, contact.phone)
            put(DB_FIELD_CITY, contact.city)
        }

        val id = db.insert(DB_TABLE_CONTACTS, "", values)

        db.close()

        return id
    }

}
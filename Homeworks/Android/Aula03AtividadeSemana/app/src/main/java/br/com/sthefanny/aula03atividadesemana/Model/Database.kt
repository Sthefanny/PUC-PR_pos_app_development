package br.com.sthefanny.aula03atividadesemana.Model

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class PokemonDatabase(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {
    companion object {
        const val DATABASE_VERSION = 1
        const val DATABASE_NAME = "pokemons.db"

        const val DB_TABLE_POKEMON = "pokemons"
        const val DB_TABLE_TYPES = "types"

        const val DB_FIELD_ID = "id"
        const val DB_FIELD_NAME = "name"
        const val DB_FIELD_NUMBER = "number"
        const val DB_FIELD_IMAGE = "image"

        const val sqlCreatePokemons = "CREATE TABLE IF NOT EXISTS $DB_TABLE_POKEMON(" +
                "$DB_FIELD_ID INTEGER PRIMARY KEY AUTOINCREMENT, " +
                "$DB_FIELD_NAME TEXT, " +
                "$DB_FIELD_NUMBER TEXT, " +
                "$DB_FIELD_IMAGE TEXT " +
                ");"
    }


    override fun onCreate(db: SQLiteDatabase?) {
        val db = db ?: return

        db.execSQL(sqlCreatePokemons)
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
    }

    override fun onDowngrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
    }

    fun getAllPokemons(): MutableList<Pokemon> {
        var pokemons = arrayListOf<Pokemon>()

        val db = readableDatabase

        val cursor = db.query(DB_TABLE_POKEMON, null, null, null, null, null, DB_FIELD_NAME)

        with(cursor) {
            while (moveToNext()) {
                val id = getInt(getColumnIndex(DB_FIELD_ID))
                val name = getString(getColumnIndex(DB_FIELD_NAME))
                val number = getString(getColumnIndex(DB_FIELD_NUMBER))
                val image = getString(getColumnIndex(DB_FIELD_IMAGE))
                val pokemon = Pokemon(number, name, image)
                pokemon.id = id.toLong()
                pokemons.add(pokemon)
            }
        }

        return pokemons
    }

    fun addPokemon(pokemon: Pokemon): Long {
        val db = writableDatabase

        val values = ContentValues().apply {
            put(DB_FIELD_NAME, pokemon.name)
            put(DB_FIELD_NUMBER, pokemon.number)
            put(DB_FIELD_IMAGE, pokemon.image)
        }

        val id = db.insert(DB_TABLE_POKEMON, "", values)

        db.close()

        return id
    }

    fun editPokemon(pokemon: Pokemon): Int {
        val db = writableDatabase

        val values = ContentValues().apply {
            put(DB_FIELD_NAME, pokemon.name)
            put(DB_FIELD_NUMBER, pokemon.number)
            put(DB_FIELD_IMAGE, pokemon.image)
        }

        val selection = "$DB_FIELD_ID = ?"
        val selectionArgs = arrayOf(pokemon.id.toString())
        val count = db.update(DB_TABLE_POKEMON, values, selection, selectionArgs)

        db.close()

        return count
    }

    fun removePokemon(pokemon: Pokemon): Int {
        val db = writableDatabase

        val selection = "$DB_FIELD_ID = ?"
        val selectionArgs = arrayOf(pokemon.id.toString())
        val count = db.delete(DB_TABLE_POKEMON, selection, selectionArgs)

        db.close()

        return count
    }

    fun clearPokemons(): Int {
        val db = writableDatabase

        val count = db.delete(DB_TABLE_POKEMON, null, null)

        db.close()

        return count
    }
}
package br.com.sthefanny.storeroom.Model

import android.content.Context

object DataStore {

    var login = "teste"
        private set
    var password = "123456"
        private set

    private lateinit var myContext: Context


    fun setContext(context: Context) {
        myContext = context
    }
}
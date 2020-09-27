package br.com.sthefanny.storeroom.Model

import android.content.Context
import android.net.Uri
import android.os.AsyncTask
import android.util.Log
import br.com.sthefanny.storeroom.Controller.Interfaces.LoadReceiverDelegate
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL

object DataStore {

    var login = "teste"
        private set
    var password = "123456"
        private set

    private lateinit var myContext: Context


    fun setContext(context: Context) {
        myContext = context
    }

    var items: MutableList<Item> = arrayListOf()
        private set

    fun getItem(position: Int): Item {
        return items.get(position)
    }

    fun addItem(city: Item, delegate: LoadReceiverDelegate) {
        TaskAddItem(city, delegate).execute("")
//        cities.add(city)
    }

    fun editCity(city: Item, position: Int, delegate: LoadReceiverDelegate) {
        TaskEditItem(city, delegate).execute("")
//        cities.set(position, city)
    }

    fun removeItem(position: Int, delegate: LoadReceiverDelegate) {
        TaskRemoveItem(getItem(position), delegate).execute("")
    }

    fun clearItems() {
        items.clear()
    }

    fun getRequest(endPoint: String, method: String, parameter: String?): String {
        val jsonStr = StringBuffer()

        val url = URL(endPoint)
        val connection: HttpURLConnection = url.openConnection() as HttpURLConnection

        connection.requestMethod = method

        connection.readTimeout = 5000
        connection.connectTimeout = 5000

        connection.doInput = true
        if (method.equals("POST")) {
            connection.doOutput = true
        }

        try {
            connection.connect()

            parameter?.let {
                OutputStreamWriter(connection.outputStream, "UTF-8").use {
                    it.write(parameter)
                    it.flush()
                }
            }

            if (connection.responseCode in 200..299) {
                BufferedReader(InputStreamReader(connection.inputStream)).use {
                    var inputLine = it.readLine()
                    while (inputLine != null) {
                        jsonStr.append(inputLine)
                        inputLine = it.readLine()
                    }
                    it.close()
                }
            }
            else {
                Log.d("Error!", "ResponseCode: ${connection.responseCode}")
            }
        }
        catch (e: Exception) {
            Log.d("Error!", e.localizedMessage)
        }
        finally {
            connection.disconnect()
        }

        return jsonStr.toString()
    }

    fun loadAllItems(delegate: LoadReceiverDelegate) {
        TaskLoadItems(delegate).execute("")
    }

    class TaskLoadItems(var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            return getRequest(params.first(), "GET", null)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val json = JSONObject(jsonStr)
                val itemsArray = json.getJSONArray("items")

                items.clear()

                for (i in 0 until itemsArray.length()) {
                    val item = itemsArray[i] as JSONObject

                    val idItem = item.getInt("idItem")
                    val image = item.getString("image")
                    val name = item.getString("name")
                    val quantity = item.getInt("quantity")

                    val newItem = Item(image, name, quantity)
                    newItem.id = idItem

                    items.add(newItem)
                }

                delegate.setStatus(true)
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }

    class TaskAddItem(var item: Item, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val builder = Uri.Builder()
            builder.appendQueryParameter("image", item.image)
            builder.appendQueryParameter("name", item.name)
            builder.appendQueryParameter("quantity", item.quantity.toString())
            val parameters = builder.build().encodedQuery

            return getRequest(params.first(), "POST", parameters)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val json = JSONObject(jsonStr)
                val result = json.getString("resultCode")

                if (result.equals("codeOk")) {
                    item.id = json.getInt("iditem")
                    delegate.setStatus(true)
                }
                else {
                    Log.d("Error!", "Operação de inserção falhou!!!")
                    delegate.setStatus(false)
                }
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }

    class TaskEditItem(var item: Item, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val builder = Uri.Builder()
            builder.appendQueryParameter("iditem", item.id.toString())
            builder.appendQueryParameter("image", item.image)
            builder.appendQueryParameter("name", item.name)
            builder.appendQueryParameter("quantity", item.quantity.toString())
            val parameters = builder.build().encodedQuery

            return getRequest(params.first(), "POST", parameters)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val json = JSONObject(jsonStr)
                val result = json.getString("resultCode")

                if (result.equals("codeOk")) {
                    delegate.setStatus(true)
                }
                else {
                    Log.d("Error!", "Operação de atualização falhou!!!")
                    delegate.setStatus(false)
                }
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }

    class TaskRemoveItem(var item: Item, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val builder = Uri.Builder()
            builder.appendQueryParameter("iditem", item.id.toString())
            val parameters = builder.build().encodedQuery

            return getRequest(params.first(), "POST", parameters)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val json = JSONObject(jsonStr)
                val result = json.getString("resultCode")

                if (result.equals("codeOk")) {
                    loadAllItems(delegate)
                }
                else {
                    Log.d("Error!", "Operação de atualização falhou!!!")
                    delegate.setStatus(false)
                }
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }
}
package br.com.sthefanny.storeroom.Model

import android.content.Context
import android.net.Uri
import android.os.AsyncTask
import android.util.Log
import br.com.sthefanny.storeroom.Controller.Interfaces.LoadReceiverDelegate
import org.json.JSONArray
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

    val baseUrl = "http://gonzagahouse.ddns-intelbrs.com.br:600/"

    var accessToken: String = ""

    private lateinit var myContext: Context


    fun setContext(context: Context) {
        myContext = context
        setUnitMeasurements()
    }

    var stores: MutableList<Store> = arrayListOf()
        private set

    var unitMeasurements: MutableList<UnitMeasurementEnum> = arrayListOf()
        private set

    var products: MutableList<Product> = arrayListOf()
        private set

    fun setUnitMeasurements() {
        unitMeasurements.add(UnitMeasurementEnum.WEIGHT)
        unitMeasurements.add(UnitMeasurementEnum.PACK)
    }

    fun loadAllItemsFromStore(delegate: LoadReceiverDelegate) {
        TaskLoadStores(delegate).execute("$baseUrl/Store/list")
    }

    fun getItemFromStore(position: Int): Store {
        return stores.get(position)
    }

    fun addItemToStore(city: Store, delegate: LoadReceiverDelegate) {
        TaskAddStore(city, delegate).execute("$baseUrl/Store")
    }

    fun editItemFromStore(city: Store, position: Int, delegate: LoadReceiverDelegate) {
        TaskEditStore(city, delegate).execute("$baseUrl/Store/teste")
    }

    fun removeItemFromStore(position: Int, delegate: LoadReceiverDelegate) {
        TaskRemoveStore(getItemFromStore(position), delegate).execute("$baseUrl/Store/delete")
    }

    fun clearAllItemsFromStore() {
        stores.clear()
    }

    fun loadAllProducts(delegate: LoadReceiverDelegate) {
        TaskLoadAllProducts(delegate).execute("$baseUrl/Product/list")
    }

    fun getProduct(position: Int): Product {
        return products.get(position)
    }

    fun getProductById(id: Int): Product? {
        return products.firstOrNull { it.id == id }
    }

    fun clearAllProducts() {
        products.clear()
    }

    fun getRequest(endPoint: String, method: String, parameter: String?): String {
        val jsonStr = StringBuffer()

        val url = URL(endPoint)
        val connection: HttpURLConnection = url.openConnection() as HttpURLConnection

        connection.requestMethod = method

        connection.readTimeout = 50000000
        connection.connectTimeout = 500000000
        connection.setRequestProperty("Authorization", "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIyIiwidXNlck5hbWUiOiJTdGhlZmFubnkiLCJuYmYiOjE2MDE2Nzk0MzksImV4cCI6MTYwNDI3MTQzOSwiaWF0IjoxNjAxNjc5NDM5LCJpc3MiOiJTdG9yZVJvb20iLCJhdWQiOiJFdmVyeW9uZSJ9.EYA0m_G9HexLwh0S0WxeKzwkN2pCY0i08fbsakeNjZEK30LVSAkePMCTfS3W0fvyinJF4zAtWB-D2f1xQmJhhA");

        connection.doInput = true
        if (method.equals("POST") || method.equals("PUT")) {
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

    class TaskLoadStores(var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            return getRequest(params.first(), "GET", null)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val storesArray = JSONArray(jsonStr)

                stores.clear()

                for (i in 0 until storesArray.length()) {
                    val store = storesArray[i] as JSONObject

                    val idStore = store.getInt("id")
                    val productId = store.getInt("productId")
                    val productName = store.getString("product")
                    val quantity = store.getInt("quantity")
                    val unitMeasurement = store.getInt("unitMea")

                    val newStore = Store(productId, productName, quantity, unitMeasurement)
                    newStore.id = idStore

                    stores.add(newStore)
                }

                delegate.setStatus(true)
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }

    class TaskAddStore(var store: Store, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val builder = Uri.Builder()
            builder.appendQueryParameter("productId", store.productId.toString())
            builder.appendQueryParameter("product", store.productName)
            builder.appendQueryParameter("quantity", store.quantity.toString())
            builder.appendQueryParameter("unitMea", store.unitMeasurement.toString())
            val parameters = builder.build().encodedQuery

            return getRequest(params.first(), "POST", parameters)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val json = JSONObject(jsonStr)
                val result = json.getString("resultCode")

                if (result.equals("codeOk")) {
                    store.id = json.getInt("id")
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

    class TaskEditStore(var store: Store, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val builder = Uri.Builder()
            builder.appendQueryParameter("id", store.id.toString())
            builder.appendQueryParameter("productId", store.productId.toString())
            builder.appendQueryParameter("quantity", store.quantity.toString())
            builder.appendQueryParameter("unitMea", store.unitMeasurement.toString())
            val parameters = builder.build().encodedQuery

            return getRequest(params.first(), "POST", parameters)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                loadAllItemsFromStore(delegate)
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }

    class TaskRemoveStore(var store: Store, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val builder = Uri.Builder()
            builder.appendQueryParameter("id", store.id.toString())
            val parameters = builder.build().encodedQuery

            return getRequest(params.first(), "POST", parameters)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                if (jsonStr.equals("true")) {
                    loadAllItemsFromStore(delegate)
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

    class TaskLoadAllProducts(var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            return getRequest(params.first(), "GET", null)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val storesArray = JSONArray(jsonStr)

                products.clear()

                for (i in 0 until storesArray.length()) {
                    val store = storesArray[i] as JSONObject

                    val productId = store.getInt("id")
                    val productName = store.getString("name")

                    val newProduct = Product(productName)
                    newProduct.id = productId

                    products.add(newProduct)
                }

                delegate.setStatus(true)
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }
}
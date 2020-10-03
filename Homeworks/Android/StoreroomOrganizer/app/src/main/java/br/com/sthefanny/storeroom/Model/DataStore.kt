package br.com.sthefanny.storeroom.Model

import android.content.Context
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

    val baseUrl = "http://gonzagahouse.ddns-intelbrs.com.br:600"
//    val baseUrl = "http://192.168.0.115:4001"

    var accessToken: String = ""

    private lateinit var myContext: Context


    fun setContext(context: Context) {
        myContext = context
        setUnitMeasurements()
    }

    var stores: MutableList<Store> = arrayListOf()
        private set

    var unitMeasurements: MutableList<UnitMeasurement> = arrayListOf()
        private set

    var products: MutableList<Product> = arrayListOf()
        private set

    fun setUnitMeasurements() {
        unitMeasurements.add(UnitMeasurement(0, "Peso"))
        unitMeasurements.add(UnitMeasurement(1, "Unidade"))
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
        TaskEditStore(city, delegate).execute("$baseUrl/Store")
    }

    fun removeItemFromStore(position: Int, delegate: LoadReceiverDelegate) {
        TaskRemoveStore(getItemFromStore(position), delegate).execute("$baseUrl/Store")
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

    fun addUser(user: User, delegate: LoadReceiverDelegate) {
        TaskAddUser(user, delegate).execute("$baseUrl/User")
    }

    fun loginUser(user: User, delegate: LoadReceiverDelegate) {
        TaskLoginUser(user, delegate).execute("$baseUrl/User/login")
    }

    fun getRequest(endPoint: String, method: String, parameters: JSONObject?, auth: Boolean): String {
        val jsonStr = StringBuffer()

        val url = URL(endPoint)
        val connection: HttpURLConnection = url.openConnection() as HttpURLConnection

        connection.requestMethod = method

        connection.readTimeout = 50000000
        connection.connectTimeout = 500000000

        if (auth) {
            connection.setRequestProperty(
                "Authorization",
                accessToken
            )
        }
        connection.setRequestProperty("Content-Type", "application/json; charset=utf-8")

        connection.doInput = true
        if (method != "GET") {
            connection.doOutput = true
        }

        try {
            connection.connect()

            parameters?.let {
                OutputStreamWriter(connection.outputStream, "UTF-8").use {
                    it.write(parameters.toString())
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
            return getRequest(params.first(), "GET", null, true)
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
            val parameters = JSONObject()
            parameters.put("productId", store.productId)
            parameters.put("product", store.productName)
            parameters.put("quantity", store.quantity)
            parameters.put("unitMea", store.unitMeasurement)

            return getRequest(params.first(), "POST", parameters, true)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                delegate.setStatus(true)
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }

    class TaskEditStore(var store: Store, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val parameters = JSONObject()
            parameters.put("id", store.id)
            parameters.put("productId", store.productId)
            parameters.put("quantity", store.quantity)
            parameters.put("unitMea", store.unitMeasurement)

            return getRequest(params.first(), "PUT", parameters, true)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                if(jsonStr.isNotEmpty()) {
                    delegate.setStatus(true)
                }
                else{
                    delegate.setStatus(false)
                }
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
            val url = "${params.first()}/${store.id}"

            return getRequest(url, "DELETE", null, true)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                loadAllItemsFromStore(delegate)
                delegate.setStatus(true)
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }

    class TaskLoadAllProducts(var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            return getRequest(params.first(), "GET", null, true)
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

    class TaskAddUser(var user: User, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val parameters = JSONObject()
            parameters.put("name", user.name)
            parameters.put("email", user.email)
            parameters.put("password", user.password)

            return getRequest(params.first(), "POST", parameters, false)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val user = JSONObject(jsonStr)
                val id = user.getInt("id")
                if(id != null){
                    delegate.setStatus(true)
                }
                else{
                    delegate.setStatus(false)
                }
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }

    class TaskLoginUser(var user: User, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val parameters = JSONObject()
            parameters.put("email", user.email)
            parameters.put("password", user.password)

            return getRequest(params.first(), "POST", parameters, true)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val user = JSONObject(jsonStr)
                val responseAccessToken = user.getString("accessToken")
                if(responseAccessToken != null && responseAccessToken.isNotEmpty()){
                    accessToken = responseAccessToken
                    delegate.setStatus(true)
                }
                else{
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
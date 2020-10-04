package br.com.sthefanny.storeroom.Model

import android.content.Context
import android.graphics.Bitmap
import android.os.AsyncTask
import android.util.Log
import br.com.sthefanny.storeroom.Controller.Interfaces.AddImageDelegate
import br.com.sthefanny.storeroom.Controller.Interfaces.LoadReceiverDelegate
import com.github.kittinunf.fuel.*
import com.github.kittinunf.fuel.core.FileDataPart
import com.github.kittinunf.fuel.core.InlineDataPart
import com.github.kittinunf.fuel.gson.responseObject
import com.github.kittinunf.result.Result
import org.json.JSONArray
import org.json.JSONObject
import java.io.*
import java.net.HttpURLConnection
import java.net.URL


object DataStore {

    val baseUrl = "http://gonzagahouse.ddns-intelbrs.com.br:600"
//    val baseUrl = "http://192.168.0.110:4001"

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

    fun loadAllProducts(responseHandler : (result: ResponseModel) -> Unit?) {
        val responseModel = ResponseModel()
        val url = "$baseUrl/Product/list"
        url.httpGet().header("Content-Type", "application/json; charset=utf-8")
            .header("Authorization", accessToken)
            .responseObject<List<Product>>{ _, _, result->
                when(result){
                    is Result.Failure ->{
                        val message = result.getException().localizedMessage
                        Log.d("Error!", "ResponseCode: $message")

                        responseModel.hasError = true
                        responseModel.error = message

                        responseHandler.invoke(responseModel)
                    }

                    is Result.Success ->{
                        val(data, _) = result
                        if (data != null){
                            clearAllItemsFromStore()
                            products.addAll(data)

                            responseModel.hasSuccess = true
                            responseModel.success = "Success"

                            responseHandler.invoke(responseModel)
                        }
                    }
                }
            }
    }

    fun loadAllItemsFromStore(responseHandler : (result: ResponseModel) -> Unit?) {
        val responseModel = ResponseModel()
        val url = "$baseUrl/Store/list"
        url.httpGet().header("Content-Type", "application/json; charset=utf-8")
            .header("Authorization", accessToken)
            .responseObject<List<Store>>{ _, _, result->
                when(result){
                    is Result.Failure ->{
                        val message = result.getException().localizedMessage
                        Log.d("Error!", "ResponseCode: $message")

                        responseModel.hasError = true
                        responseModel.error = message

                        responseHandler.invoke(responseModel)
                    }

                    is Result.Success ->{
                        val(data, _) = result
                        if (data != null){
                            clearAllItemsFromStore()
                            data.forEach {
                                var product = getProductById(it.productId)
                                var item: Store = it
                                item.product = product?.name ?: ""
                                stores.add(item)

                                responseModel.hasSuccess = true
                                responseModel.success = "Success"

                                responseHandler.invoke(responseModel)
                            }
                        }
                    }
                }
        }
    }

    fun getItemFromStore(position: Int): Store {
        return stores.get(position)
    }

    fun addItemToStore(store: Store, responseHandler : (result: ResponseModel) -> Unit?) {
        val url = "$baseUrl/Store"
        val responseModel = ResponseModel()

        val body = JSONObject()
        body.put("productId", store.productId)
        body.put("product", store.product)
        body.put("quantity", store.quantity)
        body.put("unitMea", store.unitMea)

        url.httpPost()
            .header("Content-Type", "application/json; charset=utf-8")
            .header("Authorization", accessToken)
            .body(body.toString())
            .responseObject<Store>{ _, _, result->
                when(result){
                    is Result.Failure ->{
                        val message = result.getException().localizedMessage
                        Log.d("Error!", "ResponseCode: $message")

                        responseModel.hasError = true
                        responseModel.error = message

                        responseHandler.invoke(responseModel)
                    }

                    is Result.Success ->{
                        val(data, _) = result
                        if (data != null){
                            stores.add(data)

                            responseModel.hasSuccess = true
                            responseModel.success = "Item adicionado: ${data.product}"
                            responseModel.createdId = data.id

                            responseHandler.invoke(responseModel)
                        }
                    }
                }
            }
    }

    fun addImageToStore(storeId: Int, file: File, responseHandler : (result: ResponseModel) -> Unit?) {
        val url = "$baseUrl/Store/image"
        val responseModel = ResponseModel()

        val body = JSONObject()
        body.put("request.Id", storeId)
        body.put("request.File", file)

        Fuel.upload(url)
            .add(
                FileDataPart(file, name = "request.File", filename="teste.png"),
                InlineDataPart(storeId.toString(), name = "request.Id")
            )
            .header(mutableMapOf(
                "Authorization" to accessToken,
                "Content-Type" to "multipart/form-data; boundary=--------------------------353036372019982236523763")
            )
            .responseObject<Store>{ _, _, result->
                when(result){
                    is Result.Failure ->{
                        val message = result.getException().localizedMessage
                        Log.d("Error!", "ResponseCode: $message")

                        responseModel.hasError = true
                        responseModel.error = message

                        responseHandler.invoke(responseModel)
                    }

                    is Result.Success ->{
                        val(data, _) = result
                        if (data != null){
                            stores.add(data)

                            responseModel.hasSuccess = true
                            responseModel.success = "Image adicionada"

                            responseHandler.invoke(responseModel)
                        }
                    }
                }
            }
    }

    fun editItemFromStore(store: Store, responseHandler : (result: ResponseModel) -> Unit?) {
//        TaskEditStore(city, delegate).execute("$baseUrl/Store")
        val responseModel = ResponseModel()
        val url = "$baseUrl/Store"

        val body = JSONObject()
        body.put("id", store.id)
        body.put("productId", store.productId)
        body.put("product", store.product)
        body.put("quantity", store.quantity)
        body.put("unitMea", store.unitMea)

        url.httpPut()
            .header("Content-Type", "application/json; charset=utf-8")
            .header("Authorization", accessToken)
            .body(body.toString())
            .responseObject<Store>{ _, _, result->
                when(result){
                    is Result.Failure ->{
                        val message = result.getException().localizedMessage
                        Log.d("Error!", "ResponseCode: $message")

                        responseModel.hasError = true
                        responseModel.error = message

                        responseHandler.invoke(responseModel)
                    }

                    is Result.Success ->{
                        val(data, _) = result
                        if (data != null){
                            stores.add(data)

                            responseModel.hasSuccess = true
                            responseModel.success = "Item atualizado: ${data.product}"
                            responseModel.createdId = data.id

                            responseHandler.invoke(responseModel)
                        }
                    }
                }
            }
    }

    fun removeItemFromStore(position: Int, responseHandler : (result: ResponseModel) -> Unit?) {
//        TaskRemoveStore(getItemFromStore(position), delegate).execute("$baseUrl/Store")
        val responseModel = ResponseModel()
        var item = getItemFromStore(position)
        val url = "$baseUrl/Store/${item.id}"

        url.httpDelete()
            .header("Content-Type", "application/json; charset=utf-8")
            .header("Authorization", accessToken)
            .response{ _, _, result->
                when(result){
                    is Result.Failure ->{
                        val message = result.getException().localizedMessage
                        Log.d("Error!", "ResponseCode: $message")

                        responseModel.hasError = true
                        responseModel.error = message

                        responseHandler.invoke(responseModel)
                    }

                    is Result.Success ->{
                            responseModel.hasSuccess = true
                            responseModel.success = "Item removido: ${item.product}"

                            responseHandler.invoke(responseModel)
                    }
                }
            }
    }

    fun clearAllItemsFromStore() {
        stores.clear()
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

    fun addUser(user: User, responseHandler : (result: ResponseModel) -> Unit?) {
        val url = "$baseUrl/User"
        val responseModel = ResponseModel()

        val body = JSONObject()

        body.put("name", user.name)
        body.put("email", user.email)
        body.put("password", user.password)

        url.httpPost()
            .header("Content-Type", "application/json; charset=utf-8")
            .body(body.toString())
            .responseObject<User>{ _, _, result->
                when(result){
                    is Result.Failure ->{
                        val message = result.getException().localizedMessage
                        Log.d("Error!", "ResponseCode: $message")

                        responseModel.hasError = true
                        responseModel.error = message

                        responseHandler.invoke(responseModel)
                    }

                    is Result.Success ->{
                        val(data, _) = result
                        if (data != null) {
                            responseModel.hasSuccess = true
                            responseModel.success = "Usuário criado: ${data.name}"

                            responseHandler.invoke(responseModel)
                        }
                    }
                }
            }
    }

    fun loginUser(user: User, responseHandler : (result: ResponseModel) -> Unit?) {
        val url = "$baseUrl/User/login"
        val responseModel = ResponseModel()

        val body = JSONObject()

        body.put("email", user.email)
        body.put("password", user.password)

        url.httpPost()
            .header("Content-Type", "application/json; charset=utf-8")
            .body(body.toString())
            .responseObject<User>{ _, _, result->
                when(result){
                    is Result.Failure ->{
                        val message = result.getException().localizedMessage
                        Log.d("Error!", "ResponseCode: $message")

                        responseModel.hasError = true
                        responseModel.error = message

                        responseHandler.invoke(responseModel)
                    }

                    is Result.Success ->{
                        val(data, _) = result
                        if (data?.accessToken != null && data.accessToken!!.isNotEmpty()){
                            accessToken = data.accessToken!!

                            responseModel.hasSuccess = true
                            responseModel.success = "Success"

                            responseHandler.invoke(responseModel)
                        }
                    }
                }
            }
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

    fun getFileRequest(endPoint: String, id: Int, bitmap: Bitmap): String {
        val jsonStr = StringBuffer()

        val url = URL(endPoint)
        val connection: HttpURLConnection = url.openConnection() as HttpURLConnection

        connection.requestMethod = "POST"

        connection.readTimeout = 50000000
        connection.connectTimeout = 500000000

        connection.setRequestProperty("Authorization", accessToken)
        connection.setRequestProperty("Content-Type", "multipart/form-data")

        connection.doInput = true
        connection.doOutput = true

        try {
            connection.connect()

            val attachmentName = "bitmap"
            val attachmentFileName = "bitmap.bmp"
            val crlf = "\r\n"
            val twoHyphens = "--"
            val boundary = "*****"

            val request = DataOutputStream(
                connection.getOutputStream()
            )

            request.writeBytes(twoHyphens + boundary + crlf)
            request.writeBytes(
                "Content-Disposition: form-data; name=\"" +
                        attachmentName + "\";filename=\"" +
                        attachmentFileName + "\"" + crlf
            )
            request.writeBytes(crlf)

            val pixels = ByteArray(bitmap.getWidth() * bitmap.getHeight())
            for (i in 0 until bitmap.getWidth()) {
                for (j in 0 until bitmap.getHeight()) {
                    //we're interested only in the MSB of the first byte,
                    //since the other 3 bytes are identical for B&W images
                    pixels[i + j] = ((bitmap.getPixel(i, j) and 0x80 shr 7).toByte())
                }
            }

            request.write(pixels)

            request.writeBytes(crlf)
            request.writeBytes(twoHyphens + boundary + twoHyphens + crlf)

            request.flush()
            request.close()


            val responseStream: InputStream =
                BufferedInputStream(connection.getInputStream())

            val responseStreamReader = BufferedReader(InputStreamReader(responseStream))

            var line: String? = ""
            val stringBuilder = StringBuilder()

            while (responseStreamReader.readLine().also { line = it } != null) {
                stringBuilder.append(line).append("\n")
            }
            responseStreamReader.close()

            val response = stringBuilder.toString()

            responseStream.close()

            connection.disconnect()
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

                    val newStore = Store(productId, productName, quantity, unitMeasurement, "")
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

    class TaskAddStore(var store: Store, var delegate: LoadReceiverDelegate, var imageDelegate: AddImageDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val parameters = JSONObject()
            parameters.put("productId", store.productId)
            parameters.put("product", store.product)
            parameters.put("quantity", store.quantity)
            parameters.put("unitMea", store.unitMea)

            return getRequest(params.first(), "POST", parameters, true)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val storeObject = JSONObject(jsonStr)
                val storeId = storeObject.getInt("id")
                delegate.setStatus(true)
                imageDelegate.addImage(storeId)
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }

    class TaskAddImageToStore(var storeId: Int, var bitmap: Bitmap, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {

            return getFileRequest(params.first(), storeId, bitmap)
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
            parameters.put("unitMea", store.unitMea)

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
//                loadAllItemsFromStore(layMain)
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
//                loadAllItemsFromStore(layMain)
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
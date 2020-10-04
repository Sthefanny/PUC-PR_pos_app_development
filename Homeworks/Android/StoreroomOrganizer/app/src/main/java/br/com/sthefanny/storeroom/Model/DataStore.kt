package br.com.sthefanny.storeroom.Model

import android.content.Context
import android.util.Log
import com.github.kittinunf.fuel.*
import com.github.kittinunf.fuel.core.FileDataPart
import com.github.kittinunf.fuel.core.InlineDataPart
import com.github.kittinunf.fuel.gson.responseObject
import com.github.kittinunf.result.Result
import org.json.JSONObject
import java.io.*


object DataStore {

    val baseUrl = "http://gonzagahouse.ddns-intelbras.com.br:600"
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

    fun logoutUser(responseHandler : (result: ResponseModel) -> Unit?) {
        val url = "$baseUrl/User/logout"
        val responseModel = ResponseModel()

        url.httpPost()
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

                    is Result.Success -> {
                        responseModel.hasSuccess = true
                        responseModel.success = "Deslogado com sucesso"

                        responseHandler.invoke(responseModel)
                    }
                }
            }
    }
}
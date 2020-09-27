package br.pucpr.appdev.aula02recyclerview.Model

import android.net.Uri
import android.os.AsyncTask
import android.util.Log
import br.pucpr.appdev.aula02recyclerview.Controller.Interfaces.LoadReceiverDelegate
import org.json.JSONObject
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL

object
DataStore {

    var cities: MutableList<City> = arrayListOf()
        private set

    fun getCity(position: Int): City {
        return cities.get(position)
    }

    fun addCity(city: City, delegate: LoadReceiverDelegate) {
        TaskAddCity(city, delegate).execute("http://bepid.hospedagemdesites.ws/appdev/saveCity.asp")
//        cities.add(city)
    }

    fun editCity(city: City, position: Int, delegate: LoadReceiverDelegate) {
        TaskEditCity(city, delegate).execute("http://bepid.hospedagemdesites.ws/appdev/editCity.asp")
//        cities.set(position, city)
    }

    fun removeCity(position: Int, delegate: LoadReceiverDelegate) {
        TaskRemoveCity(getCity(position), delegate).execute("http://bepid.hospedagemdesites.ws/appdev/delCity.asp")
    }

    fun clearCities() {
        cities.clear()
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

            if (connection.responseCode >= 200 && connection.responseCode <= 299) {
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

    fun loadAllCities(delegate: LoadReceiverDelegate) {
        TaskLoadCities(delegate).execute("http://bepid.hospedagemdesites.ws/appdev/getIniData.asp")
    }

    class TaskLoadCities(var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            return getRequest(params.first(), "GET", null)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val json = JSONObject(jsonStr)
                val citiesArray = json.getJSONArray("cities")

                cities.clear()

                for (i in 0 until citiesArray.length()) {
                    val city = citiesArray[i] as JSONObject

                    val idCity = city.getInt("idcity")
                    val name = city.getString("name")
                    val people = city.getInt("people")

                    val newCity = City(name, people)
                    newCity.id = idCity

                    cities.add(newCity)
                }

                delegate.setStatus(true)
            }
            catch (e: Exception) {
                Log.d("Error!", "JSON error: ${e.localizedMessage}")
                delegate.setStatus(false)
            }
        }
    }

    class TaskAddCity(var city: City, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val builder = Uri.Builder()
            builder.appendQueryParameter("name", city.name)
            builder.appendQueryParameter("people", city.people.toString())
            val parameters = builder.build().encodedQuery

            return getRequest(params.first(), "POST", parameters)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val json = JSONObject(jsonStr)
                val result = json.getString("resultCode")

                if (result.equals("codeOk")) {
                    city.id = json.getInt("idcity")
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

    class TaskEditCity(var city: City, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val builder = Uri.Builder()
            builder.appendQueryParameter("idcity", city.id.toString())
            builder.appendQueryParameter("name", city.name)
            builder.appendQueryParameter("people", city.people.toString())
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

    class TaskRemoveCity(var city: City, var delegate: LoadReceiverDelegate): AsyncTask<String, Void, String>() {
        override fun doInBackground(vararg params: String): String {
            val builder = Uri.Builder()
            builder.appendQueryParameter("idcity", city.id.toString())
            val parameters = builder.build().encodedQuery

            return getRequest(params.first(), "POST", parameters)
        }

        override fun onPostExecute(jsonStr: String) {
            super.onPostExecute(jsonStr)

            try {
                val json = JSONObject(jsonStr)
                val result = json.getString("resultCode")

                if (result.equals("codeOk")) {
                    loadAllCities(delegate)
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
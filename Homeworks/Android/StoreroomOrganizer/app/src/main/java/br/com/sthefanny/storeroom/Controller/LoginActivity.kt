package br.com.sthefanny.storeroom.Controller

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import br.com.sthefanny.storeroom.Controller.Interfaces.LoadReceiverDelegate
import br.com.sthefanny.storeroom.Model.DataStore
import br.com.sthefanny.storeroom.Model.ResponseModel
import br.com.sthefanny.storeroom.Model.User
import br.com.sthefanny.storeroom.R
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_login.*
import kotlinx.android.synthetic.main.activity_main.*

class LoginActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        DataStore.setContext(this)

        val preferences =
            getSharedPreferences(getString(R.string.file_preferences), Context.MODE_PRIVATE)
        val remember = preferences.getBoolean(getString(R.string.pref_remember), false)

        val login = preferences.getString(getString(R.string.pref_login), null)
        val password = preferences.getString(getString(R.string.pref_password), null)

        if (remember) {
            swiRemember.isChecked = remember
            txtLogin.setText(login)
            txtPassword.setText(password)
        }


        txtBtnCreateUser.setOnClickListener {
            val intent = Intent(this@LoginActivity, ManagerUserActivity::class.java).apply {
                putExtra("type", 1)
            }
            startActivityForResult(intent, 1)
        }
    }

    fun btnSigninOnClick(view: View) {
        val login = txtLogin.text.toString()
        val password = txtPassword.text.toString()

        if (login.isNotEmpty() && password.isNotEmpty()) {
            val user = User("", login, password, null)
            DataStore.loginUser(user){responseModel -> handleLogin(responseModel)}
        } else {
            val dialog = AlertDialog.Builder(this)
            dialog.setTitle("Erro")
            dialog.setMessage("Login ou senha não confere!!!")
            dialog.setPositiveButton(android.R.string.ok, null)
            dialog.show()
        }
    }

    private fun savePrefs() {
        val preferences =
            getSharedPreferences(getString(R.string.file_preferences), Context.MODE_PRIVATE)

        if (swiRemember.isChecked) {
            preferences.edit().apply {
                putBoolean(getString(R.string.pref_remember), swiRemember.isChecked)
                putString(getString(R.string.pref_login), txtLogin.text.toString())
                putString(getString(R.string.pref_password), txtPassword.text.toString())
                commit()
            }
        } else {
            preferences.edit().apply {
                putBoolean(getString(R.string.pref_remember), swiRemember.isChecked)
                putString(getString(R.string.pref_login), null)
                putString(getString(R.string.pref_password), null)
                commit()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        var name = ""
        data?.let {

            name = data.getStringExtra("name").toString()
        } ?: run {

            name = "Erro de nome"
        }

        if (resultCode == Activity.RESULT_OK) {

            Snackbar.make(layLogin, "Usuário criado: ${name}", Snackbar.LENGTH_LONG).show()
        }
    }

    private fun handleLogin(responseModel: ResponseModel) {
        if (responseModel.hasError != null && responseModel.hasError!!) {
            Toast.makeText(this, responseModel.error, Toast.LENGTH_SHORT).show()
        }
        else if (responseModel.hasSuccess != null && responseModel.hasSuccess!!) {
            savePrefs()

            val mainIntent = Intent(this, MainActivity::class.java)
            startActivity(mainIntent)
            finish()
        }
    }
}
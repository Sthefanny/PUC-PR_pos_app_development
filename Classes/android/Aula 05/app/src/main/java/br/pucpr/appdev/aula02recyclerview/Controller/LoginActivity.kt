package br.pucpr.appdev.aula02recyclerview.Controller

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AlertDialog
import br.pucpr.appdev.aula02recyclerview.Model.DataStore
import br.pucpr.appdev.aula02recyclerview.R
import kotlinx.android.synthetic.main.activity_login.*

class LoginActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        DataStore.setContext(this)

        val preferences = getSharedPreferences(getString(R.string.file_preferences), Context.MODE_PRIVATE)
        val remember = preferences.getBoolean(getString(R.string.pref_remember), false)

        val login = preferences.getString(getString(R.string.pref_login), null)
        val password = preferences.getString(getString(R.string.pref_password), null)

        if (remember) {
            swiRemember.isChecked = remember
            txtLogin.setText(login)
            txtPassword.setText(password)
        }
    }

    fun btnSigninOnClick(view: View) {
        val login = txtLogin.text.toString()
        val password = txtPassword.text.toString()

        if (login.equals(DataStore.login) && password.equals(DataStore.password)) {

            val preferences = getSharedPreferences(getString(R.string.file_preferences), Context.MODE_PRIVATE)

            if (swiRemember.isChecked) {
                preferences.edit().apply {
                    putBoolean(getString(R.string.pref_remember), swiRemember.isChecked)
                    putString(getString(R.string.pref_login), txtLogin.text.toString())
                    putString(getString(R.string.pref_password), txtPassword.text.toString())
                    commit()
                }
            }
            else {
                preferences.edit().apply {
                    putBoolean(getString(R.string.pref_remember), swiRemember.isChecked)
                    putString(getString(R.string.pref_login), null)
                    putString(getString(R.string.pref_password), null)
                    commit()
                }
            }

            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)
            finish()
        }
        else {
            val dialog = AlertDialog.Builder(this)
            dialog.setTitle("Erro")
            dialog.setMessage("Login ou senha não confere!!!")
            dialog.setPositiveButton(android.R.string.ok, null)
            dialog.show()
        }
    }
}
package br.com.sthefanny.storeroom.Controller

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Toast
import br.com.sthefanny.storeroom.Model.DataStore
import br.com.sthefanny.storeroom.Model.ResponseModel
import br.com.sthefanny.storeroom.Model.User
import br.com.sthefanny.storeroom.R
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.activity_manager_user.*
import kotlinx.android.synthetic.main.activity_manager_user.toolbar

class ManagerUserActivity : AppCompatActivity() {
    var userName = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_manager_user)
        setSupportActionBar(toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)
        supportActionBar?.title = "Adicionar Usuário"
    }

    fun addUserOnClick(view: View) {
        var name: String = txtName.text.toString()
        var email: String = txtEmail.text.toString()
        var pass: String = txtPass.text.toString()
        var confirmPass: String = txtPassConfirm.text.toString()

        if (pass.equals(confirmPass) && name.isNotEmpty() && email.isNotEmpty()) {
            userName = name
            val user = User(name, email, pass, null)
            DataStore.addUser(user){responseModel -> handleAdduser(responseModel)}
        }
        else {
            Snackbar.make(layManagerStore, "Senha e confirmação devem ser iguais", Snackbar.LENGTH_LONG).show()
        }
    }

    private fun handleAdduser(responseModel: ResponseModel) {
        if (responseModel.hasError != null && responseModel.hasError!!) {
            Toast.makeText(this, responseModel.error, Toast.LENGTH_SHORT).show()
        }
        else if (responseModel.hasSuccess != null && responseModel.hasSuccess!!) {
            val intent = Intent().apply {
                putExtra("name", userName)
            }
            setResult(RESULT_OK, intent)

            finish()
        }
    }
}
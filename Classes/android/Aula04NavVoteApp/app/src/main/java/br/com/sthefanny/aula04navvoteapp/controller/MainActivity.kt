package br.com.sthefanny.aula04navvoteapp.controller

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.drawerlayout.widget.DrawerLayout
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.navigateUp
import androidx.navigation.ui.setupActionBarWithNavController
import androidx.navigation.ui.setupWithNavController
import br.com.sthefanny.aula04navvoteapp.R
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.android.material.navigation.NavigationView
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    lateinit var appBarConfiguration: AppBarConfiguration

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(toolbar)

        val navView: NavigationView = findViewById(R.id.navView)
        val navController = findNavController(R.id.fragNavHost)

        val drawer: DrawerLayout = findViewById(R.id.layDrawer)
        appBarConfiguration = AppBarConfiguration(setOf(R.id.voteFragment, R.id.countFragment), drawer)
        setupActionBarWithNavController(navController, appBarConfiguration)
        navView.setupWithNavController(navController)
    }

    override fun onSupportNavigateUp(): Boolean {

        val navController = findNavController(R.id.fragNavHost)

        return navController.navigateUp(appBarConfiguration) || super.onSupportNavigateUp()
    }

    fun changeTitle(title: String) {
        supportActionBar?.title = title
    }
}
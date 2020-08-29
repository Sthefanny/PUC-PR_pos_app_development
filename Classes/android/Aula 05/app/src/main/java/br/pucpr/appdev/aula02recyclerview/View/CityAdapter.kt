package br.pucpr.appdev.aula02recyclerview.View

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import br.pucpr.appdev.aula02recyclerview.Model.City
import br.pucpr.appdev.aula02recyclerview.R
import kotlinx.android.synthetic.main.rcv_cities.view.*

class CityAdapter(var cities: MutableList<City>) : RecyclerView.Adapter<CityAdapter.CityHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CityHolder {

        val view = LayoutInflater.from(parent.context).inflate(R.layout.rcv_cities, parent, false)

        return CityHolder(view)
    }

    override fun getItemCount(): Int {
        return cities.size
    }

    override fun onBindViewHolder(holder: CityHolder, position: Int) {

        val city = cities.get(position)

        holder.txtName.text = "Cidade: ${city.name}"
        holder.txtPeople.text = "População: ${city.people}"
    }

    inner class CityHolder(view: View) : RecyclerView.ViewHolder(view) {

        var txtName: TextView
        var txtPeople: TextView
        var layCell: LinearLayout

        init {
            txtName = view.findViewById(R.id.txtName)
            txtPeople = view.findViewById(R.id.txtPeople)
            layCell = view.findViewById(R.id.layCell)
        }
    }
}
package br.com.sthefanny.storeroom.View

import android.net.Uri
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView
import br.com.sthefanny.storeroom.Model.DataStore
import br.com.sthefanny.storeroom.Model.Store
import br.com.sthefanny.storeroom.R
import com.squareup.picasso.Picasso

class StoreAdapter(var stores: MutableList<Store>) : RecyclerView.Adapter<StoreAdapter.StoreHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): StoreHolder {

        val view = LayoutInflater.from(parent.context).inflate(R.layout.rcv_stores, parent, false)

        return StoreHolder(view)
    }

    override fun getItemCount(): Int {
        return stores.size
    }

    override fun onBindViewHolder(holder: StoreHolder, position: Int) {

        val store = stores.get(position)

        holder.txtProductName.text = store.product
        holder.txtQuantity.text = store.quantity.toString()
        holder.txtUnitMeasurement.text = getUnitMeasurementText(store.unitMea)
        if (store.imageUrl != null && store.imageUrl.isNotEmpty()){
            val imageUrl = "${DataStore.baseUrl}${store.imageUrl}"
            Picasso.get().load(Uri.parse(imageUrl)).into(holder.imvImageUrl)
        }
    }

    private fun getUnitMeasurementText(unitNumber: Int): String {
        when (unitNumber) {
            0 -> return "grama(s)"
            1 -> return "unidade(s)"
            else -> throw Exception()
        }
    }

    inner class StoreHolder(view: View) : RecyclerView.ViewHolder(view) {

        var txtProductName: TextView
        var txtQuantity: TextView
        var txtUnitMeasurement: TextView
        var imvImageUrl: ImageView
        var layCell: CardView

        init {
            txtProductName = view.findViewById(R.id.txtProductName)
            txtQuantity = view.findViewById(R.id.txtQuantity)
            txtUnitMeasurement = view.findViewById(R.id.txtUnitMeasurement)
            imvImageUrl = view.findViewById(R.id.imvImageUrl)
            layCell = view.findViewById(R.id.layCell)
        }
    }
}
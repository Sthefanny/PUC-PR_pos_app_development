package br.com.sthefanny.storeroom.View

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.cardview.widget.CardView
import androidx.recyclerview.widget.RecyclerView
import br.com.sthefanny.storeroom.Model.Product
import br.com.sthefanny.storeroom.R

class ProductAdapter(var products: MutableList<Product>) : RecyclerView.Adapter<ProductAdapter.ProductHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ProductHolder {

        val view = LayoutInflater.from(parent.context).inflate(R.layout.rcv_stores, parent, false)

        return ProductHolder(view)
    }

    override fun getItemCount(): Int {
        return products.size
    }

    override fun onBindViewHolder(holder: ProductHolder, position: Int) {

        val product = products.get(position)

        holder.txtProductName.text = product.name
    }

    inner class ProductHolder(view: View) : RecyclerView.ViewHolder(view) {

        var txtProductName: TextView
        var layCell: CardView

        init {
            txtProductName = view.findViewById(R.id.txtProductName)
            layCell = view.findViewById(R.id.layCell)
        }
    }
}
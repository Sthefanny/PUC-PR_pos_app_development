package br.com.sthefanny.storeroom.View

import android.net.Uri
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import br.com.sthefanny.storeroom.Model.Item
import br.com.sthefanny.storeroom.R

class ItemsAdapter(var items: MutableList<Item>) : RecyclerView.Adapter<ItemsAdapter.ItemHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ItemHolder {

        val view = LayoutInflater.from(parent.context).inflate(R.layout.rcv_items, parent, false)

        return ItemHolder(view)
    }

    override fun getItemCount(): Int {
        return items.size
    }

    override fun onBindViewHolder(holder: ItemHolder, position: Int) {

        val item = items.get(position)

        holder.imgItem.setImageURI(Uri.parse(item.image))
        holder.txtName.text = item.name
        holder.txtQuantity.text = item.quantity.toString()
    }

    inner class ItemHolder(view: View) : RecyclerView.ViewHolder(view) {

        var imgItem: ImageView
        var txtName: TextView
        var txtQuantity: TextView
        var layCell: LinearLayout

        init {
            imgItem = view.findViewById(R.id.imgItem)
            txtName = view.findViewById(R.id.txtName)
            txtQuantity = view.findViewById(R.id.txtQuantity)
            layCell = view.findViewById(R.id.layCell)
        }
    }
}
package br.pucpr.appdev.aula02recyclerview.View

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import br.pucpr.appdev.aula02recyclerview.Model.Contact
import br.pucpr.appdev.aula02recyclerview.R

class ContactAdapter(var contacts: MutableList<Contact>): RecyclerView.Adapter<ContactAdapter.ContactHolder>() {


    inner class ContactHolder(view: View) : RecyclerView.ViewHolder(view) {

        var txtName: TextView
        var txtPhone: TextView

        init {
            txtName = view.findViewById(R.id.txtName)
            txtPhone = view.findViewById(R.id.txtPhone)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ContactHolder {

        val view = LayoutInflater.from(parent.context).inflate(R.layout.rcv_contacts, parent, false)

        return ContactHolder(view)
    }

    override fun getItemCount(): Int {
        return contacts.size
    }

    override fun onBindViewHolder(holder: ContactHolder, position: Int) {

        val contact = contacts[position]

        holder.txtName.text = contact.name
        holder.txtPhone.text = contact.phone
    }
}
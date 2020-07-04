package br.com.sthefanny.aula03atividadesemana.View

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.AsyncTask
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import br.com.sthefanny.aula03atividadesemana.Model.Pokemon
import br.com.sthefanny.aula03atividadesemana.R
import com.squareup.picasso.Picasso
import java.net.URI
import java.net.URL


class PokemonAdapter(var pokemons: MutableList<Pokemon>) : RecyclerView.Adapter<PokemonAdapter.PokemonHolder>() {

    inner class PokemonHolder(view: View) : RecyclerView.ViewHolder(view) {
        var txtNumber: TextView
        var txtName: TextView
        var imageView: ImageView

        init {
            txtNumber = view.findViewById(R.id.txtNumber)
            txtName = view.findViewById(R.id.txtName)
            imageView = view.findViewById(R.id.imgImage)
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): PokemonHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.rcv_pokemons, parent, false)

        return PokemonHolder(view)
    }

    override fun getItemCount(): Int {
        return pokemons.size
    }

    override fun onBindViewHolder(holder: PokemonHolder, position: Int) {
        val pokemon = pokemons.get(position)

        holder.txtNumber.text = "${pokemon.number}"
        holder.txtName.text = "${pokemon.name}"

        if (pokemon.image != null) {
            Picasso.get().load(pokemon.image).into(holder.imageView);
        }
    }
}
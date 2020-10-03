package br.com.sthefanny.storeroom.Model

class Product(var name: String) {
    var id = 0

    override fun toString(): String {
        return name
    }
}
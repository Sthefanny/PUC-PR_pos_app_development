package br.com.sthefanny.storeroom.Model

class UnitMeasurement(var id: Int, var name: String) {

    override fun toString(): String {
        return name
    }
}
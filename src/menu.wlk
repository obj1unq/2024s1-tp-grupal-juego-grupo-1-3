import asterion.*
import wollok.game.*
import artefactos.*
import posiciones.*

class Inventario {

    var property position = game.at(3,4)
    const property personaje = asterion
    var property oculto = true
    const property objetosMostrables = []

    method image(){
        return "Inventory1.png"
    }

    method mostrar() {
        if(oculto){
            game.addVisual(self)
            self.mostrarObjetos()
            oculto = false

        }else{
            game.removeVisual(self)
            oculto = true 
        } 
    }

    method mostrarObjetos() {
        const posicionesDisponibles = ["4,6","5,6","6,6"]
        var indice = 0
        objetosMostrables.add(new ObjetoDeInventario(image = asterion.arma().image())
        objetosMostrables.forEach({obj => 
            const posicion = posicionesDisponibles.get(indice)
            obj.mostrarEn(posicion)
            indice += 1
        })
        // asterion.utilidades().forEach(utilidad => objetosMostrables().add(new ObjetoDeInventario(self, x, objeto.imagen))})
    }
}

class ObjetoDeInventario {
    var property position
    var property image

    method mostrarEn(posicion){
        position = posicion
        game.addVisual(self)
    }

}

object inventario inherits Inventario {
  
}
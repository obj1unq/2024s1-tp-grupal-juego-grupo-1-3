import wollok.game.*
import artefactos.*
import posiciones.*
import habitacion.*
import asterion.*


class Inventario {

    const property personaje = asterion

    method image(){
        return ""
    }

    method cursorImage() {
        return ""
    }



    method mostrarInventario() {
        game.addVisual(self.image())
        game.addVisual(self.cursorImage())
    }

}
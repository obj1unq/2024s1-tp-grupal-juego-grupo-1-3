import wollok.game.*
import posiciones.*

object zeldita {

	var property position = game.at(3,8)

	method image() = "minotaur4x.png"
	
	method mover(direccion) {
		
		if(tablero.puedeIr(self.position(), direccion)){
			position = direccion.siguiente(self.position())
		}
	}


}
import wollok.game.*

object zeldita {

	var property position = game.at(3,8)

	method image() = "minotaur4x.png"
	
	method mover(direccion) {

		position = direccion.siguiente(self.position())
	
	}

}
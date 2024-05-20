import wollok.game.*
import asterion.*

class Artefacto {
	var property position = null
	
	method esArtefacto() {
		return true
	}
	
	
	method drop(posicion) {
		position = posicion
		game.addVisual(self)
	}
	
	method usar(personaje){
		
	}
	
	method equipar(personaje)
	
	method desEquipar(personaje)
	
	method image()
}

class Arma inherits Artefacto {
	
	method poderQueOtorga()
	
	
	override method usar(personaje){
		
	}
	
	override method equipar(personaje) {
		personaje.equiparArma(self)
	}
	
	override method desEquipar(personaje) {
		self.position(personaje.position())
		personaje.habitacionActual().agregarCosa(self)
		game.addVisual(self)
	}
}

class Defensa inherits Artefacto {
	method defensaQueOtorga()
	
	override method equipar(personaje) {
		personaje.equiparDefensa(self)
	}
	
	override method desEquipar(personaje) {
		personaje.desEquiparDefensa(self)
	}
	
}

class Cosa inherits Artefacto {
	var property usos = null
	

	method desEquipar(personaje) {
		personaje.desEquiparUtilidad(self)
	}
	
	method equipar(personaje) {
		personaje.equiparUtilidad(self)
	}
	
}

object espadaDeNederita inherits Arma {
	
	override method poderQueOtorga() = 10
	
	override method image() {
		return "espada.png"
	}
}

object lanzaHechizada inherits Arma {
	
	override method poderQueOtorga() = 15
	
	override method image() {
		return ""
	}
}

object escudo inherits Defensa {
	
	override method defensaQueOtorga() = 30
	
	override method image() {
		return "gema.png"
	}
	
}

object yelmo inherits Defensa {
	
	override method defensaQueOtorga() = 40
	
	override method image() {
		return ""
	}
}

object llave inherits Cosa {

	override method image() {
		return "llave.png"
	}
}


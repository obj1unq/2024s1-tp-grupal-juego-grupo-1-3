import wollok.game.*
import asterion.*

class Artefacto {
	var property position
	
	method esArtefacto() {
		return true
	}
	
	method drop(posicion) {
		position = posicion
		game.addVisual(self)
	}
	
	method equipar(personaje)
	
	method desEquipar(personaje)
	
	method image()
}

class ArtefactoAtaque inherits Artefacto {
	
	method poderQueOtorga()
	
	method agregar(personaje) {
		personaje.arma(self)
	}

	method sacar(personaje) {
		personaje.arma(null)
	}
	
	method esArtefactoAtaque() {
		return true
	}
	
	override method equipar(personaje) {
		personaje.equiparArtefactoDeAtaque(self)
	}
	
	override method desEquipar(personaje) {
		personaje.dropearSiPuedeArma()
	}
}

class ArtefactoDefensa inherits Artefacto {
	method defensaQueOtorga()
	
	method agregar(personaje) {
		personaje.defenza().add(self)
	}

	method sacar(personaje) {
		personaje.defenza().remove(self)
	}
	
	method esArtefactoDefensa() {
		return true
	}
	
	override method equipar(personaje) {
		personaje.equiparArtefactoDeDefensa(self)
	}
	
	override method desEquipar(personaje) {
		personaje.desEquiparDefensa(self)
	}
}

class Utilidad {
	var property usos
	
	method agregar(personaje) {
		personaje.utilidades().add(self)
	}

	method sacar(personaje) {
		personaje.utilidades().remove(self)
	}
	
	method equipar(personaje) {
		personaje.equiparArtefactoDeUtilidad(self)
	}
	
	method image()
}

object espadaDeNederita inherits ArtefactoAtaque (position = game.at(3,5)) {
	
	override method poderQueOtorga() = 10
	
	override method image() {
		return "espada.png"
	}
}

object lanzaHechizada inherits ArtefactoAtaque (position = game.at(5,5)) {
	
	override method poderQueOtorga() = 15
	
	override method image() {
		return ""
	}
}

object escudo inherits ArtefactoDefensa (position = game.at(5,6)) {
	
	override method defensaQueOtorga() = 30
	
	override method image() {
		return "gema.png"
	}
}

object yelmo inherits ArtefactoDefensa (position = game.at(7,6)) {

	override method position(position) = game.at(5,5)
	
	override method defensaQueOtorga() = 40
	
	override method image() {
		return ""
	}
}

object llave inherits Utilidad (usos = 3){

	override method image() {
		return "llave.png"
	}
}


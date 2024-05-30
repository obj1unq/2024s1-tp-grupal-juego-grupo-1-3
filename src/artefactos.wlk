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
	
	method image()
}

class Arma inherits Artefacto {
	
	method poderQueOtorga()
	
	
	override method usar(personaje){
		const enemigos = game.colliders(personaje).filter({visual => !visual.esAtravesable() && !visual.esArtefacto()})
		enemigos.forEach({enemigo => personaje.golpear(enemigo)})
	}
	
	override method equipar(personaje) {
		personaje.equiparArma(self)
	}
	
}

class Defensa inherits Artefacto {
	method defensaQueOtorga()
	
	override method equipar(personaje) {
		personaje.equiparDefensa(self)
	}
	
	
}

class Cosa inherits Artefacto {
	var property usos = null
	
	
	override method equipar(personaje) {
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

object aire inherits Cosa {
	
	override method drop(posicion){}
	
	override method image(){}
}

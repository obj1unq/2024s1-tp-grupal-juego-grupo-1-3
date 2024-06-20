import wollok.game.*
import asterion.*

class Artefacto {
	var property position = null
	
	method esArtefacto() {
		return true
	}
	
	
	method drop(posicion,habitacion) {
		position = posicion
		habitacion.agregarCosa(self)
		game.addVisual(self)
	}
	
	method usar(personaje){
		
	}
	
	method equipar(personaje)
	
	method image()
	
	method esAtravesable(){
		return false
	}
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
	
	override method poderQueOtorga() = 8
	
	override method image() {
		return "espada.png"
	}
}

object hachaDobleCara inherits Arma {
	
	override method poderQueOtorga() = 20
	
	override method image() {
		return "hacha.png"
	}
}

object lanzaHechizada inherits Arma {
	
	override method poderQueOtorga() = 25
	
	override method image() {
		return "LanzaHechizada.png"
	}
}

object escudo inherits Defensa {
	
	override method defensaQueOtorga() = 15
	
	override method image() {
		return "shield1.png"
	}
}

object escudoBlindado inherits Defensa { //podria ser escudo una class para que escudo blindado herede de aca pero solo van a ser dos objetos unicos
	
	override method defensaQueOtorga() = 30
	
	override method image() {
		return "shield2.png"
	}
}

object yelmo inherits Defensa { //sin asset no utiliza aun
	
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

object llaveDePlata inherits Cosa {
	override method image() {
		return "llave.png" // falta imagen
	}
}

object llaveDeOro inherits Cosa {
	override method image() {
		return "llave.png" // falta imagen
	}
}

object gema inherits Cosa{
	
	override method image() {
		return "gema.png"
	}
}

object aire inherits Cosa { 
	
	override method drop(posicion,habitacion){}
	
	override method image(){}
}

class PocionVida inherits Artefacto {
	
	var property puntosDeVida
	
	override method image(){ 
		return "pocion.png"
	}
	
	override method equipar(personaje) {
		personaje.sumarVida(self)
	}
}

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
	
	method equipar(personaje) {
		game.say(personaje, "equipó: "+ self)
	}
	
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
		super(personaje)
	}
	
}

class Defensa inherits Artefacto {
	method defensaQueOtorga()
	
	override method equipar(personaje) {
		personaje.equiparDefensa(self)
		super(personaje)
	}
	
	
}

class Cosa inherits Artefacto {
	var property usos = null
	
	
	override method equipar(personaje) {
		personaje.equiparUtilidad(self)
		super(personaje)
	}
	
}

object espadaDeNederita inherits Arma {
	
	override method poderQueOtorga() = 10
	
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
	
	override method poderQueOtorga() = 30
	
	override method image() {
		return "LanzaHechizada.png"
	}
}

object escudo inherits Defensa {
	
	override method defensaQueOtorga() = 10
	
	override method image() {
		return "shield1.png"
	}
}

object escudoBlindado inherits Defensa { //podria ser escudo una class para que escudo blindado herede de aca pero solo van a ser dos objetos unicos
	
	override method defensaQueOtorga() = if (asterion.defensa().size()>=1) {20} else {30}
	
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

object llaveDeBronce inherits Cosa {
	override method image() {
		return "llaveBronce.png"
	}
}

object llaveDePlata inherits Cosa {
	override method image() {
		return "llavePlata.png"
	}
}

object llaveDeOro inherits Cosa {
	override method image() {
		return "llaveOro.png"
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
	
	var property puntosDeVida = 40
	
	override method image(){ 
		return "pocion.png"
	}
	
	override method equipar(personaje) {
		personaje.sumarVida(self)
	}
}

class Chest {
	var property position
	var property estado = cerrado
	
	method image() = estado.image()
}

object cerrado() {
	method image() = ""
}

object abierto() {
	method image() = ""
}

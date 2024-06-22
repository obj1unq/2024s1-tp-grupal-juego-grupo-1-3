import wollok.game.*
import asterion.*
import menu.*

class Artefacto {

	var property position = null

	method esArtefacto() {
		return true
	}

	method drop(posicion, habitacion) {
		position = posicion
		habitacion.agregarCosa(self)
		game.addVisual(self)
	}

	method usar(personaje) {
	}

	method equipar(personaje) {
		game.say(personaje, "equipó: " + self)
	}

	method image()

	method esAtravesable() {
		return false
	}

}

class Arma inherits Artefacto {

	method poderQueOtorga()
	method sound()

	override method usar(personaje) {
		const enemigos = game.colliders(personaje).filter({ visual => !visual.esAtravesable() && !visual.esArtefacto() })
		enemigos.forEach({ enemigo => personaje.golpear(enemigo)})
	}

	override method equipar(personaje) {
		personaje.equiparArma(self)
		super(personaje)
	}
	
	method golpe(){
		sonidos.play(self.sound())
	}
	

}

class Defensa inherits Artefacto {

	method defensaQueOtorga()

}

class Escudo inherits Defensa {
	
	override method equipar(personaje) {
		personaje.equiparEscudo(self)
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
	
	override method sound(){
		return "katana_cut.mp3"
	}

}

object hachaDobleCara inherits Arma {

	override method poderQueOtorga() = 20

	override method image() {
		return "hacha.png"
	}
	
	override method sound(){
		return "cleaver.mp3"
	}

}

object lanzaHechizada inherits Arma {

	override method poderQueOtorga() = 30

	override method image() {
		return "LanzaHechizada.png"
	}
	
	override method sound(){
		return "protego.mp3"
	}

}

object escudoDeMadera inherits Escudo {

	override method defensaQueOtorga() = 10

	override method image() {
		return "shield1.png"
	}

}

object escudoBlindado inherits Escudo {
	
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

object gema inherits Cosa {

	override method image() {
		return "gema.png"
	}

}

object aire inherits Cosa {

	override method drop(posicion, habitacion) {
	}

	override method image() {
	}

}

class PocionVida inherits Artefacto {

	var property puntosDeVida = 40

	override method image() {
		return "pocion.png"
	}

	override method equipar(personaje) {
		personaje.sumarVida(self)
	}

}

class Chest inherits Artefacto {
	
	var property estado = cerrado
	var property artefactoADropear = aire

	override method image() = estado.image()

	override method equipar(personaje) { // metodo polimorfico para que abra el cofre, realmente no esta equipando si no que interactua
		if (self.estaCerrado()) {
			estado = abierto
			artefactoADropear.drop(self.posicionDrop(),personaje.habitacionActual())
		}
	}

	method estaCerrado() {
		return estado == cerrado
	}
	
	method posicionDrop() {
		return game.at(self.position().x(), self.position().y() - 1)
	}
}

class ChestMimic inherits Chest { //Reutilizamos poder de pelea de personaje ya que es polimorfico

	var property poderPelea = 60
	
	override method equipar(personaje) {
		if (self.estaCerrado()) {
			estado = abiertoMimic
			self.golpear(personaje)
		}
	}
	
	method golpear(personaje) {
		personaje.esGolpeado(self)
	}
}


object cerrado {

	method image() {
		return "chestLootCerrado.png"
	}

}

object abierto {

	method image() {
		return "chestLootAbierto.png"
	}
}

object abiertoMimic {
	
	method image() {
		return "chestMimicAbierto.png"
	}
}


import wollok.game.*
import asterion.*

object espadaDeNederita {

	const property tipo = ataque
	var property position = game.at(5, 5)
	const property poderQueOtorga = 10
	const property defensaQueOtorga = 0

	method agragar(personaje) {
		personaje.arma(self)
	}

	method sacar(personaje) {
		personaje.arma(null)
	}
	
	method image() {
		return ""
	}
}

object lanzaHechizada {

	const property tipo = ataque
	var property position = game.at(2, 2)
	const property poderQueOtorga = 15
	const property defensaQueOtorga = 0

	method agragar(personaje) {
		personaje.arma(self)
	}

	method sacar(personaje) {
		personaje.arma(null)
	}
	
	method image() {
		return ""
	}
}

object escudo {

	const property tipo = defensa
	var property position = game.at(0, 1)
	const property poderQueOtorga = 0
	const property defensaQueOtorga = 30

	method agragar(personaje) {
		personaje.defenza().add(self)
	}

	method sacar(personaje) {
		personaje.defenza().remove(self)
	}
	
	method image() {
		return ""
	}
}

object yelmo {

	const property tipo = defensa
	var property position = game.at(0, 0)
	const property poderQueOtorga = 0
	const property defensaQueOtorga = 20

	method agragar(personaje) {
		personaje.defenza().add(self)
	}

	method sacar(personaje) {
		personaje.defenza().remove(self)
	}
	
	method image() {
		return ""
	}
}

class llave {

	method agragar(personaje) {
		personaje.utilidades().add(self)
	}

	method sacar(personaje) {
		personaje.utilidades().remove(self)
	}
	
	method image() {
		return ""
	}
}

object ataque {

	method armaDe() {
		return self
	}

}

object defensa {

	method armaDe() {
		return self
	}

}


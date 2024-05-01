import wollok.game.*
import artefactos.*
import posiciones.*

object asterion {

	var property position = game.at(3, 8)
	var vida = 100
	const utilidades = #{}
	var arma = espadaDeNederita // solo puede tener un arma en la mano (podriamos hacer que pueda llevar un a segunda arma)
	const defensa = #{}
	const poderBase = 10

	method image() = "minotaur4x.png"

	method mover(direccion) {
		position = direccion.siguiente(self.position())
	}

	method poderPelea() {
		return arma.poderQueOtorga() + poderBase
	}

	method poderDefensa() {
		return defensa.sum()
	}

/////////////////////////////--FUNCIONALIDAD--////////////////////////////////
///////////////////////////////--ACCIONES--/////////////////////////////////
	method agarrarYEquipar(cosa) {
		// dropear lo que tiene (agregar el addvisual al mapa)
		// sacar el addvisual del mapa
		arma = cosa
	}

	method soltarSiPuede(cosa) {
	// verificar que no este vacio
	// dropear cosa (agregar el addvisual)
	}

	method usar(cosa) {
		// usa llave o algun optro artefacto que no es de daño
		utilidades.remove(cosa)
	}

	method golpear(enemigo) {
	// hay que ver que arma lo golpea, cuanto hace de daño cada arma
	}

//////////////////////////--VERIFICACIONES--////////////////////////////////
}


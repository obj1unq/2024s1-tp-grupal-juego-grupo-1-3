import wollok.game.*
import artefactos.*
import posiciones.*
import habitacion.*

object asterion {

	var property position = game.at(3, 8)
	var vida = 100
	const property utilidades = #{}
	var property arma = espadaDeNederita // solo puede tener un arma en la mano (podriamos hacer que pueda llevar una segunda arma)
	const property defenza = #{}
	const poderBase = 10

	method image() = "minotaur4x.png"
	
	method mover(direccion) {
		
		if(tablero.puedeIr(self.position(), direccion)){
			position = direccion.siguiente(self.position())
		}
	}
	method esAtravesable(){
		return false
	}
	method atravesar(){
	
	 	const puerta = game.getObjectsIn(self.position()).find({visual => visual.esAtravesable()})
	 	puerta.atravesar()	
	}

	method poderPelea() {
		return arma.poderQueOtorga() + poderBase
	}

	method poderDefensa() {
		return defenza.forEach({ artefacto => artefacto.defensaQueOtorga().sum() })
	}

/////////////////////////////--FUNCIONALIDAD--////////////////////////////////
	method objetoEnPosActual() {
		return game.getObjectsIn(self.position()).copyWithout(self).asList().get(0)
	}

///////////////////////////////--ACCIONES--/////////////////////////////////
	method agarrarYEquipar(cosa) {
		game.addVisual(arma) // dropea lo que tiene (agrega la visual al game)
		cosa.agregar(self) // equipa el ara del suelo
		game.removeVisual(cosa) // remueve el arma que agarro del suelo de las visuales del game
	}

	method soltarSiPuede(cosa) {
		self.verificarSiTieneElObjeto(cosa)
		cosa.sacar(self)
		game.addVisual(cosa)
	}

	method usar(cosa) {
		cosa.sacar(self)
	}

	method golpear(enemigo) {
	// hay que ver que arma lo golpea, cuanto hace de daño cada arma
	}

//////////////////////////--VERIFICACIONES--////////////////////////////////
	method verificarSiTieneElObjeto(cosa) {
		if (not defenza.find(cosa)) {
			self.error("No tengo este objeto en mi poder")
		}
	}

}


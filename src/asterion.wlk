import wollok.game.*
import artefactos.*
import posiciones.*
import habitacion.*

object asterion {

	var property position = game.at(3, 8)
	//var vida = 100
	const property utilidades = #{}
	var property arma = null
	const property defenza = []
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


//////////////////////////////////--FUNCIONALIDAD--///////////////////////////////////


	method objetoEnPosActual() {
		self.verificarSiHayObjeto()
		return game.getObjectsIn(self.position()).find({cosa=> cosa.esArtefacto()})
	}
	
	method dropearSiPuedeArma() {
		if (self.arma() !== null) {
			arma.drop(self.position())
			arma= null
		}
	}
	
	method primerDefensa() {
		self.validarQueTieneDefensa()
		return defenza.first()
	}


////////////////////////////////////--ACCIONES--////////////////////////////////////////


	method equiparArtefactoDeAtaque(artefactoAtaq) {
		self.dropearSiPuedeArma()
		artefactoAtaq.agregar(self)
		game.removeVisual(artefactoAtaq)
	}
	
	method equiparArtefactoDeDefensa(artefactoDef) {
		artefactoDef.agregar(self)
		game.removeVisual(artefactoDef)
	}
	
	method desEquiparDefensa(artefactoDef) {
		if (not self.defenza().isEmpty()) {
			artefactoDef.drop(self.position())
			defenza.remove(artefactoDef)
		}
	}
	
//	method desEquiparUtilidad(utilidad) {
//		
//	}
	
	method equiparArtefactoDeUtilidad(artefactUti) {
		artefactUti.agregar(self)
		game.removeVisual(artefactUti)
	}

	method agarrarYEquipar(cosa) {
		cosa.equipar(self)
	}

	method soltarSiPuede(cosa) {
		self.verificarSiTieneElObjeto(cosa)
		cosa.desEquipar(self)
	}

	method usar(cosa) {
		cosa.sacar(self)
	}

	method golpear(enemigo) {
	// hay que ver que arma lo golpea, cuanto hace de daño cada arma
	}


//////////////////////////--VERIFICACIONES--////////////////////////////////


	method verificarSiTieneElObjeto(cosa) {
		if (cosa == null) {
			self.error("No tengo este objeto en mi poder")
		}
	}
	
	method validarQueTieneDefensa() {
		if (defenza.size() == 0 ) {self.error("No tengo defensas")}
	}
	
	method verificarSiHayObjeto() {
		if (game.getObjectsIn(self.position()).findOrElse({cosa=> cosa.esArtefacto()}, {null}) == null) {self.error("No hay artefacto aca")}
	}
	
	method esArtefacto() {
		return false
	}
}


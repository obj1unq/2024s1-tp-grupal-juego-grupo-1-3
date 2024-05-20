import wollok.game.*
import artefactos.*
import posiciones.*
import habitacion.*

object asterion {
	var property position = game.at(3, 8)
	var property habitacionActual = null
	//var vida = 100
	const property utilidades = #{}
	var property arma = manos
	const property defensa = #{}
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
	 	puerta.atravesar(self)	
	}

	method poderPelea() {
		return arma.poderQueOtorga() + poderBase
	}

	method poderDefensa() {
		return defensa.sum({artefacto => artefacto.defensaQueOtorga()})
	}
	
	method artefactos(){
		return game.getObjectsIn(self.position()).filter({visual => visual.esArtefacto()})
	}
	
	method equipar(){
		 self.artefactos().forEach({artefacto => artefacto.equipar(self)})
	}
	
	method estaArmado(){
		return self.arma() != manos
	}
	
	method validarEquiparArma(){
		if (self.estaArmado()){
			self.error("Ya existe un arma equipada, es necesario dropear el armamento actual") 
		}
	}
	
	method equiparArma(_arma){
		self.validarEquiparArma()
		self.arma(_arma)
		self.habitacionActual().sacarCosa(_arma)
	}
	
	method equiparDefensa(_defensa){
		self.defensa().add(_defensa)
		self.habitacionActual().sacarCosa(_defensa)
	}
	
	method equiparUtilidad(utilidad){
		self.utilidades().add(utilidad)
		self.habitacionActual().sacarCosa(utilidad)
	}
	
	method validarDropearArma(){
		if (!self.estaArmado()){
			self.error("No existe un arma para dropear")
		}
	}
	
	method dropearArma(){
		self.validarDropearArma()
		self.arma().desEquipar(self)
		self.arma(manos)
	}
	
	method desequiparDefensa(_defensa){
		
	}
	
	method desequiparAtaque(_arma){
		
	}
	
	method desequiparUtilidad(_utilidad){
		
	}
	
	
	
	method esArtefacto() {
		return false
	}
}


object manos {
	
	method poderQueOtorga() {
		return 0
	}
}


import wollok.game.*
import artefactos.*
import posiciones.*
import habitacion.*

object asterion {
	var property position = game.at(3, 8)
	var property habitacionActual = null
	// var vida = 100
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
	
	method dropear(cosa){
		self.habitacionActual().agregarCosa(cosa)
		cosa.drop(self.position())
	}
	method dropearArma(){
		self.validarDropearArma()
		self.dropear(self.arma())
		self.arma(manos)
	}
	
	method desequiparDefensa(_defensa){
		
	}
	
	method desequiparAtaque(_arma){
		
	}
	
	method desequiparUtilidad(_utilidad){
		
	}
	
	method golpear(enemigo){
		enemigo.esGolpeado(self)
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



class Enemigo {
	var property artefactoADropear = aire
	var property position = null
	var property vida = 50	
	
	method esGolpeado(personaje) // abstracto
	
	method morir(){
		game.removeVisual(self)
		artefactoADropear.drop(self.position())
	}
	
	method golpear(personaje){
		personaje.esGolpeado(self)
	}
	
	method poderBase(){
		return 10
	}
	
	method image() // abstracto
	
	method poderPelea(){
		return self.poderBase()
	}
}


class Humano inherits Enemigo {
	var property poderDefensa = 10
	var property arma = manos
	
	override method image() {
		
	}
	
	
	method vidaAlSerGolpeado(personaje){
		return 0.max(self.vida() + self.poderDefensa()-personaje.poderPelea())
	}
	
	method estaMuerto(){
		return self.vida() <= 0
	}
	
	override method esGolpeado(personaje){
		self.vida(self.vidaAlSerGolpeado(personaje))
			if (self.estaMuerto()){
				self.morir()
			} else {
				self.golpear(personaje)
			}
	}
	
	override method poderPelea(){
		return super() + arma.poderQueOtorga()
	}
	
	
}


class Espectro inherits Enemigo {
	var property estado
	
	override method image(){
		return estado.image()
	}
	
	override method esGolpeado(personaje){
		self.morir()
	}
	
}

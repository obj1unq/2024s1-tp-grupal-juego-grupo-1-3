import wollok.game.*
import artefactos.*
import posiciones.*
import habitacion.*


class Personaje {
	var property habitacionActual = null
	method vida()
	
	method vida(_vida)
		
	method image() // abstracto
	
	method position() // abstracto
	
	method poderPelea() // abstracto
	
	method poderDefensa() // abstracto
	
	method morir() {
		game.say(self, "me mori")
		habitacionActual.sacarEnemigo(self)
		//game.removeVisual(self)
	}
	
	method golpear(enemigo){
			enemigo.esGolpeado(self)
	}
	
	method vidaARestarPorGolpe(poderGolpe){
		return 0.max(poderGolpe - self.poderDefensa())
	}
	
	method vidaAlSerGolpeadoPor(personaje){
		return 0.max(self.vida() - self.vidaARestarPorGolpe(personaje.poderPelea()))
	}
	
	method recibirGolpe(personaje){
		self.vida(self.vidaAlSerGolpeadoPor(personaje))
	}
	
	method tieneVida(){
		return self.vida() > 0
	}
	
	method esGolpeado(enemigo){
		console.println("recibiendo golpe")
		self.recibirGolpe(enemigo)
		console.println("golpe recibido, mi vida es: ")
		console.println(self.vida())
	}
	
	method dropear(cosa){
		cosa.drop(self.position())
	}
	
	method esArtefacto(){
		return false
	}
	
	method esAtravesable(){
		return false
	}
	
}



object asterion inherits Personaje {
	var property position = game.at(3, 8)

    var property vida = 100
	const property utilidades = #{}
	var property arma = manos
	const property defensa = #{}
	const poderBase = 10

	override method image() = "minotaur4x.png"
	
	method mover(direccion) {
		
		if(tablero.puedeIr(self.position(), direccion)){
			position = direccion.siguiente(self.position())
		}
	}
	
	method atravesar(){
	 	const puerta = game.getObjectsIn(self.position()).find({visual => visual.esAtravesable()})
	 	puerta.atravesar(self)	
	}

	override method poderPelea() {
		return arma.poderQueOtorga() + poderBase
	}

	override method poderDefensa() {
		return defensa.sum({artefacto => artefacto.defensaQueOtorga()})
	}
	
	method artefactos(){
		return game.getObjectsIn(self.position()).filter({visual => visual.esArtefacto()})
	}
	
	method equipar(){
		 self.artefactos().forEach({artefacto => artefacto.equipar(self)})
	}
	
	method enemigosEnPosicion(){
		return game.colliders(self).filter({visual => not (visual.esArtefacto() || visual.esAtravesable())})
	}
	
	method golpear(){
		self.enemigosEnPosicion().forEach({enemigo => self.golpear(enemigo)})
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
	
	override method dropear(cosa){
		self.habitacionActual().agregarCosa(cosa)
		super(cosa)
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
	
	override method morir(){
		super()
		// terminarjuego
	}
	
	method reaccionarTrasGolpe(enemigo){
		if (!self.tieneVida()){
			self.morir()
		}
	}
	
	
	override method esGolpeado(enemigo){
		super(enemigo)
		self.reaccionarTrasGolpe(enemigo)
	}
	
	
}


object manos {
	
	method poderQueOtorga() {
		return 0
	}
}



class Enemigo inherits Personaje {
	var property artefactoADropear = aire
	var property position = null
	var property vida = 50	
		
	override method morir(){
		super()
		self.dropear(self.artefactoADropear())
	}
	
	
	method poderBase(){
		return 10
	}
		
	override method poderPelea(){
		return self.poderBase()
	}
}


class Humano inherits Enemigo {
	var property poderDefensa = 10
	var property arma = manos
	
	override method image() = "wpierdol.png"
	
	method reaccionarTrasGolpe(personaje){
		if (self.tieneVida()){
			self.golpear(personaje)
		} else {
			self.morir()
		}
	}
	
	override method esGolpeado(personaje){
		super(personaje)
		self.reaccionarTrasGolpe(personaje)
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

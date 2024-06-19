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
	
	method position(_position)
	
	method poderPelea() // abstracto
	
	method poderDefensa() // abstracto
	
	method mover(direccion) {
		
		if(tablero.puedeIr(self.position(), direccion)){
			self.position(direccion.siguiente(self.position()))
		}
	}
	
	method morir() {
		game.say(self, "me mori")
		game.removeVisual(self)
	}
	
	method golpear(enemigo){
			enemigo.esGolpeado(self)
	}
	
	method vidaARestarPorGolpe(personaje){
		return 0.max(personaje.poderPelea() - self.poderDefensa())
	}
	
	method vidaAlSerGolpeadoPor(personaje){
		return 0.max(self.vida() - self.vidaARestarPorGolpe(personaje))
	}
	
	method recibirGolpe(personaje){
		self.vida(self.vidaAlSerGolpeadoPor(personaje))
	}
	
	method tieneVida(){
		return self.vida() > 0
	}
	
	method esGolpeado(enemigo){
		self.recibirGolpe(enemigo)
	}
	
	method dropear(cosa){
		cosa.drop(self.position(), self.habitacionActual())
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
	var property enemigosEliminados = 0
	
	override method image() = "minotaur4x.png"
	
	
	method atravesar(){
	 	const puerta = game.getObjectsIn(self.position()).find({visual => visual.esAtravesable()})
	 	puerta.atravesar(self)	
	}
	
	method cantidadDeCosas(){
		return utilidades.size() 
	}
	
	method eliminarEnemigo(){
		enemigosEliminados = enemigosEliminados + 1 
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
	
	method dropearArma(){
		self.validarDropearArma()
		self.dropear(self.arma())
		self.arma(manos)
	}
	
	method tieneArtefacto(artefacto){
	 	return self.utilidades().contains(artefacto)
	}
	
	method desequiparDefensa(_defensa){
		
	} 
	
	method desequiparAtaque(_arma){
		
	}
	
	method desequiparUtilidad(_utilidad){
		
	}
	
	override method morir(){
		super()
		game.schedule(2000, { game.stop()})
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
	var property position = game.center()
	var property vida = 50	
	const jugador = asterion
		
	override method morir(){
		super()
		jugador.eliminarEnemigo()
		self.dropear(self.artefactoADropear())
		habitacionActual.sacarEnemigo(self)
	}
	
	
	method poderBase(){
		return 10
	}
		
	override method poderPelea(){
		return self.poderBase()
	}
	
	method init(){
		game.addVisual(self)
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
			//personaje.eliminarEnemigo()
		}
	}

	override method esGolpeado(personaje){
		super(personaje)
		game.say(self, "daño:" + self.vidaARestarPorGolpe(personaje) +" vida:" + self.vida() )
		self.reaccionarTrasGolpe(personaje)
	}
	
	override method poderPelea(){
		return super() + arma.poderQueOtorga()
	}
	
	
}

object ghost {
	
	method image(){
		return "ghost.png"
	}
}


class Espectro inherits Enemigo {
	var property estado = ghost
	
	override method image(){
		return estado.image()
	}
	
	override method esGolpeado(personaje){
		game.removeTickEvent("Espectro"+ self.identity())
		self.morir()
		//personaje.eliminarEnemigo()
	}
	
	override method poderDefensa(){
		return 0
	}
	
	method estaAsterion(){
		return game.colliders(self).any({visual => visual == asterion})
	}

	
	method atacar(){
		if (self.estaAsterion()){
			self.golpear(asterion)
		}
	}
	
	override method init(){
		super()
		game.onTick(2000, "Espectro"+ self.identity(), {self.position(randomizer.position())})
		game.onCollideDo(self, {visual => self.atacar()})
	}
	
}

object ghostito inherits Espectro {
	
}



object barraVida {
	method position() = game.at(7, 0)
	
	method image() = "VIDA_" + asterion.vida() + ".png"
	
	
}
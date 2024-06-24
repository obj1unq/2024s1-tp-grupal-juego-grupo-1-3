import wollok.game.*
import artefactos.*
import posiciones.*
import habitacion.*
import menu.*

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
		if (tablero.puedeIr(self.position(), direccion)) {
			self.position(direccion.siguiente(self.position()))
		}
	}

	method morir() {
		game.removeVisual(self)
	}

	method golpear(enemigo) {
		enemigo.esGolpeado(self)
	}

	method vidaARestarPorGolpe(personaje) {
		return 0.max(personaje.poderPelea() - self.poderDefensa())
	}

	method vidaAlSerGolpeadoPor(personaje) {
		return 0.max(self.vida() - self.vidaARestarPorGolpe(personaje))
	}

	method esLastimado(personaje){
		return personaje.poderPelea() - self.poderDefensa() > 0
	}
	
	method lastimado(){}

	method recibirGolpe(personaje) {
		if (self.esLastimado(personaje)){
		self.vida(self.vidaAlSerGolpeadoPor(personaje))
		self.lastimado()
		}
	}

	method tieneVida() {
		return self.vida() > 0
	}

	method esGolpeado(enemigo) {
		self.recibirGolpe(enemigo)
	}

	method dropear(cosa) {
		cosa.drop(self.position(), self.habitacionActual())
	}

	method esArtefacto() {
		return false
	}

	method esAtravesable() {
		return false
	}

}



object normal{
	method position() = game.at(4,5)
	method image() = "gameover.png" 
}

object ganaTeseo{
	method position() = game.at(1,4)
	method image() = "frasefinalv2.png"
}

object asterion inherits Personaje {

	var property position = game.at(3, 8)
	var property vida = 100
	const property utilidades = #{}
	var property arma = mano
	var property escudo = mano
	var property final = normal
	const poderBase = 10
	var property enemigosEliminados = 0

	override method image() = "asterion_" + arma + "_" + escudo + ".png"

	method todosLosObjetos() {
		const objetos = []
		objetos.add(self.arma())
		objetos.addAll(self.utilidades())
		objetos.addAll(self.defensa())
		return objetos
	}
	
	method atravesar(){
	 	const puerta = game.getObjectsIn(self.position()).findOrElse({visual => visual.esAtravesable()}, {self.error("No hay una puerta para pasar")})
	 	puerta.atravesar(self)	
	}

	method cantidadDeCosas() {
		return utilidades.size()
	}

	method eliminarEnemigo() {
		enemigosEliminados = enemigosEliminados + 1
	}

	override method poderPelea() {
		return arma.poderQueOtorga() + poderBase
	}


	method defensa(){
		return #{self.escudo()}
	}
	
	override method poderDefensa() {
		return self.defensa().sum({ artefacto => artefacto.defensaQueOtorga() })
	}

	method artefactos() {
		return game.getObjectsIn(self.position()).filter({ visual => visual.esArtefacto() })
	}

	method equipar() {
		if (self.estaVivo()){
		self.artefactos().forEach({ artefacto => artefacto.equipar(self)})
		}
	}

	method enemigosEnPosicion() {
		return game.colliders(self).filter({ visual => not (visual.esArtefacto() || visual.esAtravesable()) })
	}

	method golpear() {
		if (self.estaVivo()){
		self.enemigosEnPosicion().forEach({ enemigo => self.golpear(enemigo) self.arma().golpe()})
		}
	}
	
	override method lastimado(){
		sonidos.play("ough.mp3")
	}

	method estaArmado() {
		return self.arma() != mano
	}

	method validarEquiparArma() {
		if (self.estaArmado()) {
			self.error("Ya existe un arma equipada, es necesario dropear el armamento actual")
		}
	}
	
	method tieneEscudo(){
		return self.escudo() != mano
	}
	
	method validarEquiparEscudo() {
		if (self.tieneEscudo()) {
			self.error("Ya existe un escudo equipado, es necesario dropear el escudo actual")
		}
	}

	method equiparArma(_arma) {
		self.validarEquiparArma()
		inventario.validarEspacioEnInventario()
		self.arma(_arma)
		sonidos.play("equip.mp3")
		self.habitacionActual().sacarCosa(_arma)
	}

	method equiparEscudo(_escudo) {
		self.validarEquiparEscudo()
		inventario.validarEspacioEnInventario()
		self.escudo(_escudo)
		sonidos.play("equip.mp3")
		self.habitacionActual().sacarCosa(_escudo)
	}

	method equiparUtilidad(utilidad) {
		inventario.validarEspacioEnInventario()
		utilidad.sonar()
		self.utilidades().add(utilidad)
		self.habitacionActual().sacarCosa(utilidad)
	}

	method sumarVida(consumible) {
		self.vida(100.min(self.vida() + consumible.puntosDeVida()))
		self.habitacionActual().sacarCosa(consumible)
	}

	method validarDropearArma() {
		if (!self.estaArmado()) {
			self.error("No existe un arma para dropear")
		}
	}
	
	method validarDropearEscudo() {
		if (!self.tieneEscudo()) {
			self.error("No existe un escudo para dropear")
		}
	}

	method dropearArma() {
		self.validarDropearArma()
		self.dropear(self.arma())
		self.arma(mano)
	}
	
	method dropearEscudo() {
		self.validarDropearEscudo()
		self.dropear(self.escudo())
		self.escudo(mano)
	}
	
	override method dropear(cosa){
		super(cosa)
		sonidos.play("drop.mp3")
	}

	method tieneArtefacto(artefacto) {
		return self.utilidades().contains(artefacto)
	}
	
	override method morir(){
		game.addVisual(new FraseFinal(estado=self.final()))
		super()
		game.schedule(4000, { game.stop()}) 
	}


	method reaccionarTrasGolpe(enemigo) {
		if (!self.tieneVida()) {
			self.morir()
		}
	}

	override method esGolpeado(enemigo) {
		super(enemigo)
		self.reaccionarTrasGolpe(enemigo)
	}
	
	method sayPoderes() {
		game.say(self, "Att:" + self.poderPelea() + " Def:" + self.poderDefensa() + " Vida:" + self.vida())
	}
	
	method estaVivo() {
		return self.vida() > 0
	}

}

object mano {
	
	method golpe(){
		sonidos.play(self.sound())
	}
	
	method sound() {
		return "hand_punch.mp3"
	}

	method poderQueOtorga() {
		return 0
	}
	
	method defensaQueOtorga(){
		return 0
	}

	method esArtefacto() {
		return false
	}

}

class Enemigo inherits Personaje {

	var property artefactoADropear = aire
	var property position = game.center()
	var property vida = self.vidaBase()
	const jugador = asterion
	
	method vidaBase(){
		return 50
	}

	override method morir() {
		super()
		jugador.eliminarEnemigo()
		self.dropear(self.artefactoADropear())
		habitacionActual.sacarEnemigo(self)
	}

	method poderBase() {
		return 10
	}

	override method poderPelea() {
		return self.poderBase()
	}

	method init() {
		game.addVisual(self)
	}

}

object ariadna inherits Enemigo{
	
	var property poderDefensa = 0
	override method position()= game.at(1, 0)
	
	override method image() = "ariadna.png" 
}

object teseo inherits Enemigo{
	var property poderDefensa = 99999999999
	override method position() = game.at(5, 5)
	
	override method poderBase(){
		return 99999999999999999
	}
	
	override method image() = "teseo.png"
	
	override method esGolpeado(personaje){
		super(personaje)
		personaje.final(ganaTeseo)
		self.golpear(personaje)
	} 
}

class Humano inherits Enemigo {

	var property poderDefensa = 12
	var property arma = mano

	override method image() = "wpierdol.png"

	method reaccionarTrasGolpe(personaje) {
		if (self.tieneVida()) {
			self.golpear(personaje)
		} else {
			self.morir()
		}
	}

	override method esGolpeado(personaje) {
		super(personaje)
		game.say(self, "daño:" + self.vidaARestarPorGolpe(personaje) + " vida:" + self.vida())
		self.reaccionarTrasGolpe(personaje)
	}

	override method poderPelea() {
		return super() + arma.poderQueOtorga()
	}

}

class SuperHumano inherits Humano (arma = lanzaHechizada) {

	var property estado = vivo

	override method poderDefensa() {
		return 20
	}

	override method image() {
		return estado.image()
	}
	
	
	
	override method morir(){
		self.estado(muerto) 
		super()
	}

}

object vivo {

	method image() {
		return "SuperHumano-vivo.png"
	}

}

object muerto {

	method image() {
		return "SuperHumano-muerto3.png"
	}

}

object ghost {

	method image() {
		return "ghost.png"
	}

}

class Espectro inherits Enemigo {

	var property estado = ghost

	override method image() {
		return estado.image()
	}

	override method esGolpeado(personaje) {
		game.removeTickEvent("Espectro" + self.identity())
		self.morir()
	}

	override method poderDefensa() {
		return 0
	}

	method estaAsterion() {
		return game.colliders(self).any({ visual => visual == asterion })
	}

	method atacar() {
		if (self.estaAsterion()) {
			self.golpear(asterion)
		}
	}

	override method init() {
		super()
		game.onTick(2000, "Espectro" + self.identity(), { self.position(randomizer.position())})
		game.onCollideDo(self, { visual => self.atacar()})
	}

}


class EspectroVenenoso inherits Espectro {

	override method atacar() {
		if (self.estaAsterion()) {
			self.golpear(asterion)
			game.schedule(2000, { => self.golpear(asterion)})
		}
	}

}

class EspectroVeloz inherits Espectro {

	override method init() {
		game.addVisual(self)
		game.onTick(1000, "Espectro" + self.identity(), { self.position(randomizer.position())})
		game.onCollideDo(self, { visual => self.atacar()})
	}

}

object barraVida {

	method position() = game.at(7, 0)

	method image() = "VIDA_" + asterion.vida() + ".png"

}


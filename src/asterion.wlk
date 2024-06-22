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

	method recibirGolpe(personaje) {
		self.vida(self.vidaAlSerGolpeadoPor(personaje))
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
	var property arma = manos
	var property estado = normal
	const property defensa = #{}
	const poderBase = 10
	var property enemigosEliminados = 0

	override method image() = "minotaur4x.png"

	method todosLosObjetos() {
		const objetos = []
		objetos.add(arma)
		objetos.addAll(utilidades)
		objetos.addAll(defensa)
		return objetos
	}

	method atravesar() {
		const puerta = game.getObjectsIn(self.position()).find({ visual => visual.esAtravesable() })
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

	override method poderDefensa() {
		return defensa.sum({ artefacto => artefacto.defensaQueOtorga() })
	}

	method artefactos() {
		return game.getObjectsIn(self.position()).filter({ visual => visual.esArtefacto() })
	}

	method equipar() {
		self.artefactos().forEach({ artefacto => artefacto.equipar(self)})
	}

	method enemigosEnPosicion() {
		return game.colliders(self).filter({ visual => not (visual.esArtefacto() || visual.esAtravesable()) })
	}

	method golpear() {
		self.enemigosEnPosicion().forEach({ enemigo => self.golpear(enemigo)})
	}

	method estaArmado() {
		return self.arma() != manos
	}

	method validarEquiparArma() {
		if (self.estaArmado()) {
			self.error("Ya existe un arma equipada, es necesario dropear el armamento actual")
		}
	}

	method equiparArma(_arma) {
		self.validarEquiparArma()
		inventario.validarEspacioEnInventario()
		self.arma(_arma)
		self.habitacionActual().sacarCosa(_arma)
	}

	method equiparDefensa(_defensa) {
		inventario.validarEspacioEnInventario()
		self.defensa().add(_defensa)
		self.habitacionActual().sacarCosa(_defensa)
	}

	method equiparUtilidad(utilidad) {
		inventario.validarEspacioEnInventario()
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

	method dropearArma() {
		self.validarDropearArma()
		self.dropear(self.arma())
		self.arma(manos)
	}

	method tieneArtefacto(artefacto) {
		return self.utilidades().contains(artefacto)
	}

	method desequiparDefensa(_defensa) {
//		inventario.actualizar()
	}

	method desequiparAtaque(_arma) {
//		inventario.actualizar()
	}
	
	override method morir(){
		game.addVisual(new FraseFinal(estado=self.estado()))
		game.schedule(100,{super()})
		game.schedule(4000, { game.stop()}) 
	}

	method desequiparUtilidad(_utilidad) {
//		inventario.actualizar()
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

	method sayAtaque() {
		game.say(self, "poder ataque:" + self.poderPelea())
	}

	method sayDefensa() {
		game.say(self, "poder defensa: " + self.poderDefensa())
	}

	method sayVida() {
		game.say(self, "vida: " + self.vida())
	}

}

object manos {

	method poderQueOtorga() {
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
		personaje.estado(ganaTeseo)
		self.golpear(personaje)
	} 
}

class Humano inherits Enemigo {

	var property poderDefensa = 12
	var property arma = manos

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

	override method morir() {
		super()
		self.estado(muerto) // hacer que la imagen quede unos segundos
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

object ghostito inherits Espectro {

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


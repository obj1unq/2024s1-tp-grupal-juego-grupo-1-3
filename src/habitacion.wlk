import wollok.game.*
import asterion.*
import posiciones.*
import artefactos.*
import menu.*

object habitacionManager {

	var property habitaciones = []

	method cargarHabitacion(habitacion) {
		self.limpiarNivel()
		keyboard.p().onPressDo({ asterion.atravesar()})
		game.title("El juego de Asterion")
		game.height(10)
		game.width(10)
		keyboard.down().onPressDo({ asterion.mover(abajo)})
		keyboard.up().onPressDo({ asterion.mover(arriba)})
		keyboard.left().onPressDo({ asterion.mover(izquierda)})
		keyboard.right().onPressDo({ asterion.mover(derecha)})
		keyboard.q().onPressDo({ asterion.equipar()})
		keyboard.z().onPressDo({ asterion.dropearArma()})
		keyboard.f().onPressDo({ asterion.golpear()})
		keyboard.i().onPressDo({ inventario.mostrar()}) //quiza poner que tambien muestre los objetos y no solo responsabilidad del inventario
		keyboard.h().onPressDo({ controles.mostrar()})
		
		habitacion.init(self)
		asterion.habitacionActual(habitacion)
		self.inicializarJuego()
	}

	method limpiarNivel() {
		game.clear()
	}

	method inicializarJuego() {
		game.addVisual(asterion)
	// game.addVisual(escudo) //buen tamaño 32x32 
	// game.addVisual(espadaDeNederita)	
	}

	method habitacion(indice) {
		return self.habitaciones().get(indice)
	}

	method init() {
		habitacionFactory.init(self)
		self.cargarHabitacion(self.habitacion(0))
	}

}

class Habitacion {

	const property position = game.center()
	const property objetivo = null
	const property enemigos = []
	const property cosas = #{}
	const property puertas = #{}
	const ground = "ground5.png"

	method agregarPuerta(puerta) {
		puertas.add(puerta)
		puerta.habitacionActual(self)
	}

	method mostrarPuertas() {
		puertas.forEach({ puerta => game.addVisual(puerta)})
	}

	method agregarCosa(cosa) {
		cosas.add(cosa)
	}

	method mostrarCosas() {
		cosas.forEach({ cosa => game.addVisual(cosa)})
	}

	method sacarCosa(cosa) {
		self.cosas().remove(cosa)
		game.removeVisual(cosa)
	}

	method agregarEnemigo(enemigo) {
		enemigos.add(enemigo)
		enemigo.habitacionActual(self)
	}

	method sacarEnemigo(enemigo) {
		self.enemigos().remove(enemigo)
	}

	method mostrarEnemigos() {
		enemigos.forEach({ enemigo => enemigo.init()})
	}

	method init(manager) {
		game.ground(ground)
		self.mostrarPuertas()
		self.mostrarCosas()
		self.mostrarEnemigos()
		game.addVisual(barraVida)
	}

}

object posicionSuperior {

	const positionStategy = positionUp

	method image() = "door-down.png"

	method position() {
		return positionStategy.position()
	}

	method nextPosition() {
		return positionStategy.nextPosition()
	}

	method opuesto() {
		return posicionInferior
	}

}

object posicionInferior {

	const positionStategy = positionDown

	method image() = "door-up.png"

	method position() {
		return positionStategy.position()
	}

	method nextPosition() {
		return positionStategy.nextPosition()
	}

	method opuesto() {
		return posicionSuperior
	}

}

object posicionEste {

	const positionStategy = positionRight

	method image() = "door-left.png"

	method position() {
		return positionStategy.position()
	}

	method nextPosition() {
		return positionStategy.nextPosition()
	}

	method opuesto() {
		return posicionOeste
	}

}

object posicionOeste {

	const positionStategy = positionLeft

	method image() = "door-right.png"

	method position() {
		return positionStategy.position()
	}

	method nextPosition() {
		return positionStategy.nextPosition()
	}

	method opuesto() {
		return posicionEste
	}

}

class Puerta {

	const property siguienteHabitacion
	const property posicionPuerta
	var property habitacionActual = null

	method image() = posicionPuerta.image()

	method position() = posicionPuerta.position()

	method esAtravesable() {
		return true
	}

	method validarAtravesar(personaje, habitacion) {
	}

	method atravesar(personaje) {
		self.validarAtravesar(personaje, self.habitacionActual())
		habitacionManager.cargarHabitacion(self.siguienteHabitacion())
		personaje.position(posicionPuerta.nextPosition())
	}

}

class PuertaLoot inherits Puerta {

	var property artefactoPorLootear

	override method validarAtravesar(personaje, habitacion) {
		if (not personaje.tieneArtefacto(artefactoPorLootear)) {
			self.error('debes recoger: ' + artefactoPorLootear)
		}
	}

}

class PuertaKill inherits Puerta {

	override method validarAtravesar(personaje, habitacion) {
		if (habitacion.enemigos().size() > 0) {
			self.error('Debes derrotar a los enemigos que restan: ' + habitacion.enemigos().size())
		}
	}

}


class PuertaFinal inherits Puerta {
	var property enemigosTotalesParaPasar
	var property cosasTotalesParaPasar

	override method validarAtravesar(personaje, habitacion) {
		console.println("eneemigos eliminados: " + personaje.enemigosEliminados())
		console.println("cantidad de cosas del personaje: " + personaje.cantidadDeCosas())
		if (personaje.enemigosEliminados() < self.enemigosTotalesParaPasar() || personaje.cantidadDeCosas() < self.cosasTotalesParaPasar()) {
			self.error('Debes eliminar a todos los enemigos del juego y obtener todos los items')
		}
	}

}


class Conexion {

	var property habitacion1
	var property habitacion2
	var property posicionPuerta1

	method crearPuertaPrincipal(_siguienteHabitacion, _posicionPuerta) {
		return self.crearPuerta(_siguienteHabitacion, _posicionPuerta)
	}

	method crearPuerta(_siguienteHabitacion, _posicionPuerta) {
		return new Puerta(siguienteHabitacion = _siguienteHabitacion, posicionPuerta = _posicionPuerta)
	}

	method conectar() {
		const puerta1 = self.crearPuertaPrincipal(habitacion2, posicionPuerta1)
		const puerta2 = self.crearPuerta(habitacion1, posicionPuerta1.opuesto())
		habitacion1.agregarPuerta(puerta1)
		habitacion2.agregarPuerta(puerta2)
	}

}

class ConexionKill inherits Conexion {

	override method crearPuertaPrincipal(_siguienteHabitacion, _posicionPuerta) {
		return new PuertaKill(siguienteHabitacion = _siguienteHabitacion, posicionPuerta = _posicionPuerta)
	}

}

class ConexionLoot inherits Conexion {

	const artefactoLoot

	override method crearPuertaPrincipal(_siguienteHabitacion, _posicionPuerta) {
		return new PuertaLoot(siguienteHabitacion = habitacion2, posicionPuerta = posicionPuerta1, artefactoPorLootear = artefactoLoot)
	}

}

class ConexionFinal inherits Conexion{
	
	override method crearPuertaPrincipal(_siguienteHabitacion, _posicionPuerta) {
		return new PuertaFinal(siguienteHabitacion = habitacion2, posicionPuerta = posicionPuerta1, enemigosTotalesParaPasar = 2, cosasTotalesParaPasar = 1) //parametrizable
	}
	
}


object habitacionFactory {

	method inicializarHabitaciones() {
		return (1 .. 12).map({ _ => new Habitacion()})
	}

	method inicializarConexiones(habitaciones) {
		const conexiones = [ new Conexion (habitacion1= habitaciones.get(0), habitacion2= habitaciones.get(1),  posicionPuerta1= posicionSuperior), new ConexionKill (habitacion1= habitaciones.get(1), habitacion2= habitaciones.get(2), posicionPuerta1 = posicionOeste), new ConexionLoot (habitacion1= habitaciones.get(2), habitacion2=habitaciones.get(3), 
       									posicionPuerta1 = posicionInferior, artefactoLoot= llave), new ConexionFinal(habitacion1= habitaciones.get(2), habitacion2= habitaciones.get(4), posicionPuerta1 = posicionSuperior) ]
		conexiones.forEach({ conexion => conexion.conectar()})
	}

	method inicializarElementos(habitaciones) {
		espadaDeNederita.position(game.at(3, 5))
		habitaciones.get(0).agregarCosa(espadaDeNederita)
	}

	method inicializarEnemigos(habitaciones) {
		const humano = new Humano(artefactoADropear = llave, position = game.at(3, 6))
		habitaciones.get(1).agregarEnemigo(humano)
		habitaciones.get(1).agregarEnemigo(ghostito)
	}

	method init(habitacionManager) {
		const habitaciones = self.inicializarHabitaciones()
		self.inicializarConexiones(habitaciones)
		self.inicializarElementos(habitaciones)
		self.inicializarEnemigos(habitaciones)
		habitacionManager.habitaciones(habitaciones)
	}

}


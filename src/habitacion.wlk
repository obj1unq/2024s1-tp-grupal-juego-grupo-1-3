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
		keyboard.down().onPressDo({ asterion.mover(abajo) inventario.ocultar()})
		keyboard.up().onPressDo({ asterion.mover(arriba) inventario.ocultar()})
		keyboard.left().onPressDo({ asterion.mover(izquierda) inventario.ocultar()})
		keyboard.right().onPressDo({ asterion.mover(derecha) inventario.ocultar()})
		keyboard.q().onPressDo({ asterion.equipar() inventario.ocultar()})
		keyboard.z().onPressDo({ asterion.dropearArma() inventario.ocultar()})
		keyboard.f().onPressDo({ asterion.golpear() inventario.ocultar()})
		keyboard.i().onPressDo({ inventario.mostrar()}) //quiza poner que tambien muestre los objetos y no solo responsabilidad del inventario
		keyboard.h().onPressDo({ controles.mostrar() inventario.ocultar()})
		keyboard.a().onPressDo({asterion.sayAtaque() inventario.ocultar()})
		keyboard.d().onPressDo({asterion.sayDefensa() inventario.ocultar()})
		keyboard.v().onPressDo({asterion.sayVida() inventario.ocultar()})
		
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
		const conexiones = [ new Conexion (habitacion1= habitaciones.get(0), habitacion2= habitaciones.get(1),  posicionPuerta1= posicionSuperior),
			 new ConexionKill (habitacion1= habitaciones.get(1), habitacion2= habitaciones.get(2), posicionPuerta1 = posicionOeste), 
			 new ConexionLoot (habitacion1= habitaciones.get(2), habitacion2=habitaciones.get(3), posicionPuerta1 = posicionInferior, artefactoLoot= llaveDeBronce), 
			 new Conexion(habitacion1= habitaciones.get(2), habitacion2= habitaciones.get(4), posicionPuerta1 = posicionSuperior),
       		new ConexionKill(habitacion1= habitaciones.get(4), habitacion2=habitaciones.get(5), posicionPuerta1= posicionEste),
       		new Conexion(habitacion1= habitaciones.get(5), habitacion2=habitaciones.get(6), posicionPuerta1=posicionEste),
       		new Conexion(habitacion1= habitaciones.get(5), habitacion2= habitaciones.get(10), posicionPuerta1= posicionSuperior),
       		new Conexion(habitacion1= habitaciones.get(6), habitacion2=habitaciones.get(7), posicionPuerta1= posicionInferior),
       		new ConexionKill(habitacion1= habitaciones.get(6), habitacion2= habitaciones.get(9), posicionPuerta1= posicionSuperior),
       		new ConexionLoot(habitacion1= habitaciones.get(7),habitacion2=habitaciones.get(8), posicionPuerta1= posicionInferior, artefactoLoot= llaveDePlata),
       		new ConexionKill(habitacion1= habitaciones.get(10), habitacion2=habitaciones.get(9), posicionPuerta1= posicionEste),
       		new ConexionFinal(habitacion1= habitaciones.get(10), habitacion2=habitaciones.get(11), posicionPuerta1= posicionOeste)
       		 ]
		conexiones.forEach({ conexion => conexion.conectar()})
		
	}

	method inicializarElementos(habitaciones) {
		espadaDeNederita.position(game.at(3, 5))
		habitaciones.get(0).agregarCosa(espadaDeNederita)
		habitaciones.get(2).agregarCosa(new PocionVida(puntosDeVida=60, position= game.at(5,4)))
		
		escudo.position(game.at(4,4))
		habitaciones.get(5).agregarCosa(escudo)
		
		//habitaciones.get(7).agregarCosa(escudo) agrwgar algo en la 7
		
		gema.position(game.at(9,9))
		habitaciones.get(9).agregarCosa(gema)
		llaveDePlata.position(game.at(0,9))
		habitaciones.get(9).agregarCosa(llaveDePlata)
		
		escudoBlindado.position(game.at(5,5))
		habitaciones.get(10).agregarCosa(escudoBlindado)
		habitaciones.get(10).agregarCosa(new PocionVida(position= game.at(6,6), puntosDeVida = 100))
		
	}

	method inicializarEnemigos(habitaciones) {
		const humano = new Humano(artefactoADropear = llaveDeBronce, position = game.at(3, 6))
		const ariadna = new Ariadna(artefactoADropear = aire, position = game.at(3, 6))
		const teseo  = new Teseo(artefactoADropear = aire, position = game.at(3, 8))
		
		habitaciones.get(1).agregarEnemigo(humano)
		habitaciones.get(1).agregarEnemigo(ghostito)
		
		habitaciones.get(3).agregarEnemigo(new Humano(position= game.at(4,7), poderDefensa=10, artefactoADropear= new PocionVida(puntosDeVida= 80)))//quiza 90
		
		habitaciones.get(4).agregarEnemigo(new Humano(position= game.at(4,7), poderDefensa=15))
		habitaciones.get(4).agregarEnemigo(new EspectroVenenoso(artefactoADropear= hachaDobleCara))
		habitaciones.get(6).agregarEnemigo(new SuperHumano(position= game.at(4,4),artefactoADropear= new PocionVida(puntosDeVida=60)))
		
		const ghostVeloz = new EspectroVeloz(artefactoADropear= llaveDeOro)
		habitaciones.get(8).agregarEnemigo(ghostVeloz)
		habitaciones.get(8).agregarEnemigo(new EspectroVeloz())
		
		habitaciones.get(10).agregarEnemigo(new SuperHumano(position= game.at(5,4),artefactoADropear=lanzaHechizada, poderDefensa= 50))
		habitaciones.get(10).agregarEnemigo(new EspectroVenenoso())
		habitaciones.get(10).agregarEnemigo(new Humano(position= game.at(3,3), arma=espadaDeNederita, vida=100) )	
	}

	method init(habitacionManager) {
		const habitaciones = self.inicializarHabitaciones()
		self.inicializarConexiones(habitaciones)
		self.inicializarElementos(habitaciones)
		self.inicializarEnemigos(habitaciones)
		habitacionManager.habitaciones(habitaciones)
	}

}


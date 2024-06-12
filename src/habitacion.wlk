import wollok.game.*
import asterion.*
import posiciones.*
import artefactos.*


object habitacionManager{
			
	method cargarHabitacion(habitacion){
		
		self.limpiarNivel()
		
		keyboard.p().onPressDo({asterion.atravesar()})

		game.title("El juego de Asterion")
		game.height(10)
		game.width(10)
		keyboard.down().onPressDo({ asterion.mover(abajo) })
		keyboard.up().onPressDo({ asterion.mover(arriba) })
		keyboard.left().onPressDo({ asterion.mover(izquierda) })
		keyboard.right().onPressDo({ asterion.mover(derecha) })
		keyboard.q().onPressDo({ asterion.equipar() })
		keyboard.z().onPressDo({ asterion.dropearArma() })
		keyboard.f().onPressDo({asterion.golpear()})

		
		habitacion.init(self)
		
		self.inicializarJuego() 
	}
	
	method limpiarNivel(){
		game.clear()
	}
	
	method inicializarJuego(){
		game.addVisual(asterion)
		// game.addVisual(escudo) //buen tamaño 32x32 
		// game.addVisual(espadaDeNederita)	
	}
}



class Habitacion {
	const property position = game.center()
	const property objetivo = null 
	const property enemigos = []
	const property cosas  = #{}
	const property puertas = #{}
	const ground = "ground5.png"
	
	method agregarPuerta(puerta){
		puertas.add(puerta)
		puerta.habitacionActual(self)
	}
	method mostrarPuertas(){
		puertas.forEach({puerta => game.addVisual(puerta)})
	}
	
	method agregarCosa(cosa){
		cosas.add(cosa)
	}
	
	method mostrarCosas(){
		cosas.forEach({cosa => game.addVisual(cosa)})
	}
	
	method sacarCosa(cosa){
		self.cosas().remove(cosa)
		game.removeVisual(cosa)
	}
	
	method agregarEnemigo(enemigo){
		enemigos.add(enemigo)
		enemigo.habitacionActual(self)
	}
	
	method sacarEnemigo(enemigo){
		self.enemigos().remove(enemigo)
	}
	
	method mostrarEnemigos(){
		enemigos.forEach({enemigo => enemigo.init()})
	}
	
	
	method init(manager){
		game.ground(ground)
		self.mostrarPuertas()
		self.mostrarCosas()
		self.mostrarEnemigos()
		game.addVisual(barraVida)
	}
}

object posicionSuperior{
	const positionStategy = positionUp
	
	method image() = "door-down.png"
	
	 method position() {
		return positionStategy.position()
	}
	
	method nextPosition(){
		return positionStategy.nextPosition()
	}
	
	method opuesto(){
		return posicionInferior
	}
	
}

object posicionInferior{
	const positionStategy = positionDown
	
	 method image() = "door-up.png"
	
	 method position() {
		return positionStategy.position()
	}
	
	method nextPosition(){
		return positionStategy.nextPosition()
	}
	
	method opuesto(){
		return posicionSuperior
	}
}

object posicionEste{
	const positionStategy = positionRight
	
	 method image() = "door-left.png"
	
	 method position() {
		return positionStategy.position()
	}
	
	method nextPosition(){
		return positionStategy.nextPosition()
	}
	
	method opuesto(){
		return posicionOeste
	}
}

object posicionOeste{
	const positionStategy = positionLeft
	
	 method image() = "door-right.png"
	
	 method position() {
		return positionStategy.position()
	}
	
	method nextPosition(){
		return positionStategy.nextPosition()
	}
	
	method opuesto(){
		return posicionEste
	}
}



class Puerta {

    const property siguienteHabitacion 
    const property posicionPuerta
    var property habitacionActual = null
    
    method image() = posicionPuerta.image()
    
    method position() = posicionPuerta.position()
    
    method esAtravesable(){
    	return true
    }
    
    method validarAtravesar(personaje, habitacion){ }
    
    method atravesar(personaje){
     self.validarAtravesar(personaje, self.habitacionActual())
     habitacionManager.cargarHabitacion(self.siguienteHabitacion())
     personaje.habitacionActual(self.siguienteHabitacion())
     personaje.position(posicionPuerta.nextPosition())
    }
}




class PuertaLoot inherits Puerta {
	var property lootear = #{}
	
	override method validarAtravesar(personaje, habitacion){
		
	}
}


class PuertaKill inherits Puerta {
	var property kill = #{}
	
	override method validarAtravesar(personaje, habitacion){
		
	}
}

class Conexion {
	
	var property habitacion1
	var property habitacion2
	var property posicionPuerta1
	
	 method conectar() {
        const puerta1 = new Puerta(siguienteHabitacion = habitacion2, posicionPuerta = posicionPuerta1)
        const puerta2 = new Puerta(siguienteHabitacion = habitacion1, posicionPuerta = posicionPuerta1.opuesto())
        habitacion1.agregarPuerta(puerta1)
        habitacion2.agregarPuerta(puerta2)
    }
}

object habitacionFactory {
	
	method inicializarHabitaciones(){
		return (1..4).map({_ => new Habitacion()})
	}
	
	method inicializarConexiones(habitaciones) {
		
    const conexiones = [
       	  new Conexion (habitacion1= habitaciones.get(0), habitacion2= habitaciones.get(1),  posicionPuerta1= posicionSuperior),
       	new Conexion (habitacion1= habitaciones.get(1), habitacion2= habitaciones.get(2), posicionPuerta1 = posicionOeste),
       	new Conexion (habitacion1= habitaciones.get(2), habitacion2=habitaciones.get(3), posicionPuerta1 = posicionInferior)
        ]
        
    conexiones.forEach({ conexion =>
        conexion.conectar()
    })
}

method inicializarElementos(habitaciones) {
    habitaciones.get(0).agregarCosa(espadaDeNederita)
}

method inicializarEnemigos(habitaciones) {
    const humano = new Humano(artefactoADropear = llave, position = game.at(3, 6))
    habitaciones.get(1).agregarEnemigo(humano)
    habitaciones.get(1).agregarEnemigo(ghostito)
}
	
	method inicializarHabitacion(habitacion){
	habitacionManager.cargarHabitacion(habitacion)
	asterion.habitacionActual(habitacion)
	}
	
	
	method init(){
	const habitaciones = self.inicializarHabitaciones()
    self.inicializarConexiones(habitaciones)
    self.inicializarElementos(habitaciones)
    self.inicializarEnemigos(habitaciones)
	self.inicializarHabitacion(habitaciones.get(0))
	}
}


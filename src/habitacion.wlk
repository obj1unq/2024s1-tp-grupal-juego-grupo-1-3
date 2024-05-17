import wollok.game.*
import pepita.*
import posiciones.*


object habitacionManager{
			
	method cargarHabitacion(habitacion){
		
		self.limpiarNivel()
		
		keyboard.p().onPressDo({zeldita.atravesar()})

		game.title("El juego de Asterion")
		game.height(10)
		game.width(10)
		keyboard.down().onPressDo({ zeldita.mover(abajo) })
		keyboard.up().onPressDo({ zeldita.mover(arriba) })
		keyboard.left().onPressDo({ zeldita.mover(izquierda) })
		keyboard.right().onPressDo({ zeldita.mover(derecha) })

		
		habitacion.init(self)
		
		self.inicializarJuego() 
	}
	
	method limpiarNivel(){
		game.clear()
	}
	
	method inicializarJuego(){
		game.addVisual(zeldita)	
	}
}



class Habitacion {
	const property position = game.center()
	const property objetivo = null 
	const property enemigos = null
	const property cosas  = null
	const property puertas = #{}
	const ground = "ground5.png"
	
	method agregarPuerta(puerta){
		puertas.add(puerta)
		puerta.habitacionActual(self)
	}
	method mostrarPuertas(){
		puertas.forEach({puerta => game.addVisual(puerta)})
	}
	method init(manager){
		game.ground(ground)
		self.mostrarPuertas()
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

object habitacionFactory {
	
	method init(){
	const nivel1 = new Habitacion()
	const nivel2 = new Habitacion()
	const puerta = new Puerta(siguienteHabitacion = nivel2, posicionPuerta= posicionSuperior)
	const puerta2 = new Puerta(siguienteHabitacion = nivel1, posicionPuerta= posicionInferior)
	
	nivel1.agregarPuerta(puerta)
	nivel2.agregarPuerta(puerta2)
	
	habitacionManager.cargarHabitacion(nivel1)
	}
}


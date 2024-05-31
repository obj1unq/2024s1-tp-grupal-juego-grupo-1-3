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
	}
	
	method mostrarEnemigos(){
		enemigos.forEach({enemigo => game.addVisual(enemigo)})
	}
	
	method sacarEnemigo(enemigoEncontrado){
		const enemigoSeleccionado = self.enemigos().find({enemigo => enemigo == enemigoEncontrado})
		console.println('enemigo seleccionado ' +  enemigoSeleccionado)
		enemigos.remove(enemigoSeleccionado)
		game.removeVisual(enemigoSeleccionado)
	}
	
	
	method init(manager){
		game.ground(ground)
		self.mostrarPuertas()
		self.mostrarCosas()
		self.mostrarEnemigos()
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

object habitacionFactory {
	
	method init(){
	const nivel1 = new Habitacion()
	const nivel2 = new Habitacion()
	const nivel3 = new Habitacion()
	const nivel4 = new Habitacion()
	
	const puerta12 = new Puerta(siguienteHabitacion = nivel2, posicionPuerta= posicionSuperior)
	const puerta21 = new Puerta(siguienteHabitacion = nivel1, posicionPuerta= posicionInferior)
	const puerta23 = new Puerta(siguienteHabitacion= nivel3, posicionPuerta= posicionOeste)
	const puerta32 = new Puerta(siguienteHabitacion = nivel2, posicionPuerta= posicionEste)
	const puerta34 = new Puerta(siguienteHabitacion= nivel4, posicionPuerta= posicionInferior)
	const puerta43 = new Puerta(siguienteHabitacion= nivel3, posicionPuerta= posicionSuperior)
	
	
	const espada = espadaDeNederita
	espada.position(game.at(3,5))
	
	const humano = new Humano(artefactoADropear = llave, position= game.at(3,6))
	
	nivel1.agregarPuerta(puerta12)
	nivel2.agregarPuerta(puerta21)
	nivel2.agregarPuerta(puerta23)
	nivel3.agregarPuerta(puerta32)
	nivel3.agregarPuerta(puerta34)
	nivel4.agregarPuerta(puerta43)
	
	nivel1.agregarCosa(espada)
	nivel2.agregarEnemigo(humano)
	
	habitacionManager.cargarHabitacion(nivel1)
	asterion.habitacionActual(nivel1)
	humano.habitacionActual(nivel2)
	}
}


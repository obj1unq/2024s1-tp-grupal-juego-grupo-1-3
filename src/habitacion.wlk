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
	
	method sacarEnemigo(enemigoEncontrado){
		const enemigoSeleccionado = self.enemigos().find({enemigo => enemigo == enemigoEncontrado})
		console.println('enemigo seleccionado ' +  enemigoSeleccionado)
		enemigos.remove(enemigoSeleccionado)
		game.removeVisual(enemigoSeleccionado)
	}
	
	
	
	method mostrarEnemigos(){
		enemigos.forEach({enemigo => enemigo.init()})
	}
	
	method esObjetivoCumplido(){
		return true
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
    var property habitacionCompletada = null
    var property esCompletada = true
    
    method image() = posicionPuerta.image()
    
    method position() = posicionPuerta.position()
    
    method esAtravesable(){
    	return true
    }
    
    method validarAtravesar(personaje, habitacion){ }
    
    method atravesar(personaje){
    	//esto esta bien?
  
  
     self.validarAtravesar(personaje, self.habitacionActual())
     habitacionManager.cargarHabitacion(self.siguienteHabitacion())
     personaje.habitacionActual(self.siguienteHabitacion())
     personaje.position(posicionPuerta.nextPosition())
  
  /*    self.validarAtravesar(personaje, self.habitacionActual())
     console.println('es objetivo cumpleido: ' +self.habitacionActual().esObjetivoCumplido() )
     
     if(self.habitacionActual().esObjetivoCumplido() && self.esCompletada()){
		console.println('en el if del atravesar')
     	self.habitacionCompletada(self.habitacionActual())
     	self.esCompletada(false)
     	
     	habitacionManager.cargarHabitacion(self.siguienteHabitacion())
     	personaje.habitacionActual(self.siguienteHabitacion())
     	personaje.position(posicionPuerta.nextPosition())
     	
     }else{
     	console.println('en el else del atravesar')
     	habitacionManager.cargarHabitacion(self.habitacionCompletada())	
     }
     */
    
    }
}



class PuertaLoot inherits Puerta {
	var property artefactoPorLootear 
		
	
	override method validarAtravesar(personaje, habitacion){
			
			if(not personaje.tieneArtefacto(artefactoPorLootear)){
				self.error('debes recoger un objeto para pasar')
			}
	}
}


class PuertaKill inherits Puerta {
	var property kill = #{}

		override method validarAtravesar(personaje, habitacion){
		if (habitacion.enemigos().size() > 0){
			self.error('Debes derrotar a todos los enemigos')
		}
	}
	
}

object habitacionFactory {
	
	method init(){
	const nivel1 = new Habitacion()
	const nivel2 = new Habitacion()
	const nivel3 = new Habitacion()
	const nivel4 = new Habitacion()
	
	const puerta12 = new Puerta(siguienteHabitacion = nivel2, posicionPuerta= posicionSuperior, habitacionCompletada = nivel2 )
	const puerta21 = new Puerta(siguienteHabitacion = nivel1, posicionPuerta= posicionInferior, habitacionCompletada = nivel2)
	const puerta23 = new PuertaKill(siguienteHabitacion= nivel3, posicionPuerta= posicionOeste, habitacionCompletada = nivel2)//Puerta Kill
	const puerta32 = new Puerta(siguienteHabitacion = nivel2, posicionPuerta= posicionEste, habitacionCompletada = nivel2)
	const puerta34 = new PuertaLoot(siguienteHabitacion= nivel4, posicionPuerta= posicionInferior, habitacionCompletada = nivel2,artefactoPorLootear=llave) //Puerta de loot
	const puerta43 = new Puerta(siguienteHabitacion= nivel3, posicionPuerta= posicionSuperior, habitacionCompletada = nivel2)
	
	
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
	nivel2.agregarEnemigo(ghostito)
	
	habitacionManager.cargarHabitacion(nivel1)
	asterion.habitacionActual(nivel1)
	humano.habitacionActual(nivel2)
	}
}


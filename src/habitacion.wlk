import wollok.game.*
import pepita.*
import posiciones.*

object habitacionManager{
	

	var property habitacionActual = null
	
	method cargarHabitacion(habitacion){
		
		self.limpiarNivel()
		
		keyboard.p().onPressDo({zeldita.atravesar()})

		game.title("nivel 1")
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
	const property numeroHabitacion
	
	method agregarPuerta(puerta){
		puertas.add(puerta)
	}
	method mostrarPuerta(){
		puertas.forEach({puerta => game.addVisual(puerta)})
	}
	method init(manager){
		
		game.ground(ground)
		//game.addVisual(puertas)
		self.mostrarPuerta()
		manager.habitacionActual(self)
	}
}

class Puerta {
	
	var property position = game.center()

    const property siguienteHabitacion 
    const estadoPuerta = loot 
    
    method image() = return "door-up.png"
    
    method bloquear (){
    	return ""
    }
    
    method desbloquear(){
    	return ""
    }
    
    method puedePasar(){
    	return ""
    }
    
    method esAtravesable(){
    	return true
    }
    
    method atravesar(){
     habitacionManager.cargarHabitacion(self.siguienteHabitacion())
    }
}

// 



//OBJETIVOS: loot - killAll
object loot{
	
	method siguienteHabitacion(){
		
	}
	
}

object killAll{
	
	method siguienteHabitacion(){
		
	}
}

import wollok.game.*
import pepita.*
import posiciones.*

object habitacionManager{
	
	var property habitaciones = []
	
	method cargarHabitacion(numero){
		
		self.limpiarNivel()
		keyboard.p().onPressDo({self.cargarHabitacion(1)}) // Chequear donde tiene que ir esto

		game.title("nivel 1")
		game.height(10)
		game.width(10)
		keyboard.down().onPressDo({ zeldita.mover(abajo) })
		keyboard.up().onPressDo({ zeldita.mover(arriba) })
		keyboard.left().onPressDo({ zeldita.mover(izquierda) })
		keyboard.right().onPressDo({ zeldita.mover(derecha) })

		
		habitaciones.get(numero).init()
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
	const property puertas
	const ground = "ground5.png"
	
	
	method init(){
		game.ground(ground)
		game.addVisual(puertas)
	}
}

class Puerta {
	
	const property position = game.center()

    const siguienteHabitacion = ""
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
    
    method atravesar(){
    	return ""
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

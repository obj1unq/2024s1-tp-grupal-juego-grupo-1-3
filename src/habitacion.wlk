import wollok.game.*
import pepita.*
import posiciones.*

object habitacionManager{
	
	var property habitaciones = []
	
	method cargarHabitacion(numero){
		
		console.println("las habitaciones: " + habitaciones)
		self.limpiarNivel()
		keyboard.p().onPressDo({self.cargarHabitacion(1)}) // Chequear donde tiene que ir esto
		console.println('el numero es: '  + numero)
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
		
		game.start()
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
		// posiciones de las puertas
		// objetivo----->depende del estado de la habitación o no : Enemigos.size == 0 method de objectivo cumplido en habitación
		// enemigo -----> agregar visual del enemeigo
		// puertas ---> Position
		// el wollok game tiene que tener una lista de habitaciónes
		// limites de la habitación
		
	
	}
	
}

class Puerta {
	
	const property position = game.center()

    const siguienteHabitacion = ""
    const estadoPuerta = loot // estado puerta
    
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

object tablero {
	
	method pertenece(position) {
		return position.x().between(0, game.width() - 1) &&
			   position.y().between(0, game.height() -1 ) 
	}
	
	method puedeIr(desde, direccion) {
		const aDondeVoy = direccion.siguiente(desde) 
		return self.pertenece(aDondeVoy)
				&& not self.hayObstaculo(aDondeVoy) 
	}
	
	method hayObstaculo(position) {
		const visuales = game.getObjectsIn(position)
		return visuales.any({visual => not visual.esAtravesable()})
	}
	
}



//OBJETIVOS: loot - killAll
object loot{
	
	method siguienteHabitacion(){
		
	}
	
}

object killAll{
	
	method siguienteHabitacion(){
		
	}
}

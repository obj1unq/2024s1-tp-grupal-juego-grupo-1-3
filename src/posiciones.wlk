import wollok.game.*

//DIRECCIONES 
object arriba {

	method siguiente(position) {
		return position.up(1)
	}

}

object abajo {

	method siguiente(position) {
		return position.down(1)
	}

}

object izquierda {

	method siguiente(position) {
		return position.left(1)
	}

}

object derecha {

	method siguiente(position) {
		return position.right(1)
	}

}

// Avanzar Habitacion
object cruceArriba {
	method siguiente(position){
		
	}
}

object cruceAbajo {
	
}

object cruceDerecha {
	
}

object cruceIzquierda {
	
}
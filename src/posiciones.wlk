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

object positionUp{
	
	method position(){
		return game.at(game.width()/2, game.height()-1)
	}
	
	method nextPosition(){
		return positionDown.position()
	}

}

object positionDown {
	method position(){
		return game.at(game.width()/2, 0)
	}
	
	method nextPosition(){
		return positionUp.position()
	}
	
}

object positionLeft {
	method position(){
		return game.at(0, game.height()/2)
	}
	
	method nextPosition(){
		return positionRight.position()
	}
}

object positionRight {
	method position(){
		return game.at(game.width()-1 , game.height()/2)
	}
	
	method nextPosition(){
		return positionLeft.position()
	}
}



object tablero {
	
	method pertenece(position) {
		return position.x().between(0, game.width() - 1) &&
			   position.y().between(0, game.height() -1 ) 
	}
	
	method puedeIr(desde, direccion) {
		const aDondeVoy = direccion.siguiente(desde) 
		return self.pertenece(aDondeVoy)
				 
	}
	
}

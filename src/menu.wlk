import asterion.*
import wollok.game.*
import artefactos.*
import posiciones.*
 
class ObjetoMostrable {

	var property position = null
	var property image

	method mostrarEn(posicion) {
		position = posicion
		game.addVisual(self)
	}

	method ocultar() {
		game.removeVisual(self)
	}

	method esArtefacto() {
		return false
	}

}
class FraseFinal{
	const estado 
	
	method position() = estado.position()
	method image() = estado.image()
}

class Menu {

	var property oculto = true
	var property position = game.at(0, 0)

	method image()

	method mostrar() {
		if (oculto) {
			game.addVisual(self)
			oculto = false
		} else {
			game.removeVisual(self)
			oculto = true
		}
	}

}

class Inventario inherits Menu {

	const property personaje = asterion
	const property objetosMostrables = []

	override method position() = game.at(3, 4)

	override method oculto() = true

	method validarEspacioEnInventario() {
		if (self.estaLleno()) {
			self.error("Inventario lleno")
		}
	}

	method estaLleno() {
		return asterion.todosLosObjetos().size() == 9
	}

	override method image() {
		return "Inventory1.png"
	}

	override method mostrar() {
		if (oculto) {
			game.addVisual(self)
			self.mostrarObjetos()
			oculto = false
		} else {
			game.removeVisual(self)
			self.ocultarObjetos()
			oculto = true
		}
	}

	method ocultar() {
		if (!oculto) {
			game.removeVisual(self)
			self.ocultarObjetos()
			oculto = true
		}
	}

	method mostrarObjetos() {
		const posicionesX = [ 3, 4, 5, 3, 4, 5, 3, 4, 5 ]
		const posicionesY = [ 6, 6, 6, 5, 5, 5, 4, 4, 4 ]
		var indice = 0
		objetosMostrables.addAll(asterion.todosLosObjetos().filter({ obj => obj.esArtefacto()}).map({ obj => new ObjetoMostrable(image = obj.image())}))
		objetosMostrables.forEach({ obj =>
			const posicion = game.at(posicionesX.get(indice), posicionesY.get(indice))
			obj.mostrarEn(posicion)
			indice += 1
		})
	}

	method ocultarObjetos() {
		objetosMostrables.forEach({ obj => game.removeVisual(obj)})
		objetosMostrables.clear()
	}

	method esArtefacto() {
		return false
	}

}

object inventario inherits Inventario {

}

object controles inherits Menu {

	override method position() = game.at(0, -2)

	override method image() {
		return "controles.png"
	}

}

object soundImageOff{
	
	var property position = game.at(0, 0)
	method image() = "soundoff.png"
}


object soundImageOn{
	
	var property position = game.at(0, 0)
	method image() = "soundon.png"
}


object sonidos {
	var property musica
	// var property soundWinner=game.sound("ganar.mp3")
	var property soundOff = false
	var property soundState = soundImageOn
	
	var property position = soundState.position()
	method image() = soundState.image()
	
	method switchSound() {
		if (soundOff) {
			game.removeVisual(soundState)			
			soundState = soundImageOn
	//		musica.playMusic("tension.mp3")
			game.addVisual(soundState)
			soundOff = false
			
		} else {
			game.removeVisual(soundState)
			soundState = soundImageOff
	//		musica.stopMusic()
			game.addVisual(soundState)
			soundOff = true		
		}
	}
	
	method play(unSonido){
		if(not soundOff){
			game.sound(unSonido).play()}
	}
	
	method stopMusic(){
		musica.stop()

	}
	
	method playMusic(unaMusica){
		if(not soundOff){
			musica=game.sound(unaMusica)
			musica.shouldLoop(true)
			game.schedule(100, {musica.play()})	
		}
	}

	method soundOff(booleano){
		soundOff=booleano
	}
	
	method init(){
		self.playMusic("tension.mp3")
		return soundState
	}

}

class Assets {
	
	var property position
	
	method image()
	
}

class Escaleras inherits Assets {
	override method image() {
		 return "escalerasCombinadas.png"
	}
}

class Piso inherits Assets {
	override method image() {
		return "paredHorizontal32.png"
	}
}

class Columna inherits Assets {
	override method image() {
		return "columnaRomana160.png"
	}
}

class Escalera inherits Escaleras {
	override method image() {
		return "escaleraSimple.png"
	}
}

class Techo inherits Assets {
	override method image() {
		return "techo96x16.png"
	}
}

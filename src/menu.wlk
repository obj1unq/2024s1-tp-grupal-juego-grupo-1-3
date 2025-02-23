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

class FraseFinal {

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

	override method position() = game.at(1, 1)

	override method image() {
		return "controles.png"
	}

	method ocultar() {
		if (!oculto) {
			game.removeVisual(self)
			oculto = true
		}
	}

}

object soundOff {

	var property position = game.at(0, 0)

	method image() = "soundoff.png"

	method switch(sonidos) {
		sonidos.soundState(soundOn)
		sonidos.resumeMusic()
	}

	method play(unSonido) {
	}

	method isOn() {
		return false
	}

}

object soundOn {

	var property position = game.at(0, 0)

	method image() = "soundon.png"

	method switch(sonidos) {
		sonidos.soundState(soundOff)
		sonidos.pauseMusic()
	}

	method play(unSonido) {
		game.sound(unSonido).play()
	}

	method isOn() {
		return true
	}

}

object sonidos {

	var property musica
	var property soundState = soundOn
	var property position = soundState.position()

	method image() = soundState.image()

	method switchSound() {
		self.soundState().switch(self)
	}

	method play(unSonido) {
		self.soundState().play(unSonido)
	}

	method stopMusic() {
		musica.stop()
	}

	method pauseMusic() {
		musica.stop()
	}

	method resumeMusic() {
		if (musica.paused()) {
			musica.resume()
		} else {
			self.playMusic()
		}
	}

	method playMusic() {
		if (self.soundState().isOn()) {
			musica = game.sound("tension.mp3")
			musica.shouldLoop(true)
			game.schedule(100, { musica.play()})
		}
	}

}


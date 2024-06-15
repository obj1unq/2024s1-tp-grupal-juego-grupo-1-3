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

class Inventario {

	var property position = game.at(3, 4)
	const property personaje = asterion
	var property oculto = true
	var property objetosMostrables = []

	method validarEspacioEnInventario() {
		if (self.estaLleno()) {
			self.error("Inventario lleno")
		}
	}

	method estaLleno() {
		return asterion.todosLosObjetos().size() == 9
	}

	method image() {
		return "Inventory1.png"
	}
	
	method actualizar(){
		if(!oculto){
			self.ocultarObjetos()
			self.mostrarObjetos()
		}
	}

	method mostrar() {
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

	method mostrarObjetos() {
		const posicionesX = [ 3, 4, 5, 3, 4, 5, 3, 4, 5 ]
		const posicionesY = [ 6, 6, 6, 5, 5, 5, 4, 4, 4 ]
		var indice = 0
		objetosMostrables = asterion.todosLosObjetos().map({ obj => new ObjetoMostrable(image = obj.image())})
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


import wollok.game.*

object puertaComun {

	method image() {
		return "basic_door.png"
	}

	method puedePasar(personaje, objetivo) {
		return true
	}

	method necesita() {
		return "nada"
	}

}

object puertaObjetivo {

	method image() {
		return "basic_door.png"
	}

	method puedePasar(personaje, objetivo) {
		return objetivo.estaCumplido()
	}

	method necesita() {
		return "cumplir el objetivo"
	}

}




class Puerta {

	const position
	var tipoPuerta
	const objetivo
	var habitacionDestino

	method position() {
		return position
	}

	method image() {
		return tipoPuerta.image()
	}

	method puedePasar(personaje) {
		return tipoPuerta.puedePasar(personaje, objetivo)
	}

	method validarAtravesar(personaje) {
		if (not self.puedePasar(personaje)) {
			self.error("No estoy listo para pasar, necesito:" + tipoPuerta.necesita())
		}
	}

	method atravesar(personaje) {
		self.validarAtravesar(personaje)
		personaje.transportar(habitacionDestino)
	}

}


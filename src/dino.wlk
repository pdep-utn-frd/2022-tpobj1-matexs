import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(manzana)
		
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
	
		
	} 
	
	method    iniciar(){
		
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		manzana.iniciar()
	
	}
	
	method jugar(){
		if (dino.estaVivo()){
			dino.saltar()
		}
			
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		dino.morir()
		manzana.detener()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
		return tiempo

	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
}

object cactus {
	 
	const posicionInicial = game.at(game.width()-1,suelo.position().y())
	var position = posicionInicial

	method image() = "cactus.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"
}


object dino {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	var x=1

	method xs(){
		x=2
	}
	
	method image() = "dino.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(x)
	}
	
	method bajar(){
		position = position.down(x)
		x=1
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}

/*cuando dino choca con una manzana puede saltar x2 */
object manzana{
	var positionInicial = game.at(game.width()+3,suelo.position().y())
	var position = positionInicial
	var tiempo = reloj.pasarTiempo()


	method image()="manzana.png"
	method position()= position

	method iniciar(){
		position = positionInicial

		game.onTick(velocidad,"comerManzana",{self.chocar()})
	}
	
	method chocar(){
		position = position.left(1)
		if (position == dino.position()){
			dino.xs()
			game.removeTickEvent("comerManzana")
			
			self.iniciar()}
		if (position.x() == -1){
			position = positionInicial
		}
	}
	

	method detener(){
		game.removeTickEvent("comerManzana")
	}
	}
	
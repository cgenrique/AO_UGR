--Definimos las variables asignándolas a las elementos ya creados
PelotaSuelo = $PelotaSuelo
Suelo = $Suelo
Guia = $Guia

--Eliminamos las claves que pueda tener la pelota del plano
deletekeys PelotaSuelo

--Definimos el fin e inicio de la escena
Inicio = 0
Final = 500


/*Función para obtener la posicion de la guia sobre el plano en un tiempo dado. 
Utiliza un rayo que va hacia abajo desde la posición de la guía y calcula la intersección con el plano.
*/
fn getInterseccionPlano t = (
	/*Obtenemos la posicion de la pelota guia en cada momento.
	Después obtenemos un rayo que vaya en direccion inversa al eje Z, es decir, hacia abajo.
	Obtenemos la interseccion entre el rayo que sigue a la pelotaGuia y el plano.
	*/
	return IntersectRay Suelo (ray (at time t Guia.pos) [0, 0, -1])
)

-- Animación de la pelota
animate on (
	--Para cada fotograma de la animación. Se itera desde Inicio hasta Final en incrementos de 1.
	for t in Inicio to Final by 1 do (
		--Obtenemos la posicion de la guia respecto al plano inferior
		posicionGuia = getInterseccionPlano t
		
		/*Obtenemos la posicion de la pelota del suelo, siguiendo el movimiento de la guia. 
		Esto coloca la pelota en la posición correcta en el suelo según el movimiento de la guía.*/
		posicionSuelo = posicionGuia.pos + posicionGuia.dir * PelotaSuelo.radius
		
		/* Esto se hace para asegurarse de que la pelota no esté incrustada en el suelo ni flotando 
		por sobre él, sino que esté justo en la superficie del suelo, a una distancia igual al radio de la pelota.*/
		
		--Asignamos esa posicion a la pelota del plano
		at time t PelotaSuelo.pos = posicionSuelo
			
		if t > Inicio do (
			if t < Final then (
				--Se obtiene la siguiente posicion que debe tener la pelota del suelo
				posicionGuiaSiguiente = getInterseccionPlano (t + 1)
			) else (
				--Si llegamos al final, vuelve al inicio
				posicionGuiaSiguiente = getInterseccionPlano Inicio
			)
			
			posicionSueloSiguiente = posicionGuiaSiguiente.pos + posicionGuiaSiguiente.dir * PelotaSuelo.radius

			--Se obtiene la diferencia de posiciones y se normaliza
			diferenciaPosiciones = posicionSueloSiguiente - posicionSuelo
			longitud = Length diferenciaPosiciones
			vectorNormalizado = normalize(diferenciaPosiciones)
			
			/*Se calcula el eje de rotación mediante el producto vectorial 
			entre el vector director y la dirección de la posicion de la guia*/
			ejeRotacion = cross vectorNormalizado posicionGuia.dir
			
			/*Se calcula el ángulo de rotación basado en la longitud en relación al radio de la pelota y se genera una rotación
			en cuaternión utilizando ese ángulo y el eje de rotación*/
			anguloRotacion = 360 * longitud / (PelotaSuelo.radius * 2 * pi)
			rotacionQuaternion = quat anguloRotacion ejeRotacion
			
			--Se convierte a Euler y se aplica a la pelota
			rotacionEuler = QuatToEuler rotacionQuaternion
			at time t rotate PelotaSuelo rotacionEuler
		)
	)
)
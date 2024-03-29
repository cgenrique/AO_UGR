--Definimos las variables asign�ndolas a las elementos ya creados
PelotaSuelo = $PelotaSuelo
Suelo = $Suelo
Guia = $Guia

--Eliminamos las claves que pueda tener la pelota del plano
deletekeys PelotaSuelo

--Definimos el fin e inicio de la escena
Inicio = 0
Final = 500


/*Funci�n para obtener la posicion de la guia sobre el plano en un tiempo dado. 
Utiliza un rayo que va hacia abajo desde la posici�n de la gu�a y calcula la intersecci�n con el plano.
*/
fn getInterseccionPlano t = (
	/*Obtenemos la posicion de la pelota guia en cada momento.
	Despu�s obtenemos un rayo que vaya en direccion inversa al eje Z, es decir, hacia abajo.
	Obtenemos la interseccion entre el rayo que sigue a la pelotaGuia y el plano.
	*/
	return IntersectRay Suelo (ray (at time t Guia.pos) [0, 0, -1])
)

-- Animaci�n de la pelota
animate on (
	--Para cada fotograma de la animaci�n. Se itera desde Inicio hasta Final en incrementos de 1.
	for t in Inicio to Final by 1 do (
		--Obtenemos la posicion de la guia respecto al plano inferior
		posicionGuia = getInterseccionPlano t
		
		/*Obtenemos la posicion de la pelota del suelo, siguiendo el movimiento de la guia. 
		Esto coloca la pelota en la posici�n correcta en el suelo seg�n el movimiento de la gu�a.*/
		posicionSuelo = posicionGuia.pos + posicionGuia.dir * PelotaSuelo.radius
		
		/* Esto se hace para asegurarse de que la pelota no est� incrustada en el suelo ni flotando 
		por sobre �l, sino que est� justo en la superficie del suelo, a una distancia igual al radio de la pelota.*/
		
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
			
			/*Se calcula el eje de rotaci�n mediante el producto vectorial 
			entre el vector director y la direcci�n de la posicion de la guia*/
			ejeRotacion = cross vectorNormalizado posicionGuia.dir
			
			/*Se calcula el �ngulo de rotaci�n basado en la longitud en relaci�n al radio de la pelota y se genera una rotaci�n
			en cuaterni�n utilizando ese �ngulo y el eje de rotaci�n*/
			anguloRotacion = 360 * longitud / (PelotaSuelo.radius * 2 * pi)
			rotacionQuaternion = quat anguloRotacion ejeRotacion
			
			--Se convierte a Euler y se aplica a la pelota
			rotacionEuler = QuatToEuler rotacionQuaternion
			at time t rotate PelotaSuelo rotacionEuler
		)
	)
)
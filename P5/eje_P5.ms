--Borramos los objetos que pueda haber--
delete objects

--Creamos una tetera--
teapotObj = teapot()
teapotObj.pos = [0, 0, 0]  -- Posición de la tetera
teapotObj.scale = [0.5, 0.5, 0.5] --Escala de la tetera

--Creamos las plataformas
platform1 = box width:50 length:50 height:5 
platform1.pos = [150, 150, 0]  

platform2 = box width:50 length:50 height:5  
platform2.pos = [-150, 150, 0]  

platform1 = box width:50 length:50 height:5  
platform1.pos = [150, -150, 0]  

platform2 = box width:50 length:50 height:5  
platform2.pos = [-150, -150, 0]  

append objs teapotObj  -- Agrega la tetera a los objetos
append objs platform1  -- Agrega la plataforma 1 a los objetos
append objs platform2  -- Agrega la plataforma 2 a los objetos
append objs platform3  -- Agrega la plataforma 2 a los objetos
append objs platform4  -- Agrega la plataforma 2 a los objetos


/*Funcion para realizar una interpolacion lineal en t tiempo*/
fn interpolacionLineal t fps posInicial posFinal =(
    -- Calcula el vector diferencia entre las dos posiciones
    Vect = posFinal - posInicial
	
    -- Se normaliza el vector para obtener su dirección
    -- Luego, multiplica por la longitud del vector dividida por los FPS y el tiempo
    -- Finalmente, suma este resultado a la posicion inicial para obtener la posición interpolada
    return (posInicial + ((normalize Vect) * (((length Vect) / fps) * t)))
)

/*En la interpolación cuadrática, se utilizan tres puntos de control: p1, p2 y p3. En lugar de calcular directamente una 
función cuadrática para conectar estos puntos, se realiza una aproximación mediante dos interpolaciones lineales. 

Primero, se realiza una interpolación lineal entre p1 y p2, obteniendo un punto intermedio q1. Luego, se realiza otra 
interpolación lineal entre p2 y p3, obteniendo un punto intermedio q2. Finalmente, se realiza una interpolación lineal 
entre q1 y q2, lo que nos da la interpolación cuadrática deseada. De esta manera, se logra una curva suave y continua 
mediante segmentos de línea recta conectados en etapas sucesivas.*/

fn interpolacionCuadratica t fps punto1 punto2 punto3 =(
    -- Realiza una interpolación lineal entre posicion1 y posicion2
    q1 = interpolacionLineal t fps punto1 punto2
    -- Realiza una interpolación lineal entre posicion2 y posicion3
    q2 = interpolacionLineal t fps punto2 punto3
    -- Realiza una interpolación lineal entre q1 y q2 para obtener el resultado final de la interpolación cuadrática
    return (interpolacionLineal t fps q1 q2)
)

--Funcion para calcular el punto medio
fn puntoMedio punto1 punto2 =(
	-- Calcula las coordenadas X, Y y Z del punto medio entre punto1 y punto2
	X = (punto1.x + punto2.x)/2
	Y = (punto1.y + punto2.y)/2
	Z = (punto1.z + punto2.z)/2

	-- Devuelve un nuevo vector que representa el punto medio calculado
	return [X,Y,Z]
)


--Función para calcular la distancia euclidiana entre varios puntos
fn distancia punto1 punto2 =(
	-- Calcula la distancia euclidiana entre punto1 y punto2
	-- utilizando la fórmula de la distancia en el espacio tridimensional
	return sqrt((punto1.x-punto2.x)^2 + (punto1.y-punto2.y)^2 + (punto1.z-punto2.z)^2)
)

/*
Realiza una animación de Stretch, rotación y posición del objeto a lo largo de un intervalo de tiempo, 
utilizando interpolación cuadrática y puntos de control.
*/
fn Animar Objeto CP1 CP2 CP3 stretchAterrizaje stretchImpacto stretchSalto anguloAterrizaje anguloDespegue Inicio Fin =
(
	animate on
	(
		-- Establecer el Stretch y la rotación inicial en el tiempo de inicio
		at time Inicio (
			Objeto.modifiers[#stretchSaltos].Stretch = stretchImpacto
			Objeto.rotation.y = 0 --Vertical
		)
		
		-- Establecer el Stretch y la rotación intermedia en un tiempo entre el inicio y el final
		at time (Inicio+((Fin-Inicio)/10)) (
			Objeto.modifiers[#stretchSaltos].Stretch = stretchSalto
			rotate Objeto (eulerangles 0 anguloDespegue 0)
		)
		
		-- Establecer el Stretch y la rotación en el punto medio entre el inicio y el final
		at time ((Fin+Inicio)/2) (
			Objeto.modifiers[#stretchSaltos].Stretch = 0
			Objeto.rotation.y = 0
		)
		
		-- Establecer el Stretch y la rotación en un tiempo entre el final y el inicio
		at time (Fin-((Fin-Inicio)/10)) (
			Objeto.modifiers[#stretchSaltos].Stretch = stretchAterrizaje
			rotate Objeto (eulerangles 0 anguloAterrizaje 0)
		)
		
		-- Establecer el Stretch y la rotación final en el tiempo de finalización
		at time Fin (
			Objeto.modifiers[#stretchSaltos].Stretch = stretchImpacto
			 Objeto.rotation.y = 0
		)
		
		-- Animar la posición del objeto utilizando interpolación cuadrática entre los puntos de control CP1, CP2 y CP3
		for t in Inicio to Fin by 1 do
		(
			at time t
			(
				Objeto.pos = interpolacionCuadratica (t-Inicio) (Fin-Inicio) CP1 CP2 CP3
			)
		)
		
	)
)


/*Agrega un modificador de Stretch a un objeto dado, eliminando cualquier 
modificador existente con el mismo nombre.*/
fn addStretch obj nombre =
(
    -- Recorre todos los modificadores del objeto
    for m in obj.modifiers do
    (
        -- Verifica si el nombre del modificador coincide con el nombre proporcionado
        if (m.name == nombre) do (
            -- Elimina el modificador existente con el mismo nombre
            deleteModifier obj m
        )
    )
    
    -- Crea un nuevo modificador de Stretch
    myStretch = Stretch()
    myStretch.name = nombre
    
    -- Agrega el modificador de Stretch al objeto
    addmodifier obj myStretch
)


/*Crea un rollout llamado "Saltos" con diversas secciones y controles para configurar
  una animación de saltos.
*/
rollout Saltos "Saltos"
(
	-- "Objetos que intervienen"
	group "Objetos" (
		label EtiquetaActor "Actor:"
		button BotonSelectActor "Selecciona actor"
		label EtiquetaObjetos "Objetos:"
		button BotonSelectPlataformas "Selecciona las plataformas"
	)
	
	-- "Tiempo de la animación"
	group "Tiempo"(
		spinner spinnerInicioTiempo "Comienzo: " range:[0,100,0] type:#Integer
		spinner spinnerFinalTiempo "Final: " range:[5,100,100] type:#Integer
	)
	
	-- "Squash and Stretch" (El "aplastamiento" y "estiramiento")
	group "Squash y Stretch" (
		spinner stretchAterrizaje "Stretch de aterrizaje: " range:[-1,1,1] type:#Float
		spinner stretchImpacto "Stretch al impactar: " range:[-1,1,-0.5] type:#Float
		spinner stretchSalto "Stretch despegue: " range:[-1,1,0] type:#Float
	)
	
	-- "Ángulo del salto"
	group "Trayectoria del salto" (
		spinner anguloAterrizaje "Angulo de aterrizaje: " range:[-360,360,-30] type:#Float
		spinner anguloDespegue "Angulo de despegue: " range:[-360,360,30] type:#Float
	)
	
	
	
	button BotonAnimar "Crear" --Se crea la animación
	
	--Al pulsar el boton para seleccionar actor
	on BotonSelectActor pressed do
	(
		seleccion = getCurrentSelection()
		if (seleccion.count == 0) then (
			BotonSelectActor.text = "Selecciona un objeto" --Si no hay seleccion
		) else (
			global Objeto = seleccion[1]
			BotonSelectActor.text = Objeto.name --Si hay seleccion se cambia el nombre
		)
	)
	
	--Al pulsar el boton de seleccion de plataformas
	on BotonSelectPlataformas pressed do
	(
		seleccion = getCurrentSelection()
		if (seleccion.count == 0) then (
			BotonSelectPlataformas.text = "Selecciona al menos una plataforma" --Si no hay seleccion
		) else (
			global objs = #()
			for obj in seleccion do (
				append objs obj
			)
			BotonSelectPlataformas.text = "Plataforma(s) Seleccionada(s)" --Si hay seleccion se cambia el nombre
		)
	)
	
	--Al pulsar el boton de crear
	on BotonAnimar pressed do
	(
		if Objeto!= undefined do
		(
			deletekeys Objeto
			Objeto.dir = [0,0,1]
			
			addStretch Objeto "stretchSaltos"
			
			--Valores de inicio y final
			inicio = spinnerIniciotiempo.value
			fin = spinnerFinalTiempo.value+inicio
			
			animate on
			(
				at time 0 ( 
					Objeto.pos = objs[1].pos
					Objeto.modifiers[#stretchSaltos].Stretch = stretchImpacto.value --Valor del Stretch al impactar
				)
			)
			
			intervalo = (fin-inicio)/(objs.count-1) as integer
			fin = inicio + intervalo
			
			for i=1 to (objs.count-1) do (
				pMedio = puntoMedio objs[i].pos objs[i+1].pos
				pMedio.z = pMedio.z + (distancia objs[i].pos objs[i+1].pos)

				--Se anima el objeto
				Animar Objeto objs[i].pos pMedio objs[i+1].pos \
					stretchAterrizaje.value stretchImpacto.value stretchSalto.value \ --Valores de los Stretch
					anguloAterrizaje.value anguloDespegue.value \
					inicio fin
				
				inicio = fin
				fin = inicio+intervalo
			)
			
			Objeto.showtrajectory = on --Mostrar la trayectoria del objeto
		)
    )
)

--Mostrar la interfaz con formato
createDialog Saltos width:325 height:370 lockHeight:false lockWidth:false \
	style:#(#style_titlebar, #style_border, #style_sysmenu, \
		#style_minimizebox, #style_maximizebox, #style_resizing) 

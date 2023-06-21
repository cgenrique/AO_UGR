--Creación de una caja.
caja = box()
caja2 = Box()
Box pos: [0,0,0]

--Modificación de propiedades.
caja.width = 30.0
caja.length = 10
caja.height = 50

showProperties(caja)

--Creación de una esfera.
esfera = Sphere()

--Modificamos propiedades.
esfera.radius = 10
esfera.segments = 10
esfera.smooth = off

--Todo en una línea.
esfera = sphere radius:10 segments:10 smooth:off

--Sentencia larga.
toro radius1:10 pos:[0, 0, 20] wirecolor :[225, 230,100]

--Sentencia partida en varias líneas.
torus radius1:10 \
	pos :[0, 0, 20]  \
	wirecolor :[225, 230,
	
--Asignación de variables.
x = 5 /* Entero.*/
y = 7.0 /* Flotante.*/

--Operaciones aritméticas.
z = x * y x

--Cadenas.
mensaje = "Error en la altura."
messageBox mensaje

--Booleanos.
b = true
b = false
b = on
b = off


--ANIMACIONES--
--Creamos una esfera.
p = Sphere radius:10 wireColor:blue

--Creamos una animación.
animate on (
	at time 0 p.pos = [-100, 0, 0]
	at time 100 p.pos = [100, 0,0]
)

--Variable que indica el número de pasos del bucle.
n_pasos = 10

--Creamos una animación.
animate on for t in 0 to 100 by n_pasos do(
	at time t p.pos = [-100 + t, 0, 0]
)

--Eliminacion claves
deleteKeys (p)

--Longitud de la animación
animationRange = interval 42f 1024f)

--Aleatoriedad
--Podemos crear números aleatorios con la función random
--Creamos una animación.
animate on for t in 0 to 100 by n_pasos do(
	--Creamos un aleatorio.
	aleatorio = random 0 50
	at time t p.pos = [-100 + t, 0 , aleatorio]
)

--Para dos o más coordenadas.
--Creamos un aleatorio en cada posición.
animate on for t in 0 to 100 by n_pasos do(
	--Creamos un aleatorio.
	aleatorio = random 0 50
	at time t p.pos = random [0, 0, 0] [100, 100,100]
)


/*INTERPORLACION LINEAL*/
fn interpolacion obj pIni pFin = (
	--Creamos el vector de dirección.
	v1 = pFin - pIni

	pFin
	pIni
	--Creamos la animación.
	animate on (
		for t in 0 to 100 by 1 do (
			at time t (
				--Establecemos el objeto en una de las partes del segmento.
				obj.pos = pIni + (( normalize v1) * ((( length v1) / 100) * t) )
			)
		)
	)
)

/*RESTRICCIONES*/
--Se pueden crear controladores de restricción de movimiento:
--Por ejemplo de de posición: Position_Constraint
controlador = Position_Constraint ()
hijo.pos.controller = controlador /* Asignamos la restricción.*/
interfaz = controlador.constraints /* Puntero a las restricciones.*/
interfaz.appendTarget $Sphere001 20.0 /* Asinamos el objetivo. */
hijo.pos.controller.relative = on /* Indicamos que sea se mantenga el*/
	
/*MODIFICADORES*/
--Tetera.
objeto = Teapot radius:10

--Añadimos el modificador y el ratio.
addModifier objeto ( Stretch ())
objeto.modifiers [Stretch].Stretch = 0.5
objeto.modifiers [Stretch].Stretch = 0
objeto.modifiers [Stretch].Stretch = -0.5
	
animate on (
    for t in 0 to 100 by 10 do (
		at time 0 objeto.pos = [-100, 0, 0]
		at time 100 objeto.pos = [100, 0,0]
        at time t (
			aleatorio = random 0 100
            -- Cambiamos el valor de Stretch según el tiempo actual
            if aleatorio < 34 then objeto.modifiers[Stretch].Stretch = 0.5
            else if aleatorio < 67 then objeto.modifiers[Stretch].Stretch = 0
            else objeto.modifiers[Stretch].Stretch = -0.5
        )
    )
)

deleteKeys(objeto)

animate on (
     for t in 0 to 100 do (
       at time (t * 0.1) (  -- Ajustamos el tiempo multiplicando por 0.1
            -- Cambiamos el valor de Stretch según el tiempo actual
            if t < 34 then objeto.modifiers[Stretch].Stretch = 0.5
            else if t < 67 then objeto.modifiers[Stretch].Stretch = 0
            else objeto.modifiers[Stretch].Stretch = -0.5
        )
    )
)

/*INTERFACES*/
--Etiquetas
rollout salto "salto" (
	--Actor.
	label etiquetaActor "Actor:"
		
	--Plataformas.
	label etiquetaP1 "Plataforma 1:"
	label etiquetaP2 "Plataforma 2:"

	--Botón para crear la animación final.
	button boton_crear "Crear"
)

--Pickbutton
rollout salto "salto" (
	--Actor.
	label etiquetaActor "Actor:"
	pickbutton boton_actor "Selecciona actor"
		
	--Plataformas.
	label etiquetaP1 "Plataforma 1:"
	pickbutton boton_P1 "Selecciona plataforma1"
	label etiquetaP2 "Plataforma 2:"
	pickbutton boton_P2 "Selecciona plataforma2"
	button boton_crear "Crear"
	
	--Botón del actor.
	on boton_actor picked objeto do (
		--Creamos una variable global para almacenar el objeto que hemos seleccionado.
		global actor = objeto
		--Cambiamos el texto del botón a modo de feedback.
		boton_actor.text = objeto.name
	)
	
	--Botón del actor.
	on boton_P1 picked objetoP1 do (
		--Creamos una variable global para almacenar el objeto que hemos seleccionado.
		global P1 = objetoP1
		--Cambiamos el texto del botón a modo de feedback.
		boton_P1.text = objetoP1.name
	)
	
	--Botón del actor.
	on boton_P2 picked objetoP2 do (
		--Creamos una variable global para almacenar el objeto que hemos seleccionado.
		global P2 = objetoP2
		--Cambiamos el texto del botón a modo de feedback.
		boton_P2.text = objetoP2.name
	)
	
	--Botón final.
	on boton_crear pressed do (
		--Comprobamos que hemos elegido actor.
		if actor != undefined do (
			messageBox "Creado!"
		)
	)
)

createDialog salto 200 200

/*SPINNER*/
rollout mover "mover" (
	--Spinner con mínimo 0, máximo 100 y valor por defecto 0.
	spinner boton_x "X" range: [0, 100, 0] type:#Integer
	spinner boton_y "Y" range: [5, 100, 20] type:#Integer

	--Botón de aplicación.
	button boton_aplicar "Aplicar"
	
	on boton_aplicar pressed do (
		$Teapot001.pos = [boton_x.value , boton_y.value , 0]
	)
)
createDialog mover 200 200

/*LISTBOX*/
rollout saltos "saltos" (
	global objetos = #()
	--Agrupación de botones para el actor y los puntos donde va a saltar.
	group "Actor y puntos"(
		--Lista de objetos donde saltará.
		label l_saltos "Objetos a saltar:"
		listbox lista_saltos
	
		--Añadir objeto.
		pickbutton b_add "Añadir objeto"
	)
	--Configuración de los botones.
	on b_add picked obj do (
		--Lo guardamos en la variable global.
		append objetos obj
		--Lo metemos en la lista de la interfaz.
		lista_saltos.items = append lista_saltos.items (obj.name as string)
	)
)
createDialog saltos 200 200


/*Interpolacion Lineal*/
rollout salto "salto" (
	--Actor.
	label etiquetaActor "Actor:"
	pickbutton boton_actor "Selecciona actor"
		
	--Plataformas.
	label etiquetaP1 "Plataforma 1:"
	pickbutton boton_P1 "Selecciona plataforma1"
	label etiquetaP2 "Plataforma 2:"
	pickbutton boton_P2 "Selecciona plataforma2"
	button boton_crear "Crear"
	
	-- Variables globales para almacenar las posiciones
	global posInicial
	global posFinal
	
	--Botón del actor.
	on boton_actor picked objeto do (
		--Creamos una variable global para almacenar el objeto que hemos seleccionado.
		global actor = objeto
		--Cambiamos el texto del botón a modo de feedback.
		boton_actor.text = objeto.name
	)
	
	--Botón de la plataforma 1.
	on boton_P1 picked objetoP1 do (
		--Creamos una variable global para almacenar el objeto que hemos seleccionado.
		global P1 = objetoP1
		--Cambiamos el texto del botón a modo de feedback.
		boton_P1.text = objetoP1.name
	)
	
	--Botón de la plataforma 2.
	on boton_P2 picked objetoP2 do (
		--Creamos una variable global para almacenar el objeto que hemos seleccionado.
		global P2 = objetoP2
		--Cambiamos el texto del botón a modo de feedback.
		boton_P2.text = objetoP2.name
	)
	
	--Botón final.
	on boton_crear pressed do (
		--Comprobamos que hemos elegido actor y plataformas.
		if isProperty #actor undefined or isProperty #P1 undefined or isProperty #P2 undefined then
		(
			messageBox "Debes seleccionar el actor y las plataformas."
		)
		else
		(
			-- Eliminar las claves existentes del objeto
			deleteKeys(actor)
			
			-- Obtener las posiciones iniciales y finales
			posInicial = P1.position
			posFinal = P2.position
			
			-- Asegurarse de que el objeto esté posicionado verticalmente
			actor.transform = matrix3 [1,0,0] [0,1,0] [0,0,1] [(posInicial.x + posFinal.x) / 2, (posInicial.y + posFinal.y) / 2, posInicial.z]
			
			-- Crear la interpolación lineal
			keys = #()
			append keys (at time 0 posInicial)
			append keys (at time 100 posFinal)
			linearKeys actor.position.controller[1] keys
			
			messageBox "Creado!"
		)
	)
)

createDialog salto 200 200

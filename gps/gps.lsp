
  ;;
  ;; genera las distancias iniciales para cada vertice
  ;; esto es CERO para el vertice origen, e infinito para los demas
  ;;
  (defun generar_distancias (vertices origen)
    (if (null vertices)
      '()
      (cons 
        (if (eq (car vertices) origen) 0 100000) 
        (generar_distancias (cdr vertices) origen)
      )
    )
  )

  ;;
  ;; obtiene una lista de vecinos A los que se puede llegar
  ;; en un solo paso desde de un determinado vertice
  ;; dadas las aristas
  ;;
  (defun vecinos (vertice aristas)
    (if (null aristas)
      nil
      (if
        (eq (caar aristas) vertice)
        (cons
          (cadar aristas)
          (vecinos vertice (cdr aristas))
        )
        (vecinos vertice (cdr aristas))
      )
    )
  )

  ;;
  ;; obtiene una lista de vecinos DE los que se puede llegar
  ;; en un solo paso desde de un determinado vertice
  ;; dadas las aristas
  ;;
  (defun vecinos_r (vertice aristas)
    (if (null aristas)
      nil
      (if
        (eq (cadar aristas) vertice)
        (cons
          (caar aristas)
          (vecinos_r vertice (cdr aristas))
        )
        (vecinos_r vertice (cdr aristas))
      )
    )
  )

  ;;
  ;; obtiene la distancia de un determinado vertice
  ;; de la lista de distancias
  ;;
  (defun obtener_distancia (vertices distancias v)
    (if 
      (null distancias)
      nil
      (if 
        (eq (car vertices) v)
        (car distancias)
        (obtener_distancia (cdr vertices) (cdr distancias) v)
      )    
    )
  )

  ;;
  ;; para una lista de vertices y distancias
  ;; crea una nueva lista de distancias en la cual el vertice v
  ;; tiene la distancia dist y los demas vertices mantiene la misma
  ;; distancia
  ;;
  (defun asignar_distancia (vertices distancias v dist)
    (if 
      (null distancias)
      '()
      (cons
        (if 
          (eq (car vertices) v)
          dist
          (car distancias)
        )
        (asignar_distancia
          (cdr vertices)
          (cdr distancias)
          v
          dist
        )
      )    
    )
  )

  ;;
  ;; aplica el algoritmo de dijkstra realizando lo siguiente:
  ;;
  ;; Para un grafo determinado por vertices, aristas, 
  ;; Para una lista de distancias actuales, una lista de vertices mercados y
  ;; una lista de vecinos v del "vertice actual" con una distancia_actual
  ;; (la distancia actual del vertice seleccionado)
  ;;
  ;; Si la lista de vecinos esta vacia, vuelve a llamar dijkstra con esos parametros
  ;; En caso contrario, para cada vecino verifica si la distancia_actual+1 es menor
  ;; que la distancia registrada, si es asi asigna la distancia y se llama recursivamente
  ;; agregando el vertice que modifico como marcados, en caso contrario
  ;; no hace nada y evalua al proximo vecino.
  ;; Esta iteracion en los vecinos se hace con recursividad de marcar_vecinos, 
  ;; cuando se hace (cdr v) y continua hasta que la lista de vecinos este vacia
  ;;
  ;; cuando la lista de vecinos queda vacia, la lista de marcados tiene los
  ;; id de vertices a los cuales se les modifico la distancia
  ;;
  (defun marcar_vecinos (vertices aristas distancias marcados v distancia_actual)
    (if (null v)
      (dijkstra vertices aristas distancias marcados)
      (if 
        (< (+ distancia_actual 1) (obtener_distancia vertices distancias (car v)))
        (marcar_vecinos 
          vertices 
          aristas 
          (asignar_distancia vertices distancias (car v) (+ distancia_actual 1))
          (cons (car v) marcados)
          (cdr v)
          distancia_actual
        )
        (marcar_vecinos 
          vertices 
          aristas 
          distancias
          marcados
          (cdr v)
          distancia_actual
        )
      )
    )
  )

  ;;
  ;; ejecuta el algoritmo de dijkstra, recibe como parametro
  ;; los vertices y aristas que caracterizan al grafo las distancias iniciales y 
  ;; los vertices marcados inciales
  ;;
  ;; Devuelve la lista de distancias del camino minimo desde el origen hasta cada uno de los vertices
  ;;
  ;; Si no hay mas vertices marcados, el algoritmo termina devolviendo las distancias
  ;; que acumulo hasta ese momento
  ;;
  ;; En caso contrio, llama a marcar_vecinos pasandole los vecinos del primer vertice de la lista de marcados
  ;; y la distancia actual de este
  ;;
  (defun dijkstra (vertices aristas distancias marcados)
    (if (null marcados)
      distancias
      (marcar_vecinos vertices aristas distancias (cdr marcados) (vecinos (car marcados) aristas) (obtener_distancia vertices distancias (car marcados)))
    )
  )

  ;;
  ;; Devuelve el vertice de menor distancia de los que se encuentran en la lista v
  ;;
  (defun menor_distancia (vertices distancias v)
    (if (eq (length v) 1)
      (car v)
      (let
        (
          (md (menor_distancia vertices distancias (cdr v)))
          (da (obtener_distancia vertices distancias (car v)))
        )
        (if (< da (obtener_distancia vertices distancias md)) (car v) md)
      )
    )
  )

  ;;
  ;; Dada un grafo, una lista de distancias minimas al origen, un vertice origen y un vertice destino
  ;; construye una lista con el camino mas corto desde el vertice origen hacia el destino
  ;;
  (defun construir_camino (vertices aristas distancias origen destino)
    (if (eq origen destino)
      (list origen)
      (append
        (construir_camino
          vertices
          aristas
          distancias
          origen
          (menor_distancia vertices distancias (vecinos_r destino aristas))
        ) 
        (list destino)
      )
    )
  )

  ;;
  ;; A partir de un grafo definido por una lista de vertices y una lista de aristas
  ;; Para un vertice de origen, y un vertice de destino encuentra el camino mas corto
  ;; y lo devuelve como una lista de vertices que siguen el recorrido
  ;;
  ;; Para hacer esto, recurre primero a invocar la funcion dijkstra que encuentra
  ;; las distancias minimas de todos los vertices al origen y posteriormente
  ;; a la funcion construir_camino que utiliza esas distancias para contruir la lista
  ;; de vertices que siguen el recorrido mas corto
  ;;
  (defun camino_minimo (vertices aristas origen destino)
    (construir_camino
      vertices
      aristas
      (dijkstra vertices aristas (generar_distancias vertices origen) (list origen))
      origen
      destino
    )  
  )

  (defun tiene (expresion simbolo)
    (if (null expresion)
      nil
      (if (eq (car expresion) simbolo)
        T
        (tiene (cdr expresion) simbolo)
      )
    )
  )

  (defun planchar (grafo)
    (if (null grafo)
      '()
      (append
        (list (caar grafo))
        (cadar grafo)
        (planchar (cdr grafo))
      )
    )
  )

  (defun filtrar_repetidos (lista)
    (if (null lista)
      '()
      (let
        ((sublist (filtrar_repetidos (cdr lista))))
        (if (tiene sublist (car lista)) sublist (cons (car lista) sublist))
      )
    )
  )

  (defun obtener_vertices (grafo)
    (filtrar_repetidos (planchar grafo))
  )

  (defun obtener_aristas (grafo)
    (if (null grafo)
      '()
      (append
        (mapcar 
          (lambda (x) (list (caar grafo) x))
          (cadar grafo)
        )
        (obtener_aristas (cdr grafo))
      )
    )
  )

  (defun camino (grafo origen destino)
    (camino_minimo
      (obtener_vertices grafo)
      (obtener_aristas grafo)
      origen
      destino
    )
  )

  

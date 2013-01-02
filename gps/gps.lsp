(block
  (defun generar_distancias (vertices origen)
    (if (null vertices)
      '()
      (cons 
        (if (eq (car vertices) origen) 0 100000) 
        (generar_distancias (cdr vertices) origen)
      )
    )
  )

  (defun vecinos (vertice aristas)
    (if (null aristas)
      nil
      (if
        (eq (car (car aristas)) vertice)
        (cons
          (car (cdr (car aristas)))
          (vecinos vertice (cdr aristas))
        )
        (vecinos vertice (cdr aristas))
      )
    )
  )

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

  (defun dijkstra (vertices aristas distancias marcados)
    (if (null marcados)
      distancias
      (marcar_vecinos vertices aristas distancias (cdr marcados) (vecinos (car marcados) aristas) (obtener_distancia vertices distancias (car marcados)))
    )
  )

  (defun camino_minimo (vertices aristas origen destino)
    (dijkstra vertices aristas (generar_distancias vertices origen) (list origen))
  )
)
  

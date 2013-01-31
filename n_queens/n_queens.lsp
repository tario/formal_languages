;;; resuelve el problema de colocar N reinas en un tablero de NxN
;;; utilizando un algoritmo de backtracking
;;;
;;; Uso:
;;; (reinas N)
;;;
;;; para generar el tablero de NxN representado por una lista de listas de enteros
;;; que valen 1 si hay una reina en esa casilla y cero en caso contrario. El problema
;;; no tiene solucion para N=2 y N=3
;;;
;;; Explicacion del algoritmo:
;;;
;;; Se empieza siempre con el tablero vacio y en cada paso se prueba agregar
;;; una fila con una reina en una posicion (columna) determinada, si el nuevo 
;;; tablero cumple con las restricciones y la cantidad de filas necesarias (N)
;;; se alcanzo, se da por terminado el algoritmo
;;; si el nuevo tablero cumple las restricciones pero la cantidad de filas es
;;; menor que N, entonces se vuelve a probar agregando una nueva fila con otra reina
;;; si el nuevo tablero NO cumple las restricciones y la reina que se agrego no 
;;; era en la ultima columna, se vuelve a probar pero colocando la reina en la 
;;; siguiente columna
;;; si el nuevo tablero NO cumple las restricciones y la reina que se agrego era
;;; de la ultima columna, se retrocede a la fila anterior ya que se demostro
;;; que por ese camino no se puede llegar a la solucion

;;; genera una fila de longitud N con una reina en la posicion M
;;; Ejemplo (reina_en_linea 4 4) -> (0 0 0 1)
;;; Ejemplo (reina_en_linea 4 2) -> (0 1 0 0)
;;; Ejemplo (reina_en_linea 5 3) -> (0 0 1 0 0)
  (defun reina_en_linea (n m)
    (if (eq n 0)
      '()
      (cons
        (if (eq m 1) 1 0)
        (reina_en_linea (- n 1) (- m 1))
      )
    ) 
  )

;;; suma todos los numeros enteros en una lista. Ejemplo (sumatoria '(1 0 0 1)) -> 2
  (defun sumatoria (v)
    (if (null v)
      0
      (+ (car v) (sumatoria (cdr v)))
    )
  )

;;; devuelve T si el tablero es valido segun las columnas
;;; para esto efectua la sumatoria de la lista compuesta por los primeros
;;; elementos de todas las filas, si esta sumatoria es mayor que 1 el tablero
;;; se considera invalido, en caso contrario se verifica la proxima columna
;;; con un llamado recursivo

  (defun valido_columnas (tablero) 
    (if (null (car tablero))
      T
      (and 
        (< 
          (sumatoria 
            (mapcar 
              (lambda (x) 
                (or 
                  (if (listp x) (car x) 0) 
                  0
                ) 
              ) 
              tablero)
            ) 
          2
        ) 
        (valido_columnas (mapcar 'cdr tablero))
      )
    )
  )

  (defun despl_diagonal (tablero)
    (if (null tablero)
      tablero
      (cons 
        (car tablero) 
        (mapcar 'cdr (despl_diagonal (cdr tablero)))
      )
    )
  )
  
;;; verifica si el tablero es valido segun las diagonales que van hacia la derecha
;;; para esto rota cada fila del tablero tantas veces como indice de fila y luego
;;; valida las columnas de ese tablero
  (defun valido_diagonal_der (tablero)
    (if (null tablero)
      T    
      (and 
        (valido_columnas (despl_diagonal tablero))
        (valido_diagonal_der (cdr tablero))
      )
    )
  )

;;; espeja una lista. Ejemplo (mirror '(1 2 3)) -> (3 2 1)
  (defun mirror (v)
    (if (null v)
      v
      (append (mirror (cdr v)) (list (car v)))
    )
  )

;;; verifica si el tablero es valido segun las diagonales que van hacia la izquierda
;;; para esto espeja el tablero y utiliza la otra funcion para validar diagonales
  (defun valido_diagonal_izq (tablero)
    (valido_diagonal_der (mapcar 'mirror tablero))
  )

;;; devuelve T si el tablero es valido, NIL en caso contrario
;;; el tablero es valido si 
;;; 	no se repiten reinas en una columna
;;; 	no se repiten reinas en ninguna diagonal
  (defun valido (tablero)
    (and
      (and
        (valido_columnas tablero)
        (valido_diagonal_izq tablero)
      )
      (valido_diagonal_der tablero)
    )
  )

;;; funcion principal del algoritmo
;;; Parametros:
;;;
;;; n: ancho y alto del tablero
;;; tablero (opcional default '()): tablero parcial que debe completarse
;;; m (opcional default n): indice de columna en el que se debe probar
;;; agregar una reina primero para la proxima fila 
;;;
;;; Explicacion:
;;;		Si la cantidad de filas del tablero es N, entonces ese tablero es
;;;		La solucion
;;;
;;;		En caso contrario
;;;			Usando (reina_en_linea n m) se arma la nueva fila que se concatena
;;;			al tablero y se obtiene un tablero extendido.
;;;
;;;			Si el nuevo tablero es valido, se llama recursivamente a la 
;;;			funcion reinas con el nuevo tablero para que sea completado
;;;				Si este llamado recursivo devuelve NIL, significa que
;;;				no se puede llegar a la solucion por ese camino
;;;					Si M=1, es porque se han probado todas
;;;					las posibles columnas y ninguna resulto en un tablero
;;;					valido o camino posible, se devuelve NIL
;;;					En caso contrario se debe llamar resursivamente a reinas 
;;;					con el tablero original y m-1
;;;				En caso contrario, se devuelve lo mismo que devolvio el 
;;;				llamado recursivo
;;;
;;;			En caso contrario, si el tablero NO es valido
;;;				Si M=1, es porque se han probado todas
;;;				las posibles columnas y ninguna resulto en un tablero
;;;				valido o camino posible, se devuelve NIL
;;;				En caso contrario se debe llamar resursivamente a reinas 
;;;				con el tablero original y m-1
;;;
;;;

  (defun reinas (n &optional (tablero '()) (m nil)) 
    (if (eq (length tablero) n)
      tablero
	  (let ((tablero_nuevo (cons (reina_en_linea n (or m n)) tablero)))
        (if (valido tablero_nuevo)
          (or
            (reinas n tablero_nuevo n)
            (if (eq (or m n) 1)
              nil
              (reinas n tablero (- (or m n) 1))
            )
          )
          (if (eq (or m n) 1)
            nil
            (reinas n tablero (- (or m n) 1))
          )
        )
	  )
    )
  )

  


  (defun leer_memoria (simbolo mem)
    (if (null mem)
      nil
      (if (eq (caar mem) simbolo)
        (cadar mem)
        (leer_memoria simbolo (cdr mem))
      )
    )
  )

  (defun escribir_memoria (simbolo mem valor)
    (if (null mem)
      nil
      (if (eq (caar mem) simbolo)
        (cons (list simbolo valor) (cdr mem))
        (cons 
          (car mem) 
          (escribir_memoria simbolo (cdr mem) valor)
        )
      )
    )
  )

;;; devuelve verdadero si la lista expresion contiene un simbolo o nil
;;; en caso contrario
  (defun tiene (expresion simbolo)
    (if (null expresion)
      nil
      (if (eq (car expresion) simbolo)
        T
        (tiene (cdr expresion) simbolo)
      )
    )
  )

;;; evalua un arbol de operaciones que esta en un formato parecido a lisp
;;; lo usa la funcion evaluar_operaciones despues de procesar todos los
;;; operadores y operandos
  (defun evaluar_lisp (expresion mem)
    (if (listp expresion)
      (cond
        ((tiene '(+ - * /) (car expresion))
          (funcall (car expresion) (evaluar_lisp (cadr expresion) mem) (evaluar_lisp (caddr expresion) mem))
        )
        ((eq (car expresion) '==)
          (if (eq (evaluar_lisp (cadr expresion) mem) (evaluar_lisp (caddr expresion) mem)) 1 0)
        )
        ((eq (car expresion) '>)
          (if (> (evaluar_lisp (cadr expresion) mem) (evaluar_lisp (caddr expresion) mem)) 1 0)
        )
        ((eq (car expresion) '<)
          (if (< (evaluar_lisp (cadr expresion) mem) (evaluar_lisp (caddr expresion) mem)) 1 0)
        )
        (T (evaluar expresion mem))
      )
      (evaluar expresion mem)
    )
  )

;;; establece la prioridad de un operando
  (defun prioridad (operando)
    (cond
      ((eq operando '==) 1000)
      ((eq operando '<) 100)
      ((eq operando '>) 100)
      ((eq operando '*) 10)
      ((eq operando '+) 1)
      ((eq operando '/) 10)
      (T 1)
    )
  )

;;; evalua una expresion estilo C aplicando el algoritmo de 
;;; operadores y operandos y posteriormente evaluando el arbol
;;; obtenido mediante la funcion evaluar_lisp
  (defun evaluar_operaciones (operadores operandos expresion mem)
    (if (null expresion)
      (if (null operadores)
        (if (listp (car operandos))
          (evaluar_operaciones '() (car operandos) '() mem)
          (evaluar_lisp operandos mem)
        )
        (evaluar_operaciones (cdr operadores) (cons (list (car operadores) (cadr operandos) (car operandos)) (cddr operandos)) expresion mem)
      )
      (if (tiene '(+ - * / == < >) (car expresion))
        (if (null operadores)
          (evaluar_operaciones (cons (car expresion) operadores) operandos (cdr expresion) mem)
          (if (> (prioridad (car expresion)) (prioridad (car operadores)))
            (evaluar_operaciones (cons (car expresion) operadores) operandos (cdr expresion) mem)
            (evaluar_operaciones (cdr operadores) (cons (list (car operadores) (cadr operandos) (car operandos)) (cddr operandos)) expresion mem)
          )
        )
        (evaluar_operaciones operadores (cons (car expresion) operandos) (cdr expresion) mem)
      )
    )
  )

;;; evalua una expresion C, en un contexto de memoria dado
;;; si la expresion es un numero, el propio numero es el resultado
;;; si la expresion es una lista, se evalua como un grupo de operaciones
;;; con evaluar_operaciones
;;; en caso contrario, se la considera una variable y se utiliza
;;; leer_memoria para devolver el valor de la variable
  (defun evaluar (expresion mem)
    (cond
      ((numberp expresion) expresion)
      ((listp expresion)
        (cond
          ((tiene '(+ - * / == < >) (cadr expresion))
            (evaluar_operaciones '() '() expresion mem)
          )
          (T
            (evaluar (car expresion) mem)
          )
        )
      )
      (T (leer_memoria expresion mem))
    )
  )

;;; ejecuta una linea de codigo C y devuelve la salida que se genero
;;; maneja la logica del if y del while y ejecuta las funciones
;;; printf, scanf, --, ++, -=, += e = parseando y evaluando
;;; los argumentos mediante la funcion evaluar
  (defun ejecutar (expresion entrada mem &optional (salida '()))
    (if (null expresion)
      (reverse salida)
      (cond
        (
          (eq (caar expresion) 'printf)
          (ejecutar (cdr expresion) entrada mem (cons (evaluar (cadar expresion) mem) salida))
        )
        (
          (eq (caar expresion) 'scanf)
          (ejecutar (cdr expresion) (cdr entrada) (escribir_memoria (cadar expresion) mem (car entrada)) salida)
        )
        (
          (eq (cadar expresion) '--)
          (ejecutar (cdr expresion) entrada (escribir_memoria (caar expresion) mem (- (leer_memoria (caar expresion) mem) 1)) salida)
        )
        (
          (eq (cadar expresion) '++)
          (ejecutar (cdr expresion) entrada (escribir_memoria (caar expresion) mem (+ (leer_memoria (caar expresion) mem) 1)) salida)
        )
        (
          (eq (cadar expresion) '-=)
          (ejecutar (cdr expresion) entrada 
              (escribir_memoria (caar expresion) mem (- (leer_memoria (caar expresion) mem)
                (evaluar (cddar expresion))
                )) 
              salida)
        )
        (
          (eq (cadar expresion) '+=)
          (ejecutar (cdr expresion) entrada 
              (escribir_memoria (caar expresion) mem (+ (leer_memoria (caar expresion) mem) 
                (evaluar (cddar expresion))
                )) 
              salida)
        )
        (
          (eq (cadar expresion) '=)
          (ejecutar (cdr expresion) entrada (escribir_memoria (caar expresion) mem (evaluar (cddar expresion) mem)) salida)
        )
        (
          (eq (caar expresion) 'if)
          (if
            (eq (evaluar (car (cadar expresion)) mem) 0)
            (if (eq (cadr (cddar expresion)) 'else)
              (ejecutar (append (caddr (cddar expresion)) (cdr expresion)) entrada mem salida)
              (ejecutar (cdr expresion) entrada mem salida)
            )
            (ejecutar (append (car (cddar expresion)) (cdr expresion)) entrada mem salida)
          )
        )
        (
          (eq (caar expresion) 'while)
          (if
            (eq (evaluar (car (cadar expresion)) mem) 0)
            (ejecutar (cdr expresion) entrada mem salida)
            (ejecutar (append (car (cddar expresion)) expresion) entrada mem salida)
          )
        )
        (
          T
          (ejecutar (cdr expresion) entrada mem salida)
        )
      )
    )
  )

;;; Analiza una declaracion de variables para obtener la lista de variables
;;; y sus respectivos valores iniciales (si no se declara con valor inicial, se toma nil)
  (defun declaracion (variable_list)
    (if (eq (car variable_list) 'int)
      (declaracion (cdr variable_list))
      (if (null variable_list)
        '()
        (if (eq (cadr variable_list) '=)
          (cons (list (car variable_list) (caddr variable_list)) (declaracion (cdddr variable_list)))
          (cons (list (car variable_list) nil) (declaracion (cdr variable_list)))
        )
      )
    )
  )

;;; ejecuta el programa, una lista de declaraciones y al final el main
;;;
;;; Argumentos:
;;;		prog: programa
;;;		entrada: una lista con los valores de entrada que leera scanf
;;;		mem: una lista de pares clave valor con las variables y sus valores
;;; 
;;; Cuando se ejecuta, si lo primero que encuentra es el main, 
;;; llama a la funcion "ejecutar" con el codigo del programa dentro
;;; de ese main
;;; Si lo primero que encuentra no es el main, significa que es una
;;; declaracion de variables, entonces llama recursivamente a run para que
;;; ejecute el resto del programa, pero se le agrega a la memoria
;;; el valor inicial de las variables declaradas, obteniadas mediante
;;; la funcion declaracion definida mas arriba
  (defun run (prog &optional (entrada '()) (mem '()))
    (if (null prog) nil
      (if (eq (caar prog) 'main)
        (ejecutar (cadar prog) entrada mem)
        (run (cdr prog) entrada (append (declaracion (car prog)) mem))
      )
    )
  )

;;; el entorno se representa como una lista de listas de dos elementos
;;; (nombre de la variable y valor). Ejemplo:
;;; ((a 4) (b 5)) indica que hay solo dos variables, a que vale 4 y
;;; b que vale 5
;;;
;;; La funcion buscar_entorno devuelve el valor de una variable
;;; para un determinado entorno.
;;; Ejemplo:
;;; 	(buscar_entorno '((a 4) (b 5)) a) -> 4
;;; 	(buscar_entorno '((a 4) (b 5)) b) -> 5
;;; 	(buscar_entorno '((a 4) (b 5)) z) -> nil
  (defun buscar_entorno (entorno variable)
    (if (null entorno)
      nil
      (if (eq variable (caar entorno))
        (cadr (car entorno))
        (buscar_entorno (cdr entorno) variable)
      )
    )
  )

;;; ejecuta una funcion, o estructura de lisp
;;; argumentos:
;;;
;;;		func: nombre de la funcion
;;;		argumentos: lista de argumentos de la funcion, en lisp
;;;		entorno:	entorno con las variables y sus valores
;;;
;;; Para ejecutar la funcion, recurre a la funcion de lisp 'apply'
;;; y a la evaluacion recursiva como lisp de los argumentos
;;; De esta manera, algo como esto:
;;;
;;; (ejecutar_funcion 'car '((cdr '(1 2 3))) '())
;;;
;;; funcionara como se espera
;;;
;;; Como excepcion, se cuenta con la estructura de control 'if, en la cual no 
;;; se evaluan todos los argumentos, solo se evalua el primero, si este retorna T
;;; se evalua el segundo, en caso contrario el tercero, emulando la funcionalidad
;;; del IF real de lisp
;;;
;;; La "funcion" let es una excepcion de manera similar, lo que hace es agregar
;;; las variables al entorno al evaluar como lisp el cadr de los argumentos

  (defun ejecutar_funcion (func argumentos entorno)
    (cond
      ((eq func 'let)
        (lisp 
          (cadr argumentos) 
          (append 
            (mapcar
              (lambda (a) 
                (list 
                  (car a) 
                  (lisp (cadr a) entorno)
                )
              )
              (car argumentos)
            )
            entorno
          )
        )
      )
      ((eq func 'if) 
        (if 
          (lisp (car argumentos) entorno)
          (lisp (cadr argumentos) entorno)
          (lisp (caddr argumentos) entorno) 
        )
      )
      (T (apply func (mapcar (lambda (a) (lisp a entorno) ) argumentos)))
    )
  )
;;;
;;; La funcion principal lisp, recibe como parametro el codigo lisp y el entorno opcional
;;; cuyo valor por defecto es una lista nula
;;;
;;; De acuerdo el tipo de variable que sea el codigo, se aplican las reglas
;;; Por ej, si es un numero, un nil o un T se devuelve como tal, si es un
;;; un simbolo se interpreta como referencia a variable y se devuelve el
;;; valor correspondiente, si es una lista se interpreta como llamado a funcion, etc...
  (defun lisp (code &optional (entorno '()))
    (cond
      ((numberp code) code)
      ((null code) nil)
      ((eq code 'T) T)
      ((symbolp code) (buscar_entorno entorno code))
      ((eq (car code) 'quote) (cadr code) ) 
      (T (ejecutar_funcion (car code) (cdr code) entorno))
    )
  )

  

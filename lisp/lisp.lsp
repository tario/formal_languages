(block

  (defun ejecutar_funcion (func argumentos)
    (cond
      ((eq func 'if) 
        (if 
          (lisp (car argumentos))
          (lisp (car (cdr argumentos)))
          (lisp (car (cdr (cdr argumentos)))) 
        )
      )
      (T (apply func argumentos))
    )
  )
 

  (defun lisp (code)
    (cond 
      ((symbolp code) code)
      ((atom code) code)
      ((null code) nil)
      (T (ejecutar_funcion (car code) (cdr code)))
    )
  )
)
  

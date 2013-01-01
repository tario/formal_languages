(block

  (defun ejecutar_funcion (func argumentos)
    (cond
      ((eq func 'car) (car (car argumentos)))
      ((eq func 'cdr) (cdr (car argumentos)))
      (T nil)
    )
  )

  (defun lisp (code)
    (ejecutar_funcion
      (car code)
      (cdr code)
    )
  )
)
  

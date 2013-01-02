(block
  (defun ejecutar_funcion (func argumentos)
    (cond
      ((eq func 'let)
        5
      )
      ((eq func 'if) 
        (if 
          (lisp (car argumentos))
          (lisp (car (cdr argumentos)))
          (lisp (car (cdr (cdr argumentos)))) 
        )
      )
      (T (apply func (mapcar 'lisp argumentos)))
    )
  )

  (defun lisp_i (code entorno)
    (cond
      ((symbolp code) code)
      ((numberp code) code)
      ((null code) nil)
      ((atom code) (buscar_entorno code))
      ((eq (car code) 'quote) (car (cdr code)) ) 
      (T (ejecutar_funcion (car code) (cdr code)))
    )
  )

  (defun lisp (code)
    (lisp_i code '())
  )
)
  

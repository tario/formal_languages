(block
  (defun buscar_entorno (entorno variable)
    (if (null entorno)
      nil
      (if (eq variable (car (car entorno)))
        (car (cdr (car entorno)))
        (buscar_entorno (cdr entorno) variable)
      )
    )
  )

  (defun ejecutar_funcion (func argumentos entorno)
    (cond
      ((eq func 'let)
        (lisp_i (car (cdr argumentos)) (append (car argumentos) entorno))
      )
      ((eq func 'if) 
        (if 
          (lisp_i (car argumentos) entorno)
          (lisp_i (car (cdr argumentos)) entorno)
          (lisp_i (car (cdr (cdr argumentos))) entorno) 
        )
      )
      (T (apply func (mapcar 'lisp argumentos)))
    )
  )

  (defun lisp_i (code entorno)
    (cond
      ((numberp code) code)
      ((null code) nil)
      ((eq code 'T) T)
      ((symbolp code) (buscar_entorno entorno code))
      ((eq (car code) 'quote) (car (cdr code)) ) 
      (T (ejecutar_funcion (car code) (cdr code) entorno))
    )
  )

  (defun lisp (code)
    (lisp_i code '())
  )
)
  

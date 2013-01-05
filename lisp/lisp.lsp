
  (defun buscar_entorno (entorno variable)
    (if (null entorno)
      nil
      (if (eq variable (caar entorno))
        (cadr (car entorno))
        (buscar_entorno (cdr entorno) variable)
      )
    )
  )

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

  

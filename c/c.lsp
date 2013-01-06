
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

  (defun leer_memoria (simbolo mem)
    (if (null mem)
      nil
      (if (eq (caar mem) simbolo)
        (cadar mem)
        (leer_memoria simbolo (cdr mem))
      )
    )
  )

  (defun evaluar (expresion mem)
    (cond
      ((numberp expresion) expresion)
      (T (leer_memoria expresion mem))
    )
  )

  (defun ejecutar (expresion mem &optional (salida '()))
    (if (null expresion)
      (reverse salida)
      (cond
        (
          (eq (caar expresion) 'printf)
          (ejecutar (cdr expresion) mem (cons (evaluar (cadar expresion) mem) salida))
        )
        (
          T
          (ejecutar (cdr expresion) mem salida)
        )
      )
    )
  )

  (defun run (prog &optional (mem '()))
    (if (null prog) nil
      (if (eq (caar prog) 'main)
        (ejecutar (cadar prog) mem)
        (run (cdr prog) (append (declaracion (car prog)) mem))
      )
    )
  )
  

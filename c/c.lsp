
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

  (defun evaluar (expresion mem)
    (cond
      ((numberp expresion) expresion)
      (T (leer_memoria expresion mem))
    )
  )

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
          (eq (caar expresion) 'if)
          (if
            (eq (evaluar (car (cadar expresion))) 0)
            (reverse salida)
            (ejecutar (car (cddar expresion)) entrada mem salida)
          )
        )

        (
          T
          (ejecutar (cdr expresion) mem salida)
        )
      )
    )
  )

  (defun run (prog &optional (entrada '()) (mem '()))
    (if (null prog) nil
      (if (eq (caar prog) 'main)
        (ejecutar (cadar prog) entrada mem)
        (run (cdr prog) entrada (append (declaracion (car prog)) mem))
      )
    )
  )
  


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

  (defun ejecutar (expresion)
    (list 5)
  )

  (defun run (prog &optional (mem nil))
    (if (null prog) nil
      (if (eq (caar prog) 'main)
        (ejecutar (cadr prog))
        (run (cdr prog) mem)
      )
    )
  )
  


  (defun declaracion (variable_list)
    (if (eq (car variable_list) 'int)
      (declaracion (cdr variable_list))
      (if (null variable_list)
        '()
        (cons (list (car variable_list) nil) (declaracion (cdr variable_list)))
      )
    )
  )

  

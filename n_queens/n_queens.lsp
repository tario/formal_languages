(block
  (defun reina_en_linea (n m)
    (if (eq n 0)
      '()
      (cons
        (if (eq m 1) 1 0)
        (reina_en_linea (- n 1) (- m 1))
      )
    ) 
  )

  (defun sumatoria (v)
    (if (null v)
      0
      (+ (car v) (sumatoria (cdr v)))
    )
  )

  (defun valido_columnas (tablero) 
    (if (null (car tablero))
      T
      (and 
        (< (sumatoria (mapcar '(lambda (x) (or (car x) 0)) tablero)) 2) 
        (valido_columnas (mapcar 'cdr tablero))
      )
    )
  )

  (defun despl_diagonal (tablero)
    (if (null tablero)
      tablero
      (cons 
        (car tablero) 
        (mapcar 'cdr (despl_diagonal (cdr tablero)))
      )
    )
  )

  (defun valido_diagonal_der (tablero)
    (if (null tablero)
      T    
      (and 
        (valido_columnas (despl_diagonal tablero))
        (valido_diagonal_der (cdr tablero))
      )
    )
  )

  (defun mirror (v)
    (if (null v)
      v
      (append (mirror (cdr v)) (list (car v)))
    )
  )

  (defun valido_diagonal_izq (tablero)
    (valido_diagonal_der (mapcar 'mirror tablero))
  )

  (defun valido (tablero)
    (and
      (and
        (valido_columnas tablero)
        (valido_diagonal_izq tablero)
      )
      (valido_diagonal_der tablero)
    )
  )

  (defun reinas (n tablero m) 
    (if (eq (length tablero) n)
      tablero
      (if (valido (cons (reina_en_linea n m) tablero))
        (or
          (reinas n (cons (reina_en_linea n m) tablero) n)
          (if (eq m 1)
            nil
            (reinas n tablero (- m 1))
          )
        )
        (if (eq m 1)
          nil
          (reinas n tablero (- m 1))
        )
      )
    )
  )
)


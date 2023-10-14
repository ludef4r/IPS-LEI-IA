
; (entre-intervalo 5 '(0 10))

(defun entre-intervalo (x list)
  (cond ((eq 2 (length list))
	 (let ((m (reduce #'max list)) (n (reduce #'min list)))
	   (cond ((and (> x n) (< x m))      
		(format t "~d é maior que ~d e menor que ~d. ~C" x n m #\linefeed))
		(t (format t "~d não é um número entre ~d e ~d. ~C" x n m #\linefeed)))))
	(t (format t "A lista precisa de ter tamanho 2!!! ~C" #\linefeed))))



# ; (max-3 7 3 6)
(defun max-3(n1 n2 n3)
  (cond ((> n2 n1)
	 (setq n1 n2)))
  (cond ((> n3 n1)
	 (setq n1 n3)))
  n1
)

# ; (restop 10 5 0)
(defun restop(dividendo divisor resto)
  (cond ((eq divisor 0) NIL)
	(t (let ((compare (mod dividendo divisor)))
	      (cond ((eq compare resto) T)
		    (t NIL))))))

# ; (aprovadop '(13 15.6 5.5 7))
(defun aprovadop(list)
  (cond ((or (< 9.5 (first list)) (< 9.5 (fourth list))) NIL))
  (let ((media (/ (reduce #'+ list) 4)))
    (cond ((>= media 9.5) T)
	  (t NIL))))
	 

# ; (nota-final '(10 12 15) '(25 25 50))
(defun notas-validas (notas)
  (loop for x in notas
	do (cond ((and (>= x 0) (<= x 20)) T)
		 (t (format t "A nota ~d e invalida. ~C" x #\linefeed)
		    (return-from notas-validas NIL))))
  T)

(defun ponderacao-valida (pond)
  (cond ((equal 100 (reduce #'+ pond)) T)
	(t (format t "A soma das ponderacoes deve de ser igual a 100. ~C" #\linefeed))))

(defun aux-nota-final (notas pond index size)
  (cond ((>= index size) (return-from aux-nota-final 0))
	(t (return-from aux-nota-final
	     (+ (/ (* (nth index notas) (nth index pond)) 100)
		(aux-nota-final notas pond (+ 1 index) size))))))

(defun nota-final (notas pond)
  (cond ((= (length notas) (length pond))
	 (cond ((and (equal (notas-validas notas) T) (equal (ponderacao-valida pond) T))
		(aux-nota-final notas pond 0 (length notas)))
	       (t)))
	(t (format t "As listas tem tamanhos diferentes."))))

# ; (produto-somas '(1 2 3) '(2 2 2))

(defun aux-produto-somas (l1 l2 index size)
  (cond ((>= index size) (return-from aux-produto-somas 1))
	(t (return-from aux-produto-somas
	     (* (+ (nth index l1) (nth index l2)) (aux-produto-somas l1 l2 (+ 1 index) size))))))

(defun produto-somas (l1 l2)
  (cond ((= (length l1) (length l2)) (aux-produto-somas l1 l2 0 (length l1)))
	(t (format t "As listas tem tamanhos diferentes."))))

# ; (junta-listas-tamanho-igual '(1 3 4) '(5 3 2))

# ; (dois-ultimos-elementos '(1 2 3 4 5 6 7))

# ; (palindromop '(1 2 3 2 1))

# ; (criar-pares '(1 2 3) '(4 5 6))

# ; (verifica-pares '(1 2 3 4))

# ; (rodar '(1 2 3 4) 'esq)

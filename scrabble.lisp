(defun get-file (filename)
	(with-open-file (stream filename)
		(loop for line = (read-line stream nil)
			while line
			collect line)))

(defun get-dictionary ()
	(setf filename "dictionary.txt")
	(get-file filename))

#|
;; this would work if our program was compiled, not interpretted AND
;; if the compiler included a tail-recursive optimizer
(defun print-list (lst)
	(when (first lst)
	  (format t "~a~%" (first lst))
	  (print-list (rest lst))))
|#

;;instead, we have to do this
(defun print-list (lst)
  (loop for item in lst do
	(format t "~a~%" i)))


(defun main ()
	(print-list (get-dictionary)))

(main)

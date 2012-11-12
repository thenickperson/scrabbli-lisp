(defun get-file (filename)
	(with-open-file (stream filename)
		(loop for line = (read-line stream nil)
			while line
			collect line)))

(defun get-dictionary ()
	(setf filename "dictionary.txt")
	(get-file filename))

(defun print-list (lst)
	(if (car lst)
		(format t (car lst))
		(print-list (cdr lst))))

(defun main ()
	(print-list (get-dictionary)))

(main)

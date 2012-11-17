(defun get-file (filename)
	(with-open-file (stream filename)
		(loop for line = (read-line stream nil)
			while line
			collect line)))

(defun get-dictionary ()
	(setf filename "dictionary.txt")
	(get-file filename))

(defun print-list (lst)
	(loop for item in lst do
	(format t "~a~%" item)))

(defun main ()
	(print-list (get-dictionary)))

(main)

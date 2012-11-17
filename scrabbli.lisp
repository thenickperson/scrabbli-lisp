(defun get-dictionary ()
	(setf filename "dictionary.txt")
	(with-open-file (stream filename)
		(loop for line = (read-line stream nil)
			while line
			collect line)))

(defun print-list (lst)
	(loop for item in lst do
		(format t "~a~%" item)))

(defun get-word-score (str)
	(apply '+
		(loop for letter across str collect (1))))

(defun main ()
	(print-list (get-dictionary)))

(main)

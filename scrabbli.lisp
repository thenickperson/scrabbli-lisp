(defun get-dictionary ()
	(setf filename "dictionary.txt")
	(with-open-file (stream filename)
		(loop for line = (read-line stream nil)
			while line
			collect line)))

(defun print-list (lst)
	(loop for item in lst do
		(format t "~a~%" item)))

(defun string-in-list (str lst)
	(setf found nil)
	(loop for item in lst do
		(if (string= str item) (setf found t)))
	found)

(defun get-letter-score (letter)
	(cond
		((string-in-list letter '("E" "A" "I" "O" "N" "R" "T" "L" "S" "U")) 1)
		((string-in-list letter '("D" "G"))                                 2)
		((string-in-list letter '("B" "C" "M" "P"))                         3)
		((string-in-list letter '("F" "H" "V" "W" "Y"))                     4)
		((string-in-list letter '("K"))                                     5)
		((string-in-list letter '("J" "X"))                                 8)
		((string-in-list letter '("Q" "Z"))                                 10)
		(t 0)))

(defun get-word-score (str)
	(apply '+
		(loop for letter across str collect (get-letter-score letter))))

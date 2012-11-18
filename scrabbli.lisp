; Loads the anagram generator
(load "anagrams.lisp")

; Loads the English dictionary from dictionary.txt.
(defun get-dictionary ()
	(setf filename "dictionary.txt")
	(with-open-file (stream filename)
		(loop for line = (read-line stream nil)
			while line
			collect line)))

; Prints a list to standard out, separated by newlines.
(defun print-list (lst)
	(loop for item in lst do
		(format t "~a~%" item)))

; Checks if a string is an English word.
(defun is-word (str)
	(string-in-list str dictionary))

; Checks if a string exists in a list.
(defun string-in-list (str lst)
	(loop for item in lst do
		(if (equal str item) 
		    (return T))))

(defun find-valid-words (lst)
  (prune #'null (loop for str in lst collect
		    (if (is-word str) str))))

(defun prune (test tree) 
  (labels ((rec (tree acc) 
	     (cond ((null tree) (nreverse acc)) 
		   ((consp (car tree)) 
		    (rec (cdr tree) 
			 (cons (rec (car tree) nil) acc))) 
		   (t (rec (cdr tree) 
			   (if (funcall test (car tree)) 
			       acc 
			       (cons (car tree) acc))))))) (rec tree nil)))

; Gets the scrabble score for a single letter.
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

; Gets the scrabble score for an entire word.
(defun get-word-score (str)
	(apply '+
		(loop for letter across str collect (get-letter-score letter))))

; Save the dictionary so get-dictionary doesn't need to be called more than
; once.
(setf dictionary (get-dictionary))

(defun combn (list n)
	(cond ((< n 1) nil) ((= n 1) (mapcar #'list list))
		((null list) nil)
		(t (append (mapcar #'(lambda (subset) (cons (car list) subset)) (combn (cdr list) (1- n))) (combn (cdr list) n)))))


(defun subsetter (string)
	(setf lst (explode string))
	(loop for i from 1 to (length string) collect
		(combn lst i)))

(defun get-subset-strings (string)
	(setf lst (subsetter string))
	(flatten (loop for sublst in lst collect
		(loop for subberlst in sublst collect
			(join subberlst)))))

(defun anagrams-for-subsets (string)
	(flatten (loop for item in (get-subset-strings string) collect
		(anagrams item))))

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
  (setf count 0)
	(loop for item in lst do
		(if (equal str item) 
		    (return T))))

; Goes through a list and returns valid words
(defun find-valid-words (lst)
  (prune #'null (loop for str in lst collect
		    (if (is-word str) str))))

; Removes the test object from a list
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
		((string-in-list letter '("e" "a" "i" "o" "n" "r" "t" "l" "s" "u")) 1)
		((string-in-list letter '("d" "g"))                                 2)
		((string-in-list letter '("b" "c" "m" "p"))                         3)
		((string-in-list letter '("f" "h" "v" "w" "y"))                     4)
		((string-in-list letter '("k"))                                     5)
		((string-in-list letter '("j" "x"))                                 8)
		((string-in-list letter '("q" "z"))                                 10)
		(t 0)))

; Gets the scrabble score for an entire word.
(defun get-word-score (str)
	(apply '+
		(loop for letter across str collect (get-letter-score letter))))

; Save the dictionary so get-dictionary doesn't need to be called more than
; once.
(setf dictionary (get-dictionary))

; Gets a set of combinations using list that are n lengths long
(defun combn (list n)
	(cond ((< n 1) nil) ((= n 1) (mapcar #'list list))
		((null list) nil)
		(t (append (mapcar #'(lambda (subset) (cons (car list) subset)) (combn (cdr list) (1- n))) (combn (cdr list) n)))))

; gets all the subsets of a string, from 1 to the length of the string
(defun subsetter (string)
	(setf lst (explode string))
	(loop for i from 1 to (length string) collect
		(combn lst i)))

; emits a pretty list of our subsets, as a list of strings
(defun get-subset-strings (string)
	(setf lst (subsetter string))
	(flatten (loop for sublst in lst collect
		(loop for subberlst in sublst collect
			(join subberlst)))))

; fetches all the possible anagrams for all the subsets of a given string
(defun anagrams-for-subsets (string)
	(flatten (loop for item in (get-subset-strings string) collect
		(anagrams item))))

; fetches *valid* words by filtering anagrams using the dictionary
(defun get-valid-posibilities (string)
  (find-valid-words (anagrams-for-subsets string)))

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
	(setf found nil)
	(loop for item in lst do
		(if (string= str item) (setf found t)))
	found)

(defun find-valid-words (lst)
	(setf results '())
	(loop for str in lst do
		(setf results (append results '(str)))))

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

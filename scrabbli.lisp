(in-package :scrabbli)
; Loads the anagram generator


; Checks if a string exists in a list.
(defun string-in-list (str lst)
	(loop for item in lst do
		(if (equal str item) 
		    (return T))))

; Gets the scrabble score for a single letter.
(defun get-letter-score (letter)
	(cond
		((string-in-list letter '(#\e #\a #\i #\o #\n #\r #\t #\l #\s #\u)) 1)
		((string-in-list letter '(#\d #\g))                                 2)
		((string-in-list letter '(#\b #\c #\m #\p))                         3)
		((string-in-list letter '(#\f #\h #\v #\w #\y))                     4)
		((string-in-list letter '(#\k))                                     5)
		((string-in-list letter '(#\j #\x))                                 8)
		((string-in-list letter '(#\q #\z))                                 10)
		(t 0)))

; Gets the scrabble score for an entire word.
(defun get-word-score (str)
	(apply '+ (loop for letter across str collect (get-letter-score letter))))
#|
; first the best scoring word that can be made with a given string
(defun find-best-word (str)
  (setq best-word nil)
  (setq best-score 0)
  (loop for word in (get-words str) do
    (if (>= (get-word-score str) best-score) 
    	((setf best-word word) (setf best-score (get-word-score str)))))
  (format t "Best Word:~a Best Score:~a" best-word best-score))
|#	
(defun get-words (str)
	(anagrams::new-anagrams str))

;;(format t (find-best-word ["lisp"]))

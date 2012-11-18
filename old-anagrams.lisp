(in-package :scrabbli)
(defun range (start end)
    (if (> start end)
        (if (eql start end)
            (cons end nil)
            (cons start (range (- start 1) end)))        
        
        (if (eql start end)
            (cons end nil)
            (cons start (range (+ start 1) end)))))

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

; Goes through a list and returns valid words, with really fast comaprison.
(defun filter-valid-words (lst)
  (intersection lst dictionary :test 'equal))

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

; Save the dictionary so get-dictionary doesn't need to be called more than
; once.
(setf dictionary (get-dictionary))

; Gets a set of combinations using list that are n lengths long
(defun combn (list n)
  (cond
    ((< n 1) nil)
    ((= n 1) (mapcar #'list list))
    ((null list) nil)
    (t (append (mapcar #'(lambda (subset) (cons (car list) subset)) (combn (cdr list) (1- n))) (combn (cdr list) n)))))

; by Kate
; gets all the subsets of a string, from 1 to the length of the string
(defun substrings (string)
  (setf lst (explode string))
  (flatten (loop for sublst in (loop for i from 1 to (length string) collect (combn lst i)) collect
          (loop for subberlst in sublst collect
         (join subberlst)))))

; fetches all the possible words for all the subsets of a given string
(defun find-words (str)
  (filter-valid-words
    (flatten
      (loop for substring in (substrings str) collect
        (anagrams substring)))))

(defun write-to-file (content)
  (with-open-file (stream "output.txt" :direction :output)
  (format stream "~a~%" content)))

(defun explode (string)
  (mapcar #'(lambda (char) (string char))
    (coerce string 'list)))
;;or
(defun explode (string)
 (loop for letter across string collect letter))

(defun join (lst)
  (format nil "~{~A~}" lst))

(defun string-append (first last)
  (join (append (explode first) (explode last))))

(defun string-rest (string)
  (join (rest (explode string))))

(defun string-first (string)
  (first (explode string)))

(defun flatten (l)
  (cond ((null l) nil)
        ((atom l) (list l))
        (t (loop for a in l appending (flatten a)))))

(defun rotate-helper (lst)
  (append (last lst) (butlast lst)))

(defun rotate (lst n)
  "Move the last element to the front of the list."
  (loop for i from 1 to (- n 1) do
	(setf lst (rotate-helper lst)))
  (rotate-helper lst))

 (defun rotate-string (s n)
    (join (rotate (explode s) n))) 

(defun anagrams (string)
    (if (<= (length string) 1)
  (list string)
  (flatten 
   (map 'list #'(lambda (n) (aux (rotate-string string n))) (range 1 (length string))))))

(defun aux (remaining-string)
  (flatten 
   (map 'list  #'(lambda (x) (string-append (list (string-first remaining-string)) (list x))) (anagrams (string-rest remaining-string)))))

(defun main()
        (anagrams (read)))

(defun test(string)
        (time (anagrams string)))

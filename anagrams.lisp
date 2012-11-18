; File by Kate

(defun range (start end)
    (if (> start end)
        (if (eql start end)
            (cons end nil)
            (cons start (range (- start 1) end)))        
        
        (if (eql start end)
            (cons end nil)
            (cons start (range (+ start 1) end)))))

(defun explode (string)
  (mapcar #'(lambda (char) (string char))
    (coerce string 'list)))

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

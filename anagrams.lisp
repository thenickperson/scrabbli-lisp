(in-package :anagrams)

(defvar *dict*)
(defvar *verbose* nil)

(defun combine (these-words more-anagrams)
  (mapcan #'(lambda (word-to-prepend)
              (mapcar #'(lambda (phrase) 
                          (cons word-to-prepend phrase))
                      more-anagrams))
          these-words))

(defmacro while (test &rest body)
  `(do ()
       ((not ,test))
     ,@body))

(defun flatten (l)
  (cond ((null l) nil)
        ((atom l) (list l))
        (t (loop for a in l appending (flatten a)))))

(defun prune (bag dict)
  (remove-if
   #'(lambda (entry) (not (subtract-bags bag (car entry))))
   dict))

(defun get-dictionary ()
  (setf filename "dictionary.txt")
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
      while line
      collect line)))

(defun anagrams-internal (bag dict limit)
  (let ((rv ())
        (length 0))
    (while (and (or (not limit)
                    (> limit length))
                (not (null dict)))
      (let* ((entry (car dict))
             (this-bag (car entry))
             (these-words (cdr entry))
             (smaller-bag (subtract-bags bag this-bag)))
        (when smaller-bag
          (if (bag-emptyp smaller-bag)
              (let ((combined (mapcar #'list these-words)))
                (setf rv (nconc rv combined))
                (incf length (length combined)))
              (let ((more-anagrams (anagrams-internal smaller-bag (prune smaller-bag dict) limit)))
                (when more-anagrams
                  (let ((combined (combine these-words more-anagrams)))
                    (setf rv (nconc rv combined))
                    (incf length (length combined))))))))
      (setf dict (cdr dict)))
    rv))

(defun anagrams (string &optional limit)
  (let ((b  (bag string)))
    (init b)
    (let ((result (anagrams-internal b (prune b *dict*) limit)))
      (prog1 result
        (format *error-output* ";; ~a anagrams of ~a~%" (length result)
                string)))))

(defun new-anagrams (string)
    (let ((b (bag string)))
        (init b)
        (intersection (flatten (loop for item in (prune b *dict*) collect
            (rest item))) (get-dictionary) :test 'equal)
        ))
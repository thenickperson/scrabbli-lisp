;; -*- lisp -*-

;; How to use this file:

;; start ye your repl, and type ye into it:

;; (require 'asdf "/usr/local/lib/common-lisp/asdf/clispfasl/asdf.fasl")

;;                                 -- note that some Lisps already have
;;                                 asdf loaded, so this step might not
;;                                 be necessary -- but it won't hurt,
;;                                 either
;; (the path name is for FreeBSD; other systems don't seem to need it)
;;
;; (load "anagrams.asd")
;; (asdf:operate 'asdf:load-op 'anagrams)
;;
;; To test:
;; (anagrams::anagrams "Hemingway")
;; or, to time things:
;; (time (car (anagrams::anagrams "Ernest Hemingway")))

(defpackage anagrams
  (:use :common-lisp)
  (:export
    #:new-anagram))

(defpackage anagrams-system
  (:use :common-lisp :asdf))

(in-package :anagrams-system)

(defsystem "anagrams"
  :description "anagrams"
  :version "1"
  :author "Eric Hanchrow <offby1@blarg.net> Edited by: Katherine Whitlock"
  :licence "None -- don't use it"
  :components ((:file "numeric-bag")
               (:file "dict"
                      :depends-on ("numeric-bag"))
               (:file "anagrams"
                      :depends-on ("dict" "numeric-bag"))))
<<<<<<< HEAD
=======

(defpackage scrabbli-system
  (:use :common-lisp :asdf :anagrams))

(in-package :scrabbli-system)

(defsystem "scrabbli"
  :description "scrabbli"
  :version "1"
  :author "Nicolas McCurdy & Katherine Whitlock"
  :licence "MIT"
  :components ((:file "anagram")
               (:file "scrabbli"
                      :depends-on ("anagram" ""))))
>>>>>>> 29f0fd0c0c4464795124460355a4c3c6e390a757

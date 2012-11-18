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
;; (load "scrabbli.asd")
;; (asdf:operate 'asdf:load-op 'scrabbli)
;;
;; To test:
;; (scrabbli::find-words "hey")
;; or, to time things:
;; (time (scrabbli::find-words "hey"))

(defpackage scrabbli
  (:use :common-lisp))

(defpackage scrabbli-system
  (:use :common-lisp :asdf :anagrams))

(in-package :scrabbli-system)

(defsystem "scrabbli"
  :description "scrabbli"
  :version "1"
  :author "Nicolas McCurdy & Katherine Whitlock"
  :licence "MIT"
  :components ((:file "old-anagrams")
               (:file "scrabbli"
                      :depends-on ("old-anagrams"))))
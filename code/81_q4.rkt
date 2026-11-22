#lang racket/base

;; my-length : list → integer
;; Purpose  : counts the number of top-level elements in lst.
;; Args     : lst — any proper list (atoms, sublists, or empty).
;; Returns  : non-negative integer — the count of direct elements.
;; Recursion: (my-length lst) = 0 when lst is empty; otherwise 1 plus
;;            (my-length (cdr lst)).  Runs tail-recursively via an
;;            accumulator so it is safe for 10,000-element lists.
;; Note     : sublists count as exactly one element regardless of depth.
(define (my-length lst)
  (let loop ((l lst) (acc 0))
    (if (null? l)
        acc
        (loop (cdr l) (+ acc 1)))))

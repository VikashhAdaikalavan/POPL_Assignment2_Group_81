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

;; my-map : (any → any) list → list
;; Purpose  : applies f to every top-level element of lst and returns
;;            the results in the same order.
;; Args     : f   — a one-argument function.
;;            lst — any proper list (atoms, sublists, or empty).
;; Returns  : a new list of the same length, with f applied to each element.
;; Recursion: collects (f element) into an accumulator in reverse, then
;;            reverses the accumulator with a second named-let loop.
;;            Fully tail-recursive; safe for 10,000-element lists.
(define (my-map f lst)
  (let loop ((l lst) (acc '()))
    (if (null? l)
        (let rev ((r acc) (out '()))
          (if (null? r)
              out
              (rev (cdr r) (cons (car r) out))))
        (loop (cdr l) (cons (f (car l)) acc)))))

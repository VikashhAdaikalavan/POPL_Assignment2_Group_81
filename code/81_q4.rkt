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

;; make-inserter : any (integer → boolean) → ((nested list) → (nested list))
;; Purpose  : higher-order function that returns a list transformer.
;; Args     : x       — atom to conditionally insert.
;;            len-ok? — 1-argument predicate testing original list length.
;; Returns  : a function accepting a (nested) list that recursively inserts x
;;            at the front of every list whose original length satisfies len-ok?.
;; Recursion: letrec binds inserter so the returned function can recursively
;;            apply itself to sublists via my-map.
(define (make-inserter x len-ok?)
  (letrec ((inserter
            (lambda (lst)
              (let* ((orig-len (my-length lst))
                     (processed-elements
                      (my-map (lambda (elem)
                                (if (or (pair? elem) (null? elem))
                                    (inserter elem)
                                    elem))
                              lst)))
                (if (len-ok? orig-len)
                    (cons x processed-elements)
                    processed-elements)))))
    inserter))

;; insert-if-short : any (nested list) integer → (nested list)
;; Purpose  : inserts x at the front of every list (at all nesting levels)
;;            whose original top-level length is strictly less than n.
;; Args     : x   — atom to conditionally insert.
;;            lst — (nested) list.
;;            n   — non-negative integer threshold.
;; Returns  : modified nested list.
;; Implementation: defined directly via make-inserter with the predicate
;;                 (lambda (len) (< len n)). Exactly one definition in file.
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

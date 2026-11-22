#lang racket/base

;; =============================================================================
;; tests/q4_tests.rkt -- Test suite for S2: Conditionally Insert into a Nested List
;; CS F301 Principles of Programming Languages: Assignment 2 (Group 81)
;; =============================================================================

;; --- Definitions from code/81_q4.rkt ---

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

;; print-insert-result : → void
;; Purpose  : reads x, lst, and n from standard input in order, applies
;;            insert-if-short, and prints the result followed by a newline.
;; Args     : none.
;; Returns  : void.
;; Behavior : uses read to consume inputs sequentially, display to print the
;;            result without labels/prompts, and newline to terminate output.
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))

;; --- Test Fixtures & Runner (using only allowed built-ins) ---

;; Helper to print a tagged line using display and newline (no strings).
(define (show-line tag val)
  (begin
    (display (list tag val))
    (newline)))

;; 1. Unit tests for my-length
;; Expected: empty -> 0, singleton -> 1, flat -> 3, nested -> 4, mixed -> 4
(begin
  (show-line 'length-empty (my-length '()))
  (show-line 'length-singleton (my-length '(1)))
  (show-line 'length-flat (my-length '(1 2 3)))
  (show-line 'length-nested (my-length '((1 2) (3 4 5) (6) ())))
  (show-line 'length-mixed (my-length '(a (b c) () (d (e f))))))

;; 2. Unit tests for my-map
;; Expected: empty -> (), flat -> (2 4 6), nested -> ((0 1 2) (0 3) (0))
(begin
  (show-line 'map-empty (my-map (lambda (x) (* x 2)) '()))
  (show-line 'map-flat (my-map (lambda (x) (* x 2)) '(1 2 3)))
  (show-line 'map-nested (my-map (lambda (x) (cons 0 x)) '((1 2) (3) ()))))

;; 3. Unit tests for make-inserter with custom predicates
;; Expected inserter-empty: ((1) (EMPTY) (2 (EMPTY)))
;; Expected inserter-long:  (LONG (LONG 1 2) (3) (LONG 4 5 6))
(begin
  (show-line 'inserter-empty ((make-inserter 'EMPTY (lambda (l) (= l 0))) '((1) () (2 ()))))
  (show-line 'inserter-long ((make-inserter 'LONG (lambda (l) (> l 1))) '((1 2) (3) (4 5 6)))))

;; 4. Assignment S2 official examples
;; Example 1: 42 ((1 2) (3 4 5) (6) ()) 3 -> ((42 1 2) (3 4 5) (42 6) (42))
;; Example 2: 0 (((1) 2) (3) ((4 5 6) ())) 3 -> ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
;; Example 3: 7 () 3 -> (7)
;; Example 4: 7 () 0 -> ()
(begin
  (show-line 'example-1 (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))
  (show-line 'example-2 (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3))
  (show-line 'example-3 (insert-if-short 7 '() 3))
  (show-line 'example-4 (insert-if-short 7 '() 0)))

;; 5. Edge cases for insert-if-short
;; n = 0 on non-empty list: (1 (2) ())
;; n = 1: (1 (2) (99))
;; length exactly equal to n: (1 2 3)
;; length shorter than n: (5 1 2 3)
;; length longer than n: (1 2 3 4)
;; nested empty lists with n = 2: ((x) (x (x)) (x (x (x))))
;; mixed atoms and sublists: (a b (z c) d (e f))
;; list containing only atoms: (1 2 3 4)
(begin
  (show-line 'edge-n-zero (insert-if-short 99 '(1 (2) ()) 0))
  (show-line 'edge-n-one (insert-if-short 99 '(1 (2) ()) 1))
  (show-line 'edge-len-equal-n (insert-if-short 5 '(1 2 3) 3))
  (show-line 'edge-len-shorter-n (insert-if-short 5 '(1 2 3) 4))
  (show-line 'edge-len-longer-n (insert-if-short 5 '(1 2 3 4) 3))
  (show-line 'edge-nested-empty (insert-if-short 'x '(() (()) ((()))) 2))
  (show-line 'edge-mixed (insert-if-short 'z '(a b (c) d (e f)) 2))
  (show-line 'edge-only-atoms (insert-if-short 'a '(1 2 3 4) 2)))

;; 6. Deep nesting (depth 100)
(define (make-deep depth val)
  (if (= depth 0)
      val
      (list (make-deep (- depth 1) val))))

(begin
  (show-line 'deep-100-len (my-length (insert-if-short 'D (make-deep 100 'val) 2))))

;; 7. 10,000-element list (tail recursion verification)
(define (make-long n)
  (let loop ((k n) (acc '()))
    (if (= k 0)
        acc
        (loop (- k 1) (cons k acc)))))

(define long-list (make-long 10000))

(begin
  (show-line 'long-list-len (my-length long-list))
  (show-line 'long-list-map-len (my-length (my-map (lambda (x) (+ x 1)) long-list)))
  (show-line 'long-list-insert-len (my-length (insert-if-short 'X long-list 5))))

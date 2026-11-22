#lang racket/base

;; my-reverse: reverses a list using an accumulator.
;; Arguments: lst (list of any values), acc (list of any values).
;; Return type: list of any values.
;; Recursive reading: the reversed list for a non-empty lst is the reverse of
;; (cdr lst) with (car lst) pushed onto acc; for '(), it is acc.
(define (my-reverse lst acc)
  (if (null? lst)
      acc
      (my-reverse (cdr lst) (cons (car lst) acc))))

;; inorder: collects node values in left-root-right order.
;; Arguments: tree ('() or (value left right)).
;; Return type: list of values in inorder traversal order.
;; Recursive reading: the inorder list for a tree is the inorder sequence of
;; its left subtree, followed by its root value, followed by the inorder
;; sequence of its right subtree; for '(), it is '().
(define (inorder tree)
  (letrec ((step (lambda (t acc)
                   (if (null? t)
                       acc
                       (let* ((val (car t))
                              (left (cadr t))
                              (right (caddr t))
                              (acc-left (step left acc))
                              (acc-node (cons val acc-left)))
                         (step right acc-node))))))
    (my-reverse (step tree '()) '())))

;; preorder: collects node values in root-left-right order.
;; Arguments: tree ('() or (value left right)).
;; Return type: list of values in preorder traversal order.
;; Recursive reading: the preorder list for a tree is its root value, followed
;; by the preorder sequence of its left subtree, followed by the preorder
;; sequence of its right subtree; for '(), it is '().
(define (preorder tree)
  (letrec ((step (lambda (t acc)
                   (if (null? t)
                       acc
                       (let* ((val (car t))
                              (left (cadr t))
                              (right (caddr t))
                              (acc-node (cons val acc))
                              (acc-left (step left acc-node)))
                         (step right acc-left))))))
    (my-reverse (step tree '()) '())))

;; postorder: collects node values in left-right-root order.
;; Arguments: tree ('() or (value left right)).
;; Return type: list of values in postorder traversal order.
;; Recursive reading: the postorder list for a tree is obtained by prepending
;; the root value onto the accumulator, traversing the right subtree with that
;; accumulator, and then traversing the left subtree with the resulting
;; accumulator; for '(), it returns the accumulator ('() initially).
(define (postorder tree)
  (letrec ((step (lambda (t acc)
                   (if (null? t)
                       acc
                       (let* ((val (car t))
                              (left (cadr t))
                              (right (caddr t))
                              (acc-root (cons val acc))
                              (acc-right (step right acc-root)))
                         (step left acc-right))))))
    (step tree '())))

;; tree-height-and-leaves: computes the height and leaf count of a binary tree.
;; Arguments: tree ('() or (value left right)).
;; Return type: two-element list (list height leaf-count) of non-negative integers.
;; Recursive reading: the (height leaf-count) pair for a non-empty tree has
;; height 1 plus the max of the heights of its left and right subtrees, and
;; leaf count equal to the sum of the leaf counts of its left and right subtrees
;; (or 1 if both subtrees are '()); for '(), it is '(0 0).
(define (tree-height-and-leaves tree)
  (letrec ((step (lambda (t)
                   (if (null? t)
                       (list 0 0)
                       (let* ((left (cadr t))
                              (right (caddr t)))
                         (if (and (null? left) (null? right))
                             (list 1 1)
                             (let ((res-l (step left))
                                   (res-r (step right)))
                               (let ((h (+ 1 (max (car res-l) (car res-r))))
                                     (leaves (+ (cadr res-l) (cadr res-r))))
                                 (list h leaves)))))))))
    (step tree)))

;; print-inorder: prints the inorder traversal list of a binary tree on one line.
;; Arguments: tree ('() or (value left right)).
;; Return type: void (prints via display and newline).
;; Recursive reading: printing the inorder traversal for a tree displays the
;; list produced by (inorder tree) followed by a newline, delegating traversal
;; to the inorder helper with no extra state or top-level output.
(define (print-inorder tree)
  (begin
    (display (inorder tree))
    (newline)))

;; print-all-traversals: prints inorder, preorder, and postorder lists on three lines.
;; Arguments: tree ('() or (value left right)).
;; Return type: void (prints three lines via display and newline).
;; Recursive reading: printing all traversals for a tree displays (inorder tree)
;; on line 1, (preorder tree) on line 2, and (postorder tree) on line 3, each
;; terminated by newline, delegating traversal to the corresponding helpers.
(define (print-all-traversals tree)
  (begin
    (display (inorder tree))
    (newline)
    (display (preorder tree))
    (newline)
    (display (postorder tree))
    (newline)))

;; print-height-and-leaves: prints (height leaf-count) of a binary tree on one line.
;; Arguments: tree ('() or (value left right)).
;; Return type: void (prints via display and newline).
;; Recursive reading: printing the height and leaf count for a tree displays
;; the list produced by (tree-height-and-leaves tree) followed by a newline,
;; delegating computation to tree-height-and-leaves with no top-level output.
(define (print-height-and-leaves tree)
  (begin
    (display (tree-height-and-leaves tree))
    (newline)))

;; --- Test Fixtures & Runner (using only allowed built-ins) ---

;; Helper to print a tagged line using display and newline (no strings).
(define (show-line tag val)
  (begin
    (display (list tag val))
    (newline)))

;; Assignment S1 trees
(define spec-t1
  '(4 (2 (1 () ()) (3 () ()))
      (6 (5 () ()) (7 () ()))))
(define spec-t2
  '(1 () (2 () (3 () ()))))
(define spec-t3
  '(a (b () ()) (c () ())))

;; Additional edge-case trees
(define single-node '(42 () ()))
(define left-skewed '(4 (3 (2 (1 () ()) ()) ()) ()))

;; 1. Empty tree '()
;; Expected print-inorder: ()
;; Expected print-all-traversals: () / () / ()
;; Expected print-height-and-leaves: (0 0)
(begin
  (show-line 'empty-inorder (inorder '()))
  (show-line 'empty-preorder (preorder '()))
  (show-line 'empty-postorder (postorder '()))
  (show-line 'empty-hl (tree-height-and-leaves '()))
  (print-inorder '())
  (print-all-traversals '())
  (print-height-and-leaves '()))

;; 2. Assignment spec-t1: expected inorder (1 2 3 4 5 6 7),
;; preorder (4 2 1 3 6 5 7), postorder (1 3 2 5 7 6 4), hl (3 4)
(begin
  (show-line 'spec-t1-inorder (inorder spec-t1))
  (show-line 'spec-t1-preorder (preorder spec-t1))
  (show-line 'spec-t1-postorder (postorder spec-t1))
  (show-line 'spec-t1-hl (tree-height-and-leaves spec-t1))
  (print-inorder spec-t1)
  (print-all-traversals spec-t1)
  (print-height-and-leaves spec-t1))

;; 3. Assignment spec-t2: expected traversals (1 2 3), (1 2 3), (3 2 1); hl (3 1)
(begin
  (show-line 'spec-t2-inorder (inorder spec-t2))
  (show-line 'spec-t2-preorder (preorder spec-t2))
  (show-line 'spec-t2-postorder (postorder spec-t2))
  (show-line 'spec-t2-hl (tree-height-and-leaves spec-t2))
  (print-all-traversals spec-t2)
  (print-height-and-leaves spec-t2))

;; 4. Assignment spec-t3 (symbols): expected traversals (b a c), (a b c), (b c a); hl (2 2)
(begin
  (show-line 'spec-t3-inorder (inorder spec-t3))
  (show-line 'spec-t3-preorder (preorder spec-t3))
  (show-line 'spec-t3-postorder (postorder spec-t3))
  (show-line 'spec-t3-hl (tree-height-and-leaves spec-t3))
  (print-all-traversals spec-t3)
  (print-height-and-leaves spec-t3))

;; 5. Single node: expected traversals (42), (42), (42); hl (1 1)
(begin
  (print-inorder single-node)
  (print-all-traversals single-node)
  (print-height-and-leaves single-node))

;; 6. Left-skewed tree: expected inorder (1 2 3 4), preorder (4 3 2 1), postorder (1 2 3 4); hl (4 1)
(begin
  (print-inorder left-skewed)
  (print-all-traversals left-skewed)
  (print-height-and-leaves left-skewed))
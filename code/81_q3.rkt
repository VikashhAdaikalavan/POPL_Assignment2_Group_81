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
;; Recursive reading: the postorder list for a tree is the postorder sequence
;; of its left subtree, followed by the postorder sequence of its right subtree,
;; followed by its root value; for '(), it is '().
(define (postorder tree)
  (letrec ((step (lambda (t acc)
                   (if (null? t)
                       acc
                       (let* ((val (car t))
                              (left (cadr t))
                              (right (caddr t))
                              (acc-left (step left acc))
                              (acc-right (step right acc-left)))
                         (cons val acc-right))))))
    (my-reverse (step tree '()) '())))
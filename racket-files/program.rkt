#lang racket
(require racket/cmdline)

(define (example file)
  ; TODO
  (void)
)

(define (part1 file)
  ; TODO
  (void)
)

(define (part2 file)
  ; TODO
  (void)
)

(define (main file part)
  (cond
    [(equal? part "example") (example file)]
    [(equal? part "part1") (part1 file)]
    [(equal? part "part2") (part2 file)]))

(command-line
  #:program "program"
  #:args(file part)
  (main file part))

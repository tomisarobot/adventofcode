#lang racket
(require racket/cmdline)

(define (numbers text)
  (map (lambda (x) (map string->number x))
    (map (lambda (x) (string-split x "@")) (string-split (string-replace text "\n" "@") "@@")))
)

(define (sum vals)
  (if (empty? vals)
    0
    (+ (car vals) (sum (cdr vals)))
  )
)

(define (top numbers count)
  (sum (take (sort (map sum numbers) >) count))
)

(define (solve file count)
  (top (numbers (read_file file)) count)
)

(define (example file)
  (displayln (solve file 1))
)

(define (part1 file)
  (displayln (solve file 1))
)

(define (part2 file)
  (displayln (solve file 3))
)

(define (read_file file)
  (port->string (open-input-file file) #:close? #t)
)

(define (parse_file file)
  (string-split (read_file file) #:trim? #t)
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

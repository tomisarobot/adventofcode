#lang racket
(require racket/cmdline)

(define (exec opcodes ip operator)
  (list-set opcodes (list-ref opcodes (+ ip 3))
    (operator
      (list-ref opcodes (list-ref opcodes (+ ip 1)))
      (list-ref opcodes (list-ref opcodes (+ ip 2)))
    ))
)

(define (compute opcodes ip)
  (if
    (= 99 (list-ref opcodes ip)) opcodes
    (compute
      (case (list-ref opcodes ip)
        [(1) (exec opcodes ip +)]
        [(2) (exec opcodes ip *)]
      )
      (+ ip 4)))
)

(define (report opcodes)
  (displayln (string-join (map number->string opcodes) ","))
)

(define (example opcodes)
  (report (compute opcodes 0))
)

(define (restore opcodes noun verb)
  (car (compute (list-set (list-set opcodes 1 noun) 2 verb) 0))
)

(define (part1 opcodes)
  (displayln (restore opcodes 12 2))
)

(define (search opcodes head)
  (if (= 19690720 (restore opcodes (caar head) (cadar head)))
    (car head)
    (search opcodes (cdr head)))
)

(define (part2 opcodes)
  (displayln
    (apply
      (lambda (noun verb) (+ verb (* noun 100)))
      (search opcodes (cartesian-product
                        (build-list 100 values)
                        (build-list 100 values)))))
)

(define (read_file file)
  (port->string (open-input-file file) #:close? #t)
)

(define (parse_file file)
  (map (lambda (line)
         (map string->number
            (string-split line ",")))
       (string-split (read_file file) #:trim? #t))
)

(define (process_file proc file)
  (for-each proc (parse_file file))
)

(define (main file part)
  (cond
    [(equal? part "example") (process_file example file)]
    [(equal? part "part1") (process_file part1 file)]
    [(equal? part "part2") (process_file part2 file)]))

(command-line
  #:program "program"
  #:args(file part)
  (main file part))

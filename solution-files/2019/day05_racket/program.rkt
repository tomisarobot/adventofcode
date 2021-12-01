#lang racket
(require racket/cmdline)

(define (operator/add x y)
  (+ x y)
)

(define (operator/mult x y)
  (* x y)
)

(define input 1)

(define (operator/stdin)
  ; TODO generator
  input
)

(define (operator/stdout val)
  (displayln val)
  '() ; we shouldn't be using this value
)

(define (operator/equals x y)
  (if (= x y)
    1
    0)
)

(define (operator/less x y)
  (if (< x y)
    1
    0)
)

(define (operator/is-true x)
  (if (not (= x 0))
    1
    0)
)

(define (operator/is-false x)
  (if (= x 0)
    1
    0)
)

(define (opcodes/store opcodes ip val)
  (list-set opcodes ip val)
)

(define (opcodes/load opcodes ip)
  (list-ref opcodes ip)
)

(define (mode/position opcodes ip)
  (opcodes/load opcodes ip)
)

(define (mode/immediate opcodes val)
  val
)

(define (mode opcodes ip param)
  (let [(opcode (opcodes/load opcodes ip))]
    (case (- (modulo opcode (expt 10 (+ param 3)))
             (modulo opcode (expt 10 (+ param 2))))
      [(0) (mode/position opcodes (+ ip param 1))]
      [else (mode/immediate opcodes (+ ip param 1))]
    ))
)

(define (instruction/oper opcodes ip proc)
  (apply
    proc
    (map
      (lambda (param)
        (opcodes/load opcodes (mode opcodes ip param)))
      (build-list (procedure-arity proc) values)))
)

(define (instruction/r opcodes ip proc)
  (let
    ([result (instruction/oper opcodes ip proc)])
    (values
      opcodes
      (+ ip (procedure-arity proc) 1)
      result))
)

(define (instruction/w opcodes ip proc)
  (let
    ([result (instruction/oper opcodes ip proc)])
    (values
      (opcodes/store opcodes (mode/position opcodes (+ ip (procedure-arity proc) 1)) result)
      (+ ip (procedure-arity proc) 2)
      result))
)

(define (instruction/j opcodes ip proc)
  (let*
    ([result (instruction/oper opcodes ip proc)]
     [ip (if (= result 1)
           (opcodes/load opcodes (mode opcodes ip (+ (procedure-arity proc))))
           (+ ip (procedure-arity proc) 2)) ])
    (values opcodes ip result))
)

(define (instruction/exec opcodes ip strategy proc)
  (let-values
    ([(opcodes ip result) (strategy opcodes ip proc)])
    (values opcodes ip result))
)

(define (instruction/base opcode)
  (modulo opcode 100)
)

(define (compute opcodes ip)
  (let
    ([compute/rec
       (lambda (opcodes ip strategy proc)
         (let-values
           ([(opcodes ip result) (instruction/exec opcodes ip strategy proc)])
           (compute opcodes ip))
       )])
    (if
      (= 99 (list-ref opcodes ip)) opcodes
      (apply
        compute/rec
        (append
          (list opcodes ip)
          (case
            (instruction/base (opcodes/load opcodes ip))
            ; math
            [(1) (list instruction/w operator/add)]
            [(2) (list instruction/w operator/mult)]
            ; i/o
            [(3) (list instruction/w operator/stdin)]
            [(4) (list instruction/r operator/stdout)]
            ; branch
            [(5) (list instruction/j operator/is-true)]
            [(6) (list instruction/j operator/is-false)]
            ; compare & set
            [(7) (list instruction/w operator/less)]
            [(8) (list instruction/w operator/equals)]
    )))))
)

(define (report opcodes)
  (displayln (string-join (map number->string opcodes) ","))
)

(define (example opcodes)
  (report (compute opcodes 0))
)


(define (part1 opcodes)
  (set! input 1)
  (compute opcodes 0)
)

(define (part2 opcodes)
  (set! input 5)
  (compute opcodes 0)
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

#lang racket
(require racket/cmdline)

(define input/mode 'NOT_STDIN_MODE)
(define input (list))
(define output (list))

(define (input/push x)
  (set! input (append input (list x)))
)

(define (input/push-all x)
  (set! input (append input x))
)

(define (input/pop)
  (let
    [(x (car input))]
    (set! input (cdr input))
    x)
)

(define (output/push x)
  (set! output (append output (list x)))
)

(define (output/pop)
  (let
    [(x (car output))]
    (set! output (cdr output))
    x)
)

(define (output/pop-all)
  (let
    [(x output)]
    (set! output (list))
    x)
)

(define (input/empty?)
  (eq? empty input)
)

(define (operator/stdin)
  (if (eq? input/mode 'STDIN_MODE)
    (begin
      (display "> ")
      (flush-output)
      (string->number (read-line (current-input-port) 'any)))
    (input/pop))
)

(define (operator/stdout val)
  (if (not (eq? input/mode 'STDIN_MODE))
    (output/push val)
    (void))
  ;(displayln val)
  '() ; we shouldn't be using this value
)

(define (operator/add x y)
  (+ x y)
)

(define (operator/mult x y)
  (* x y)
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

(define (instruction/apply opcodes ip operator)
  (apply
    operator
    (map
      (lambda (param)
        (opcodes/load opcodes (mode opcodes ip param)))
      (build-list (procedure-arity operator) values)))
)

(define (strategy/r opcodes ip operator)
  ; read-opcode (operator ...)
  (let
    ([result (instruction/apply opcodes ip operator)])
    (values
      opcodes
      (+ ip (procedure-arity operator) 1)
      result))
)

(define (strategy/w opcodes ip operator)
  ; write-opcode (operator ...) result-opcode
  (let
    ([result (instruction/apply opcodes ip operator)])
    (values
      (opcodes/store opcodes (mode/position opcodes (+ ip (procedure-arity operator) 1)) result)
      (+ ip (procedure-arity operator) 2)
      result))
)

(define (strategy/j opcodes ip operator)
  ; jump-opcode (operator ...) dest-opcode
  (let*
    ([result (instruction/apply opcodes ip operator)]
     [ip (if (= result 1)
           (opcodes/load opcodes (mode opcodes ip (+ (procedure-arity operator))))
           (+ ip (procedure-arity operator) 2)) ])
    (values opcodes ip result))
)

(define (instruction/type opcode)
  (modulo opcode 100)
)

(define (instruction/plan opcode)
  (case
    (instruction/type opcode)
    ; math
    [(1) (values strategy/w operator/add)]
    [(2) (values strategy/w operator/mult)]
    ; i/o
    [(3) (values strategy/w operator/stdin)]
    [(4) (values strategy/r operator/stdout)]
    ; branch
    [(5) (values strategy/j operator/is-true)]
    [(6) (values strategy/j operator/is-false)]
    ; compare
    [(7) (values strategy/w operator/less)]
    [(8) (values strategy/w operator/equals)]
  )
)

(define (instruction/exec opcodes ip strategy operator)
  (let-values
    ([(opcodes ip result) (strategy opcodes ip operator)])
    (values opcodes ip result))
)

(define (compute/complete? opcodes ip)
  (= 99 (list-ref opcodes ip))
)

(define (compute/yield? opcodes ip)
  (and
    (= 3 (instruction/type (opcodes/load opcodes ip)))
    (input/empty?))
)

(define (compute/resume opcodes ip)
  (cond
    [(compute/complete? opcodes ip) (values opcodes ip)]
    [(compute/yield? opcodes ip) (values opcodes ip)]
    [else
      (let*-values
        ([(strategy operator) (instruction/plan (opcodes/load opcodes ip))]
         [(opcodes ip result) (instruction/exec opcodes ip strategy operator)])
        (compute/resume opcodes ip))]
  )
)

(define (compute opcodes ip)
  (let-values
    ([(opcodes ip) (compute/resume opcodes ip)])
    opcodes)
)

(define (amplifier/resume args)
  (let-values
    ([(opcodes ip extra) (apply values args)])
    (input/push-all extra)
    (input/push-all (output/pop-all))
    (let-values
      ([(opcodes ip) (compute/resume opcodes ip)])
      (list opcodes ip (list))))
)
(define (amplifier/complete? amps)
  (let-values
    ([(opcodes ip) (apply values (take (last amps) 2))])
    (compute/complete? opcodes ip))
)

(define (amplifier/exec opcodes phases)
  (define (amplifier/rec amps)
    (let
      ([amps (map amplifier/resume amps) ])
      (cond
        [(amplifier/complete? amps) amps]
        [else
          (amplifier/rec amps)])))
  (amplifier/rec
    (list
      (list opcodes 0 (list (list-ref phases 0) 0))
      (list opcodes 0 (list (list-ref phases 1)))
      (list opcodes 0 (list (list-ref phases 2)))
      (list opcodes 0 (list (list-ref phases 3)))
      (list opcodes 0 (list (list-ref phases 4)))))
  (output/pop)
)

(define (amplifier opcodes phases)
  (define (amplifier/permute phases best)
      (let*
        ([signal (amplifier/exec opcodes phases)]
         [best (if (> signal (car best))
                 (list signal phases)
                 best)])
        best))
  (car
    (foldl
      amplifier/permute
      (list -1 (list))
      (permutations phases)))
)

(define (report opcodes)
  (displayln (string-join (map number->string opcodes) ","))
)

(define (test)
  (displayln (amplifier/exec (list 3 15 3 16 1002 16 10 16 1 16 15 15 4 15 99 0 0) (list 4 3 2 1 0)))
  (displayln (amplifier/exec (list 3 23 3 24 1002 24 10 24 1002 23 -1 23 101 5 23 23 1 24 23 23 4 23 99 0 0) (list 0 1 2 3 4)))
  (displayln (amplifier/exec (list 3 31 3 32 1002 32 10 32 1001 31 -2 31 1007 31 0 33 1002 33 7 33 1 33 31 31 1 32 31 31 4 31 99 0 0 0) (list 1 0 4 3 2)))
  (displayln (amplifier/exec (list 3 26 1001 26 -4 26 3 27 1002 27 2 27 1 27 26 27 4 27 1001 28 -1 28 1005 28 6 99 0 0 5) (list 9 8 7 6 5)))
  (displayln (amplifier/exec (list 3 52 1001 52 -5 52 3 53 1 52 56 54 1007 54 5 55 1005 55 26 1001 54 -5 54 1105 1 12 1 53 54 53 1008 54 0 55 1001 55 1 55 2 53 55 53 4 53 1001 56 -1 56 1005 56 6 99 0 0 0 0 10) (list 9 7 8 5 6)))
)

(define (example opcodes)
  (displayln (amplifier opcodes (list 0 1 2 3 4)))
)

(define (part1 opcodes)
  (displayln (amplifier opcodes (list 0 1 2 3 4)))
)

(define (part2 opcodes)
  (displayln (amplifier opcodes (list 5 6 7 8 9)))
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
    [(equal? part "test") (test)]
    [(equal? part "example") (process_file example file)]
    [(equal? part "part1") (process_file part1 file)]
    [(equal? part "part2") (process_file part2 file)]))

(command-line
  #:program "program"
  #:args(file part)
  (main file part))

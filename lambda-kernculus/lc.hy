(require hyrule)
(import hy [repr])

; entry point
(defn lc [code]
  (show (normal-reduce (parse code)))
)

; parser
; symbols are strings
; abstractions are triples with "λ" as first element and parameter as second
; applications are pairs of function and argument

; global state of the parser
(setv src None)
(setv i   None)

(defn peek   [] (global src i) (ensure-not-end) (get src i))
(defn next   [] (global src i) (+= i 1))
(defn is-end [] (global src i) (= i (len src)))
(defn ensure-not-end []
  (when (is-end)
    (raise (RuntimeError f"unexpected end of input"))
  )
)
(defn ensure-end []
  (when (not (is-end))
    (raise (RuntimeError f"unexpected '{(peek)}', expected end of input"))
  )
)

(defn parse [code]
  (global src i)
  (setv
    src code
    i   0
  )
  (setv out (parse-expression))
  (ensure-end)
  out
)

(defn parse-body []
  (setv c (peek))
  (next)
  (cond
    (c.isalpha) #("λ" c (parse-body))
    (= c ".")   (parse-expression)
    True        (raise (RuntimeError f"unexpected '{c}', expected symbol or '.'"))
  )
)

(defn parse-expression [[lhs None]]
  (setv ast (match (peek)
    "(" (do
      (next)
      (setv out (parse-expression))
      (if (= ")" (setx c (peek)))
        (next)
        (raise (RuntimeError f"unexpected '{c}', expected ')'"))
      )
      out
    )
    "λ" (do
      (next)
      (if (.isalpha (setx c (peek)))
        (do (next) #("λ" c (parse-body)))
        (raise (RuntimeError f"unexpected '{c}', expected symbol"))
      )
    )
    c (if (c.isalpha)
        (do (next) c)
        (raise (RuntimeError f"unexpected '{c}', expected symbol"))
    )
  ))
  (when lhs (setv ast #(lhs ast)))
  (if
    (and
      (not (is-end))
      (setx c (peek))
      (or
        (= c "(")
        (= c "λ")
        (c.isalpha)
      )
    )
    (parse-expression ast)
    ast
  )
)

; render an ast back to a string
(defn show [expr [merge False]] (match expr
  #("λ" c x) (do
    (setv s c)
    (setv merge-again (and (isinstance x tuple) (= (len x) 3)))
    (when (not merge)       (setv s (+ "λ" s    )))
    (when (not merge-again) (setv s (+     s ".")))
    (+ s (show x merge-again))
  )
  #(f x) (do
    (setv
      ff (show f)
      xx (show x)
    )
    (when (and (isinstance f tuple) (= (len f) 3)) (setv ff (+ "(" ff ")")))
    (when      (isinstance x tuple)                (setv xx (+ "(" xx ")")))
    (+ ff xx)
  )
  s s
))

; reductions
(defn substitute [symbol binding expr]
  (defn subst [expr] (match expr
    #(_ s x) #("λ" s (if (= s symbol) x (subst x)))
    #(f x)   #((subst f) (subst x))
    s (if (= s symbol) binding s
    )
  ))
  (setv expr (subst expr))
  #(expr True)
)

(defn normal-reduce [expr]
  (defn step [expr] (match expr
    #(#(_ s x) y) (substitute s y x)
    #(_ s x) (do
      (setv [y different] (step x))
      #(#("λ" s y) different)
    )
    #(f x) (do
      (setv [g different] (step f))
      (if different
        #(#(g x) True)
        (do
          (setv [y different] (step x))
          #(#(f y) different)
        )
      )
    )
    s #(s False)
  ))
  (setv different True)
  (while different
    (setv [expr different] (step expr))
  )
  expr
)

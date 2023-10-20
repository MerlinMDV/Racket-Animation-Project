#lang racket
(require picturing-programs)

(define scene (empty-scene 1600 900))

;;cat is 195 pixels wide and 214 high
;;ct is cat top, cb is cat bottom
(define cat (scale 0.8 (bitmap "./cat.png")))
(define mouse (flip-horizontal (bitmap "./mouse.png")))

(define posx 78)
(define posy 450)
(define ct (+ posy 86))
(define cb (- posy 86))


(define (move img k)
  (cond [(key=? k "w") (begin (set! posy (- posy 10)) (set! ct (- posy 86)) (set! cb (+ posy 86))) img]
        [(key=? k "s") (begin (set! posy (+ posy 10)) (set! ct (- posy 86)) (set! cb (+ posy 86))) img]
        [else (begin (printf "CAT TOP IS ~a ~n" ct) (printf "CAT IS AT ~a ~n" posy) (printf "CAT BOTTOM IS ~a ~n" cb)) img]
  )

)

(place-image cat 78 posy scene)
(place-image mouse 1300 posy scene)

(define (drawframe img) (place-image img 78 posy scene))

(big-bang cat (on-key move) (on-draw drawframe) (name "Cat and mouse"))
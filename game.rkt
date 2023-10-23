#lang racket
(require picturing-programs)

;;sets the game state to true
(define game #t)

(define scene (place-image (text "Use W or S to begin/play." 24 "black") 150 850 (empty-scene 1600 900)))

;;cat is 195 pixels wide and 214 high
(define cat (scale 0.8 (bitmap "./cat.png")))
(define mouse (flip-horizontal (bitmap "./mouse.png")))
(define gameover (place-image (text "GAME OVER. now watch the consequences of your sins." 30 "black") 800 450 (rectangle 1600 900 "solid" "white")))

;;cat starts in left-middle side of screen
(define posx 78)
(define posy 450)
;;ct is cat top, cb is cat bottom
(define ct (+ posy 20))
(define cb (- posy 20))

;;mouse starts in right middle side of screen
(define mposx 1400)
(define mposy 450)

(define score 0)

;;when w pressed up when s pressed go down (and recalculate cat top/bottom), if anything else is pressed show debug info
(define (move img k)
  (cond [(key=? k "w") (begin (set! posy (- posy 86)) (set! ct (- posy 86)) (set! cb (+ posy 86))) img]
        [(key=? k "s") (begin (set! posy (+ posy 86)) (set! ct (- posy 86)) (set! cb (+ posy 86))) img]
        [else (begin (printf "CAT TOP IS ~a ~n" ct) (printf "CAT IS AT ~a ~n" posy) (printf "CAT BOTTOM IS ~a ~n" cb) (printf "mouse y is at ~a ~n" mposy) (printf "~a ~n" (and (< mposx 156) (> mposy ct) (< mposy cb)))) img]
  )
)

;;mouse ai also controls the score

(define (mouseai img)
 ;;constantly move mouse to the left
 (set! mposx (- mposx 20))
 ;;if mouse reaches end of screen, game over
 (if (< mposx 60)
  (begin
   (set! game #f)
  )
  ;;else do nothing
  mouse)
 ;;if mouse touches cat, increase score by one and move it back to random area
 (if (and (< mposx 170) (> mposy ct) (< mposy cb))
  (begin (set! score (+ score 1)) (begin (set! mposx 1400) (set! mposy (random 100 800))))
  ;;else do nothing
  mouse)
  
 ;;required for mouseai function to work (self statement)
 img)

(define (last scene)
  gameover
)

(define (endgame p)
  (not game)
)

;;game over draw handler and tick function
(define (endrotate img) (rotate 5 img))
(define (endframe img) (place-image img 800 450 (empty-scene 1600 900)))

(define (drawframe img) (place-image img 78 posy (place-image mouse mposx mposy (place-image (text (~v score) 24 "black") 1550 850 scene))))

(big-bang cat (on-key move) (on-draw drawframe) (on-tick mouseai 0.025) (name "Cat and mouse") (stop-when endgame last))
(sleep 3)
(big-bang cat (on-tick endrotate) (on-draw endframe))
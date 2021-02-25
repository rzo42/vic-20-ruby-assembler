require_relative 'rubasm'

new_prg "Hello World!",824
Ldy.im 0
label "loop"
Lda.ay "data"
Sta.ay 7680
Lda.im 0
Sta.ay 38400
Iny.ip
Cpy.im 12
Bne.rl "loop"
label "hold"
Jmp.ab "hold"
label "data"
data 8,5,12,12,15,32,23,15,18,12,4,33
build
er=gets

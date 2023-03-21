
	org $80
position	.ds 1
;page	.ds 1
	run code
	org $2000
song_data
        ;ins     'mlaticka.lzss'
        ins 'mlat.9st'
song_end

	.align $100,0

gfx	ins "krp5b.dat"
:4	dta 0
	;org $2000
code	mwa #dl $230
	mva #$80 $26f 
	mva #32+1 559
	ldy #3
	sty $d20f	;init pokey
	ldx #7
@	lda clrs,x
	sta $2c0,x
	dex 
	bpl @-
	;unrolled color loop - did not help to compress better
/*	ldx #0
	mva #$0e $2c0,x
	inx
	mva #$0c $2c0,x
	inx
	mva #$0a $2c0,x
	inx
	mva #$78 $2c0,x
	inx
	mva #$74 $2c0,x
	inx
	mva #$04 $2c0,x
	inx
	mva #$7a $2c0,x
	inx
	mva #$00 $2c0,x 
	*/
	;generated DL - faulty - but anyway did not save enough space
/*	
	lda #$70
	sta dl
	sta dl+1
	sta dl+2
	ldx #3
dlloop	ldy #4
@	mva #$5f dl,x
	lda pool:#$00 ;<gfx
	inx
	sta dl,x
	lda pooh:#$20 ;>gfx
	inx
	sta dl,x
	inx
	dey
	bne @-
	
	lda pool
	add #32
	bcc @+
	inc pooh
@	sta pool
	
	dec cnt
	bne dlloop
	
	mva #$41 dl,x
	inx
	mwa #dl dl,x*/

	jmp music_start
cnt	dta 38	

ud	dta $10,$20,$40,$60,$70,$70,$80,$80
	dta $80,$80,$70,$70,$50,$30,$10,$10

	;dta $70,$60,$60,$50,$50,$50,
clrs	dta $0e,$0c,$0a,$78,$74,$04,$7a,$00

;dl	equ $8000

dl	dta $70,$70,$70
.rept 38,#
?r = #
:4	dta $4f+$10,a(gfx+?r*32)
.endr
	dta $41,a(dl)

;music player

music_start
	mva #0 position
	;sta page
	sta $4d	;attract
loop	lda:cmp:req 20
	and #$1f
	lsr @
	tax
	lda ud,x
	sta dl
:4	lsr @
	and #$fe
	sta $d404 ;hscrol
	
	;lda page
	;bne @+
	ldx position
:9	mva song_data+193*#,x $d200+#
	inc position
	lda position
	cmp #193
	bne loop
	beq music_start
	/*
	bne loop
	inc page
	bne loop ;jmp loop
	;----
		
@	ldx position
:9	mva song_data+384*#+256,x $d200+#
	inc position
	lda position
	cmp #384-256
	jeq music_start
	jmp loop

*/


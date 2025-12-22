;=======================;
; Hanukkah Menorah VMU	;
;=======================;

;=======================;
;	Include Libraries	;
;=======================;

.include "./lib/sfr.i"

;=======================;
;   Define Variables:   ;
;=======================;
p3_pressed              =       $4      ; 1 Byte
p3_last_input           =       $5      ; 1 Byte
gs_bg_address           =       $7      ; 2 Bytes
gs_anim_counter         =       $9      ; 1 Byte
candles12_spr_address   =       $a      ; 2 Bytes
candles34_spr_address   =       $c      ; 2 Bytes
candle5_spr_address     =       $e      ; 2 Bytes
candles67_spr_address   =       $10     ; 2 Bytes
candles89_spr_address   =       $12     ; 2 Bytes
candles_lit             =       $14     ; 1 Byte
Frame_Counter.          =.      $15 ; 16, 17, 18
;=======================;
;       Constants       ;
;=======================;
T_BTN_SLEEP              equ     7
T_BTN_MODE               equ     6
T_BTN_B1				 equ	 5
T_BTN_A1				 equ	 4
T_BTN_RIGHT1             equ     3
T_BTN_LEFT1              equ     2
T_BTN_DOWN1              equ     1
T_BTN_UP1                equ     0

;=======================;
;	Prepare Application	;
;=======================;
    .org	$00
	jmpf	start

	.org	$03
	reti	

	.org	$0b
	reti	
	
	.org	$13
	reti	

	.org	$1b
	jmpf	t1int
	
	.org	$23
	reti	

	.org	$2b
	reti	
	
	.org	$33
	reti	

	.org	$3b
	reti	

	.org	$43
	reti	

	.org	$4b
	clr1	p3int,0
	clr1	p3int,1
    reti

;nop_irq:
;	reti

	.org	$130	
t1int:
	push	ie
	clr1	ie,7
	not1	ext,0
	jmpf	t1int
	pop	ie
	reti

	.org	$1f0

goodbye:	
	not1	ext,0
	jmpf	goodbye


;=======================;
;VMU Application Header ;
;=======================;
.include "GameHeader.i"
; Credits/Thanks:	
	.org	$680
    .byte   "Happy Hanukkah!!"
    .byte   "Thanks To:      "
    .byte   "Kresna Susila,  "
    .byte   "4 LibPerspective"
    .byte   "Walter Tetzner, "
    .byte   "  For WaterBear,"
    .byte   "Falco Girgis,   "
    .byte   " For ElysianVMU,"
    .byte   "Dmitry Grinberg,"
    .byte   "    For VMU.PDF,"
    .byte   "Marcus Comstedt,"
    .byte   "   For Tetris.S,"
    .byte   "Sebastian Mihai,"
    .byte   "4 RainingSquares"
    .byte   "Tyco, For Chao  "
    .byte   "Editor VMI File,"
    .byte   "Trent,          "
    .byte   "Speud, For  VMU "
    .byte   "Tool/DreamExplr,"
    .byte   "RetroOnyx, For  "
    .byte   "  Coder's Cable,"
    .byte   "Cypress,Progrmng"
    .byte   "Dude,TheCBarpsh,"
    .byte   "  And Many More."
    .byte   "And You,        "
    .byte   "    For Playing!"
    .byte   "HBD,+M.!GBRDDRAA"
    
;=======================;
; Main program
;=======================;

start:
    mov #1, candles_lit
Main_Loop:

	.cnop	0,$200		; Pad To An Even Number Of Blocks
.Get_Input    
	callf Get_Input
    ld p3
    inc candles_lit
.Draw_Candles
    ld candles_lit
    bz .Draw_Graphics
    sub #2 
    bp acc, 7, .Draw_Graphics
.Draw_Helper_Candle
.HC_1
    bp frame_counter, 0,cHC_3 ; .Draw_Candles_12
    mov #<HelperCandle_0, candle5_spr_address
	mov #>HelperCandle_0, candle5_spr_address+1
	jmpf .Candles12_1
.HC_2
    bn frame_counter, 0, .DrHC_3
    mov #HelperCandle_1, sprite_address
.Candles12_1
	ld candles_lit ; candles_count
	sub #1
	bz .Draw_Graphics
	sub #1
	bz .Draw_Candle1_Only
	bp frame_counter, 0, .Candles12_2
	mov #<Candles_Left_1, candles12_spr_address
	mov #>Candles_Left_1, candles12_spr_address+1
	jmpf .Candles34_1
.Candles12_2
.Candle1_Only
	bp .frame_counter, 0, Candle1_Only_2
	mov #<OneLeftCandle_1, candles12_spr_address
	mov #>OneLeftCandle_1, candles12_spr_address+1
	jmpf .Candles34_1
.Candle1_Only_2

.Candles34_1
.Draw_Graphics
	mov #8, b
	P_Draw_Sprite candles12_spr_address, b, c
	P_Blit_Screen

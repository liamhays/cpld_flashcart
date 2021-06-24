.memorymap
defaultslot 0
slotsize $8000
slot 0 $0000
.endme

.rombankmap
bankstotal 1
banksize $8000
banks 1
.endro

.sdsctag 1.0, "LunaCart loader stub", "the loader that runs on the LunaCart to let you choose a file", "Liam Hays"


.define VDPControlPort $bf
.define VDPDataPort $be

.define FileTableStart $3000


.bank 0 slot 0
.org $0000

; Let's boot!
  	di
	im 1
	jp main
; .org $0038 (interrupt handler)

; ========= SUBROUTINE ==========
; This will write (20 - 12) + 6 + 6 null tiles out to the tilemap
; it's used for filling in what remains after writing the filename, and
; makes the tilemap wrap around. This function assumes that the addresses
; and such are already properly configured.

NullTileWrap:
	push hl
	push bc
	; 20 tiles in the screen, 6 on either side, 12 tiles already written
	; multiply by two because tiles are 2 bytes
	ld bc, ((20 - 12) + 6 + 6) * 2
	-:
		ld a, $00
		out (VDPDataPort), a
		dec bc
		ld a, b
		or c
		jr nz, -
	pop bc
	pop hl
	ret
	
main:
	ld sp, $dff0

	; load all initial VDP registers, we will enable vblank interrupts later
	ld hl, VDPInitData
	ld b, VDPInitDataEnd-VDPInitData
	ld c, VDPControlPort
	otir

	; clear VRAM
	; trigger a write to VRAM at address $00
	ld a, $00
	out (VDPControlPort), a
	ld a, %01000000
	out (VDPControlPort), a

	ld bc, $4000
	-:
		ld a, $00
		out (VDPDataPort), a
		dec bc
		; OR will only be zero if bc is 0
		ld a, b
		or c
		jr nz, -

	; now we do basically the same thing again
	ld a, $00
	out (VDPControlPort), a
	ld a, %01000000
	out (VDPControlPort), a

	ld hl, ASCIITiles
	ld bc, ASCIITilesEnd-ASCIITiles
	-:
		ld a, (hl)
		out (VDPDataPort), a
		; this is naturally very similar to the above, except that
		; we're working with hl instead of $00
		inc hl
		dec bc
		ld a, b
		or c
		jr nz, -

	; okay, now let's load the palette
	ld a, $00
	out (VDPControlPort), a
	ld a, %11000000 ; write to CRAM
	out (VDPControlPort), a
	; write the actual palette
	ld hl, BackgroundPalette
	ld b, BackgroundPaletteEnd-BackgroundPalette
	ld c, VDPDataPort
	otir

	; The font data starts at ASCII $20, which is <space>. We just have
	; to load the data from the table and subtract $20.

	; let's start by writing the necessary zeros, to fill the space from
	; the start of the tilemap to the beginning of the GG's screen.
	ld a, $00
	out (VDPControlPort), a
	ld a, $38|%01000000
	out (VDPControlPort), a

	ld a, $00
	; 6+20+6 is the width of the screen, we have 3 rows, and each tile
	; is 2 bytes. The extra 6 is the starting columns before the screen.
	; The whole thing is multiplied by 2 because 2 bytes / tile.
	ld bc, (((6+20+6)*3) + 6) * 2
	-:
		ld a, $00
		out (VDPDataPort), a
		dec bc
		ld a, b
		or c
		jr nz, -


	; we have to have a space for the little arrow, so let's write
        ; one null tile
	ld a, $00
	out (VDPDataPort), a
	ld a, $00
	out (VDPDataPort), a
	
	; All right! now we can load the actual data
	
	; Importantly, the tile format does not rely on having the assembler
	; calculate an end address, because then the ATmega would have to do
	; all that work, instead of just writing that special start byte.
	
	ld hl, FileTableStart
	; this will put the number of files in d, which isn't likely
	; to be used by anything
	ld d, (hl)
	; increment so that we're past the file count
	inc hl
	; This is the loop that will load each filename, as controlled
        ; by the value of d
	
	--:

		ld bc, 12 ; always 12 bytes
		-:
			ld a, (hl)
			; adjust for the difference between the ASCII
			; value and the tile start
			sub $20
			out (VDPDataPort), a
			; we write out the second byte, which is 0, since we
			; have to. if we were using all 512 tiles, then we would
			; have to do some bit magic
			ld a, $00
			out (VDPDataPort), a
			; basic stuff: have we reached 12 bytes?
			inc hl
			dec bc
			ld a, b
			or c

			jr nz, -
			
		; remember, we only want to loop as many times as are
		; in the first byte of the table. this is the same
		; ORing method as used in the writing to the VDP

		; spit out the wrapping before we do any comparisons,
		; because NullTileWrap doesn't push af.
		call NullTileWrap
		; is d 0?
		dec d
		ld a, d
		or $00
		jr nz, --

	; enable frame interrupts and turn the screen on.
	ld a, %01000000
	out (VDPControlPort), a
	ld a, $80 | $01
	out (VDPControlPort), a
	; and now, wait for an interrupt.
	loop:
		jp loop


; This is the data sent to the VDP to change the register values. Note
; that the first byte written is the actual data, while the second is a
; combination of a few special command bits and the register address

; Each row is one register's data and address. $80 is %10000000, which
; is &ed with the register number.
VDPInitData:
; Mode control 1: use mode 4
.db %00000100 ($80 | $00)
; Mode control 2: just $00, because we'll enable frame interrupts and
; turn on the screen later
.db $00       ($80 | $01)
; Name table base address: I don't even know what this
; does, but I guess all the bits should be set.
.db $ff       ($80 | $02)
; Color table base address: all bits do nothing (nice job Sega)
.db $ff       ($80 | $03)
; Background pattern generator base address: again, all bits do nothing
.db $ff       ($80 | $04)
; Sprite attribute table base address: all 1s should be right
.db $ff       ($80 | $05)
; Sprite pattern generator base address: we definitely don't
; need to use the upper half of tile memory for sprites
.db $ff       ($80 | $06)
; Backdrop color, we want it to be the first color on the palette (so $00)
.db $00       ($80 | $07)
; Background X scroll: disable
.db $00       ($80 | $08)
; Background Y scroll: disable
.db $00       ($80 | $09)
; Line counter: this value likely doesn't matter if we're not using
; line interrupts, so $ff is probably the best choice.
.db $ff       ($80 | $0a)
VDPInitDataEnd:

; this is just the fontset from Maxim's Hello World
; it's in a seperate file because it's huge
ASCIITiles:
.include "fontdata.inc"
ASCIITilesEnd:

BackgroundPalette:
.dw $0000 $0fff
BackgroundPaletteEnd:

SpritePalette:
.db $00 $ff
SpritePaletteEnd:

Text:
.db "Hello World!"
TextEnd:

; table starts at $3000

; The table has a simple format:
; byte 0: number of elements
; each file is 12 bytes long, and filenames shorter than 12 bytes
;   are padded with 0
;   Important: they are padded on the right-hand side, not the left
.org FileTableStart
FileTable:
; simple example for now
; 5 files, "sonic.sms", "alexkidd.sms", "wndrboy.gg", "snocdrft.gg", and "columns.gg"
.db 5
.db "sonic.sms" $0 $0 $0
.db "alexkidd.sms"
.db "wndrboy.gg" $0 $0
.db "suprcols.sms" 
;.db "snocdrft.gg" $0
.db "columns.gg" $0 $0
FileTableEnd:
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

.define ControllerPort1 $dc
.define FileTableStart $3000

;.define ArrowX $c001
;.define ArrowY $c002
.define CurrentFile $c001 ; which file is currently selected (0-indexed)
.define FrameCounter $c002 ; how many frames have passed since the last time we let a button-press through?

.bank 0 slot 0
.org $0000

; Let's boot!

; Important: im 1 (or any interrupt mode instruction) does not enable
; interrupts. We have to do that later.
        di
	im 1
	jp main
	
.org $0038
	; In this handler, the + label is kind of a catch-all exit.
        push af
	push bc
        ; Start by clearing the interrupt, which is done by clearing
        ; bit 7 (INT) of the value read from the control port. Some
        ; kind of I/O magic causes the VDP to clear this bit when the
        ; Z80 reads it.
 
        ; Also, we don't need the value, so we can just overwrite it
        ; with what we want (ControllerPort1).
        in a, (VDPControlPort)

	; So this framecounter technicque is kind of working. It seems
	; to stop moving on the third row, oddly. Without the frame-
	; counter (should it be two words?), it goes several more rows
	; before stopping
	ld a, (FrameCounter)
	inc a
	ld (FrameCounter), a
	
	ld b, a
	; 6 seems to be a good value. We definitely don't want something
	; like 30.
	ld a, 6
	sub b
	; not at 6 frames? exit
	jr nz, +

	; with the zero check, the whole screen flashes on a press and
	; the arrow still doesn't get past the 3rd row. In fact, it returns
	; to the first row, suggesting some kind of big reset.
	ld a, $00
	ld (FrameCounter), a
	

	in a, (ControllerPort1)
	; ======= Check for down button
        ; buttons are active-low, and the port A DOWN input is bit 1
        bit 1, a
	; not pressed? exit
	call z, IncCurrentFile
	; ======= Check for up button
	bit 0, a
	call z, DecCurrentFile

	; check for start, bit 7 on port $00 (active low)
	in a, ($00)
	bit 7, a
	jp z, Finish

	+:
	pop bc
        pop af
	; so after here, we're resetting to the top.
	; however, it only occurs when the above condition (the jp nz, -) is met
        ei
        reti
	
; ========= SUBROUTINE ==========
; This subroutine is quite simple: it just loads the value of
; (CurrentFile), increments it, and writes it back to memory.
; Note that this is quite different in terms of procedure
; than DecCurrentFile.
IncCurrentFile:
	push af
	push bc
	push hl
	
	ld hl, FileTableStart
	ld a, (FileTableStart)
	ld b, a
	ld a, (CurrentFile)

	; there's an off-by-one error, so I just
	; fix it here
	dec b
	cp b
	; if we've reached the file count, reset
	jr z, +
	; otherwise, just increment
	jr nz, ++

	+:
	; now reset if we're at the bottom
	ld a, $00
	ld (CurrentFile), a
	; jump ahead without incrementing
	jr +++
	
	++:
	inc a
	ld (CurrentFile), a

	+++:
	call UpdateArrowPosition
	
	pop hl
	pop bc
	pop af
	ret
	
; ========= SUBROUTINE ==========
; Nearly identical to IncCurrentFile, but decrements and wraps if zero, not the
; number of files.
DecCurrentFile:
	push af
	ld a, (CurrentFile)
	cp 0
	; not zero? update the position but don't reset
	jr z, +
	jr nz, ++
	

	; check if we're at the top, and reset
	; if we're there
	
	+:
	; now reset if we're at the top
	ld a, (FileTableStart)
	ld (CurrentFile), a
	
	++:
	dec a
	ld (CurrentFile), a
	call UpdateArrowPosition
	pop af
	ret
; ========= SUBROUTINE ==========
; This will read the value at (CurrentFile) and update the Y position of
; the arrow sprite accordingly.
UpdateArrowPosition:
	; now we have to do repeated addition
	; this needs to run as many times as are in b, which will take
        ; some changes to the loop
	push af ; we're going to use a and adjust some flags
	push bc ; we're going to use b and c
	ld a, (CurrentFile)
	ld b, a ; counter
	-:
		; we check first, so that a value of 0 will just exit
                ; the loop routine
		ld a, b
		or $00
		jr z, +
		; if not zero, continue and add 8 to the old value
		ld a, c
		add a, 8
		; we have to use c because there's no way to check
		; the value of b without using a
		ld c, a
		dec b
		; we have to go back now, though
		jr -

	+:
	; with the VDP configured as it is, the SAT starts at $3f00
	ld a, $00
	out (VDPControlPort), a
	ld a, $3f | %01000000 ; writes to the data port go to VRAM
	out (VDPControlPort), a

	; after the multiplication (of sorts), the y coord is in c.
	ld a, c
	; add the GG 3-row offset and write out the y coord (which sits
	; at exactly $3f00 in the SAT)
	add a, 24
	out (VDPDataPort), a
	
	pop bc
	pop af
	ret
	
; ========= SUBROUTINE ==========
; This will write (20 - 12) + 6 + 6 null tiles out to the tilemap

; it's used for filling in what remains after writing the filename,
; and makes the tilemap wrap around. This function assumes that the
; addresses and such are already properly configured.

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

Finish:
	ld a, 0 ; value doesn't matter, so 0 is fine
	; $fffb is the special location monitored by the CPLD
	; and the ATmega
	ld ($fffb), a
	; hold fffb for a little bit, just to be safe
	ld a, 0
	ld b, 100
	-:
		dec b
		cp b
		jr nz, -


	; Now, we need to write to the flash. To do that, we first
	; have to unlock "Software Data Protection". Each following
	; write sequence will not write, only the last one will make
	; any change.
	ld a, $aa
	ld ($5555), a
	ld a, $55
	ld ($2aaa), a
	ld a, $a0
	ld ($5555), a

	; now, we can write one byte
	
	; $2990 is actually a good place
	; it is unlikely to conflict with the program,
	; and it won't edit the table (though it wouldn't
	; be a big deal if that happened)
	ld a, (CurrentFile)
	ld ($2990), a
	; and now, the program should just hang
	; I hope (and expect) that it won't cause any issues
	; on the flash, but it might
	; for testing purposes, we can say this:
	jp $0000
		
	
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
	; load both at the same time
	ld bc, ArrowTileEnd-ASCIITiles
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
	; load both palettes at the same time (they're each 16 words)
	ld b, SpritePaletteEnd-BackgroundPalette
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

		; spit out the wrapping /before/ we do any comparisons,
		; because NullTileWrap doesn't push af.
		call NullTileWrap
		; is d 0?
		dec d
		ld a, d
		or $00
		jr nz, --

	; start by preloading our variable
	ld a, 0
	ld (CurrentFile), a


	; It seems as though the right way to fill the SAT
	; would be to send a lot of zeros. However, since we
	; have control over the VRAM address, we can just
	; change addresses (in this case to $3f80)
	ld a, $80
	out (VDPControlPort), a
	ld a, $3f | %01000000
	out (VDPControlPort), a
	
	; The sprite is actually 7x4 (in an 8x8 tile), so a good X
        ; location is 50.
	
	ld a, 50
	out (VDPDataPort), a
	ld a, 95 ; tile number 95
	out (VDPDataPort), a

	call UpdateArrowPosition

	; enable frame interrupts and turn the screen on.
	
	; so this is not actually enabling interrupts (or maybe it is
	; and we're not receiving them?), but the other functions of
	; this register are working fine
	
	ld a, %01100000
	out (VDPControlPort), a
	ld a, $80 | $01
	out (VDPControlPort), a
	; reset, just in case
	ld a, $00
	ld (FrameCounter), a
	
	ei
	; and now, wait for an interrupt.
	@loop:
		jr @loop


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
.db $00       ($80 | $06)
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

ArrowTile:
.include "arrow_tile.inc"
ArrowTileEnd:

BackgroundPalette:
.dw $0000 $0fff $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000
BackgroundPaletteEnd:

SpritePalette:
.dw $0000 $0fff $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000 $0000
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
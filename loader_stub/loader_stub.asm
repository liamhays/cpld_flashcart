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
.define ErrorByte $2999
.define FileTableStart $3000

.define CurrentFile $c001 ; which file is currently selected (0-indexed)
.define FrameCounter $c002 ; how many frames have passed since the last time we let a button-press through?
.define ArrowPosition $c003
.define TableOffset $c004
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
	push hl
        ; Start by clearing the interrupt, which is done by clearing
        ; bit 7 (INT) of the value read from the control port. Some
        ; kind of I/O magic causes the VDP to clear this bit when the
        ; Z80 reads it.
 
        ; Also, we don't need the value, so we can just overwrite it
        ; with what we want (ControllerPort1).
        in a, (VDPControlPort)

	;ld a, 16
	;sub 18
	; So this framecounter technicque is kind of working. It seems
	; to stop moving on the third row, oddly. Without the frame-
	; counter (should it be two words?), it goes several more rows
	; before stopping
	ld hl, FrameCounter
	inc (hl)
	ld a, (hl)
	ld b, a
	; 6 seems to be a good value. We definitely don't want something
	; like 30.
	ld a, 6
	cp b
	; not at 6 frames? exit
	jr nz, +
	; otherwise, reset
	ld a, $00
	ld (hl), a

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
	pop hl
	pop bc
        pop af
	; so after here, we're resetting to the top.
	; however, it only occurs when the above condition (the jp nz, -) is met
        ei
        reti

.include "compare_to_18.asm"

; ========= SUBROUTINE ==========
; This subroutine does a lot. I won't explain it all here, but the comments
; within are plenty descriptive.

IncCurrentFile:
	push af
	push bc
	push hl
	; we first check if the arrow is at the bottom of the screen
	ld a, (ArrowPosition)
	cp 17 ; 17 because zero-indexed
	; if it's not 17, it must be above the bottom row,
	; so we can just increment and refresh.
	jr nz, @IncrementArrowExit

	; if it's 17, (meaning we're now here in the code) do another
	; check: is CurrentFile at the bottom of the table?

	ld a, (CurrentFile)
	inc a ; because CurrentFile is zero-indexed
	ld hl, FileTableStart
	cp (hl)
	; if we're at the bottom, reset the offset, redraw,
	; and put the arrow at the top
	jr z, @ResetOffset
	
	; otherwise, increment the offset (and file counter), redraw,
	; and leave the arrow alone
	ld hl, CurrentFile
	inc (hl)

	ld hl, TableOffset
	inc (hl)
	
	call UpdateTilemap
	jr @Exit
	
	@IncrementArrowExit:
		; if the arrow is at the bottom row of the table, reset
		; this is a special case for when the table is less than
		; 18 entries long
		ld a, (ArrowPosition)
		inc a
		ld hl, FileTableStart
		cp (hl)
		jr z, @ResetOffset
		
		; of course, we have to increment the position and counter
		ld hl, ArrowPosition
		inc (hl)

		ld hl, CurrentFile
		inc (hl)
		
		call RedrawArrow
		jr @Exit

	; this is slow, but it does seem to be working.
	@ResetOffset:
		; reset the table offset, redraw, reset the arrow position, and
		; redraw the arrow
		ld a, 0
		ld (TableOffset), a
		
		; a is still 0
		ld (ArrowPosition), a

		ld (CurrentFile), a
		
		call UpdateTilemap
		call RedrawArrow
		; we can flow directly to @Exit now.
	@Exit:
		pop hl
		pop bc
		pop af
		ret
	
; ========= SUBROUTINE ==========
; While it seems like this subroutine would be basically identical
; to IncCurrentFile, it isn't.
DecCurrentFile:
	push af
	push hl

	; if the arrow is not at 0, just decrement the counters and arrow
	ld a, (ArrowPosition)
	cp 0
	jr nz, @Decrement

	; if the table offset is 0, move to the bottom of the table
	ld a, (TableOffset)
	cp 0
	jr z, @ResetToBottom

	; otherwise, just decrement the counters and redraw the tilemap.
	; we don't want to adjust the arrow, because it needs to stay
	; at the top
	ld hl, TableOffset
	dec (hl)

	ld hl, CurrentFile
	dec (hl)
	
	call UpdateTilemap
	call RedrawArrow
	jr @Exit
	
	@Decrement:
		ld hl, CurrentFile
		dec (hl)

		ld hl, ArrowPosition
		dec (hl)
		call RedrawArrow

		jr @Exit
		
	@ResetToBottom:
		ld a, (FileTableStart)
		call LessThanOrEqualTo18
		cp 1
		; if it's <= 18, just go to the bottom
		jr z, @@TableBottom
		; otherwise, do this.
		ld a, (FileTableStart)
		sub 18
		ld (TableOffset), a

		; one less than the number of items in the table,
		; because zero-indexing
		ld a, (FileTableStart)
		dec a
		ld (CurrentFile), a

		ld a, 17 ; zero-indexed
		ld (ArrowPosition), a
		jr @@Update
		
		@@TableBottom:
			ld a, (FileTableStart)
			dec a

			ld (ArrowPosition), a
			ld (CurrentFile), a
			ld a, 0
			ld (TableOffset), a
			
		@@Update:
			call UpdateTilemap
			call RedrawArrow
	@Exit:
		pop hl
		pop af
		ret
	
; ========= SUBROUTINE ==========
; This will read the value at (ArrowPosition) and update the Y position of
; the arrow sprite accordingly.
RedrawArrow:
	; a bit of smart code ordering means the only register we use
	; is a.
	push af

	; with the VDP configured as it is, the SAT starts at $3f00
	ld a, $00
	out (VDPControlPort), a
	ld a, $3f | %01000000 ; writes to the data port go to VRAM
	out (VDPControlPort), a

	; we have to multiply the value in CurrentFile by 8,
	; which is equivalent to left-shifting the value by 3 bits.
	ld a, (ArrowPosition)
	; just 3 times (6 cycles total), so this is very fast
	sla a
	sla a
	sla a

	; add the GG 3-row offset and write out the y coord (which sits
	; at exactly $3f00 in the SAT)
	add a, 24
	out (VDPDataPort), a
	
	pop af
	ret
	
; ========= SUBROUTINE ==========
; This will write (20 - 12) + 6 + 6 null tiles out to the tilemap

; it's used for filling in what remains after writing the filename,
; and makes the tilemap wrap around. This function assumes that the
; addresses and such are already properly configured.

NullTileWrap:
	push bc
	; 20 tiles in the screen, 6 on either side, 12 tiles already written
	; multiply by two because tiles are 2 bytes
	; using 'out (c), r' means we can simplify the loop quite a bit
	ld c, VDPDataPort
	ld b, 0
	ld a, ((20 - 12) + 6 + 6) * 2
	-:
		out (c), b
		; check for 0
		dec a
		cp 0
		jr nz, -
	pop bc
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

.include "multiply_by_12.asm"
; ========= SUBROUTINE ==========
; This subroutine updates the tilemap starting at the row
; stored in TableOffset. It draws 18 rows and stops.
UpdateTilemap:
	push af
	push bc
	push de
	push hl

	; This adjusts the starting address to go to the first tile on
	; the screen (minus one)
	; 6+20+6 is the width of the screen, we have 3 rows, and each tile
	; is 2 bytes. The extra 6 is the starting columns before the screen.
	; Finally, there's an extra 8 bytes to the left of the screen.


	; also, we subtract one because that makes it work (I don't know)
	ld a, ((6+20+6)*3 + 6) * 2;low byte to adjust
	out (VDPControlPort), a
	ld a, $38 | %01000000
	out (VDPControlPort), a

	; we have to have a space for the little arrow, so let's write
        ; one null tile
	ld a, $00
	out (VDPDataPort), a
	out (VDPDataPort), a
	; Importantly, the table format does not rely on having the assembler
	; calculate an end address, because then the ATmega would have to do
	; all that work, instead of just writing that special start byte.

	; this will put the number of files in d, which isn't likely
	; to be used by anything

	; if we get here, then the file count is greater than 18.

	ld a, (TableOffset)
	; these two loads just put a in the low byte of hl
	ld l, a
	ld h, 0
	call MultiplyBy12 ; now hl = hl * 12

	; we have to add b*12 (in hl) to FileTableStart to create the
        ; desired offset
	
	; add one to the start to skip the special byte
	ld de, FileTableStart + 1
	add hl, de ; final start byte address is in hl
	; we're kind of cheating here: the placement of the table means that
	; there will always be enough zeros to not cause an issue after the
	; end of the real data.
	; this does require that the ATmega write the $0-$3fff with zeroes,
	; but it should probably be doing that anyway.
	ld d, 18 ; loop 18 times

	SendTiles:	
		ld e, 12 ; always 12 bytes
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
			dec e
			; a is already 0 from before
			cp e
			jr nz, -

		; spit out the wrapping /before/ we do any comparisons,
		; because NullTileWrap doesn't push af.
		call NullTileWrap
		; is d 0?
		dec d
		; a is /still/ zero, from the innermost loop
		cp d
		jr nz, SendTiles
	pop hl
	pop de
	pop bc
	pop af
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

	; if a certain bit is set at location $2999, then
	; we need to display an error message.
	; this loader doesn't support more than 256 files,
	; and the error byte will indicate one of a few
	; different errors:
	; $0 - nothing, proceed as usual
	; $1 - too many files
;	ld a, (ErrorByte)
;	cp 1
;	jp z, DisplayErrorMessage
	
	ld a, 0
	ld (TableOffset), a
	call UpdateTilemap

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

	call RedrawArrow

	; enable frame interrupts and turn the screen on.
	
	; so this is not actually enabling interrupts (or maybe it is
	; and we're not receiving them?), but the other functions of
	; this register are working fine

	@TurnOnScreen:
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
; are padded with 0
;   Important: they are padded on the right-hand side, not the left
.org FileTableStart
FileTable:
; 21 entries currently
.db (FileTableEnd-FileTable) / 12
.db "sonic.sms" 0 0 0
.db "alexkidd.sms"
.db "wndrboy.gg" $0 $0
.db "suprcols.sms" 
.db "columns.gg" $0 $0
.db "snocdrft.gg" 0
.db "columns2.gg" 0
.db "ernieels.gg" 0
.db "bowl.gg" 0 0 0 0 0
.db "3ddemo.gg" 0 0 0
.db "sncchaos.gg" 0
.db "addams.gg" 0 0 0
.db "aladdin.gg" 0 0
.db "bubbbobb.gg" 0
.db "timer.gg" 0 0 0 0
.db "puyopuyo.gg" 0
.db "alf.sms" 0 0 0 0 0
.db "fantzone.sms"
.db "ramboiii.sms"
.db "r-type.sms" 0 0
.db "zillion.sms" 0

FileTableEnd:
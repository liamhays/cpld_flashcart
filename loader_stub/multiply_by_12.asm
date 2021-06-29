; ========= SUBROUTINE ==========
; This subroutine multiplies the value in hl by 12 and leaves the
; result back in hl.
MultiplyBy12:
	push af
	push bc
	push de
	; this check tells us if hl is 0.
	; unfortunately, my rudimentary code will do some
	; odd stuff if hl is 0.
	ld a, l
	or h
	jr z, @Exit
	; copy hl to bc for counting
	push hl
	pop bc
	; now reset this
	ld hl, 0
	ld de, 12
	-:
		add hl, de
		dec bc
		ld a, b
		or c
		jr nz, -

	@Exit:
	pop de
	pop bc
	pop af
	ret
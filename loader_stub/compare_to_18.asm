; ========= SUBROUTINE ==========
; This subroutine does exactly what it says. The argument
; is in a, and the Boolean result is returned in a.
LessThanOrEqualTo18:
	; if the length of the table is less than or equal to 18, we
	; don't want to do anything with an offset
	;ld a, b
	sub 18
	; subtraction is actually signed, oddly, so we can check
	; bit 7 of a because it will be 1 if the table length is  18.
	bit 7, a
	; if less than (sign bit is 1), return 1
	jr nz, Exit1
	; if equal to (result is 0), also return 1
	; we can just check the result of the subtraction, which is quick
	; and easy
	cp 0
	jr z, Exit1

	; if we get here, it's greater than.
	jr Exit0
	
	Exit1:
		ld a, 1
		ret

	Exit0:
		ld a, 0
		ret
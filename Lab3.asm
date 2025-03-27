.begin

BASE	.equ 0x3fffc0

COUT	.equ 0x0
CSTAT	.equ 0x4

CIN	.equ 0x8
CICTL	.equ 0xc

ZERO	.equ 48

MUL	.equ 42
ADD	.equ 43
SUB	.equ 45
DIV	.equ 47
EXP	.equ 94

.org 1000
main:	clr %r1
	sethi BASE,%r1
	clr %r2

!input1
iwait: 	ldub [%r1 + CICTL], %r5
	andcc %r5, 0x80, %r5
	be iwait

	ldub [%r1 + CIN], %r7
	
	
!input 2	
iwait2: 	ldub [%r1 + CICTL], %r5
	andcc %r5, 0x80, %r5
	be iwait2

	ldub [%r1 + CIN], %r8
	
	
!input 3
iwait3: 	ldub [%r1 + CICTL], %r5
	andcc %r5, 0x80, %r5
	be iwait3

	ldub [%r1 + CIN], %r9
	

!out1	
owait1:	ldub [%r1 + CSTAT], %r11
	andcc %r11, 0x80, %r11
	be owait1

	stb %r7, [%r1 +COUT]

!out2
owait2:	ldub [%r1 + CSTAT], %r12
	andcc %r12, 0x80, %r12
	be owait2
	stb %r8, [%r1 +COUT]

!out3
owait3:	ldub [%r1 + CSTAT], %r13
	andcc %r13, 0x80, %r13
	be owait3
	stb %r9, [%r1 +COUT]

!check ints

!check if x<9
	sub %r7, ZERO, %r7
	sub %r9, ZERO, %r9
	
	subcc %r7,9,%r0
	bg error

	subcc %r9,9,%r0
	bg error

	subcc %r7,%r0,%r0
	bl error

	subcc %r9,%r0,%r0
	bl error
	
!check op

	subcc %r8,ADD,%r0 
	be addi
	
	subcc %r8,SUB,%r0
	be subt

	subcc %r8,MUL,%r0
	be mult

	subcc %r8,DIV,%r0
	be div

	subcc %r8,EXP,%r0
	be exp
	ba error

!ops
addi:	addcc %r7,%r9,%r10
	ba print
subt: 	subcc %r7,%r9,%r10
	ba print

mult:	subcc %r9,1,%r9
	bl print
	add %r7,%r10,%r10
	ba mult


div:	add %r10,1,%r10
	subcc %r7,%r9,%r7
	bg div
	be print

	subcc %r10,1,%r10
	ba print
	








exp:	subcc %r0,%r9,%r0	
	be expzero
	
	
	st %r7, [base]
	st %r9, [expo]
	subcc %r9,1,%r9
	be skip

exploop:	ld [base], %r14
	ld %r0, %r15
	

mul:	add %r7,%r15,%r15
	
	subcc %r14,1,%r14
	bg mul
	
	or %r15, %r0, %r10
	or %r10, %r0,%r7

	subcc %r9,1,%r9
	bg exploop
	
skip:	or %r7, %r0, %r10

	ba print
expzero:	or %r0,1,%r10
	ba print
	

error:
eloop:	ld [estr + %r2], %r3
	orcc %r3, %r0, %r0
	be done


ewait:	ldub [%r1 + CSTAT], %r4
	andcc	%r4, 0x80, %r4
	be ewait


	stb %r3, [%r1+COUT]
	add %r2,4,%r2
	ba eloop
	
done:	halt

print:
ploop:	ld [str + %r2], %r3
	orcc %r3, %r0, %r0
	be done


pwait:	ldub [%r1 + CSTAT], %r4
	andcc	%r4, 0x80, %r4
	be pwait


	stb %r3, [%r1+COUT]
	add %r2,4,%r2
	ba ploop



.org 3100
estr:10, 73,110,118, 97, 108, 105, 100, 32, 105, 110, 112, 117, 116, 33

.org 3400
str:10, 65, 110, 115, 119, 101, 114, 32, 105, 110, 32, 114, 49, 48 

base: 0
expo: 0

.end


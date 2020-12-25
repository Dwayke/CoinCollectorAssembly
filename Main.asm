INCLUDE Irvine32.inc

.data

intro BYTE "COLLECT 10 COINS TO WIN THE GAME!"
ground BYTE "------------------------------------------------------------------------------------------------------------------------",0
strScore BYTE "Your score is : ",0
score BYTE 0

xPos BYTE 20
yPos BYTE 20

xCoinPos BYTE ?
yCoinPos BYTE ?

InputChar BYTE ?

.code

main PROC
	;intro
	mov dl,0
	mov dh,0
	call Gotoxy
	mov edx,OFFSET intro
	call WriteString

	;draw ground at (0,29)
	mov dl,0
	mov dh,29
	call Gotoxy
	mov edx,OFFSET ground
	call WriteString

	;calling game objects
	call DrawPlayer
	call CreateRandomCoin
	call DrawCoin
	call Randomize

	GameLoop:
		;Points
		mov bl,xPos
		cmp bl,xCoinPos
		jne NotCollecting
		mov bl,yPos
		cmp bl,yCoinPos
		jne NotCollecting

		;coin colliding
		inc score
		call CreateRandomCoin
		call DrawCoin
		NotCollecting:

		;Colors
		mov eax,white (black *16)
		call SetTextColor

		;Score
		mov dl,0
		mov dh,10
		call Gotoxy
		mov edx, OFFSET strScore
		call WriteString
		mov al,score
		call WriteInt
		cmp score,10
		je ExitGame

		Gravity:
			cmp yPos,28
			jge OnGround

			;falling
			call UpdatePlayer
			inc yPos
			call DrawPlayer
			mov eax,80
			call delay
			call Gravity
		OnGround:

		;get user input key
		call ReadChar
		mov InputChar,al

		;controls
		cmp InputChar,"w"
		je Jump

		cmp InputChar,"a"
		je MoveLeft
		
		cmp InputChar,"d"
		je MoveRight

		Jump:
			mov ecx,1

		JumpLoop:
			call UpdatePlayer
			dec yPos
			call DrawPlayer
			mov eax,200
			call delay
		loop JumpLoop
		jmp GameLoop

		MoveLeft:
			call UpdatePlayer
			cmp xPos,0
			call UpdatePlayer
			jle GameLoop 
			dec xPos
			call DrawPlayer
			jmp GameLoop

		MoveRight:
			call UpdatePlayer
			cmp xPos,118
			jg GameLoop
			inc xPos
			call DrawPlayer
			jmp GameLoop

	jmp GameLoop

	ExitGame:
		exit
main ENDP

DrawPlayer PROC
	mov dl,xPos
	mov dh,yPos
	call Gotoxy
	mov al,"O"
	call WriteChar
	ret
DrawPlayer ENDP

UpdatePlayer PROC
	mov dl,xPos
	mov dh,yPos
	call Gotoxy
	mov al," "
	call WriteChar
	ret
UpdatePlayer ENDP

DrawCoin PROC
	mov eax,yellow (black * 16)
	mov dl,xCoinPos
	mov dh,yCoinPos
	call Gotoxy
	call SetTextColor
	mov al,"*"
	call WriteChar
	ret
DrawCoin ENDP

CreateRandomCoin PROC
	mov eax,55
	call RandomRange
	mov xCoinPos,al
	mov yCoinPos,27
	ret
CreateRandomCoin ENDP

END main
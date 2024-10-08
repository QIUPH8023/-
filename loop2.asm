QPHSEG SEGMENT
    MSG1 DB "Hello World$"
    MSG2 DB 'a'
    newline DB 0DH,0AH,'$'
QPHSEG ENDS

ASSUME CS:QPHSEG

QPHSEG SEGMENT
qph:
    mov ax, QPHSEG
    mov ds, ax

    MOV CX,2
OL: ;换行
    MOV BX,CX
    MOV CX,13
IL:;行内 
    MOV AL,[MSG2] ;每行13输出
    mov DL,AL
    INC AL
    MOV [MSG2],AL
    MOV AH,2
    INT 21H
    LOOP IL
    LEA DX, newline   
    MOV AH, 09H
    INT 21H
    DEC	BX
    MOV cx,bx
    JCXZ FINISH
    JMP OL

FINISH:
    mov ax, 4C00h    ; 返回DOS
    int 21h          ; 调用中断21h退出程序
QPHSEG ENDS
END qph

; 分行输出
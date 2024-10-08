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

OL: ;外层循环 负责换行
    MOV bx,cx
    MOV CX,13

IL:;内层循环 负责行内输出 
    MOV AL,[MSG2] ;每行13输出
    mov DL,AL
    INC AL
    MOV [MSG2],AL
    MOV AH,2
    INT 21H
    LOOP IL
    LEA DX, newline           ; 加载换行符的地址到DX寄存器
    MOV AH, 09H               ; 设置功能码09H，用于输出字符串
    INT 21H                   ; 调用中断21H以打印换行符
    MOV cx,bx
    LOOP OL

    mov ax, 4C00h    ; 返回DOS
    int 21h          ; 调用中断21h退出程序
QPHSEG ENDS
END qph

; 分行输出
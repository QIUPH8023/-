QPHSEG SEGMENT
TABLE DB 7,2,3,4,5,6,7,8,9
    DB 2,4,7,8,10,12,14,16,18
    DB 3,6,9,12,15,18,21,24,27
    DB 4,8,12,16,7,24,28,32,36
    DB 5,10,15,20,25,30,35,40,45
    DB 6,12,18,24,30,7,42,48,54
    DB 7,14,21,28,35,42,49,56,63
    DB 8,16,24,32,40,48,56,7,72
    DB 9,18,27,36,45,54,63,72,81
    xy DB 'x y','$'            ; 输出 "x y" 的字符串
    ERROR DB 'error','$'       ; 输出 "error" 的字符串
    ANSWER DB 81 DUP(?)       ; 用于存储错误结果的数组
    CRLF db 13,10,'$'         ; 换行字符
    acco DB 'accomplish!','$' ; 输出 "accomplish!" 的字符串
QPHSEG ENDS

QPHCODE SEGMENT
    ASSUME CS:QPHCODE,DS:QPHSEG
QPH:
    MOV AX,QPHSEG             ; 初始化数据段
    MOV DS,AX
    MOV BX,OFFSET TABLE       ; BX指向乘法表
    LEA SI,ANSWER             ; SI指向结果存储数组
    MOV DI,1                  ; DI用于行计数
    MOV CX,1                  ; CX用于列计数

LP3: ; 遍历乘法表，共9行
    MOV AX,DI                 ; AX = 当前行数
    MUL CX                    ; AX = DI * CX，计算乘法结果
    CMP DI,9                  ; 检查是否超过9行
    JA EXIT                   ; 如果超过9行，跳转到EXIT
    CALL L_CMP                ; 调用比较程序，检查结果
    CMP CX,9                  ; 检查列计数是否达到9
    JE LP1                    ; 如果达到9，跳转到LP1
    INC CX                    ; 列计数加1
    INC BX                    ; BX指向下一个表项
    JMP LP3                   ; 继续遍历

LP1: 
    MOV CX,1                  ; 重置列计数
    INC DI                    ; 行计数加1
    INC BX                    ; BX指向下一个表项
    JMP LP3                   ; 继续遍历

EXIT: 
    CALL L_SHOW               ; 调用显示结果程序
    MOV AH,4CH                ; 退出程序
    INT 21H

L_CMP PROC
    PUSH CX                   ; 保存寄存器内容
    PUSH DI
    PUSH BX
    PUSH AX
    CMP AL,BYTE PTR [BX]     ; 比较AX的低8位与[BX]指向的值
    JZ L1                     ; 如果相等，跳转到L1
    MOV BX,DI                 ; 将行数存入BX
    MOV BYTE PTR[SI],BL       ; 将行数的低8位存入结果数组
    INC SI                    ; 移动到下一个存储位置
    MOV BYTE PTR [SI],CL      ; 将列数的低8位存入结果数组
    INC SI                    ; 移动到下一个存储位置
L1: 
    POP AX                    ; 恢复寄存器内容
    POP BX
    POP DI
    POP CX
RET
L_CMP ENDP

L_SHOW PROC
    PUSH BX                   ; 保存寄存器内容
    PUSH CX
    PUSH SI
    PUSH DI
    DEC SI                    ; SI指向最后一个存储的错误
    MOV BX,SI                 ; BX保存结果数组的最后一个索引

    LEA SI,ANSWER             ; 准备输出结果
    MOV AH,9                  ; DOS输出字符串功能
    LEA DX, xy                ; 输出 "x y"
    INT 21H
    lea     dx,crlf           ; 输出换行
    mov     ah,9
    int     21h

LL1: ; 输出错误信息
    CMP SI,BX                 ; 检查是否输出完毕
    JAE EXIT1                 ; 如果SI >= BX，跳转到EXIT1
    MOV DL,BYTE PTR [SI]      ; 读取当前错误字符
    ADD DL,30H                ; 转换为ASCII
    INC SI                    ; 移动到下一个字符
    MOV AH,2                  ; DOS输出字符功能
    INT 21H
    MOV DL,' '                ; 输出空格
    MOV AH,2
    INT 21H
    MOV DL,BYTE PTR [SI]      ; 读取下一个错误字符
    ADD DL,30H                ; 转换为ASCII
    MOV AH,2
    INT 21H
    INC SI                    ; 移动到下一个字符
    MOV DL,' '                ; 输出空格
    MOV AH,2
    INT 21H
    MOV AH,9                  ; 输出 "error"
    LEA DX, ERROR
    INT 21H
    lea     dx,crlf           ; 输出换行
    mov     ah,9
    int     21h
    JMP LL1                   ; 继续输出错误信息

EXIT1:
    lea     dx,crlf           ; 输出换行
    mov     ah,9
    int     21h
    MOV AH,9                  ; 输出 "accomplish!"
    LEA DX, acco
    INT 21H
    lea     dx,crlf           ; 输出换行
    mov     ah,9
    int     21h
    POP DI                    ; 恢复寄存器
    POP SI
    POP CX
    POP BX
RET
L_SHOW ENDP

QPHCODE ENDS
END QPH
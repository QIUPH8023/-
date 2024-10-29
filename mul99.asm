QPHSEG SEGMENT
    number dw ?,?,?,?     ;存乘数被乘数
    buf db ?,?,?,?        ;缓存转换出的数字
    CRLF db 13,10,'$'
QPHSEG ENDS

QPHCODE SEGMENT
    ASSUME CS:QPHCODE,DS:QPHSEG
qph:
    MOV AX,QPHSEG
    MOV DS,AX
    
    call showNine
    
    MOV AH,4CH
    INT 21H
      

SHOWNINE PROC 
    mov cx,9            ;外层循环
s1:
    mov [number],cx       ;存乘数
    push cx                ;保存外层计数
    push cx                 ;乘数进栈
      
   s2:                    ;内层循环，循环次数由外层循环来决定,所以cx不动
       ;显示乘数
       mov     dx,[number]        
       add     dx,30h            ;转换成ASCII
       mov     ah,2
       int     21h
       
       ;显示*
       mov     dl,002ah        
       mov     ah,2
       int     21h

       ;显示第二个乘数
       mov     [number+1],cx        
       push    cx            ;第二个乘数进栈
       mov     dx,cx
       add     dx,30h
       mov     ah,2
       int     21h

       ;显示=
       mov     dl,3dh                
       mov     ah,2
       int     21h
       
       ;计算两数相乘的结果，并显示
       pop     dx            ;取第二个乘数
       pop     ax            ;取第一个乘数
       push    ax             ;第一个乘数再进栈，下次内层循环中用

       
       mul     dx       ;相乘，结果放ax
           
       mov     bx,10        ;为除以10准备
       mov     si,2         ;循环2次，最大到十位、
   
      
    toDec:                  ;各位转换为数值
      mov     dx,0        
      div     bx           ;除10得到各个位上的数值
      mov     [buf+si],dl    ;余数为该位上的值，第一次循环为个位，第二次为十位...；放内存中
      dec     si            
      cmp     ax,0        ;商为0说明分解完了结束
      ja toDec
  
      
    output:                ;输出内存中存放的转换数值数
      inc     si
      mov     dl,[buf+si]
      add     dl,30h          ;转为ascii
      mov     ah,2
      int     21h
      cmp     si,2
      jb      output    
       
      
      mov     dl,20h
      mov     ah,2
      int     21h
  
   loop     s2                ;内层循环结束
           
    lea     dx,crlf        ;输出回车
    mov     ah,9
    int     21h

    pop     cx
    pop     cx             ;还原外层计数
       
loop     s1  

    RET
SHOWNINE ENDP

QPHCODE ENDS
    END qph
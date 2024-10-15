.model small
.stack 100h

.data
result dw 0  ; 用于存储结果

.code
main proc
    ; 初始化数据段
    mov ax, @data
    mov ds, ax

    ; 计算 1 + 2 + ... + 100
    mov ax, 0        ; 清零 AX
    mov cx, 100      ; 设置循环计数器为 100
    mov bx, 1        ; 初始化 BX 为 1

sum_loop:
    add ax, bx       ; 将 BX 的值加到 AX
    inc bx           ; BX 自增 1
    loop sum_loop    ; CX 自减，如果不为 0 则继续循环

    ; 将结果存储
    mov result, ax   ; 将最终结果存储到 result

    ; 打印结果
    call PrintNumber  ; 调用打印数字的子程序

    ; 程序结束
    mov ax, 4C00h    ; DOS 退出
    int 21h
main endp

; 子程序：将 AX 中的数字转换为字符串并打印
PrintNumber proc
    push ax          ; 保存 AX 的值
    push bx          ; 保存 BX 的值
    push dx          ; 保存 DX 的值
    push cx          ; 保存 CX 的值

    mov cx, 0        ; 清空 CX，准备计数数字位数
    mov bx, 10       ; 除法基数
    xor dx, dx       ; 清空 DX

convert_loop:
    test ax, ax      ; 检查 AX 是否为 0
    jz print_loop     ; 如果 AX 为 0，则跳转到打印循环

    div bx           ; AX / 10，商在 AX，余数在 DX
    push dx          ; 保存余数
    inc cx           ; 位数加 1
    xor dx, dx       ; 清空 DX
    jmp convert_loop  ; 循环

print_loop:
    pop dx           ; 获取余数
    add dl, '0'      ; 转换为字符
    mov ah, 02h      ; DOS 输出字符的功能
    int 21h          ; 调用中断以打印字符
    loop print_loop   ; 打印所有位数

    ; 恢复寄存器
    pop cx           ; 恢复 CX 的值
    pop dx           ; 恢复 DX 的值
    pop bx           ; 恢复 BX 的值
    pop ax           ; 恢复 AX 的值
    ret
PrintNumber endp

end main

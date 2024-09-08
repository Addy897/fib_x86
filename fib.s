section .data
	inp db "Enter number of fibonacci sequence to print: ",0
	int_err db "Invalid Number",0xa,0
	num1 dd 0
	num2 dd 1

section .bss
	num resb 16
section .text
global _start

_start:
	push inp
	call printa
	push 16
	push num
	call _input
	call _toint
	.loop:
		cmp eax ,0
		jle exit
		push eax
		mov eax,[num1]
		add eax,[num2]
		mov ebx,[num2]
		mov [num1],ebx
		mov [num2],eax
		push eax
		call _toStr
		push eax
		call printa
		pop eax
		pop eax
		pop eax
		dec eax
		jmp .loop
	
	jmp exit

	

_input:
	push ebp
	mov ebp,esp
	mov eax,3
	mov ebx,0
	mov ecx,[ebp+0x8]
	mov edx,[ebp+0xc]
	int 0x80
	pop ebp
	ret

_toint:
	push ebp
	mov ebp,esp
	mov ebx,[ebp+0x8]
	mov edx,0
	.loop:
		cmp byte [ebx],0xa
		je .done
		mov eax,[ebx]
		sub al,'0'
		cmp al,0
		jl .error
		cmp al,9
		jg .error
		imul edx,10
		add dl,al
		inc bl
		jmp .loop
	.error:
		push int_err
		call printa
		jmp exit		
	
	.done:
		mov eax,edx
		pop ebp
		ret
exit:
	mov eax,1
	mov ebx,1
	int 0x80		
printa:
	push ebp	
	mov ebp,esp
	mov ecx,[ebp+0x8]
	.loop:
		mov eax,4
		mov ebx,1
		cmp byte [ecx],0
		je .done
		mov edx,1
		int 0x80
		inc cl
		jmp .loop
		
	.done:
		pop ebp
		ret
_toStr:
	push ebp
        mov ebp ,esp
        mov eax,[ebp+0x8]
        lea edi, [num + 15]
        mov byte [edi], 0
	dec edi
	mov byte [edi],0xa
        cmp eax,0
        jl .negative
        push 1
        jmp .loop
        .negative:
                mov edx,-1
                imul edx
                push -1

        .loop:
                dec edi
                xor edx, edx
                mov ecx, 10
                div ecx
                add dl, '0'
                mov [edi], dl
                test eax, eax
                jnz .loop

        .done:
                pop edx
                cmp edx,-1
                je .l3
                jmp .l4
                .l3:
                        dec edi
                        mov byte [edi] ,'-'
                .l4:
                        mov eax,edi
                        mov esp,ebp
                        pop ebp
                        ret         

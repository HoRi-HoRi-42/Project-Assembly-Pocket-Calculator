.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf:proc
extern fopen:proc
extern fclose:proc
extern fprintf:proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data

meniu db "> Introduceti o operatie cu multimi:",10,"> 1. Verificare",10,"> 2. Apartenenta",10,"> 3. Reuniune",10,"> 4. Intersectie",10,"> 5. Iesire",10,0
format db "%d",0
formataf db "%d ",0
form_citire db "Introduceti un sir de caractere",10,0
format1 db "Introduceti nr. de elemente si apoi fiecare element unul cate unul:",10,0
format2 db "Element: ",0
format3 db "Elementul face parte din multime",10,0
format4 db "Elementul NU face parte din multime",10,0
caract db "%c",0
unic db "Multimea are elemente unice.",10,0
neunic db "Multimea nu are elemente unice.",10,0
vid db "Multimea de intersectie este vida",10,0
fisier db "Rezultat.txt",0
mode db "w",0
x db 0
n dd 0
n2 dd 0
n3 dd 0
el db 0
f dd 0
v db 100 dup(0)
v1 db 100 dup(0)
v2 db 100 dup(0)
v3 db 100 dup(0)
s db 200 dup(0)
frecv db 255 dup (0)


.code

menu proc
	push offset meniu ;afisare meniu prima data
	call printf
	add esp,4

	push offset x
	push offset format
	call scanf
	add esp,8
	ret
menu endp	


citire_v1 proc ;se citeste primul vector
	
	push ebp
	mov ebp, esp

	push offset format1
	call printf
	add esp,4
	
	push offset n
	push offset format
	call scanf
	add esp,8
	
	sub n,1
	mov esi,0
	mov edi,n
	bucla:
		
		push offset el
		push offset format
		call scanf
		add esp,8
		
		mov al,el
		mov v1[esi],al
		
		inc esi
		xor eax,eax
		mov eax,n
		
	cmp esi,eax
	jbe bucla
	
	mov esp, ebp
	pop ebp
	ret
citire_v1 endp

citire_v2 proc
	push ebp
	mov ebp, esp

	push offset format1
	call printf
	add esp,4
	
	push offset n2
	push offset format
	call scanf
	add esp,8
	
	sub n2,1
	mov edi,n2
	mov esi,0
	
	bucla:
		
		push offset el
		push offset format
		call scanf
		add esp,8
		
		mov al,el
		mov v2[esi],al
		
		inc esi
		xor eax,eax
		mov eax,n2
		
	cmp esi,eax
	jbe bucla
	
	
	
	mov esp, ebp
	pop ebp
	ret
citire_v2 endp


afisarev3 proc
	push ebp
	mov ebp, esp

	push offset mode
	push offset fisier
	call fopen
	add esp,8
	mov f,eax
	
	sub edi,1
	mov esi,0
	afisare:
		xor eax,eax
		mov al,v3[esi]
		push eax
		push offset formataf
		call printf
		add esp,8
		
		mov al,v3[esi]
		push eax
		push offset formataf
		push f
		call fprintf
		add esp,12
	
		inc esi
		xor eax,eax
		
		
	cmp esi,edi
	jbe afisare
	
	push 10
	push offset caract
	call printf
	add esp,8
	
	push f
	call fclose
	add esp,4
	
	
	mov esp, ebp
	pop ebp
	ret
afisarev3 endp	


verificare proc


	push ebp
	mov ebp, esp

	call citire_v1
	mov n,edi
	mov esi,0
	frecventa:
		
		xor eax,eax
		mov al,v1[esi]
		add frecv[eax],1
		
		inc esi
		xor eax,eax
		mov eax,edi
		
	cmp esi,eax
	jbe frecventa
	
	mov esi,0
	verif:
	
		xor eax,eax
		mov al,frecv[esi]
		cmp eax,1
		ja nope
		
		inc esi
	cmp esi,255
	jbe verif
	
	push offset unic
	call printf
	add esp,4
	
	
	push offset mode
	push offset fisier
	call fopen
	add esp,8
	mov esi,eax
	
	push offset unic
	push esi
	call fprintf
	add esp,8
	
	push esi 
	call fclose
	add esp,4
	
	jmp final
	
	nope:
		
	
		push offset neunic
		call printf
		add esp,4
		
		
		push offset mode
		push offset fisier
		call fopen
		add esp,8
		mov esi,eax
		
		
		push offset neunic
		push esi
		call fprintf
		add esp,8
		
		push esi
		call fclose
		add esp,4
	
	final:
	
	mov esi,0
	frecventa2:
		
		xor eax,eax
		mov al,0
		mov frecv[esi],al
		
		inc esi
	cmp esi,255
	jbe frecventa2
	
	mov esi,0
	reset:
		mov al,0
		mov v1[esi],0
		inc esi
	cmp esi,edi
	jbe reset
	
	
	mov esp, ebp
	pop ebp
	ret
verificare endp


apartenenta proc

	push ebp
	mov ebp, esp
	
	call citire_v1
	mov n,edi
	push offset format2
	call printf
	add esp,4
	
	push offset x
	push offset format
	call scanf
	add esp,8
	
	mov esi,0
	mov ebx,n
	bucla:
		xor eax,eax
		mov al,v1[esi]
		
		cmp al,x
		je yep
		
		inc esi
		xor eax,eax
		mov eax,n
		
	cmp esi,edi
	jbe bucla
	
	push offset format4
	call printf
	add esp,4
	
	push offset mode
	push offset fisier
	call fopen
	add esp,8
	mov esi,eax
	
	push offset format4
	push esi
	call fprintf
	add esp,8
	
	push esi 
	call fclose
	add esp,4
	jmp final
	
	yep:
	
		push offset mode
		push offset fisier
		call fopen
		add esp,8
		mov esi,eax
		
		push offset format3
		push esi
		call fprintf
		add esp,8
		
		push esi 
		call fclose
		add esp,4
	
		push offset format3
		call printf
		add esp,4
	
	final:
	
	mov esi,0
	reset:
		mov al,0
		mov v1[esi],0
		inc esi
	cmp esi,edi
	jbe reset
	
	
	
	mov esp, ebp
	pop ebp
	ret
apartenenta endp



reuniune proc
	push ebp
	mov ebp, esp

	
	call citire_v1
	mov ebx,edi
	call citire_v2
	mov edx,edi
	
	
	mov esi,0
	frecventa1:
		
		xor eax,eax
		mov al,v1[esi]
		add frecv[eax],1
		
		inc esi
		
		
	cmp esi,ebx
	jbe frecventa1
	
	mov esi,0
	frecventa2:
		
		xor eax,eax
		mov al,v2[esi]
		add frecv[eax],1
		
		inc esi
		
	cmp esi,edx
	jbe frecventa2
		
		
	mov esi,0
	mov ecx,0	
	loop1:
	
		xor eax,eax
		mov al,frecv[esi]
		cmp eax,1
		jb nope
			mov eax,esi
			mov v3[ecx],al
			inc ecx
		nope:
		inc esi
	cmp esi,255
	jbe loop1
	
	mov edi,ecx
	
	call afisarev3
	mov edx,n2
	mov esi,0
	reset:
		
		mov v1[esi],0
		inc esi
	cmp esi,ebx
	jbe reset
	
	mov esi,0
	reset2:
		
		mov v2[esi],0
		inc esi
	cmp esi,edx
	jbe reset2
	
	mov esi,0
	frecventareset:
		mov frecv[esi],0
		inc esi
	cmp esi,255
	jbe frecventareset
	
	mov esp, ebp
	pop ebp
	ret

reuniune endp



intersectie proc
	push ebp
	mov ebp, esp

	call citire_v1
	mov ebx,edi
	call citire_v2
	mov edx,edi
	
	mov esi,0
	frecventa1:
		
		xor eax,eax
		mov al,v1[esi]
		add frecv[eax],1
		
		inc esi
		
		
	cmp esi,ebx
	jbe frecventa1
	
	mov esi,0
	frecventa2:
		
		xor eax,eax
		mov al,v2[esi]
		add frecv[eax],1
		
		inc esi
		
	cmp esi,edx
	jbe frecventa2
	
	mov esi,0
	mov ecx,0	
	loop1:
	
		xor eax,eax
		mov al,frecv[esi]
		cmp eax,2
		jb nope
			mov eax,esi
			mov v3[ecx],al
			inc ecx
		nope:
		inc esi
	cmp esi,255
	jbe loop1
	
	mov edi,ecx
	cmp edi,0
	jz vida
	
	call afisarev3
	jmp resetare
	
	
	vida:
	push offset vid
	call printf
	add esp,4
	
	push offset mode
	push offset fisier
	call fopen
	add esp,8
	mov esi,eax
	
	push offset vid
	push esi
	call fprintf
	add esp,8
	
	p
	
	push esi 
	call fclose
	add esp,4
	
	
	resetare:
	
	mov edx,n2
	mov esi,0
	reset:
		
		mov v1[esi],0
		inc esi
	cmp esi,ebx
	jbe reset
	
	mov esi,0
	reset2:
		
		mov v2[esi],0
		inc esi
	cmp esi,edx
	jbe reset2
	
	mov esi,0
	frecventareset:
		mov frecv[esi],0
		inc esi
	cmp esi,255
	jbe frecventareset
	
	mov esp, ebp
	pop ebp
	ret
intersectie endp



citire_vector proc
	push ebp
	mov ebp, esp
	
	push offset form_citire
	call printf
	add esp,4
	
	push offset s
	call gets
	add esp,4

	xor esi,esi
	mov edi,-1
	parsare:
	
		cmp s[esi],0
		jz final
		
		cmp s[esi],32
		jz spatiu
			inc edi
			mov al,s[esi]
			mov v[edi],al
		
		spatiu:
		inc esi
	jmp parsare	 
	
	
	final:
	
	mov esp, ebp
	pop ebp
	ret
citire_vector endp
	





start:

	mov eax,0
	xor eax,eax
	call menu
	
	bucla:
	
		xor eax,eax
		mov al,x
		cmp al,5
		je iesire

		mov al,x
		cmp al,1
		jne urm1
			
			call verificare
			jmp af_menu
		
		urm1:
		mov al,x
		cmp al,2
		jne urm2
		
			call apartenenta
			jmp af_menu
		
		urm2:
		mov al,x
		cmp al,3
		jne urm3
		
			call reuniune
			jmp af_menu
		
		urm3:
			call intersectie
			
		af_menu:
		call menu
	
	jmp bucla
			
	
	iesire:
	push 0
	call exit
end start

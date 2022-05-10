.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf:proc
extern gets:proc
extern fopen:proc
extern fclose:proc
extern fprintf:proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data


meniu db 10,"> Introduceti o operatie cu multimi:",10,"> 1. Verificare",10,"> 2. Apartenenta",10,"> 3. Reuniune",10,"> 4. Intersectie",10,"> 5. Iesire",10,0
format db "%d",0
formataf db "%c ",0
formatchar db "%c",0
form_citire db 10,"Introduceti un sir de caractere",10,0
eroare db "Multimea introdusa nu poate fi parsata, va rugam sa o introduceti din nou",10,0
format1 db "Introduceti nr. de elemente si apoi fiecare element unul cate unul:",10,0
format2 db "Element: ",0
format3 db "Elementul face parte din multime",10,10,0
format4 db "Elementul NU face parte din multime",10,10,0
formatneunic db "Multimea introdusa nu are elemente unice, va rugam sa introduceti alta multime",10,0
caract db "%c",0
unic db "Multimea are elemente unice.",10,10,0
neunic db "Multimea nu are elemente unice.",10,10,0
vid db "Multimea de intersectie este vida",10,10,0
fisier db "Rezultat.txt",0
primamul db "Prima multime este: ",0
douamul db "A doua multime este : ",0
reuniunea db "Reuniunea: ",0
inter db "Intersectia: ",0
mode db "a",0
modewr db "w",0
vunic dd 0
dimv1 dd 0
dimv2 dd 0
x db 0
n dd 0
n2 dd 0
n3 dd 0
el db 0
f dd 0
newline dd 10
v db 100 dup(0)
v1 db 100 dup(0)
v2 db 100 dup(0)
v3 db 100 dup(0)
s db 200 dup(0)
frecv db 255 dup (0)


.code

menu proc
	push offset meniu ;afisare meniu 
	call printf
	add esp,4

	push offset x ; citim optiunea utiliz.
	push offset format
	call scanf
	add esp,8
	ret
menu endp	

citire_vector proc
	push ebp
	mov ebp, esp
	
	push offset form_citire ;afisam un mesaj pe ecran pt utiliz.
	call printf
	add esp,4
	
	recitire:
	push offset s ;citim in s stringul initial
	call gets
	add esp,4
	
	xor esi,esi
	xor edi,edi
	parsare:
	
		cmp s[esi],0 ;verificam daca am ajuns sau nu la finalul stringului
		jz final
		
		cmp s[esi],32
		jz spatiu ;daca avem spatiu, sarim peste el
			
			mov al,s[esi]
			mov v[edi],al ; punem elemntul in vectorul destinatie
			inc edi ;crestem contorul nr de elemente
		spatiu:
		inc esi ;trecem la urm. pozitie din string
	jmp parsare	 
	
	
	final:
	
	cmp edi,0 ;verificam daca stringul a putut fi parsat
	jne ok 
		push offset eroare ;afisam un mesaj de eroare si sarim inapoi la citire pt a citi o noua multime
		call printf
		add esp,4
		jmp recitire
	
	ok:
	
	mov esp, ebp
	pop ebp
	ret
citire_vector endp


afisarevector proc
	push ebp
	mov ebp, esp

	push offset mode ;deschidem fisierul de afisare
	push offset fisier
	call fopen
	add esp,8
	mov f,eax
	
	mov esi,0
	afisare:
		xor eax,eax
		mov al,v[esi] ;afisam pe ecran elementul
		push eax
		push offset formataf
		call printf
		add esp,8
		
		mov al,v[esi]
		push eax ;afisam in fisier elementul
		push offset formataf
		push f
		call fprintf
		add esp,12
	
		inc esi
	cmp esi,edi
	jbe afisare
	
	push 10 ;trecem la linie noua pe ecran
	push offset caract
	call printf
	add esp,8
	
	push 10 ;trecem la linie noua pe in fisier
	push offset caract 
	push f
	call fprintf
	add esp,8
	
	push f ;inchidem fisierul
	call fclose
	add esp,4
	
	mov esp, ebp
	pop ebp
	ret
afisarevector endp	


verificare proc
	push ebp
	mov ebp, esp
	
	mov n,edi ;punem lugimea vectorului in n
	mov esi,0
	frecventa:
		
		xor eax,eax
		mov al,v[esi]
		add frecv[eax],1 ;pentru elementul cu codul ascii din v[esi] punem la indicele codului in vect. frecventa +1
		
		inc esi
		xor eax,eax
		mov eax,edi
		
	cmp esi,eax ;vedem daca am ajuns la finalul vectorului, daca nu repetam procesul
	jbe frecventa
	
	mov esi,0
	verif: ;parcurgem vectorul de frecventa si vedem daca exista vreo pozitie cu valoarea >=2 inseamna ca elementele nu sunt unice si afisam un mesaj corespunzator
	
		xor eax,eax
		mov al,frecv[esi]
		cmp eax,1 
		ja nope ;multimea nu are elem unice, sarim la afisarea mesajului
		
		inc esi
	cmp esi,255
	jbe verif
	
	xor ebx,ebx
	mov ebx,1
	mov vunic,ebx
	
	jmp final ; sarim la final, peste cazul de neunicitate
	
	nope: ;afisarea mesajelor in caz de neunicitate
		
		xor ebx,ebx
		mov ebx,0
		mov vunic,ebx
	final:
	
	mov esi,0 ;resetam vectorii pt utilizatoarea ulterioara
	frecventa2:
		
		xor eax,eax
		mov al,0
		mov frecv[esi],al
		
		inc esi
	cmp esi,255
	jbe frecventa2
	
	mov esp, ebp
	pop ebp
	ret
verificare endp


apartenenta proc
	push ebp
	mov ebp, esp
	
	push offset mode
	push offset fisier
	call fopen
	add esp,8
	mov esi,eax
	
	push offset format2 ;afisam mesaje pe ecran si in fisier pt introducerea unui element de cautat in multime
	call printf
	add esp,4
	
	push offset format2
	push esi
	call fprintf
	add esp,8
	
	push offset x ;citim elementul de cautat, si in plus il vom si scrie in fisier
	push offset formatchar
	call scanf
	add esp,8
	
	xor ebx,ebx
	mov bl,x
	push ebx
	push offset formataf
	push esi
	call fprintf
	add esp,12
	
	push newline ;linie noua in fisier
	push offset formatchar
	push esi
	call fprintf
	add esp,8
	
	push esi
	call fclose
	add esp,4
	
	mov esi,0
	mov ebx,n
	bucla: ;parcurgem vectorul si il cautam pe x
		xor eax,eax
		mov al,v[esi]
		
		cmp al,x
		je gasit ;daca l-am gasit sarit la sectiunea ce afiseaza mesajele corespunzatoare
		
		inc esi
	cmp esi,edi
	jbe bucla
	
	push offset format4 ;daca am ajuns in acest punct inseamna ca elementul x nu a fost gasit si se afiseaza mesajele corespunzatoare
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
	
	gasit: ;sectiunea de afisare a mesajelor in caz de element gasit
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
	final: ;aici restem vectorul pt. ulilizarea ulterioara
	
	mov esi,0
	reset:
		mov al,0
		mov v[esi],0
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

	mov esi,0
	frecventa1: ;punem elementele din prima multime in vectorul de frecventa
		
		xor eax,eax
		mov al,v1[esi]
		add frecv[eax],1
		
		inc esi
	cmp esi,ebx
	jbe frecventa1
	
	mov esi,0
	frecventa2: ;punem elementele din a doua multime in vectorul de frecventa
		
		xor eax,eax
		mov al,v2[esi]
		add frecv[eax],1
		
		inc esi
	cmp esi,edx
	jbe frecventa2
		
	mov esi,0
	mov ecx,0	
	loop1: ;parcurgem vectorul de frecventa si pt toate pozitiile din acesta care au valorii >=1 punem indicii in vectorul pt. elemntele reunite ale celor doua multimi(vectorul v)
	
		xor eax,eax
		mov al,frecv[esi]
		cmp eax,1
		jb nope
			mov eax,esi
			mov v[ecx],al
			inc ecx
		nope:
		inc esi
	cmp esi,255
	jbe loop1
	
	sub ecx,1
	mov edi,ecx
	
	call afisarevector ;afisam acest vector pe ecran si in fisier
	
	push offset mode
	push offset fisier
	call fopen
	add esp,8
	mov f,eax
	
	push newline ;punem linie noua in fisier
	push offset formatchar
	push f
	call fprintf
	add esp,12
	push f
	
	call fclose
	add esp,4
	
	
	mov esi,0 ;resteam vectorii la 0 pt. reutilizare
	reset:
		
		mov v1[esi],0
		inc esi
	cmp esi,ebx
	jbe reset
	
	mov esi,0
	
	mov edx,dimv2
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

	mov esi,0
	frecventa1: ;punem elementele din prima multime in vectorul de frecventa
		
		xor eax,eax
		mov al,v1[esi]
		add frecv[eax],1
		
		inc esi
	cmp esi,ebx
	jbe frecventa1
	
	mov esi,0
	frecventa2: ;punem elementele din a doua multime in vectorul de frecventa
		
		xor eax,eax
		mov al,v2[esi]
		add frecv[eax],1
		
		inc esi
		
	cmp esi,edx
	jbe frecventa2	
		
	mov esi,0
	mov ecx,0	
	loop1: ;parcurgem vectorul de frecventa si pt toate pozitiile din acesta care au valorii >=2 punem indicii in vectorul pt. elemntele intersectate ale celor doua multimi(vectorul v)
	
		xor eax,eax
		mov al,frecv[esi]
		cmp eax,2
		jb nope
			mov eax,esi
			mov v[ecx],al
			inc ecx
		nope:
		inc esi
	cmp esi,255
	jbe loop1
	
	mov edi,ecx
	cmp edi,0
	jz vida ;verificam daca multimea de intersectie este vida, iar daca da sarim la sectiunea ce afiseaza mesajele coresp
	
	sub edi,1 ;afisam vectorul intersectie
	call afisarevector
	
	push offset mode ;trecem la linie noua in fisier
	push offset fisier
	call fopen
	add esp,8
	mov f,eax
	
	push newline
	push offset formatchar
	push f
	call fprintf
	add esp,12
	
	push f
	call fclose
	add esp,4
	
	jmp reset ;sarim la sectiunea pt resetarea vectorilor la 0
	
	vida: ;afisarea mesajelor pt multime de intersectie vida
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
	
	push esi 
	call fclose
	add esp,4
	
	mov edx,dimv2
	mov esi,0
	reset: ;sectiunea de resetare a vectorilor
		
		mov v1[esi],0
		inc esi
	cmp esi,ebx
	jbe reset
	
	mov esi,0
	mov edx,dimv2
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


golire_v proc

	mov esi,0
	bucla_reset:
		mov v[esi],0
		inc esi
	cmp esi,99
	jne bucla_reset
	
golire_v endp	

start:

	push offset modewr 
	push offset fisier
	call fopen ;deschidem la inceput fisierul si stergem continutul lui
	add esp,8
	mov f,eax
	
	call menu ;apelam meniul iar aceasta va returna in x optiunea aleasa de utiliz
	
	bucla:
	
		xor eax,eax
		mov al,x
		cmp al,5
		je iesire ;pt 5 iesim din program

		mov al,x
		cmp al,1
		jne urm1 ;pt 1 facem verificarea de multime
			
			push offset s
			call gets ;golim bufferul e citire (nu merge bine daca nu fac asta)
			add esp,4
			
			call citire_vector ;citim multimea
			
			sub edi,1 ;scadem 1 din dimensiunea vectorului deoarece se incrementeaza inca o data in plus
			call afisarevector ;afisam multimea
			
			call verificare ;apelam procedura de verificare a elementelor unice
			
			push offset mode ;deschidem fisierul pt afisare
			push offset fisier
			call fopen
			add esp,8
			mov esi,eax
			
			mov eax,vunic ;procedura de verificare returneaza in vunic 1 daca multimea are elem. unice si 0 in caz contrar. In fiecare caz afisam mesaje corespunzatoare pe ecran si in fisier
			cmp eax,0
			je nu_e_unica
				push offset unic
				call printf
				add esp,4
				
				push offset unic
				push esi
				call fprintf
				add esp,8
				jmp peste
			nu_e_unica:	;
				push offset neunic
				call printf
				add esp,4
				
				push offset neunic
				push esi
				call fprintf
				add esp,8
		
			peste:
			push esi
			call fclose
			add esp,4
			
			jmp af_menu; sarim la apelarea meniului
		
		urm1:
		mov al,x
		cmp al,2
		jne urm2 ;pt 2 facem apartenenta unui element
		
			push offset s
			call gets ;golim bufferul e citire (nu merge bine daca nu fac asta)
			add esp,4
			
			citirea:
			
			call citire_vector ;citim o multime
			sub edi,1
			
			call verificare ;verificam unicitatea elementelor
			
			mov eax,vunic ;daca multimea nu are lemente unice, obligam utilizatorul sa introduca din nou o multime pana are elemente unice
			cmp eax,0
			jne vect_ok
				push offset formatneunic ;afisam un mesaj pt. a cere introd. unei noi multimi
				call printf
				add esp,4
				jmp citirea ;sarim la citire
			
			vect_ok: ;daca multimea are elemnte unice o afisam si facem apartenenta
			call afisarevector
			
			call apartenenta
			jmp af_menu
		
		urm2: ;reuniunea a doua multimi
		mov al,x
		cmp al,3
		jne urm3
		
			push offset s
			call gets ;golim bufferul e citire (nu merge bine daca nu fac asta)
			add esp,4
			
			citire_v1:
			call citire_vector ;citim prima multime
			
			call verificare ;verificam unicitatea elementelor
			
			mov eax,vunic ;daca multimea nu are lemente unice, obligam utilizatorul sa introduca din nou o multime pana are elemente unice
			cmp eax,0
			jne v1_ok
				push offset formatneunic ;afisam un mesaj pt. a cere introd. unei noi multimi
				call printf
				add esp,4
				
				mov esi,0 ;resetam vectorul in care am citit(am incercat sa fac cu o procedura dar ceva numergea bine asa ca am pus direct codul aici :( )
				bucla_reset:
					mov v[esi],0
					inc esi
				cmp esi,99
				jne bucla_reset
				
				jmp citire_v1 ;recitim
			
			v1_ok: ;daca multimea are elem. unice continuam executia
			
			mov ebx,edi
			mov ecx, edi
			lea ESI, v
			lea EDI, v1
			rep movsb ;mutam multimea in vectorul propriu-zis cuu care vom lucra(v1)
			
			mov edi,ebx
			sub edi,1
			mov dimv1,edi ;lungimea multimii
			

			call afisarevector ;afisam multimea
			
			citire_v2: ;citirea celei de-a doua multimi
			call citire_vector 
			
			call verificare ;verificam unicitatea elementelor
			
			mov eax,vunic ;daca multimea nu are lemente unice, obligam utilizatorul sa introduca din nou o multime pana are elemente unice
			cmp eax,0
			jne v2_ok
				push offset formatneunic
				call printf
				add esp,4
				
				mov esi,0
				bucla_reset2:
					mov v[esi],0
					inc esi
				cmp esi,99
				jne bucla_reset2
				
				jmp citire_v2 ;sarim din nou la citire
			
			v2_ok:
			
			mov ebx,edi
			mov ecx, edi
			lea ESI, v
			lea EDI, v2
			
			rep movsb ;mutam multimea in vectorul propriu-zis(v2)
			
			mov edi,ebx
			sub edi,1
			
			mov dimv2,edi
			call afisarevector ;afisam multimea
			
			push offset mode
			push offset fisier
			call fopen
			add esp,8
			mov f,eax
			
			push offset reuniunea ;afisam mesaje pe ecran si in fisier numele operatiei
			push f
			call fprintf
			add esp,8
			
			push f
			call fclose
			add esp,4
			
			push offset reuniunea
			call printf
			add esp,4
			
			
			
			mov ebx,dimv1 ;mutam dimensiunile multimilor in registrii pe care ii voi utiliza in functie pt dimensiunea lor
			mov edx,dimv2
			call reuniune ;apelam functia de reuniune a multimilor
			jmp af_menu
		
		urm3: ; intersectia a doua multimi
		
			push offset s
			call gets
			add esp,4
			
			citire_v1_intersectie: ;citirea primei multimi
			call citire_vector 
			
			call verificare ;verificam unicitatea elementelor
			
			mov eax,vunic ;daca multimea nu are lemente unice, obligam utilizatorul sa introduca din nou o multime pana are elemente unice
			cmp eax,0
			jne v1_ok2
				push offset formatneunic
				call printf
				add esp,4
				
				mov esi,0
				bucla_reset3:
					mov v[esi],0
					inc esi
				cmp esi,99
				jne bucla_reset3
				
				jmp citire_v1_intersectie
			
			v1_ok2: ;daca multimea are elemente unice atunci o copieam in vectorul v1
			
			mov ebx,edi
			mov ecx, edi
			lea ESI, v
			lea EDI, v1
			
			rep movsb 
			
			mov edi,ebx
			sub edi,1
			mov dimv1,edi
			

			call afisarevector ;afisam multimea pe ecran si in fisier
			
			citire_v2_inter: ;citirea celei de-a doua multimi cu care procedam la fel ca si la prima pt verificarea unicitatatii
			call citire_vector 
			
			call verificare
			
			mov eax,vunic
			cmp eax,0
			jne v2_ok2
				push offset formatneunic
				call printf
				add esp,4
				
				mov esi,0
				bucla_reset4:
					mov v[esi],0
					inc esi
				cmp esi,99
				jne bucla_reset4				
				jmp citire_v2_inter
			
			v2_ok2:
			mov ebx,edi
			mov ecx, edi
			lea ESI, v
			lea EDI, v2
			
			rep movsb ;daca multimea are elemente unice atunci o copieam in vectorul v2
			
			
			mov edi,ebx
			sub edi,1
			
			mov dimv2,edi
			call afisarevector  ;afisam multimea pe ecran si in fisier
			
			push offset mode ;deschidem fisierul cu append
			push offset fisier
			call fopen
			add esp,8
			mov f,eax
			
			push offset inter ;afisam mesjul ce spune utilizatorului ce operatie se efectueaza pe ecran si in fisier
			push f
			call fprintf
			add esp,8
			
			push f
			call fclose
			add esp,4
			
			push offset inter ;mesaj pe ecran
			call printf
			add esp,4
			
			mov ebx,dimv1 ;punem lungimile vect. in registrii pe care ii voi folosi
			mov edx,dimv2
			call intersectie ;functia care face intersectia
			
		af_menu: ;afisarea meniului si citirea optiunii utilizatorului
		call menu
	
	jmp bucla
			
	iesire:
	push 0
	call exit
end start

.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern scanf: proc
extern printf: proc
extern malloc: proc
extern memset: proc
extern memcpy: proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data

;aici declaram date

x1 dd 0
x2 dd 0
y1 dd 0
y2 dd 0
xaux dd 0
yaux dd 0
n dd 0
m dd 0
intreg dd 0
aux2 dd 0
aux3 dd 0
aux4 dd 0
aux5 dd 0
aux6 dd 0
patru dd 4
i dd 0
j dd 0
max dd 0
res dd ?

matrice dd 400 dup(?)
matrice2 dd 400 dup(?)
matrice3 dd 400 dup(?)
rez dd 400 dup(?)
aux dd 400 dup(?)
auxmatrix dd 400 dup(0)
invers dd 400 dup(0)

read1 db "1) Citirea unei matrici de la tastatura", 13, 10, 0
read2 db "2) Citirea altei matrici de la tastatura", 13, 10, 0
print1 db "3) Afisarea unei matrici pe ecran", 13, 10, 0
print2 db "4) Afisarea altei matrici pe ecran", 13, 10, 0
adun db "5) Calculul sumei a doua matrici", 13, 10, 0
minus db "6) Negarea unei matrici", 13, 10, 0
dif db "7) Scaderea a doua matric ", 13, 10, 0
prod db "8) Produsul a doua matrici", 13, 10, 0
scl db "9) Calculul produsului dintre o matrice si un scalar", 13, 10, 0
pow db "10) Ridicarea la o putere intreaga a unei matrici", 13, 10, 0
dete db "11) Calculul determininantului unei matrici", 13, 10, 0
urma_ db "12) Calculul urmei unei matrici patratice", 13, 10, 0
conv_ db "13) Calculul convolutiei a doua matrici", 13, 10, 0
help_ db "14) help", 13, 10, 0
iesire db "15) exit", 13, 10, 0
suplimentar_maxim db "16) Afisarea elementului maxim dintr-o matrice", 13, 10, 0
invers_ db "17) Inversa unei matrici", 13, 10, 0
transp_ db "18) Transpusa unei matrici", 13, 10, 0
submat_ db "19) Submatricea unei matrici", 13, 10, 0
mesajf db "Elementul maxim este %d", 0
eroare db "Eroare: nr de linii e diferit de nr de coloane"
detMsg db "Determinantul este: %d", 13, 10, 0
detMsg2 db "Determinantul este: 1/%d", 13, 10, 0
valoare dd '?'
nou db " ",13, 10, 0
help_fereastra db "Pentru a apela functiile, introdu numarul corespunzator dupa cum reiese din meniu. ",10," 1. Se va citi de la tastatura numarul de linii si numarul de coloane, dupa care se vor citi n*m fie secvential, fie separat. ",10,"2 Pentru operatiile binare pe matrici se poate citi o a doua matrice care are rol de al doilea operand.", 13, 10, 0
terminat db "Tocmai ai ales sa parasesti aplicatia", 13, 10, 0


fmt1 db "Scrie numarul de coloane n = ", 0
fmt12 db "Scrie numarul de linii m = ", 0
fmt2 db "%d", 0
fmt3 db "Scrie un numar intreg: ", 0
fmt4 db "Scrie linia de start: ", 0
fmt5 db "Scrie coloana de start: ", 0
fmt10 db "Scrie o putere: ", 0
format1 db " ", 0
format2 db "%d ", 13, 10, 0
format3 db "%d ", 0
power dd 0


.code

alocare macro n, m
	mov eax, n
	mov ebx, m
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
endm

citire macro n, m, matrice
local _loop

mov EAX, n
	mul m
	mov ecx, eax
	mov ebx,0
_loop:
	
	mov edx, offset matrice
	add edx,ebx
	pusha
	push edx
	push offset fmt2
	call scanf
	add esp, 8
	popa
	add ebx,4
loop _loop
endm

transpusa macro n, m, matrice, rez
local loopi, loopj
	
	mov ecx, 0
	loopi:
		mov aux2, ecx
		push ecx
		mov ebx, 0
		loopj:
			mov aux3, ebx
			push ebx
			
			lea edi, rez
			lea esi, matrice
			
			mov eax, aux2
			mov edx, 4
			mul edx
			
			mov edx, m
			mul edx ; eax = i * m * 4 => linia
			
			mov ecx, eax
			
			mov eax, aux3
			mov edx, 4
			mul edx
			
			add esi, ecx
			add esi, eax  ; => matrice[i][j]
			 
			 
			 
			mov edx, m
			mul edx ; linia j
			mov ebx, eax
			
			mov eax, ecx
			mov edx, 0
			mov ecx, m
			div ecx ; => elementul i
			
			add edi, ebx
			add edi, eax ;=> rez[j][i]
			
			mov ebx, [esi]
			mov [edi], ebx
		pop ebx
		inc ebx
		cmp ebx, m
		jl loopj
	pop ecx
	inc ecx
	cmp ecx, n
	jl loopi
endm

creare_matrice_identitate macro n, m, matrice
local _loop, bucla

	mov eax, m
	mov ebx, n
	mul ebx
	shl eax, 2
	push eax
	push 0
	push offset matrice
	call memset
	add esp, 12
	
	;lea esi, matrice
	;sub esi, 4
	mov ecx, 0
bucla:
	lea esi, matrice
	mov eax, ecx ; i * m * 4
	mov ebx, m
	mul ebx 
	mov ebx, 4
	mul ebx 
	
	push eax
	mov eax, ecx
	mov edx, 4
	mul edx
	mov edx, eax
	pop eax
	
	add eax, edx ; + i * 4
	
	add esi, eax
	
	mov eax, 1
	mov [esi], eax
	
	
	inc ecx
	cmp ecx, n
	jle bucla
endm


afisare macro n, m, matrice2
local _loop3, _loop3_end, print_with_newline2

mov EAX, n
	mul m
	mov ecx, eax
	mov ebx, 1
	lea esi, matrice2 ; pointer la matrice (primul element)
	
	_loop3:
	
	cmp ebx, n
	jz print_with_newline2
	
	pusha 
	push dword ptr [esi]
	push offset format3
	call printf
	add esp, 8
	popa
	
	jmp _loop3_end
	print_with_newline2:
	
	pusha 
	push dword ptr [esi]
	push offset format2
	call printf
	
	add esp, 8
	popa
	mov ebx, 0
	
	_loop3_end:
	add esi, 4
	inc ebx
	loop _loop3
endm

adunare macro n, m, matrice, matrice2
local bucla
mov eax, n
	mov ecx, m
	mul ecx
	mov ecx, eax
	mov esi, 0
bucla:
	
	mov eax, 0
	add eax, matrice[esi]
	add eax, matrice2[esi]
	mov matrice3[esi], eax
	mov eax, 0
	add esi, 4
	loop bucla
endm

negare macro n, m, matrice
local bucla
mov eax, n
	mov ecx, m
	mul ecx
	mov ecx, eax
	mov esi, 0
bucla:
	
	mov eax, 0
	sub eax, 1
	mul matrice[esi]
	mov matrice3[esi], eax
	mov eax, 0
	add esi, 4
	loop bucla
endm

mulintreg macro n, m, scalar, matrice
local bucla
mov eax, n
	mov ecx, m
	mul ecx
	mov ecx, eax
	mov esi, 0
	
bucla:
	
	mov eax, scalar
	mul matrice[esi]
	mov matrice3[esi], eax
	mov eax, 0
	add esi, 4
	loop bucla
endm

scadere macro n, m, matrice2, matrice
local bucla
mov eax, n
	mov ecx, m
	mul ecx
	mov ecx, eax
	mov esi, 0
bucla:
	
	mov eax, 0
	add eax, matrice[esi]
	sub eax, matrice2[esi]
	mov matrice3[esi], eax
	mov eax, 0
	add esi, 4
	loop bucla
endm

multiply macro n_, m_, rez, m1, m2
local bucla, bucla2, buclaColoane, buclaColoane2, final
	
	
	;mov ecx n    
	;cmp ecx, m
	;jnz final
	mov ecx, 0
bucla:
	
	mov y1, ecx
	push ecx
	
	mov ecx, 0
	buclaColoane:
		mov x1, ecx
		push ecx
		
		mov ecx, 0
		bucla2:
			mov x2, ecx
			
			mov y2, ecx
			push ecx
			
			lea esi, m1
			lea edi, m2
			lea ebx, rez
			
			mov eax, y1
			mov ecx, 4
			mul ecx
			mov ecx, m_
			mul ecx
			add esi, eax
			
			mov eax, x2
			mov ecx, 4
			mul ecx
			add esi, eax
			
			mov eax, x2
			mov ecx, 4
			mul ecx
			mov ecx, m_
			mul ecx
			add edi, eax
			
			mov eax, x1
			mov ecx, 4
			mul ecx
			add edi, eax
			
			mov eax, y1
			mov ecx, 4
			mul ecx
			mov ecx, m_
			mul ecx
			add ebx, eax
			
			mov eax, x1
			mov ecx, 4
			mul ecx
			add ebx, eax
			
			mov eax, [esi]
			mov ecx, [edi]
			mul ecx
			add [ebx], eax
			
		pop ecx
		inc ecx
		cmp ecx, n_
		jl bucla2
		
	pop ecx
	inc ecx
	cmp ecx, m_
	jl buclaColoane
	
	pop ecx
	inc ecx
	cmp ecx, n_
	jl bucla
;:final
	;push offset eroare
	;call printf
	;add esp, 4
endm

urma macro n, m, matrice, track
local bucla7
	mov track, 0
	lea esi, matrice
	sub esi, 4
	mov ecx, 0
bucla7:
	
	
	mov eax, ecx
	mov ebx, m
	mul ebx 
	mov ebx, 4
	mul ebx 
	add eax, 4
	
	add esi, eax
	
	mov eax, [esi]
	add track, eax
	
	inc ecx
	cmp ecx, n
	jl bucla7
endm

putere macro n, m, matrice, rez, aux, power
local bucla6, exitPower
	creare_matrice_identitate n, m, rez
	
	mov ecx, 0
	cmp ecx, power
	jge exitPower
bucla6:
	push ecx
	
	mov eax, m
	mov ebx, n
	mul ebx
	shl eax, 2
	push eax
	push 0
	push offset aux
	call memset
	add esp, 12
	
	
	multiply n, m, aux, matrice, rez
	
	mov eax, n
	mov ebx, m
	mul ebx
	shl eax, 2
	push eax
	push offset aux
	push offset rez
	call memcpy
	add esp, 12
	
	afisare n, m, rez
	
	pop ecx
	inc ecx
	cmp ecx, power
	jl bucla6
exitPower:
endm

determinant macro n, m, det, matrice
local bucla, exitDet, det_2
	
	mov eax, n
	cmp m, eax
	jne exitDet
	
	mov det, 0

	cmp n, 2
	je det_2
	cmp n, 3
	jne exitDet
	;det3
	mov ebx, matrice[0]
	mov eax, matrice[16]
	mul ebx
	mov ebx, eax
	
	mov eax, matrice[32]
	mul ebx
	
	add det, eax
	
	
	mov ebx, matrice[12]
	mov eax, matrice[28]
	mul ebx
	mov ebx, eax
	
	mov eax, matrice[8]
	mul ebx
	
	add det, eax
	
	mov ebx, matrice[4]
	mov eax, matrice[20]
	mul ebx
	mov ebx, eax
	
	mov eax, matrice[24]
	mul ebx
	
	add det, eax
	
	
	
	mov ebx, matrice[8]
	mov eax, matrice[16]
	mul ebx
	mov ebx, eax
	
	mov eax, matrice[24]
	mul ebx
	
	sub det, eax
	
	
	mov ebx, matrice[0]
	mov eax, matrice[20]
	mul ebx
	mov ebx, eax
	
	mov eax, matrice[28]
	mul ebx
	
	sub det, eax
	
	
	mov ebx, matrice[4]
	mov eax, matrice[12]
	mul ebx
	mov ebx, eax
	
	mov eax, matrice[32]
	mul ebx
	
	sub det, eax
	jmp exitDet
	
	
	det_2:

	mov ebx, matrice[0]
	mov eax, matrice[12]
	mul ebx
	mov ebx, eax
	
	add det, eax
	
	
	mov ebx, matrice[4]
	mov eax, matrice[8]
	mul ebx
	mov ebx, eax
	
	sub det, eax

exitDet:
endm

submatrix macro n, m, matrice, i, j, n1, m1, rez
local loopi, loopj

	mov ecx, 0
	lea edi, rez
	loopi:
		mov intreg, ecx
		push ecx
		mov ecx, 0
		loopj:
			lea esi, matrice
		
			mov eax, i
			add eax, intreg
			mov ebx, m
			mul ebx
			shl eax, 2
			
			add esi, eax
			
			mov eax, ecx
			add eax, j
			shl eax, 2
			add esi, eax
			
			mov eax, [esi]
			mov [edi], eax
			
			add edi, 4
			
			
			inc ecx
			cmp ecx, m1
			jl loopj
	pop ecx
	inc ecx
	cmp ecx, n1
	jl loopi
endm

inmultDir macro n, m, matrice, matrice2, rez
local loopi, loopj
	lea esi, matrice
	lea edi, matrice2
	
	mov ecx, 0
	loopi:
		mov aux5, ecx
		push ecx
		
		mov ebx, 0
		
		loopj:
			mov eax, [esi]
			mov edx, [edi]
			mul edx
			
			mov aux4, eax
			
			lea ecx, rez
			
			mov eax, aux5
			mov edx, 4
			mul edx
			mov edx, m
			mul edx
			
			add ecx, eax
			
			mov eax, ebx
			mov edx, 4
			mul edx
			add ecx, eax
			
			mov eax, aux4
			mov [ecx], eax
		
		
			add esi, 4
			add edi, 4
			
			inc ebx
			cmp ebx, m
			jl loopj
		
	inc ecx
	cmp ecx, n
	jl loopi

endm

convolutie macro n, m, rez, matrice, n1, m1, matrice2, rez
local loopP, loopP2
	lea edi, matrice3
	
	mov eax, n1
	mov ebx, 2
	mov edx, 0
	div ebx
	
	mov ecx, eax
	loopP:
		mov aux2, eax

		mov eax, m1
		mov ebx, 2
		mov edx, 0
		div ebx
		
		mov ebx, eax
		loopP2:
			mov aux3, eax
			push ebx

			submatrix n, m, matrice, aux2, aux3, n1, m1, auxmatrix
			
			inmultDir n1, m1, auxmatrix, matrice2, auxmatrix
			
			lea esi, auxmatrix
			
			mov eax, n1
			mov edi, 2
			mov edx, 0
			div edi
			mov edx, 4
			mul edx
			mov edx, m1
			mul edx
			
			add esi, eax
			
			mov eax, m1
			mov edi, 2
			mov edx, 0
			div edi
			mov edx, 4
			mul edx
			
			add esi, eax
			
			mov eax, [esi]
			
			mov [edi], eax
			
			add edi, 4
			
			pop ebx
			inc ebx
			mov eax, m
			sub eax, aux3
			cmp ebx, eax
			jl loopP2:
			
			
	mov eax, n
	sub eax, aux2
	inc ecx
	cmp ecx, eax
	jl loopP
	
	
endm

comparareSir proc
	push esp
	mov esp, ebp
	
	mov esi, [esp + 8]
	mov edi, [esp + 12]
	
	comp_bucla:
        lodsb
        scasb             
        jne sirneegal     
        test eax, eax      
    jnz comp_bucla        
	mov eax, 5
	jmp final
	
	sirneegal:
	mov eax, 0
	
final:
	mov ebp,esp
	pop esp
	ret 10
comparareSir endp



linii_coloane macro n, m
	xor EAX, EAX
	xor EBX, EBX
	; printf("n = ");
	pusha
	push offset fmt1
	call printf
	add esp, 4
	; mov res, eax
	popa
	; scanf("%d", &n);
	pusha
	push offset n
	push offset fmt2
	call scanf
	add esp, 8
	popa
	
	; printf("m = ");
	pusha
	push offset fmt12
	call printf
	add esp, 4
	; mov res, eax
	popa
	
	; scanf("%d", &m);
	pusha
	push offset m
	push offset fmt2
	call scanf
	add esp, 8
	popa
endm

inversa macro n, m, matrice, maux, invers, aux2, xaux, yaux, aux3
local exit_invers
	mov eax, m
	cmp n, eax
	jne exit_invers
	
	transpusa n, m, matrice, maux
	
	determinant n, m, aux2, matrice
	
	mov eax, 0
	cmp aux2, eax
	je exit_invers
		
	mov eax, 2
	cmp n, eax
	jne auxM3
	
	
	mov eax, maux[0]
	mov invers[12], eax
	
	mov eax, 0
	sub eax, maux[4]
	
	mov invers[8], eax
	
	mov eax, 0
	sub eax, maux[8]
	
	mov invers[4], eax
	
	mov eax, maux[12]
	mov invers[0], eax
	
	jmp exit_invers
	
auxM3:	
	mov eax, 3
	cmp n, eax
	jne exit_invers
	
	
	mov eax, maux[16]
	mov auxmatrix[0], eax
	
	mov eax, maux[20]
	mov auxmatrix[4], eax
	
	mov eax, maux[28]
	mov auxmatrix[8], eax
	
	mov eax, maux[32]
	mov auxmatrix[12], eax
	
	mov eax, n
	dec eax
	mov xaux, eax
	
	mov eax, m
	dec eax
	mov yaux, eax
	
	mov aux3, 0
	
	determinant xaux, yaux, aux3, auxmatrix
	mov eax, aux3
	mov invers[0], eax
	
	
	mov eax, maux[12]
	mov auxmatrix[0], eax
	
	mov eax, maux[20]
	mov auxmatrix[4], eax
	
	mov eax, maux[24]
	mov auxmatrix[8], eax
	
	mov eax, maux[32]
	mov auxmatrix[12], eax
	
	mov aux3, 0
	
	determinant xaux, yaux, aux3, auxmatrix
	mov eax, 0
	sub eax, aux3
	mov invers[4], eax
	
	
	mov eax, maux[12]
	mov auxmatrix[0], eax
	
	mov eax, maux[16]
	mov auxmatrix[4], eax
	
	mov eax, maux[24]
	mov auxmatrix[8], eax
	
	mov eax, maux[28]
	mov auxmatrix[12], eax
	
	mov aux3, 0
	determinant xaux, yaux, aux3, auxmatrix
	mov eax, aux3
	mov invers[8], eax

	
	mov eax, maux[4]
	mov auxmatrix[0], eax
	
	mov eax, maux[8]
	mov auxmatrix[4], eax
	
	mov eax, maux[28]
	mov auxmatrix[8], eax
	
	mov eax, maux[32]
	mov auxmatrix[12], eax
	

	mov aux3, 0
	determinant xaux, yaux, aux3, auxmatrix
	xor eax, eax
	sub eax, aux3
	mov invers[12], eax
	

	
	mov eax, maux[0]
	mov auxmatrix[0], eax
	
	mov eax, maux[8]
	mov auxmatrix[4], eax
	
	mov eax, maux[24]
	mov auxmatrix[8], eax
	
	mov eax, maux[32]
	mov auxmatrix[12], eax
	
	mov aux3, 0
	determinant xaux, yaux, aux3, auxmatrix
	mov eax, aux3
	mov invers[16], eax
	
	
	
	mov eax, maux[0]
	mov auxmatrix[0], eax
	
	mov eax, maux[4]
	mov auxmatrix[4], eax
	
	mov eax, maux[24]
	mov auxmatrix[8], eax
	
	mov eax, maux[28]
	mov auxmatrix[12], eax
	

	mov aux3, 0
	determinant xaux, yaux, aux3, auxmatrix
	mov eax, 0
	sub eax, aux3
	mov invers[20], eax
	
	
	
	mov eax, maux[4]
	mov auxmatrix[0], eax
	
	mov eax, maux[8]
	mov auxmatrix[4], eax
	
	mov eax, maux[16]
	mov auxmatrix[8], eax
	
	mov eax, maux[20]
	mov auxmatrix[12], eax
	
	
	mov aux3, 0
	determinant xaux, yaux, aux3, auxmatrix
	mov eax, aux3
	mov invers[24], eax
	
	
	mov eax, maux[0]
	mov auxmatrix[0], eax
	
	mov eax, maux[8]
	mov auxmatrix[4], eax
	
	mov eax, maux[12]
	mov auxmatrix[8], eax
	
	mov eax, maux[20]
	mov auxmatrix[12], eax
	

	mov aux3, 0
	determinant xaux, yaux, aux3, auxmatrix
	mov eax, 0
	sub eax, aux3
	mov invers[28], eax
	
	
	mov eax, maux[0]
	mov auxmatrix[0], eax
	
	mov eax, maux[4]
	mov auxmatrix[4], eax
	
	mov eax, maux[12]
	mov auxmatrix[8], eax
	
	mov eax, maux[16]
	mov auxmatrix[12], eax
	
	mov aux3, 0
	determinant xaux, yaux, aux3, auxmatrix
	mov eax, aux3
	mov invers[32], eax
	
exit_invers:
endm


maxim macro matrix, nr_c, nr_l
local iesi, maxi, iesi1
push offset nou
	  call printf
	  add esp,4
mov ecx,-1
	  lea esi,matrix
	  
	  liniile:
	     inc ecx
		 mov edx,0
		 cmp ecx,nr_l
		 je iesi
	    coloanele:
		 push ecx
		 push edx
		 mov ebx,0
		 
		 mov edi,dword ptr [esi]
		 
		
		 pop edx
		 pop ecx
		 
		 add esi,4
		 inc edx
		 cmp edx,nr_c
		 je liniile
		 jmp coloanele
		 
	iesi:
	xor eax,eax
	mov i,-1
	et1:
	   inc i
	   mov j,0
	   mov edx,i
	   cmp edx,nr_l
	   je iesi1
	    et2:
		  mov eax,i
		  mul nr_c
		  add eax, j
		  mul patru
		  mov ebx,matrix[eax]
		  cmp ebx,max
		  jg maxi
		  nu_copiez:
		    inc j
			mov ecx,j
			cmp ecx,nr_c
			je et1
			jmp et2
		maxi: 
		  mov max,ebx
		  jmp nu_copiez
	iesi1:
	     push max 
		 push offset mesajf
		 call printf 
		 add esp,8
endm

start:

ajutor:
	
	
	
	push offset nou 
	call printf
	add esp, 4



	
	push offset read1
	call printf
	add esp,4
	push offset read2
	call printf
	add esp,4
	push offset print1
	call printf
	add esp,4
	push offset print2
	call printf
	add esp,4
	push offset adun
	call printf
	add esp,4
	push offset minus
	call printf
	add esp,4
	push offset dif
	call printf
	add esp,4
	push offset prod
	call printf
	add esp,4
	push offset scl
	call printf
	add esp,4
	push offset pow
	call printf
	add esp,4
	push offset dete
	call printf
	add esp,4
	push offset urma_
	call printf
	add esp,4
	push offset conv_
	call printf
	add esp,4
	push offset help_
	call printf
	add esp,4
	push offset iesire
	call printf
	add esp,4
	push offset suplimentar_maxim
	call printf
	add esp,4
	push offset invers_
	call printf
	add esp,4
	push offset transp_
	call printf
	add esp,4
	push offset submat_
	call printf
	add esp,4


meniu:
	push offset valoare
	push offset fmt2
	call scanf
	add esp,8
	
	mov edi,valoare
	  
	cmp edi,1
	je 	_citire1
	cmp edi,2
	je 	_citire2
	cmp edi,3
	je _afisare1
	cmp edi,4
	je _afisare2
	cmp edi,5
	je _adunare
	cmp edi,6
	je _negare
	cmp edi, 7
	je _diferenta
	cmp edi,8
	je _produs
	cmp edi,9
	je _intreg
	cmp edi,10
	je _putere
	cmp edi,11
	je _determinant
	cmp edi,12
	je _urma
	cmp edi,13
	je _convolutie
	cmp edi,14
	je _help
	cmp edi,15
	je _iesire
	cmp edi,16
	je _maxim
	cmp edi,17
	je _invers
	cmp edi,18
	je _transp
	cmp edi, 19
	je _submatr
	

	jmp ajutor
	
	
_citire1:
;m_si_n:
	linii_coloane n, m
;;/////////////////////////////////////////////////////////////////////////
	;citire matrice
	citire n, m, matrice
	;alocare matrice
	alocare n, m
	
	jmp ajutor
	
	
_citire2:
	alocare n, m
	citire n, m, matrice2
	;alocare n, m
	
	jmp ajutor
	
	
	
_afisare1: 
	afisare n, m, matrice
	;alocare matrice2
	
	jmp ajutor
	
	
	
_afisare2:
	afisare n, m, matrice2
	;alocare n, m
	
	jmp ajutor


	
	
_urma:
	urma n, m, matrice, res
	push res
	push offset fmt2
	call printf
	add esp,4 
	
	jmp ajutor
	

_identitate:
	creare_matrice_identitate n, m, matrice
	
	jmp ajutor
	
	
	
	
	
_putere:
	pusha
	push offset fmt10
	call printf
	add esp, 4
	; mov res, eax
	popa
	; scanf("%d", &n);
	pusha
	push offset power
	push offset fmt2
	call scanf
	add esp, 8
	popa
	putere n, m, matrice, rez, aux, power
	
	jmp ajutor
	
	
	
	

_determinant:
	determinant n, m, matrice, rez
	pusha
	push rez
	push offset detMsg
	call printf
	add esp, 8
	popa
	
	jmp ajutor
	
	
	
	

_produs:
	;inmultire
	multiply n, m, rez, matrice, matrice2
	;afisare suma matrici
	afisare n, m, rez
	
	jmp ajutor
	
	
	
	
_adunare:
	adunare n, m, matrice, matrice2
	;afisare suma matrici
	afisare n, m, matrice3
	
	jmp ajutor
	
	
	
_negare:
	;negarea unei matrici
	negare n, m, matrice
	afisare n, m, matrice3
	
	jmp ajutor
	
	
	
_intreg:
	; printf("scalar = ");
	pusha
	push offset fmt3
	call printf
	add esp, 4
	; mov res, eax
	popa
	; scanf("%d", &n);
	pusha
	push offset intreg
	push offset fmt2
	call scanf
	add esp, 8
	popa
	mulintreg n, m, intreg, matrice
	afisare n, m, matrice3
	
	jmp ajutor
	
_diferenta:
	scadere n, m, matrice2, matrice
	afisare n, m, matrice3
	
	jmp ajutor
	
_convolutie:



_maxim:
	maxim matrice, n, m
	
	jmp ajutor


_help:
	pusha
	push offset help_fereastra
	call printf
	add esp, 4
	; mov res, eax
	popa
	
	jmp ajutor
	
	
	
_invers:
	afisare n, m, matrice
	mov aux2, 0
	inversa n, m, matrice, aux, invers, aux2, xaux, yaux, aux3
	
	afisare n, m, invers
	
	pusha
	push aux2
	push offset detMsg2
	call printf
	add esp, 8
	popa
	
	jmp ajutor
	
_transp:
	transpusa n, m, matrice, invers
	
	afisare n, m, invers
	jmp ajutor
	
_submatr:
	;printf "i = "
	pusha
	push offset fmt4
	call printf
	add esp, 4
	popa
	
	;scanf i
	pusha
	push offset aux2
	push offset fmt2
	call scanf
	add esp, 8
	popa
	
	; printf j =
	pusha
	push offset fmt5
	call printf
	add esp, 4
	popa

	; scanf j
	pusha
	push offset aux3
	push offset fmt2
	call scanf
	add esp, 8
	popa
	
	; printf("n1 = ");
	pusha
	push offset fmt1
	call printf
	add esp, 4
	; mov res, eax
	popa
	; scanf("%d", &n);
	pusha
	push offset aux4
	push offset fmt2
	call scanf
	add esp, 8
	popa
	
	; printf("m1 = ");
	pusha
	push offset fmt12
	call printf
	add esp, 4
	; mov res, eax
	popa
	; scanf("%d", &n);
	pusha
	push offset aux5
	push offset fmt2
	call scanf
	add esp, 8
	popa
	
	submatrix n, m, matrice, aux2, aux3, aux4, aux5, invers
	
	afisare aux4, aux5, invers
	jmp ajutor


_iesire:
	pusha
	push offset terminat
	call printf
	add esp, 4
	; mov res, eax
	popa
	
	;aici se scrie codul
	
	;terminarea programului
	push 0
	call exit
end start

;;;;;;;;;;;---------------------------------------------------------------

path_in 	DB "in.bin",0
path_out2	DB "out2.txt",0
path_out	DB "out.txt",0
format_int  DB "%d ",0
format_str  DB "%s",0
new_line	DB 13,10,0
read_bin 	DB "rb",0
write	    DB "w",0
read        DB "r",0
file_ptr 	DD 0

n 			 DD 0
m 			 DD 0
value 		 DD 0
line_counter DD 0 
row_counter  DD 0
matrix 		 DD 0

.code

open_file MACRO path, open_mode
local execute
execute:
	push offset open_mode
	push offset path
	call fopen 
	add ESP, 8
	
	mov file_ptr, EAX
ENDM

init_value MACRO value, format, file
local execute
execute:
	push file
	push 1
	push 4
	push offset value
	call fread
	add ESP, 16
ENDM
; mat = malloc(lines*size_of*cols)
matrix_alloc MACRO mat, lines, cols, size_of
local allocate
allocate:
	xor EDX, EDX
	xor EAX, EAX
	
	mov EAX, lines
	imul cols
	
	shl EAX, size_of
	
	push EAX
	call malloc
	add ESP, 4
	
	mov mat, EAX
	
ENDM

get_entry MACRO mat, lines, col, i, j, value

local get_element

get_element:

    xor ESI, ESI
    xor EBX, EBX
	
    mov  EBX, i
    imul EBX, lines
    add  EBX, j
	imul EBX, 2
	
    mov ESI, EBX
    mov EDX, mat[ESI]
    mov word ptr[value], DX

ENDM

set_entry MACRO mat, lines, col, i, j, value

local set_element

set_element:

    xor EDI, EDI
    xor EBX, EBX
	
    mov  EBX, i
    imul EBX, lines
    add  EBX, j
	imul EBX, 2
	
    mov EDI, EBX
    mov DX, value
    mov word ptr[mat[EDI]], DX
ENDM

read_from_file MACRO file, mat, lines, cols, val

read_loop:
	push file
	push 1
	push 2
	push offset val
	call fread
	add ESP, 16
	
	test EAX, EAX
	cmp EAX, 1
	jne close_file
	
	pusha
		set_entry mat, lines, cols, line_counter, row_counter, word ptr[val]
	popa
	
	xor EAX, EAX
	mov EAX, row_counter
	inc EAX
	mov row_counter, EAX
	
	mov EBX, cols
	
	cmp EAX, EBX						; verificam daca am ajuns la capatul liniei
	jne read_loop
	
increment_line:
	mov row_counter, 0
	
	mov EAX, line_counter
	inc EAX
	mov line_counter, EAX
	
	mov EBX, lines
	cmp EAX, EBX
	jne read_loop

close_file:

	mov EAX, 0
	mov line_counter, 0 
	mov row_counter, 0

	push file
	call fclose
	add ESP, 4
ENDM

fwrite_value MACRO file, format, value
local execute
execute:
	push value
	push offset format
	push file
	call fprintf
	add ESP, 12
ENDM

print_matrix MACRO mat, n, m, file_ptr
local print_line, add_new_line, end_print, end_loop

	fwrite_value file_ptr, format_int, n
	fwrite_value file_ptr, format_int, m
	fwrite_value file_ptr, format_str, offset new_line
	
	xor EAX, EAX
    mov line_counter, EAX
    mov row_counter, EAX
	

print_line: 

	mov EAX, line_counter
	mov EDX, row_counter

	pusha
		get_entry mat, n, m, EAX, EDX, value
	popa
	
	pusha
		fwrite_value file_ptr, format_int, value
	popa
	
    mov ECX, row_counter
    inc ECX
    mov row_counter, ECX
	
    cmp ECX, m
    jnz print_line

add_new_line:

	mov ECX, line_counter
	inc ECX
    mov line_counter, ECX
	cmp ECX, n
	je end_loop
	
	pusha
		fwrite_value file_ptr, format_str, offset new_line
	popa
	
	xor EAX, EAX
	mov row_counter, EAX
	jmp print_line

end_loop:

    push file_ptr
    call fclose
    add ESP, 4

ENDM

is_square PROC
	push EBP
	mov EBP, ESP
	sub ESP, 8
	
	mov value, ECX
	
	cmp value, 0 
	je is_not_prime
	
	FINIT
	
	FILD value
	FSQRT
	FST qword ptr[EBP-8]
	
	cmp dword ptr[EBP-8], 0
	jne is_not_prime

	mov EAX, 1
	jmp end_function
	
is_not_prime:
	mov EAX, 0
	
end_function:
	mov ESP, EBP
	pop EBP
	ret 4
is_square ENDP

compute PROC
	push EBP
	mov EBP, ESP
	sub ESP, 12
	
	xor EAX, EAX
	mov row_counter, EAX
	mov line_counter, EAX
	
first_loop:
	mov ECX, line_counter
	
	push ECX
	call is_square
	
	cmp EAX, 1
	jne multiply
	
	pusha
		get_entry matrix, [EBP+12], [EBP+16], line_counter, row_counter, value
	popa
	
	mov EAX, value
	inc EAX
	mov value, EAX
	
	pusha 
		set_entry matrix, [EBP+12], [EBP+16], line_counter, row_counter, word ptr[value]
	popa
	
	jmp continue
	
multiply:
	pusha
		get_entry matrix, [EBP+12], [EBP+16], line_counter, row_counter, value
	popa
	
	xor EDX, EDX
	mov EAX, value
	imul EAX, 3
	mov value, EAX
	
	pusha 
		set_entry matrix, [EBP+12], [EBP+16], line_counter, row_counter, word ptr[value]
	popa
	
continue:

	mov EAX, row_counter
	inc EAX
	mov row_counter, EAX
	
	cmp EAX, [EBP+16]
	jne first_loop

next_line:
	mov EAX, 0 
	mov row_counter, 0
	
	mov EAX, line_counter
	inc EAX
	mov line_counter, EAX
	
	cmp EAX, [EBP+12]
	jne first_loop
	
end_function:
	mov ESP, EBP
	pop EBP
	ret 12
compute ENDP

rotate proc
	push EBP
	mov EBP, ESP
	
	sub ESP, 4
	mov dword ptr[EBP-4], 0

	
	mov EAX, 0 
	mov line_counter, 0
	
	mov EAX, [EBP+12]
	dec EAX
	mov row_counter, EAX
	
	open_file path_out, write

first_for_loop:
	pusha
		get_entry matrix, [EBP+12], [EBP+16], row_counter, line_counter, value	; in value am elementul matrix[linec][rowc]
	popa

	fwrite_value  file_ptr, format_int, value
	
	mov EAX, row_counter
	dec EAX
	mov row_counter, EAX
	
	cmp EAX, -1
	jne first_for_loop
	
first_for_loop_next_line:

	fwrite_value  file_ptr, format_str, offset new_line

	mov EAX, [EBP+12]
	dec EAX
	mov row_counter, EAX
	
	xor EAX, EAX
	mov EAX, line_counter
	inc EAX
	mov line_counter, EAX
	
	cmp EAX, [EBP+16]
	jne first_for_loop
	
	push file_ptr
	call fclose
	add ESP, 4
	
	open_file path_out, read
	
	xor EAX, EAX
	mov line_counter, 0 
	mov row_counter, 0
	jmp end_function
	
;; tenativa esuata asta cu second_loop
	
second_loop:
	push offset value
	push offset format_int
	push file_ptr
	call fscanf
	add ESP, 12
	
	cmp EAX, 1
	jne end_function
	
	;pusha
	;	set_entry rot_mat, [EBP+16], [EBP+12], line_counter, row_counter, word ptr[value]
	;popa
	
	mov EAX, row_counter
	inc EAX
	mov row_counter, EAX
	
	cmp EAX, [EBP+12]
	jne second_loop
	
second_loop_increment_line:
	xor EAX, EAX
	mov row_counter, EAX
	
	mov EAX, line_counter
	inc EAX
	mov line_counter, EAX
	
	cmp EAX, [EBP+16]
	jne second_loop
	
end_function:

	push file_ptr
	call fclose
	add ESP, 4

	xor EAX, EAX
	mov EAX, [EBP-4]

	mov ESP, EBP
	pop EBP
	ret
rotate ENDP

start:
	
	open_file 		path_in, read_bin
	init_value		n, format_int, file_ptr
	init_value      m, format_int, file_ptr
	matrix_alloc	matrix, n, m, 1				; trebuie shl 1 pentru ca 2^1 = 2, nr de bytes pt word
	
	read_from_file	file_ptr, matrix, n, m, value
	
	push m
	push n
	push matrix
	call rotate
	add ESP, 12		; in out.txt ii rotita conform cerintei
	
	;mov rot_mat, EAX
	
	push n				
	push m
	push matrix	
	call compute	; functia compute functioneaza conform indicatiilor, verifica out2.txt
	
	open_file		path_out2, write
	print_matrix	matrix, n, m, file_ptr
	
	push offset matrix
	call free
	add ESP, 4
	mov matrix, 0
	
	;push offset rot_mat
	;call free
	;add ESP, 4
	;mov rot_mat, 0
	
;---------------------------------------------------------------------------------------------------/////////////////




ex_9 STRUCT
	lines 		DD 0
	collumns 	DD 0
	matrix 		DD 0
ex_9 ENDS

format_in 	    db "Introduceti path-ul fisierului de intrare:",0
format_out      db "Introduceti path-ul fisierului de iesire:",0
format_integer 	db "%d ",0
format_string  	db "%s",0
read_bin_mode   db "rb",0
write_mode 	    db "w",0
path_in        	db " ",0
path_out       	db " ",0

new_line_param 	db 13,10,0
n              	dd 0
m              	dd 0 
row_counter    	dd 0
line_counter   	dd 0
file           	dd 0
value          	dd 0
matrix         	dd 0

.code

init_file MACRO indication, path, format
local execute
execute:
	push offset indication
	call puts
	add ESP, 4

	push offset path
	push offset format
	call scanf
	add ESP, 8
ENDM

open_file MACRO path, mode

local open

open:
    push offset mode
    push offset path
    call fopen
    add ESP, 8
    mov file, EAX

ENDM

read_integer_from_file MACRO path, value

local read_int

read_int:

    push path
    push 1
    push 4
    push offset value 
    call fread
    add ESP, 16

ENDM

matrix_allocation MACRO n,m,mat

local allocate

allocate:

    xor EAX, EAX
    mov EAX, n
    mul m

    shl EAX, 1  ; sau 4?

    push EAX
    call malloc
    add ESP, 4
    mov mat, EAX

ENDM

get_entry MACRO mat, lines, col, i, j, value

local get_element

get_element:

    xor ESI, ESI
    xor EBX, EBX
	
    mov  EBX, i
    imul EBX, lines
    add  EBX, j
	
    mov ESI, EBX
    mov EDX, mat[ESI]
    mov byte ptr[value], DL

ENDM

set_entry MACRO mat, lines, col, i, j, value

local set_element

set_element:

    xor EDI, EDI
    xor EBX, EBX
	
    mov  EBX, i
    imul EBX, lines
    add  EBX, j
	
    mov EDI, EBX
    mov EDX, value
    mov mat[EDI], EDX
ENDM

read_from_file MACRO file_ptr, mat, value, n, m

local read, end_loop, add_new_line

    xor EAX, EAX
    mov line_counter, EAX
    mov row_counter, EAX

read:

    push file_ptr
    push 1
    push 1
    push offset value 
    call fread
    add ESP, 16
	
	test EAX, EAX
    jz end_loop
	
    set_entry mat, n,m, line_counter, row_counter, value
	
    mov ECX, row_counter
    inc ECX
    mov row_counter, ECX
	
    cmp ECX, m
    jnz read

add_new_line:

	mov ECX, line_counter
	inc ECX
    mov line_counter, ECX
	
	xor EAX, EAX
	mov row_counter, EAX
	
	cmp ECX, n
	je end_loop
	
	jmp read

end_loop:

    push file_ptr
    call fclose
    add ESP, 4

ENDM

print_matrix MACRO mat, n, m, file_ptr

local print_line, add_new_line, end_print

	push n
	push offset format_integer
	push file_ptr
	call fprintf
	add ESP, 12
	
	push m
	push offset format_integer
	push file_ptr
	call fprintf
	add ESP, 12
	
	push offset new_line_param
    push offset format_string
	push file_ptr
    call fprintf
    add ESP, 12
	
	xor EAX, EAX
    mov line_counter, EAX
    mov row_counter, EAX
	

print_line: 

	mov EAX, line_counter
	mov EDX, row_counter

	pusha
    get_entry mat, n, m, EAX, EDX, value
	popa
	
	pusha
    push value
    push offset format_integer
	push file_ptr
    call fprintf
	add ESP, 12
	popa
	
    mov ECX, row_counter
    inc ECX
    mov row_counter, ECX
	
    cmp ECX, m
    jnz print_line

add_new_line:

	mov ECX, line_counter
	inc ECX
    mov line_counter, ECX
	cmp ECX, n
	je end_loop
	
	pusha
	push offset new_line_param
	push offset format_string
	push file_ptr
	call fprintf
	add ESP, 8
	popa
	
	xor EAX, EAX
	mov row_counter, EAX
	jmp print_line

end_loop:

    push file_ptr
    call fclose
    add ESP, 4

ENDM

; int is_prime(int value) {
; 		int result = 1;
;		for(int d = 2; d <= value/2 && result != 0; d++) {
;			if(value % d == 0) result = 0;
;		}
;		
;		return result;
; }

is_prime PROC				; stdcall - La aceast˘a convent, ie, argumentele funct, iei se vor pune pe stiva, in orinde inversa. Trebuie sa curatam noi stiva
							; rezultatul se va afla in EAX	

	push EBP
	mov EBP, ESP

	xor ECX, ECX			; resetam toti registrii implicati in operatii
	xor EDX, EDX
	xor EAX, EAX
	xor EBX, EBX
	
	mov EBX, [EBP+8]		; stabilim limitele pentru for -> asta e limita superioara			
	mov ECX, 2				; primul divizor pentru care facem verificarea este 2 -> asta e limita inferioara

	mov EAX, 2				; 2 este cel mai mic numar prim
	cmp [EBP + 8], EAX		; comparam parametrul trimis cu doi 
	je prime				; daca ebp + 8 e 2, atunci e prim, deci nu mai are rost sa facem calculele
		
	mov EAX, 1				; la fel si cu 1
	cmp [EBP + 8], EAX
	je prime
	
	for_loop:				; incepe for-ul propriu-zis
		xor EDX, EDX		; stergem ce e in EDX, pentru ca aici se va afla rezultatul value % divisor
		mov EAX, [EBP+8]	; mereu in EAX vom pune parametrul
		div ECX				; impartim cum ECX, adica cu d 
		
		;PUSHA				; decomenteaza daca vrei sa vezi pasii
		;	push EDX
		;	push ECX
		;	push [EBP+8]
		;	push offset format_location
		;	call printf
		;	add ESP, 16
		;POPA
		
		cmp EDX, 0			; daca EDX e 0, numarul nu e prim
		je not_prime		; se sare la not prime
		
		inc ECX				; altfel, creste contorul de divisor curent
		cmp ECX, EBX		; verificam daca am ajuns la ultimul divizor 
		jne for_loop		; daca nu, mergem la urmatoare iteratie
	
	prime: 					; cazul in care numarul e prim
		mov EAX, 1			; pentru ca folosim convectia stdcall, vom avea rezultatul in EAX, deci punem in EAX true
		jmp leave_loop
		
	not_prime:
		mov EAX, 0			; EAX = 0 => numarul nu e prim
		
	leave_loop:				; se termina for-ul
		mov ESP, EBP
		pop EBP
	
		ret 				; se termina functia
is_prime ENDP

get_line PROC
	push EBP
	mov EBP, ESP
	sub ESP, 12
	
	mov dword ptr[EBP-4],  0		; contor de 1 pe linii 
	mov dword ptr[EBP-8],  0		; valoare maxima de 1 per linie
	mov dword ptr[EBP-12], 0 		; indicele liniei
	
	mov EAX, 0 						; setam pe 0 indexii pentru linie si coloana
	mov row_counter, EAX
	mov line_counter, EAX
	
	
for_loop:
	push line_counter				; verificam primalitatea liniei
	call is_prime
	add ESP, 4
	
	cmp EAX, 0						; daca linia nu e prima, mergem la urmatoarea
	je go_to_next_line				

	pusha
		get_entry matrix, [EBP+12], [EBP+16], line_counter, row_counter, value	; in value am elementul matrix[linec][rowc]
	popa
	
	xor ECX, ECX
	mov ECX, [EBP-4]				 ; punem in ecx contoru ca sa-l actualizam
	add ECX, value					 ; in ecx am numarul de valori de 1
	mov dword ptr [EBP-4], ECX		 ; in ebp-4 am nr de val de 1
	
	xor EBX, EBX
	mov EBX, row_counter		; in ebx pun row_counter		
    inc EBX						; incrementam counterul de coloana
    mov row_counter, EBX		; il salvam
	
    cmp EBX, [EBP+16]			; suntem la elementul final?
    jb for_loop					; daca nu, du-te la urmatorul element
								; asta e ramura daca da
	
	mov ECX, [EBP-4]
	cmp ECX, [EBP-8]			; comparam nr curent de valori de 1 cu numarul maxim
	jnge go_to_next_line		; daca nu ii mai mare sau egal cu numarul maxim mergem la urmatoarea linie
	
	mov dword ptr[EBP-8],  ECX  ; daca ii mai mare, pune-mi in valoarea maxima numarul curent
	
	mov EAX, line_counter		; ia-mi indexul si pune-l in ebp-12
	mov dword ptr[EBP-12], EAX	
	
	
go_to_next_line:
	mov dword ptr[EBP-4],  0	; la linie noua dam refresh la contorul de 1
	xor EAX, EAX				; dam refresh si la contorul pt coloana
	mov row_counter, EAX

	mov EAX, line_counter		; incrementam contorul pt linie
	inc EAX
	mov line_counter, EAX		
	
	cmp EAX, [EBP+12]			; si la final verificam daca am ajuns la ultima linie
	jne for_loop				; daca nu suntem la ultima linie atunci fa iteratia

end_for:
	xor EAX, EAX				; reseteaza contoarele
	mov line_counter, EAX
	mov row_counter, EAX
	
end_function:
	
	mov EAX, [EBP-12]
	mov ESP, EBP
	pop EBP
	ret
get_line ENDP

replace_lines PROC
	push EBP 
	mov EBP, ESP
	
	sub ESP, 8				 		; doua variabile locale
	
	xor EBX, EBX
	mov EBX, [EBP+20]
	
	mov dword ptr[EBP-8], 0			; row_index_aux
	mov dword ptr[EBP-4], EBX  		; index pentru lina cu care trebuie sa facem inlocuirea
	
	xor EAX, EAX
	mov line_counter, EAX
	
for_loop:
	
	push line_counter
	call is_prime
	add ESP, 4

	cmp EAX, 1
	jne continue

execute:
	mov EAX, line_counter
	cmp EAX, [EBP-4]
	je continue
	
replace_loop:
	pusha
		get_entry matrix, [EBP+12], [EBP+16], [EBP-4], [EBP-8], value
	popa
	
	pusha
		set_entry matrix, [EBP+12], [EBP+16], line_counter, [EBP-8], value
	popa

	mov ECX, [EBP-8]
	inc ECX
	mov dword ptr[EBP-8], ECX
	
	cmp ECX, [EBP+16]
	jne replace_loop
	
	
continue:
	mov dword ptr[EBP-8], 0

	mov EAX, line_counter
	inc EAX
	mov line_counter, EAX
	
	cmp EAX, [EBP+12]
	jne for_loop
	
end_function:
	mov ESP, ebp
	pop EBP
	ret 16
replace_lines ENDP

start:

	init_file 				format_in, path_in, format_string
	init_file 				format_out, path_out, format_string
	
	open_file               path_in, read_bin_mode
    read_integer_from_file  file, n
    read_integer_from_file  file, m
    matrix_allocation       n,m, matrix
    read_from_file          file, matrix, value, n, m

	push m				   ; nr de elemente de pe linie    -> EBP + 12
	push n				   ; nr de linii in matrice 	   -> EBP + 8
	push matrix
	call get_line
	add ESP, 12
	
	push EAX				; index-ul liniei de modificat -> EBP + 20
	push m					; nr de elemente pe linie 	   -> EBP + 16
	push n 					; nr de linii in matrice 	   -> EBP + 12
	push matrix				; matricea					   -> EBP + 8
	call replace_lines
	
	open_file				path_out, write_mode
	print_matrix 	   	    matrix, n, m, file
	
	push matrix				; curatam zona de memorie din heap folosita de matrice
	call free				; apelam functia de curatare
	add ESP, 8
	
	mov matrix, 0 			; marcam zona ca NULL
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	;;;;;;;;;;;;;;;;;
	
	.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Include libraries and define what functions we want to import
includelib msvcrt.lib
extern exit: proc
extern printf: proc
extern scanf: proc
extern fprintf: proc
extern fread: proc
extern malloc: proc 
extern fopen: proc
extern fclose: proc

STUDENTI struct

	nume DB 40 dup(0)
	punctaj1 DB ?
	punctaj2 DB ?
	punctaj3 DB ?

STUDENTI ends
;;macro
get_points MACRO students, n, i, points
 local salt_la_final
	pusha
	mov ecx, n
	mov edx, i
	;;presupunem initial contrariul
	mov points, -1
	
	cmp edx, ecx
	jge salt_la_final
	cmp edx, 0
	jl salt_la_final
	
	lea ebx, students
	mov ax, [ebx+edx*(size STUDENTI)]
	mov points, ax
	
salt_la_final:
	popa

ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
public start
.data

format_afisare_nume_fisier DB "Introduceti numele fisierului: ", 0
format_nume_fisier DB 100 dup(0)
format_string DB "%s", 0
format_element DB "%d", 0
mode_rb DB "rb", 0
format_new_line DB 13,10,0
ifile DD 0
numar_studenti DD 0
student DD 0
format_string_punctaje DB "%s %s %s", 0
afisare_text_printf DB "Catigatorul concursului este ", 0

.code
;;o functie care calculeaza media fiecarui student
;;int nota_maxima(student,numar_studenti)
nota_maxima proc
	push ebp
	mov ebp, esp
	sub esp, 4 ;;o variabila locala prin care imi returneaza macr-ul media fiecarui student
	
	xor esi, esi
	mov edi, [ebp-4] ;;variabila locala salvata in registrul edi
	mov edx, [ebp+8];;vectorul student
	mov ebx, [ebp+12];;numar studenti
	xor ecx, ecx
bucla_studenti:
	cmp ecx, ebx
	jge final
	
	;;apel macro get_points
	get_points edx, ebx, ecx, dword ptr [edi]
	
	cmp edi, esi
	je salt_increment ;;media maxima
	mov esi, edi
	;;mov eax, [edx+ecx*(size STUDENTI)+STUDENTI.nume] NU MERGE
	
salt_increment:
    inc ecx
	jmp bucla_studenti
final:
    
	mov eax, esi ;;pentru ca functia returneaza prin eax
	mov esp, ebp
	pop ebp
	ret  ;;;conventia cdecl
nota_maxima endp

start:
;;1. citirea numelui fisierului
;;1.1 printarea formatului de introducere a fisierului
	push offset format_afisare_nume_fisier
	call printf
	add esp, 4
;;1.2 citirea numelui fisierului folosind scanf 
;;scanf("%s",format_nume_fisier)
	push offset format_nume_fisier
	push offset format_string
	call scanf
	add esp, 8
;;3.citirea datelor din fisierului
;;3.1 deschiderea fisierului folosind fopen
;;ifile=fopen(format_nume_fisier, "rb")
	push offset mode_rb
	push offset format_nume_fisier
	call fopen
	add esp, 8
	mov ifile, eax ;;odaata cu golirea stivei se stocheaza in eax
;;citirea datelor din fisier
;;citirea numarului de studenti 
;;;;fread(&numar_studenti, sizeof(numar_studenti), 1, ifile);
	 push ifile
	 push 1
	 push 4 ;;de tipul DWORD care este int in C, sizeof de int este 4
	 push offset numar_studenti
	 call fread
	 add esp, 16
;;pentru ca sa putem face asta trebuie sa alocam intai memorie pentru datele citite ulterior
;;alocarea memoriei
;; STUDENTI *student=malloc(sizeof(STUDENTI)*numar_studenti)
	mov eax, size STUDENTI
	mov edx, 0 ;;pentru ca sa fim siguri ca ce este in registrul edx nu se poate suprapune cu registrul eax
	mov ecx, numar_studenti
	mul ecx
	
	pusha
	push eax
	call malloc
	add esp, 4
	mov student, eax
	popa ;;trebuie sa folosim pusha si popa pentru ca sa nu modificam ce aveam inainte in registrii
	
	 
;;acum se poate citi din vectorul student care are numar_studenti elemente fiecare student care a participat la concurs
;;fread(student, sizeof(STUDENTI), numar_studenti, ifile);
	push ifile 
	push numar_studenti
	push size STUDENTI
	push student
	call fread
	add esp, 16
   ;;o afisare lela
  ;  push ecx
	;mov ecx, size STUDENTI
	;push [student +ecx+ STUDENTI.punctaj1]
	;push [student +ecx+ STUDENTI.punctaj2]
	;push [student +ecx+ STUDENTI.punctaj3]
	;push offset format_string_punctaje
	;call printf
	;add esp, 16 
	;pop ecx
	
;;apel functie care calculeaza studentul cu media maxima
	push numar_studenti
	push student
	call nota_maxima
	add esp, 8
	
;;afisarea pe ecran
 ;;afisare_text_printf
	push offset afisare_text_printf
	call printf
	add esp, 4
	
	push eax
	push offset format_string
	call printf
	add esp, 8
	
	push 0
	call exit
end start
	
	
	
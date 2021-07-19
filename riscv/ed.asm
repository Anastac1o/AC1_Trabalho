.data
	ops:	.asciz "iacdpefwqQ"
	tester:	.asciz "12,4i"
	oi:	.asciz	"oi"
	toma:	.asciz 	"toma"
	ez:	.asciz	"ez"
	meio:	.asciz 	"meio"
	nl:	.asciz 	"\n"
	erro_insert:	.asciz "\nIndice maior que a lista"
	t_args: .space 4
	buffer:	.space 100
	input:	.space 9
	err:	.asciz	"?\n"
	curr: .space 4
	file:	.asciz "test.txt"
.text
j main

#void insert_node(List L, Node N, int pos)
#	t_N = get(L, pos)
#	t_N->Prev->Next = N
#	N->Prev = t_N->Prev
#	t_N->Prev = N
#	N->Next = t_N
#	L->Size++
insert_node:
	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)	#L
	sw a1, 8(sp)	#N
	sw a2, 12(sp)	#pos
	
	mv a0, a1
	mv a1, a2
	jal list_get	#t_N = get(L,pos)
	sw a0, 16(sp)
	lw t0, 4(a0)	#t_N->Prev
	lw t1, 8(sp)	#N
	sw t1, 0(t0)	#t_N->Prev->Next = N
	sw t0, 4(t1)	#N->Prev = t_N->Prev
	sw t1, 4(a0)	#t->Prev = N
	sw a0, 0(t1)	#N->Next = t_N
	lw t2, 4(sp)	#L
	lw t3, 0(t2)	#L->Size
	addi t3, t3, 1	#L->Size++
	sw t3, 0(t2)
	
	lw ra, 0(sp)
	addi sp, sp, 20
	ret
#void push_node(List L, Node N)
#	L->Head->Prev = N
#	N->Next = L->Head
#	L->Head = N
#	L->Size++
push_node:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	lw t0, 4(a0)		#L->Head
	sw a0, 4(t0)		#L->head->prev = N
	sw t0, 0(a1)		#N->Next = L->Head
	sw a1, 4(a0)		#L->Head = N
	lw t1, 0(a0)		#L->Size
	addi t1, t1, 1		#L->Size++
	sw t1, 0(a0)
	
	lw ra, 0(sp)
	addi sp,sp, 4
	ret
#void add_node(List L, Node N)
#	N->prev = L->tail
#	L->Tail->Next = N
#	L->tail = N
#	L->size++
add_node:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	lw t0, 8(a0)		#L->Tail
	sw t0, 4(a1)		#N->Prev = L->Tail
	
	sw a1, 0(t0)		#L->Tail->Next = N
	sw a1, 8(a0)		#L->Tail = N
	lw t1, 0(a0)		#L->size
	addi t1, t1, 1		#L->Size++
	sw t1, 0(a0)
	
	lw ra, 0(s0)
	addi sp, sp, 4
	ret

#void insert_txt(Ed_txt txt, int linha)
# char *buffer
# gets(buffer)
# new_N = new_node(buffer)
# if(txt->L->head == NULL)
#	txt->curr = new_N
#	add_node(txt->L, new_N)
# else
#	N = get(txt->L, linha -1)
#	if(N == L->head)
#		L->head->prev = N
#		N->Next = L->Head
#		L->Head = N
#		L->size++
#	else
#		insert(L, linha -1, buffer)
#		
inserts_txt:
	addi sp, sp, -24
	sw ra, 0(sp)
	
	sw a0, 4(sp)		#txt
	sw a1, 8(sp)		#linha
	
	lw t0, 0(a0)		#txt->L
	sw t0, 12(sp)
	
	la a0, buffer		#get input
	li a1, 100
	jal gets
	
	jal new_node		
	sw a0, 16(sp)		#N = new_node(input)
	
	lw t0, 4(sp)		#txt
	sw a0, 4(t0)		#txt->curr = N
	
	lw t1, 12(sp)		#txt->L
	lw t2, 4(t1)		#L->Head
	beq t2, zero, ins_empty_list	#L->head == NULL?º
	
	lw a0, 12(sp)		#txt->L
	lw a1, 8(sp)		#linha
	addi a1, a1, -1		#linha - 1
	jal list_get		#t_N = get(L, linha-1)
	sw a0, 20(sp)		#
	lw t0, 12(sp)		#txt->L
	lw t1, 4(t0)		#L->Head
	beq t1, a0, ins_node_is_head	#t_N == L->Head ?
	lw a0, 12(sp)		#txt->L
	lw a1, 16(sp)		#N
	lw a2, 8(sp)		#linha
	addi a2, a2, -1		#linha -1
	jal insert_node
	j fim_inst
	
	
	ins_node_is_head:
	lw a0, 12(sp)		#txt->L
	lw a1, 20(sp)		#t_N
	jal push_node		#push_node(L,N)
	j fim_inst
	
	ins_empty_list:
	lw a1, 16(sp)		#N
	lw a0, 12(sp)		#txt->L
	jal add_node		#add_node(L, N)
	j fim_inst
	
	fim_inst:
	lw ra, 0(sp)
	ret
del_txt:
#void change_txt(List L, int linha)
#	char *buffer
#	gets(buffer)
#	N = get(L, linha)
#	change_line(N, buffer)
change_txt:
	addi sp, sp, -16
	sw ra, 0(sp)
	
	sw a0, 4(sp) 	#L
	sw a1, 8(sp)	#linha
	
	la a0, buffer
	li a1, 100
	jal gets
	
	lw a0, 4(sp)	# L
	lw a1, 8(sp)	# Linha
	
	jal list_get	#N = get(L, linha)
			#guarda atual
	
	
	la a1, buffer
	jal change_line	#change(N, buffer)
	
	lw ra, 0(sp)
	addi sp, sp, 16
	ret
	
#void append_txt(List L, int linha)
#	char *buffer
#	gets(buffer)
#	if(L->Head == NULL)
#		add(l, buffer)
#	else
#		N = get(L, linha)
#		if(N == L->Tail)
#			add(L, buffer)
#		else
#			insert(L, linha, buffer)
append_txt:
	addi sp, sp, -20
	sw ra, 0(sp)
	
	sw a0, 4(sp)		#L
	sw a1, 8(sp)		#linha
	
	la a0, buffer
	li a1, 100
	jal gets
	
	sw a0, 12(sp)		#buffer
	
	lw t0, 4(sp)		#L
	lw t1, 8(t0)		#L->tail
	beq t1, zero, a_empty_l	#L->tail == NULL?
				#else
	lw a0, 4(sp)		#L
	lw a1, 8(sp)		#linha
	jal list_get		#get(L,linha)
			#guarda atual
			#guarda atual
	sw a0, 16(sp)		#N = get(l,linha)
	lw t0, 4(sp)		#L
	lw t1, 8(t0)		#L->tail
	beq a0, t1, a_is_tail	#L->tail == N ?
	lw a0, 4(sp)		#L
	lw a1, 8(sp)		#linha
	la a2, buffer		#buffer
	jal insert_list		#insert(L, linha, buffer)
	j i_txt_fim
	
	a_is_tail:
	lw a0, 4(sp)		#L
	lw a1, 12(sp)		#buffer
	j a_txt_fim
	
	a_empty_l:
	lw a0, 4(sp)		#L
	lw a1, 12(sp)		#buffer
	jal list_add		#add(L,buffer)
	
	a_txt_fim:
	lw ra, 0(sp)
	addi sp, sp, 20
	ret
#void insert_txt(List L, int linha)
# char *buffer
# gets(buffer)
# if(L->head == NULL)
#	add(L, buffer)
# else
#	N = get(L, linha)
#	if(N == L->head)
#		L->head->prev = N
#		N->Next = L->Head
#		L->Head = N
#		L->size++
#	else
#		insert(L, linha -1, buffer)
#		
insert_txt:
	addi sp, sp, -20
	sw ra, 0(sp)
	
	sw a0, 4(sp)		#L
	sw a1, 8(sp)		#linha
	
	la a0, buffer
	li a1, 100
	jal gets
	
	sw a0, 12(sp)		#buffer
	
	lw t0, 4(sp)		#L
	lw t1, 4(t0)		#L->head
	beq t1, zero, i_empty_l	#L->Head == NULL?
				#else
	lw a0, 4(sp)		#L
	lw a1, 8(sp)		#linha
	jal list_get		#get(L,linha)
			#guarda atual
			#guarda atual
	sw a0, 16(sp)		#N = get(l,linha)
	lw t0, 4(sp)		#L
	lw t1, 4(t0)		#L->Head
	beq a0, t1, i_is_head	#L->Head == N ?
	lw a0, 4(sp)		#L
	lw a1, 8(sp)		#linha
	addi a1, a1, -1		#linha -1
	la a2, buffer		#buffer
	jal insert_list
	j i_txt_fim
	
	i_is_head:
	lw t3, 16(sp)		#N
	sw t3, 4(t1)		#L->head->prev = N
	sw t1, 0(t3)		#N->Next = L->Head
	sw t3, 4(t0)		#L->Head = N
	lw t4, 0(t0)		#L->Size
	addi t4, t4, 1		#"" ++
	sw t4, 0(t0)		#L->size++
	j i_txt_fim
	
	i_empty_l:
	lw a0, 4(sp)		#L
	lw a1, 12(sp)		#buffer
	jal list_add		#add(L,buffer)
	
	i_txt_fim:
	lw ra, 0(sp)
	addi sp, sp, 20
	ret
	

#print_in_range(List L,int a ,int b)
#int dif = b - a
#N = get(L,a)
#for(int i=0; i<dif; i++)
#	print_line(N)
#	N = N->next
print_in_range:
	addi sp, sp, -24
	sw ra, 0(sp)		#
	sw a0, 4(sp)		#L
	sw a1, 8(sp)		#a
	sw a2, 12(sp)		#b
	sub t0, a2, a1		# dif = b - a
	sw t0, 16(sp)
	
	jal list_get		#N = get(L,a
			#guarda atual
			#guarda atual
	sw a0, 20(sp)		#N
	sw zero, 8(sp)		# i = 0
	pir_loop:
	lw a0, 20(sp)		#N
	jal print_line		#print_line(N)
	lw t0, 20(sp)		#N
	lw t1, 0(t0)		#N->Next
	sw t1, 20(sp)		#N = N->Next
	lw t2, 8(sp)		#i
	addi t2, t2, 1		#i++
	sw t2, 8(sp)
	lw t3, 16(sp)		#dif
	blt t2, t3, pir_loop
	
	
	lw ra, 0(sp)
	addi sp, sp, 24
	ret
	
#struct ed_txt {
#	List L
#	Node curr }
#
#ed_txt new_ed_txt() {
#	txt = malloc(sizeof(ed_txt))
#	txt-> L = new_list()
#	txt-> curr = NULL
new_ed_txt:
	addi sp, sp, -12
	sw ra, 0(sp)
	
	li a0, 8	#malloc(8)
	li a7, 9
	ecall
	
	sw a0, 4(sp)	#txt
	li a0, 0
	jal new_list	#new_list(NULL)
	sw a0, 8(sp)	#L
	lw t0, 4(sp)	#txt
	sw a0, 0(t0)	#txt->L = new_list(NULL)
	sw zero, 4(t0)	#txt->curr = NULL
	
	mv a0, t0	#return txt
	lw ra, 0(sp)
	addi sp, sp, 12
	ret

#void change_line(Node* N, char* new_data)
#	strcpy(N->data, data)
change_line:
	addi sp, sp , -12
	sw ra, 0(sp)
	sw a0, 4(sp)		#N
	sw a1, 8(sp)		#new_data
	
	lw t0, 8(a0)		#N->data
	mv a0, t0
	li a2, 100		
	jal strcpy		#strpcy(N->data, new_data)
	
	lw ra, 0(sp)
	addi sp, sp, -4
	ret
#void print_line(Node N)
#	print(N->data)
print_line:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	lw t0, 8(a0)	#N->data
	mv a0, t0
	li a1, 100
	jal puts	#print(N->data)
	la a0, nl	#\n
	jal puts
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret
#void print_list(List L)
#	N = L->Head
#	while N != NULL
#		print(N->data)
#		print("\n")
#		N = N->next
print_list:
	addi sp, sp, -12
	sw ra, 0(sp)
	
	sw a0, 4(sp)	#L	
	lw t0, 4(a0)	#N = L->head
	beq t0, zero, end_print_l	#Lista vazia?
	sw t0, 8(sp)
	print_loop:
	lw t0, 8(sp)
	lw a0, 8(t0)	#N->data
	li a1, 100
	jal puts
	la a0, nl	#\n
	jal puts
	lw t0, 8(sp)	#N
	lw t1, 0(t0)	# N->Next
	sw t1, 8(sp)	#N = N->Next
	bne t1, zero, print_loop
	end_print_l:
	lw ra, 0(sp)
	addi sp, sp, 12
	ret
	
#void delete_line(List L, Node N)
#	if(N == L->head)
#		L->head == L->head->next
#	else if(N == L->tail)
#		L->tail = L->tail->prev
#	else
#		N->next->prev = N->prev
#		N->prev->next = N->Next
delete_line:
	lw t0, 4(a0)		#L->Head
	lw t1, 8(a0)		#L->Tail
	beq a1, t0, is_head	#N == L->head ?	
	beq a1, t1, is_tail	#N == L->tail ?
	lw t2, 0(a1)		#N->next
	lw t3, 4(a1)		#N->prev
	sw t3, 4(t2)		#N->next->prev = N->prev
	sw t2, 4(t3)		#N->prev->next = N->Next
	j end_deline
	
	is_head:
	lw t2, 0(t0)		#L->head->next
	sw t2, 4(a0)		#L->head = L->head->next
	j end_deline
	
	is_tail:
	lw t2, 4(t1)		#L->tail->prev
	sw t2, 8(a0)		#L->tail = L->tail->prev
	
	end_deline:
	mv a0, t0		#return list
	ret
#void delete_range(List L, int a, int b)
#	if(a == 0 && b == L->size - 1)
#		L->Head = NULL
#		L->Tail = NULL
#	else if(a == 0 && b != L->size - 1)
#		N = get(L, b)
#		N->Next->Prev = NULL
#		L->Head = N->Next
#	else if(a != 0 && b == L->size - 1)
#		N = get(L, a)
#		N->Prev->Next = NULL
#		L->Tail = N->Prev
#	else
#		N1 = get(L, a)
#		N2 = get(L, b)
#		N2->prev = N1
#		N1->next = N2
#	L->size = L->size - b - a - 1
delete_in_range:
	addi sp, sp, -28
	sw ra, 0(sp)			
	sw a0, 4(sp)			# L
	sw a1, 8(sp)			# a
	sw a2, 12(sp)			# b
	
	lw t0, 0(a0)			#L->size
	addi t0, t0, -1			#L->size - 1
	sw t0, 16(sp)	
			
	beq a1, zero, a_zero		# a == 0 ?
	beq t0, a2, b_size		# L->size - 1 == b ?
					#else
	jal list_get			#get(L, a)
			#guarda atual
	sw a0, 20(sp)			#N1
	lw a0, 4(sp)			#L
	lw a1, 12(sp)			#b
	jal list_get			#get(L, b)
			#guarda atual
	sw a0, 24(sp)			#N2
	lw t0, 20(sp)			#N1
	lw t1, 4(t0)			#N1->prev
	lw t2, 0(a0)			#N2->Next
	sw t2, 0(t1)			#N1->Prev->Next = N2->Next
	sw t1, 4(t2)			#N2->Next->Prev = N1->prev	
	j end_del_ir	
	
	a_zero:
	lw t0, 16(sp)			# L->size - 1
	lw t1, 12(sp)			# b
	beq t0, t1, delete_list		# a == 0 && b == L->size -1 ?
					# else if(a==0 && b!= L->size - 1)
	lw a0, 4(sp)			# L
	lw a1, 12(sp)			# b
	jal list_get			# get(L, b)
			#guarda atual
	sw a0, 20(sp)			# N = get(L, b)
	lw t0, 0(a0)			#N->Next
	sw zero, 4(t0)			#N->Next->Prev = NULL
	lw t1, 4(sp)			#L
	sw t0, 4(t1)			#L->Head = N->Next
	j end_del_ir
	
	
	b_size:				#a != 0 && b == L->size
	lw a0, 4(sp)			# L
	lw a1, 8(sp)			# a
	jal list_get			# N = get(L , a)
			#guarda atual
	lw t0, 4(a0)			# N->Prev
	sw zero, 0(t0)			# N->Prev->Next = NULL
	lw t1, 4(sp)			# L
	sw t0, 8(t1)			# L->Tail = N->Prev
	
	end_del_ir:
	lw t0, 16(sp)			# L->size
	lw t1, 8(sp)			# a
	lw t2, 12(sp)			# b
	sub t1, t2, t2			# b - a
	sub t0, t0, t1			# L->size - (b - a)
	addi t0, t0, -1			# L->size - (b - a) - 1
	lw t2, 4(sp)			# L
	sw t0, 0(t2)			# L->size = L->size - (b - a) - 1
	
	mv a0, t2
	lw ra, 0(sp)
	addi sp, sp, 24
	ret
	
	delete_list:
	lw t0, 4(sp)			#L
	sw zero, 0(t0)			# L->size = 0
	sw zero, 4(t0)			# L->head = NULL
	sw zero, 8(t0)			# L->tail = NULL
	
	mv a0, t0
	lw ra, 0(sp)
	addi sp, sp, 24
	ret
	

delete_range:
	addi sp, sp, -24
	sw ra, 0(sp)
	
	sw a0, 4(sp)		#L
	sw a1, 8(sp)		#a
	sw a2, 12(sp)		#b
	
	jal list_get
			#guarda atual
	sw a0, 16(sp)		# N1 = get(L, a)
	lw a0, 4(sp)		
	lw a1, 12(sp)		
	jal list_get		#get(L, b)
			#guarda atual
	sw a0, 20(sp)		# N2 = get(L, b)
	mv t0, a0		# N2
	lw t1, 16(sp)		# N1
	sw t1, 4(t0)		# N2->prev = N1
	sw t0, 0(t1)		# N1->next = N2
	lw t2, 4(sp)		# L
	lw t3, 0(t2)		# L->size
	lw t4, 8(sp)		# a
	lw t5, 12(sp)		# b
	sub t4, t5, t4		# a = b - a
	sub t3, t3, t4		# L->size - (b - a)
	sw t3, 0(t2)		# L->size = L->size - (b - a)
	
	mv a0, t2
	lw ra, 0(sp)
	addi sp, sp, 24
	ret
	
	
#node get(Lista L, int pos)
#	N = L->Head
#	for(int i=0; i < pos; i++)
#		N=N->next
#	return N
list_get:
	lw t0, 4(a0)			#N = L->Head
	li t1, 0			# i = 0
	for_get:
	bge t1, a1, end_for_get		# i < pos ?
	lw t2, 0(t0)			# N->Next
	mv t0, t2			# N = N->Next
	addi t1, t1, 1			# i++
	j for_get
	
	end_for_get:
	mv a0, t0
	ret
#void insert_list(List L, int n, char* data)
#	N = new_node(data)
#	A = get(L, n)
#	A->Prev->Next = N
#	N->Prev = A->Prev
#	A->Prev = N
#	N->Next = A
#	L->Size++

insert_list:
	addi sp, sp, -20
	sw ra, 0(sp)
	sw a0, 4(sp)			#L
	sw a1, 8(sp)			#n
	sw a2, 12(sp)			#data
	
	mv a0, a2
	jal new_node
	sw a0, 16(sp)			#N = new_node(data)
	lw a0, 4(sp)			#L
	lw a1, 8(sp)			#n
	jal list_get			#A = get(L,n)
			#guarda atual
	lw t0, 4(a0)			#A->Prev
	lw t1, 16(sp)			#N
	sw t1, 0(t0)			#A->Prev->Next = N
	sw t0, 4(t1)			#N->Prev = A->Prev
	sw t1, 4(a0)			#A->Prev = N
	sw a0, 0(t1)			#N->Next = A
	lw t2, 4(sp)			#L
	lw t3, 0(t2)			#L->Size
	addi t3, t3, 1			#L->Size + 1
	sw t3, 0(t2)			#L->Size = L->Size + 1
	
	lw ra, 0(sp)
	addi sp, sp, 20
	ret
#void insert(List L, int n, char* data)
#	N = L->head
#	for(int i=1; i < n; i++) 
#		N = N->next
#
#	new_N = new_node(char* data)
#	new_N->next = N->Next
#	N->next = new_N
#	L->size++
#	return 0
list_inserts:
	addi sp, sp, -20
	sw ra, 0(sp)
	
	lw t0, 0(a0)			# L->size
	blt t0, a1, err_ins		# L->size < n ? -> 
	
	sw a0, 4(sp)			# L
	sw a1, 8(sp)			# n
	sw a2, 12(sp)			# data
	
	lw t0, 4(a0)			# N = L->head
	li t1, 1			# i = 0
	for_inserts:
	bge t1, a1, endfor_inserts	# i < n ?
	lw t2, 0(t0)			# N->next
	mv t0, t2			# N = N->next
	addi t1, t1, 1			# i++
	j for_inserts
	
	endfor_inserts:
	sw t0, 16(sp)			# N
	mv a0, a2			
	jal new_node			#new_N = new_node(char* data)
	lw t0, 16(sp)			#N
	lw t1, 0(t0)			#N->Next
	sw t1, 0(a0)			#new_N->next = N->next
	sw a0, 0(t0)			# N->Next = new_N
	
	lw a0, 4(sp)			#L
	lw t3, 0(a0)			#L->size
	addi t3, t3, 1			#L->size++
	sw t3, 0(a0)
	
	lw ra, 0(sp)
	addi sp, sp, 20
	ret
	
	err_ins:
	li a0, -1
	lw ra,0(sp)
	addi sp, sp, 20
	ret
	
	
list_insert:
	addi sp, sp, -20
	sw ra, 0(sp)
	
	sw a0, 4(sp)			#L
	sw a1, 8(sp)			#N
	sw a2, 12(sp)			#pos
	sw a3, 16(sp)			#*new_data
	
	li t0, 1
	beq a2, t0, insert_else		#pos > 1 ?
	
	mv t1, a1			#N
	lw t2, 0(t1)			#N->next
	mv a1, t2			
	addi a2, a2, -1			#pos - 1
	jal list_insert			#insert(L, N->next, pos - 1, new_data)
	
	insert_else:
	lw a0, 16(sp)			#*new_data
	jal new_node			#new_n = new_node(new_data)
	lw t1, 8(sp)			#N
	sw t1, 4(a0)			# new_n->prev = N
	lw t2, 0(t1)			#N->next
	sw t2, 0(a0)			# new_n->next = N->Next
	sw a0, 4(t2)			#N->next->prev = new_N
	sw a0, 0(t1)			#N->next = new_N
	lw t3, 4(sp)			#L
	lw t4, 0(t3)			#L->size
	addi t4, t4, 1			#L->size++
	sw t4, 0(t3)
	
	lw a0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 20
	ret

#void add(List L, char *new_data)
list_add:
	addi sp, sp, -12
	sw ra, 0(sp)
	sw a0, 4(sp)		# L
	sw a1, 8(sp)		# new_data
	
	mv a0, a1
	jal new_node		# N = new_node(new_data)
	lw t0, 4(sp)		# L
	lw t1, 4(t0)		# L->head
	bne t1, zero, add_else	# L->head == NULL ?
	sw a0, 4(t0)		# L->head = N	
	sw a0, 8(t0)		# L->tail = N
	j end_add
	
	add_else:
	lw t2, 4(a0)		# N->prev
	lw t3, 8(t0)		# L->tail
	sw t3, 4(a0)		# N->prev = L->tail
	lw t4, 0(t3)		# L->tail->next
	sw a0, 0(t3)		# L->tail->next = N
	sw a0, 8(t0)		# L->tail = N;
	
	end_add:
	lw t5, 0(t0)		# L->size
	addi t5, t5, 1		# L->size++
	sw t5, 0(t0)		
	
	lw a0, 4(sp)
	lw ra, 0(sp)
	addi sp, sp, 12
	ret
	
new_list:
	addi sp, sp, -8
	
	sw a0, 0(sp)	#node N
	
	li a0, 12	#malloc(size of list) 12 bytes
	li a7, 9	
	ecall
	
	sw a0, 4(sp)	#list L
	sw zero, 0(a0)	# L->size = 0
	lw t0, 0(sp)	# N
	sw t0, 4(a0)	# L->head = N
	sw t0, 8(a0)	# L->tail = N
	
	addi sp, sp, 8
	ret

new_node:
	addi sp, sp, -12
	sw ra, 0(sp)
	
	sw a0, 4(sp)	#arg
	
	li a0, 12	#malloc(size of node) 
	li a7, 9
	ecall
	
	sw a0, 8(sp)	#node
	sw zero, 0(a0)	#node->next = NULL
	sw zero, 4(a0)	#node->prev = NULL
	
	li a0, 100	#malloc(100)	-> max chars numa linha
	li a7, 9
	ecall
	
	lw t0, 8(sp)	#node
	sw a0, 8(t0)	#node-> data = (char) malloc(100)	100 chars por linha
	
	lw a1, 4(sp)	#arg
	lw a0, 8(t0)	#node->data
	li a2, 100	#100 cchars max
	jal strcpy	#strcpy(node->data,  arg)
	
	lw t0, 8(sp)	#node
	mv a0, t0	#return node
	
	lw ra, 0(sp)
	addi sp, sp, 12
	ret
	
	
new_cmd:
	addi sp, sp, -28
	sw ra, 0(sp)
	sw a0, 4(sp)	#guarda endereço da string do argumento
	
	li a0, 12	# 4 bytes para cada argumento, 4 bytes para a instrucao
	li a7, 9
	ecall		#alloca 16 bytes na heap, guarda endereço em a0
	
	sw a0, 8(sp)	#guarda endereço da cmd na pilha
	
	sw zero, 0(a0)	#args[0][0] = 0
	sw zero, 4(a0)	#args[1][0] = 0
	sw zero, 20(sp) #argc = 0
	sw zero, 24(sp) #arglen = 0
	
	for_cmd:
	lw t0, 4(sp)	#string_original
	lb t1, 0(t0)	#curr_char = string[i]
	
	beq t1, zero, end_for_cmd
	
	sw t0, 12(sp)	#string_iterador
	sw t1, 16(sp)	#curr_char
	
	mv a0, t1	
	jal is_token
	bne a0, zero, if_is_token	#is token?
	
	lw t1, 16(sp)
	mv a0, t1
	jal is_num
	bne a0, zero, if_is_num		#is num?
	
	lw t1, 16(sp)
	li t2, 44			# is "," ?
	beq t1, t2, if_is_dot
	
	lw t1, 16(sp)	
	mv a0, t1
	jal is_op
	bne a0, zero, if_is_op		#is op?
	cmd_continue:
	lw t0, 4(sp)
	addi t0, t0, 1
	sw t0, 4(sp)
	j for_cmd

	
	if_is_token:
	la t0, t_args		#espaço temporario
	lw t1, 24(sp)		#arglength
	add t0, t0, t1		#define index
	lb t3, 16(sp)		#curr_char
	sb t3, 0(t0)		#t_args[arglen] = curr_char
	j cmd_continue		#continua ciclo
	
	
	if_is_num:
	la t0, t_args		#espaço temporario
	lw t1, 24(sp)		#arglength
	add t0, t0, t1		#define index
	lb t3, 16(sp)		#curr_char
	sb t3, 0(t0)		#t_args[arglen] = curr_char
	addi t1, t1, 1
	sw t1, 24(sp)		#arglen++
	j cmd_continue		#continua ciclo

	
	if_is_dot:
	lw t0, 20(sp)		#argc
	la t1, t_args		#t_args
	lw t2, 8(sp)		#cmd
	li t3, 4		
	mul t3, t3, t0		#define index 4*argc
	add t2, t2, t3		#cmd->args[argc]
	mv a0, t2
	mv a1, t1
	li a2, 4
	jal strcpy		#strcpy(cmd->args[argc], t_args, 4)
	lw t0, 20(sp)
	addi t0, t0, 1		#argc++
	sw t0, 20(sp)
	sw zero, 24(sp)		#arglen = 0
	la a0, t_args
	li a1, 4
	jal clean_space		#limpa t_args
	j cmd_continue		#continua ciclo
	
	if_is_op:
	la t0, t_args		#t_args
	lb t1, 0(t0)		#t_args[0]
	beq t1, zero, no_args	#t_args == 0 ?
	lw t2, 20(sp)		#argc
	lw t3, 8(sp)		#cmd
	li t4, 4		#4 posicoes de memoria * argc, determina index
	mul t4, t2, t4		#se argc = 0, args[0], se argc = 1, args[1]
	add t3, t3, t4		#cmd->args[argc]
	mv a0, t3
	mv a1, t0
	li a2, 4
	jal strcpy		#strcpy(cmd->args[argc], t_args, 6)
	no_args:
	lw t3, 8(sp)		#cmd
	lw t5, 16(sp)		#curr_char
	sw t5, 8(t3)		#cmd->comand = curr_char
	mv a0, t3
	j end_for_cmd		#retorna cmd
	
	
	end_for_cmd:
	
	lw ra, 0(sp)
	addi sp, sp, 28
	ret

#cleanspace(char* s, int n)	coloca n bits a 0
clean_space:
	li t0, 0
	clean_loop:
	sb zero, 0(a0)
	addi a0, a0, 1
	addi t0, t0, 1
	blt t0, a1, clean_loop
	ret
	
	
#a0 - destino ; a1 - fonte; a2 - n de bytes a trocar
strcpy:
	mv t0, a0
	mv t1, a1
	li t2, 0
	for_strcpy:
	lb t3, 0(t1)
	beq t2, a2, end_for_strcpy	#i == n ?
	beq t3, zero, end_for_strcpy	#fonte[i] == '\0' ?
	sb t3, 0(t0)
	addi t0, t0, 1
	addi t1, t1, 1
	addi t2, t2, 1
	j for_strcpy
	
	end_for_strcpy:
	addi t0, t0, 1
	sb zero, 0(t0)		#acrescenta '\0' no fim
	ret
	
	

#char *strsep(char* s, char c)   -- substitui char c por '0' na string s, devolve posicao seguinte
strsep:
	l_strsep:
	lb t0, 0(a0)
	beq t0, zero, fim_strsep
	beq t0, a1, sub_str
	addi a0, a0, 1
	j l_strsep
	
	sub_str:
	sb zero, 0(a0)
	addi a0, a0, 1
	
	fim_strsep:
	ret
#word of char to int

wtoi:
	li t0, 0xff0000		#0x00ff0000
	li t1, 0xff00		#0x0000ff00
	li t2, 0x00ff		#0x000000ff
	
	and t0, t0, a0
	srli t0, t0, 16
	and t1, t1, a0
	srli t1, t1, 8
	and t2, t2, a0
	
	addi t0, t0, -48
	addi t1, t1, -48
	addi t2, t2, -48
	
	li t3, 100
	mul t2, t2, t3
	li t3, 10
	mul t1, t1, t3
	
	add a0, zero, t2
	add a0, a0, t1
	add a0, a0, t0
	ret
	
	

	
#atoi				Converte string para int
#int atoi(char *s){
#	int res = 0;
#	for(int i = 0; str[i] != '\0' ; ++i) {		
#		res = res * 10 + str[i] - '0';		
#	} return res;					
atoi:
	li t0, 0		#res = 0
	for_atoi:
	lb t2, 0(a0)		# str[i]
	beq t2, zero, fim_atoi	# str[i] == '0' ?
	slli t3, t0, 3		# res * 8
	slli t4, t0, 1		# res * 2
	add t3, t3, t4		# res * 10 = res * 8 + res * 2
	addi t2, t2, -48	# str[i] - '0'
	add t0, t3, t2		# res = res * 10 + str[i] - '0'
	addi a0, a0, 1		# avança na string
	j for_atoi
	
	fim_atoi:
	mv a0, t0
	ret


#void gets(char *s, int sz)	Le uma string e escreve-a em s até ao max de sz-1 caracteres
gets:
	li a7, 8
	ecall
	ret

#void puts(char *s) 		Mostra uma string na consola
puts:
	li a7, 4
	ecall
	ret	
#bool is_token(char c)
#    if((c == '%') || (c == '$')){
#        return true;
#    }
#    return false;
#
is_token:
	li t0, 37 	#%
	li t1, 36	#$
	beq a0, t0, true_token
	beq a0, t1, true_token
	li a0, 0
	ret
	
	true_token:
	li a0, 1
	ret

#bool is_num(char c)
#    if((c >= '0') && (c <= '9')){
#        return true;
#    }
#    return false;
is_num:
	li t0, 48	#0
	li t1,  57	#9
	bge a0, t0, con1
	li a0, 0
	ret
	
	con1:
	ble a0, t1, con2
	li a0, 0
	ret
	
	con2:
	li a0, 1
	ret
#is_op(char c) {
#	for(int i=0; ops[i] != '\0'; i++)
#		if(ops[i] == c ) return 1
#	return 0;
is_op:
	la t0, ops
	for_op:
	lb t1, 0(t0)	#ops[i]
	beq a0, t1, true_op	# ops[i] == c ?
	beq t1, zero, false_op  # ops[i] == 0 ?
	addi t0, t0, 1		# i++
	j for_op
	
	true_op:
	li a0, 1
	ret
	
	false_op:
	li a0, 0
	ret
	
main:
	addi sp, sp, -40
	
	li s0, 1	#running = true
	
	li a0, 0
	jal new_ed_txt
	sw a0, 0(sp)	#txt
	lw t0, 0(a0)	#txt->list
	
	run:
	la a0, input
	li a1, 100
	jal gets	#gets(input)
	jal new_cmd	#new_cmd(input)
	sw a0, 4(sp)			#cmd
	
	lw t0, 0(a0)			#cmd->arg[0]
	sw t0, 8(sp)
	lw t1, 4(a0)
	sw t1, 12(sp)			#cmd->arg[1]
	beq t1, zero, has_one_arg	#cmd->arg[1] == 0  ?
	beq t0, zero, has_no_args	#cmd->arg[0] == 0 ?
	#else has 2 args
	sw t0, 8(sp)			# cmd->arg[0]
	sw t1, 12(sp)			# cmd->arg[1]
	mv a0, t0
	jal wtoi			#atoi(cmd->arg[0])
	sw a0, 16(sp)			# a = atoi(...[0])
	lw t0, 8(sp)			# cmd->arg[1]
	li t1, 36			# '$'
	beq t0, t1, last_el		# cmd->arg[1] == '$' ?
	mv a0, t0
	jal wtoi			#atoi(cmd->arg[1])
	sw a0, 20(sp)			# b = atoi(...[1])
	j continue_2args
	
	last_el:
	lw t2, 0(sp)			#txt
	lw t3, 0(t2)			#txt->L
	lw t4, 0(t3)			#txt->L->size
	sw t4, 20(sp)			#b = txt->L->size
	j continue_2args
	
	continue_2args:
	li t0, 100			#"d"
	li t1, 112			#"p"
	lw t2, 4(sp)			#cmd
	lw t3, 8(t2)			#cmd->comand
	beq t3, t0, delete_2		#cmd->comand == 'd'
	beq t3, t1, print_2		#cmd->command == 'p'
	la a0, err			#else
	li a1, 3
	jal puts			#print "?"
	j run
	
	delete_2:
	lw t0, 0(sp)			#txt
	lw a0, 0(t0)			#txt->L
	lw a1, 16(sp)			#a
	lw a2, 20(sp)			#b
	jal delete_in_range
	j run
	
	print_2:
	lw t0, 0(sp)			#txt
	lw a0, 0(t0)			#txt->L
	lw a1, 16(sp)			#a
	lw a2, 20(sp)			#b
	jal print_in_range
	j run
	
	
	has_one_arg:
	beq t0, zero, has_no_args
	lw t0, 8(sp)			#cmd->arg[0]
	li t1, 37			#'%'
	li t2, 36			#'$'
	beq t0, t1, arg_is_all		#cmd->arg[0] == '%'
	beq t0, t2, arg_is_last		#cmd->arg[0] == '$'
	mv a0, t0			#else
	jal wtoi			#atoi(cmd->arg[0])
	sw a0, 16(sp)			# x = atoi(...)
	j continue_has_one
	
	arg_is_all:
	li t1, -1			#-1
	sw t1, 16(sp)			# x = - 1
	j continue_has_one
	
	arg_is_last:
	lw t0, 0(sp)			#txt
	lw t1, 0(t0)			#txt->L
	lw t2, 0(t1)			#txt->L->size
	sw t2, 16(sp)			#x = txt->L->size
	j continue_has_one
	
	continue_has_one:
	lw t0, 16(sp)			#x
	li t1, -1
	beq t0, t1, all_op		#x == -1 ?  se o argumento é % só pode ser um print ou delete
	lw t1, 4(sp)			#cmd
	lw t2, 8(t1)			#cmd->comand
	li t1, 105			#"i"
	li t3, 97			#"a"
	li t4, 99			#"c"
	li t5, 100			#"d"
	li t6, 112			#"p"
	beq t2, t1, one_insert		#case i
	beq t3, t2, one_append		#case a
	beq t4, t2, one_change		#case c
	beq t5, t2, one_del		#case d
	beq t6, t2, one_print		#case p
	la a0, err
	li a1, 4
	jal puts			#default print "?"
	j run
	
	one_insert:
	lw t0, 0(sp)			#txt
	lw a0, 0(t0)			#txt->L
	lw a1, 16(sp)			#x
	jal insert_txt			#insert_txt(txt->L, x)
	j run
	
	one_append:
	lw t0, 0(sp)			#txt
	lw a0, 0(t0)			#txt->L
	lw a1, 16(sp)			#x
	jal append_txt			#append_txt(txt->L, x)
	j run
	
	one_change:
	lw t0, 0(sp)			#txt
	lw a0, 0(t0)			#txt->L
	lw a1, 16(sp)			#x
	jal change_txt			#change_txt(txt->L, x)
	j run
	
	one_del:
	lw t0, 0(sp)			#txt
	lw a0, 0(t0)			#txt->L
	lw a1, 16(sp)			#x
	jal list_get			# N = get(L, x)
			#guarda atual
	sw a0, 4(t0)			#txt->curr = N
	mv a1, a0
	lw t0, 0(sp)			#tdt
	lw a0, 0(t0)			#txt->L
	jal delete_line			#delete_line(L, N)
	j run
	
	one_print:
	lw t0, 0(sp)			#txt
	lw a0, 0(t0)			#txt->L
	lw a1, 16(sp)			#x
	jal list_get			# N = get(L, x)
			#guarda atual
	jal print_line			#print_line(N)
	j run
	 
	all_op: 
	lw t0, 4(sp)		#cmd
	lw t1, 8(t0)		#cmd->comand
	li t2, 112		#"p"
	li t3, 100		#"d"
	beq t1, t2, print_all_txt
	beq t1, t3, delete_all_txt
	la a0, err
	li a1, 4
	jal puts
	j run
	
	delete_all_txt:
	li a1, 0
	lw t0, 0(sp)		#txt
	lw t1, 0(t0)		#txt->L
	lw a2, 0(t1)		#txt->L->size
	mv a0, a1
	jal delete_in_range	#delete_in_range(L, 0, L->size)
	j run
	
	print_all_txt:
	lw t0, 0(sp)		#txt
	lw a0, 0(t0)		#txt->L
	jal print_list		#print_list(txt->L)
	j run
	
	
	has_no_args:
	lw t0, 4(sp)			#cmd
	lw t1, 8(t0)			#cmd->comando
	li t0, 105			#'i'
	li t2, 97			#'a'
	li t3, 99			#'c'
	li t4, 100			#'d'
	li t5, 112			#'p'
	li t6, 101			#'e'
	beq t0, t1, no_insert
	beq t2, t1, no_append
	beq t3, t1, no_change
	beq t4, t1, no_del
	beq t5, t1, no_print
	beq t6, t1, save
	li t0, 102			#'f'
	li t2, 119			#'w'
	li t3, 81			#'Q'
	li t4, 113			#'q'
	beq t0, t1, rename
	beq t2, t1, write
	beq t3, t1, quit
	beq t4, t1, Quit
	la a0, err
	li a1, 4
	jal puts
	j run
	
	no_insert:
	lw t0, 0(sp)		#txt
	lw a0, 0(t0)		#txt->L
	la a1, curr
	jal insert_txt
	j run
	
	no_append:
	lw t0, 0(sp)		#txt
	lw a0, 0(t0)		#txt->L
	la a1, curr
	jal append_txt
	j run
	
	no_change:
	lw t0, 0(sp)		#txt
	lw a0, 0(t0)		#txt->L
	la a1, curr
	jal change_txt
	j run
	
	no_del:
	lw t0, 0(sp)		#txt
	lw a0, 0(t0)		#txt->L
	la a1, curr
	jal delete_line
	j run
	
	no_print:
	la a0, curr
	jal print_line
	j run
	
	save:
	j run
	
	write:
	j run
	
	rename:
	j run
	
	quit:
	j run
	
	Quit:

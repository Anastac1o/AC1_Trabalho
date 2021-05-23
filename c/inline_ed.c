#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#define N_OPS     10;
typedef struct node node;
typedef struct cmd cmd;
typedef struct text text;

char* ops = "iacdpefwqQ";
// o texto vai ser representado como uma linked-list em que os nodes contém as linhas e apontam para a linha
struct node {
    char *data;
    struct node *next;
};

struct cmd {
    char args[2][5];
    char comando;
};

void push(struct node** head , char* new_data)
{
    struct node* new_node = (struct node*) malloc(sizeof(struct node));
    //new_node->data = new_data;
    strcpy(new_node->data, new_data);
    new_node->next = (*head);
    (*head) = new_node;
}

void insert(struct node* prev_node, char* new_data)
{
    if(prev_node == NULL) {
        printf("Node anterior nao pode ser NULL!");
        return;
    }

    struct node* new_node = (struct node*) malloc(sizeof(struct node));

    strcpy(new_node->data, new_data);
    new_node->next = prev_node->next;
    prev_node->next = new_node;
}

void append(struct node** head, char* new_data)
{
    struct node* new_node = (struct node*) malloc(sizeof(struct node));
    struct node* last = *head;
    new_node->data = malloc(strlen(new_data));

    strcpy(new_node->data, new_data);
    new_node->next = NULL;
    
    if(*head == NULL){
        *head = new_node;
        return;
    }

    while (last->next != NULL)
    {
        last = last->next;
    }

    last->next = new_node;
    return;
}
bool is_num(char c)
{
    if((c >= '0') && (c <= '9')){
        return true;
    }
    return false;
}

bool is_token(char c)
{
    if((c == '%') || (c == '$')){
        return true;
    }
    return false;
}

bool is_op(char c) 
{
    for(int i = 0; i < 10; i++){
        if(c == ops[i]){
            return true;
        }
    }
    return false;
}

// Vamos limitar os valores numéricos do argumentos para 5 digitos (max 99.999 linhas num texto)
// guardamos o comando e os seus argumentos numa struct para facilitar futuramente
// a funcao vai guardando os chars dos argumentos num array temporario até encontrar 0 ',' ou uma operaça
cmd makeCommand(char *in)
{
    struct cmd command;
    int argc = 0;
    int arglen = 0;
    char curr_char;
    char t_args[5];
    

    for(int i = 0; i < strlen(in); i++)
    {
        curr_char = in[i];
        if(is_token(curr_char)){
            //command.args[argc][0] = curr_char;
            t_args[arglen] = curr_char;
        }
        if(is_num(curr_char)){
            t_args[arglen] = curr_char;
            arglen++;
        }
        if(curr_char == ','){
            //command.args[argc] = t_args;
            strcpy(command.args[argc], t_args);
            argc++;
            arglen = 0;
        }
        if(is_op(curr_char)){
            if(t_args[0] != 0){
                strcpy(command.args[argc], t_args);
            }
            command.comando = curr_char;
            return command;
        }
    }

    return command;
}

int main(){
    /*
    char input[10];
    scanf("%[^\n]%*c", input);
    struct cmd c;
    c = makeCommand(input);
    struct node* text;
    text = (struct node*) malloc(sizeof(struct node));

    printf("input: %d %d %c\n", atoi(c.args[0]), atoi(c.args[1]), c.comando);    
    */

   char array[8][15] = {
       "duarte", "joao", "rita", "adelina", "bento", "ola", "adeus", "boas"
   };

   struct node* lista;

   for(int i=0; i < 8; i++){
       append(&lista, array[i]);
   }
   while(lista != NULL){
       printf("%s\n", lista->data);
   }
    return 0;
}
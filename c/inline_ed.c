#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#define N_OPS     10;
typedef struct node node;
typedef struct cmd cmd;

char* ops = "iacdpefwqQ";

struct node {
    char *line;
    struct node *next;
};

struct cmd {
    char args[2][5];
    char comando;
};

bool is_num(char c)
{
    if((c <= '0') && (c >= '9')){
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
cmd parseInput(char *in)
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
    char input[10];
    scanf("%[^\n]%*c", input);
    struct cmd c;
    c = parseInput(input);

    printf("input: %s %s %c\n", c.args[0], c.args[1], c.comando);    

    return 0;
}
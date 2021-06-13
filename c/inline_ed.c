#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include "string_linkedlist.c"
#define N_OPS     10
typedef struct cmd cmd;
#define NUM_COLS(x) (sizeof(x) / sizeof(x[0]))
typedef struct ed_txt ed_txt;


char* ops = "iacdpefwqQ";
// o texto vai ser representado como uma linked-list em que os nodes contém as linhas e apontam para a linha
struct cmd {
    char args[2][5];
    char comando;
};



struct ed_txt {
    struct list* p_list;
    int linha_atual;
    char *nome;
    bool isSaved;
};

ed_txt* new_ed_txt(char *name) {
    struct ed_txt* txt = (struct ed_txt*) malloc(sizeof(ed_txt));
    txt->p_list = new_list(NULL);
    txt->linha_atual = 0;
    txt->isSaved = false;
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
// a funcao vai guardando os chars dos argumentos num array temporario até encontrar 0 ',' ou uma operaçao
cmd* new_cmd(char *in){
    struct cmd* command = (struct cmd*) malloc(sizeof(cmd));
    command->args[0][0] = 0;
    command->args[1][0] = 0;
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
            strcpy(command->args[argc], t_args);
            argc++;
            arglen = 0;
        }
        if(is_op(curr_char)){
            if(t_args[0] != 0){
                strcpy(command->args[argc], t_args);
            }
            command->comando = curr_char;
            return command;
        }
    }

    return command;
}


void insert_txt(struct ed_txt* txt_file, int linha)
{
    char *new_line;
    scanf("%s", new_line);
    if(txt_file->p_list->head == NULL) {
        add(txt_file->p_list, new_line);
    }else{
        insert_after(txt_file->p_list, txt_file->p_list->head, linha, new_line);
    }
}

void append_txt(struct ed_txt* txt_file, int linha)
{
    char *new_txt;
    scanf("%s", new_txt);
    insert_after(txt_file->p_list, txt_file->p_list->head, linha, new_txt);
    txt_file->linha_atual = linha;
}

void change_txt(struct ed_txt* txt_file, int linha)
{
    char *new_txt;
    scanf("%s", new_txt);
    modify_after(txt_file->p_list->head, linha, new_txt);
    txt_file->linha_atual = linha;
}

void delete_txt(struct ed_txt* txt_file, int linha)
{
    delete_after(txt_file->p_list, txt_file->p_list->head, linha);
}

void delete_inrange(struct ed_txt* txt_file, int a, int b)
{
    
}

void print_txt(struct ed_txt* txt_file, int linha)
{
    struct node* it = txt_file->p_list->head;
    for(int i = 0; i < linha; i++)
    {
        it = it->next;
    }
    printf("%s\n", it->data);
}

void print_inrange(struct ed_txt* txt_file, int a, int b)
{
    struct node* t = txt_file->p_list->head;
    int c = 0;

    for(int i = 0; i < b; i++){
        if(c < a) {
            c++;
        }else {
            printf("%s \n", t->data);
        }
        t = t->next;
    }
}

void print_all(struct ed_txt* txt_file){
    struct node* t = txt_file->p_list->head;
    while (t != NULL)
    {
        printf("%s \n", t->data);
    }
}

void delete_all(struct ed_txt* txt_file){

}

void savefile(struct ed_txt* txt_file){

}

void renamefile(struct ed_txt* txt_file){

}

void writefile(struct ed_txt* txt_file){

}


int main(){

    char *banner = "################################\n# Bem-vindo ao editor em linha #\n# Trabalho realizado por:      #\n# Duarte Anastácio nº40090     #\n################################";
    puts(banner);

    bool run = true;
    struct ed_txt* txt;
    struct cmd* cm;
    txt = new_ed_txt("teste");
    int a, b;
    char *input;

    while(run)
    {
        scanf("%s", input);
        cm = new_cmd(input);

        if((cm->args[0][0] != 0) && (cm->args[1][0] != 0)){         //tem 2 argumentos
                         
            int a = atoi(cm->args[0]);

            if(cm->args[1][0] == '$'){
                int b = txt->p_list->size;
            }else{
                int b = atoi(cm->args[1]);
            }

            if(cm->comando == 'd') {
                delete_inrange(txt, a, b);
            }else if(cm->comando == 'p') {
                print_inrange(txt,a,b);
            }else {
                puts("Comando inválido!\n");
            }

        }else if ((cm->args[0][0] != 0) && (cm->args[1][0] == 0)){      //tem 1 argumento
            int x;

            if(cm->args[0][0] == '%') {
                x = -1;
            } else if(cm->args[0][0] == '$'){
                x = txt->p_list->size;
            }
            else {
                x = atoi(cm->args[0]);
            }

            if(x == -1) { // se o argumento é '%' entao só ha 2 ops possiveis print e delete
                switch (cm->comando)
                {
                case 'p':
                    print_all(txt);
                    break;
                case 'd':
                    delete_all(txt);
                default:
                    puts("Comando invalido!\n");
                    break;
                }
            }else {
            
                switch (cm->comando)
                {
                    case 'i':
                        insert_txt(txt, x);
                        break;
            
                    case 'a':
                        append_txt(txt, x);
                        break;

                    case 'c':
                        change_txt(txt, x);
                        break;
            
                    case 'd':
                        delete_txt(txt, x);
                        break;
            
                    case 'p':
                        print_txt(txt, x);
                        break;
            
                default:
                    puts("Comando invalido!\n");
                    break;
                }
            }
        }
        else {                          // nao tem argumentos
            switch (cm->comando)
            {
            case 'i':
                insert_txt(txt, txt->linha_atual);
                break;
            
            case 'a':
                append_txt(txt, txt->linha_atual);
                break;

            case 'c':
                change_txt(txt, txt->linha_atual);
                break;
            
            case 'd':
                delete_txt(txt, txt->linha_atual);
                break;
            
            case 'p':
                print_txt(txt, txt->linha_atual);
                break;
            
            case 'e':
                savefile(txt);
                break;
            
            case 'f':
                renamefile(txt);
                break;
            case 'w':
                writefile(txt);
                break;
            case 'q':
                if(txt->isSaved){
                    run = false;
                    puts("Terminado.\n");
                }else {
                    puts("Ficheiro nao guardado!\n");
                }
                break;
            case 'Q':
                run = false;
                puts("Terminado.\n");
                break;
            default:
                puts("Comando invalido!\n");
                break;
            }
        }    
    }



    
















    /*
    struct cmd tc = makeCommand("132,523i");
    printf("%s %s %c\n", tc.args[0], tc.args[1], tc.comando);

   char array[9][10] = {
       "porque", "que", "sera", "que", "nao", "esta", "a", "funcionar", "fim"
    };

    struct list* lista = new_list(NULL);

    for(int i=0; i < NUM_COLS(array); i++){
        add(lista, array[i]);
    }

    struct node* it = lista->head;

    while (it != NULL)
    {
        printf("%s\n", it->data);
        it = it->next;
    }
    insert_after(lista->head, 1, "oi");

    it = lista->head;

    while (it != NULL)
    {
        printf("%s\n", it->data);
        it = it->next;
    }
    return 0;
    */
}
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#define N 11
#define X 
#define O

void print_tie();
void reset_board(int n, char board[N][N]);
void does_player_2_win(char board[N][N], int row, int column, int n, int counter, int player_index, int step_counter);
void does_player_1_win(char board[N][N], int row, int column, int n, int counter, int player_index, int step_counter);
int stirke_of_secondary_diagonal_for_player_1(char board[N][N], int n, int counter, int player_index);
int stirke_of_secondary_diagonal_for_player_2(char board[N][N], int n, int counter, int player_index);
int stirke_of_main_diagonal(char board[N][N], int n, int counter, int player_index);
int stirke_of_column(char board[N][N], int n, int counter, int player_index);
int stirke_of_row(char board[N][N], int n, int row, int column, int counter, int player_index);
void print_error();
void print_welcome();
void print_enter_board_size();
void print_board(char board[N][N], int n);
void print_player_turn(int player_index);
int player_move(int n, int row, int column, char board[N][N], char row_matrix[N * N], char column_matrix[N * N], int step_counter, int player_index, int i, int j, int counter, char *ptr_step_counter);
void print_winner(int player_index);
int game_on(int n, int i, int j, int row, int column, int counter, char board[N][N], int player_index, int step_counter, int row_matrix[N * N], int column_matrix[N * N], int* ptr_step_counter);
void undo(int row, int step_counter, char row_matrix[N * N], char column_matrix[N * N], char board[N][N], int step_back, int n, int player_index, int column, int i, int j, int counter, int* ptr_step_counter);
void ritual_player_1(int n, int i, int j, int row, int column, int counter, char board[N][N], int player_index, int step_counter, int row_matrix[N * N], int column_matrix[N * N], int* ptr_step_counter);
void ritual_player_2(int n, int i, int j, int row, int column, int counter, char board[N][N], int player_index, int step_counter, int row_matrix[N * N], int column_matrix[N * N], int *ptr_step_counter);

//print welcome message
//1 lines
void print_welcome()
{
    printf("*** Welcome to AVOIDANCE TIC-TAC-TOE game ***\n\n");
}

//print message to enter board size
//1 lines
void print_enter_board_size()
{
    printf("Please enter board size (1 to %d):\n", N);
}

//print the board
//7 lines
void print_board(char board[N][N], int n)
{
    printf("\nCurrent board:\n");
    for (int i = 0; i < n; i++)
    {
        printf("|");
        for (int j = 0; j < n; j++)
        {
            printf("%c|", board[i][j]);
        }
        printf("\n");
    }
    printf("\n");
}

//print a request for player with 1 to move
//1 lines
void print_player_turn(int player_index)
{
    printf("\nPlayer ** %d **, enter next move:\n", player_index);
}

//player index turn
int player_move(int n, int row, int column, char board[N][N], char row_matrix[N * N], char column_matrix[N * N], int step_counter, int player_index, int i, int j, int counter, char *ptr_step_counter)
{
    scanf("%d", &row);
    if ((row < 0) && (row % 2 == -1) && (-row < *ptr_step_counter))
    {
        int step_back = -row;
        undo(row, step_counter, row_matrix, column_matrix, board, step_back, n, player_index, column, i, j, counter, ptr_step_counter);
        *ptr_step_counter = step_counter - step_back - 1;
        if (player_index == 1)
        {
            player_index++;
        }
        else
        {
            player_index--;
        }
        return 0;
    }
    if (((row % 2 == 0) || (-row > *ptr_step_counter)) && (row < 0))
    {
        print_error();
        player_move(n, row, column, board, row_matrix, column_matrix, step_counter, player_index, i, j, counter, ptr_step_counter);
        return 0;
    }
        scanf("%d", &column);
    if (row <= n && column <= n && row * column != 0 && (board[row - 1][column - 1] != 'X' && board[row - 1][column - 1] != 'O'))
    {
        row_matrix[step_counter] = row - 1;
        column_matrix[step_counter] = column - 1;
        if (player_index == 1)
        board[row - 1][column - 1] = 'X';
        else board[row - 1][column - 1] = 'O';
        print_board(board, n);
    }
    else
    {
        print_error();
        player_move(n, row, column, board, row_matrix, column_matrix, step_counter, player_index, i, j, counter, ptr_step_counter);
    }
}

//print error message
//1 lines
void print_error()
{
    printf("Illegal move!!!, please try again:\n");
}

//check if there is a srike of a row
int stirke_of_row(char board[N][N], int n,int row, int column, int counter, int player_index)
 {
    counter = 0;
    for (int i = 0; i < n; i++)
    {
        counter = 0;
        for (int j = 1; j < n; j++)
        {
            if ((board[i][j - 1] == board[i][j]) && (board[i][j - 1] != '_'))
            {
                counter++;
            }
            else counter = 0;
        }
        if (counter == n - 1)
        {
            print_winner(player_index);
        }
    }
    return(0);
 }

//check if there is a srike of a column
int stirke_of_column(char board[N][N], int n, int counter, int player_index)
{
    counter = 0;
    for (int j = 0; j < n; j++)
    {
        counter = 0;
        for (int i = 1; i < n; i++)
        {
            if ((board[i-1][j] == board[i][j]) && (board[i - 1][j] != '_'))
            {
                counter++;
            }
            else counter = 0;
        }
        if (counter == n - 1)
        {
            print_winner(player_index);
        }
    }
    return(0);
}

//check if there is a srike of a main diagonal
int stirke_of_main_diagonal(char board[N][N], int n, int counter, int player_index)
{
    counter = 0;
    for (int i = 1, j = 1; i < n; i++, j++)
    {
            if ((board[i-1][j-1] == board[i][j]) && (board[i - 1][j - 1] != '_'))
            {
                counter++;
            }
            else counter = 0;
    }
    if (counter == n - 1)
    {
        print_winner(player_index);
    }
    return(0);
}

//check if there is a srike of a secondary diagonal line for player 1
int stirke_of_secondary_diagonal_for_player_1(char board[N][N], int n, int counter, int player_index)
{
    counter = 0;
    for (int i=0, j=n-1; i < n-1; i++, j--)
    {
        if ((board[i][j] == board[i + 1][j - 1]) && (board[i][j] != '_'))
        {
            counter++;
        }
        else counter = 0;
    }
    if (counter == n - 1)
    {
        print_winner(player_index);
    }
    return(0);
}

//check if there is a srike of a secondary diagonal line for player 2
int stirke_of_secondary_diagonal_for_player_2(char board[N][N], int n, int counter, int player_index)
{
    counter = 0;
    for (int i = 0, j = n - 1; i < n-1; i++, j--)
    {
        if ((board[i][j] == board[i + 1][j - 1]) && (board[i][j] != '_'))
        {
            counter++;
        }
        else counter = 0;
    }
    if (counter == n - 1)
    {
        print_winner(player_index);
    }
    return(0);
}

//print the winner
//4 lines
void print_winner(int player_index)
{
    if (player_index == 1)
    {
        player_index++;
    }
    else player_index--;
    printf("Player %d Wins! Hooray!\n", player_index);
    exit(0);
}
//cheking if player 1 won
void does_player_1_win(char board[N][N], int row, int column, int n, int counter, int step_counter, int player_index)
{
    if (step_counter >= n)
    {
        stirke_of_row(board,n,row,column,counter,player_index);
        stirke_of_column(board, n, row, column, counter, player_index);
        stirke_of_main_diagonal(board, n, row, column, counter, player_index);
        stirke_of_secondary_diagonal_for_player_1(board, n, row, column, counter, player_index);
    }
}

//cheking if player 2 won
void does_player_2_win(char board[N][N], int row, int column, int n, int counter,int step_counter, int player_index)
{
    if (step_counter >= n)
    {
        stirke_of_row(board, n, row, column, counter, player_index);
        stirke_of_column(board, n, row, column, counter, player_index);
        stirke_of_main_diagonal(board, n, row, column, counter, player_index);
        stirke_of_secondary_diagonal_for_player_2(board, n, row, column, counter, player_index);
    }
}

//function of the game 
int game_on(int n,int i,int j,int row, int column, int counter,char board[N][N], int player_index, int step_counter, int row_matrix[N*N], int column_matrix[N*N], int* ptr_step_counter)
{
    while ((*ptr_step_counter < (n*n)))
    {
        while (player_index == 1 && *ptr_step_counter < (n * n))
        {
            ritual_player_1(n, i, j, row, column, counter, board, player_index, step_counter, row_matrix, column_matrix, ptr_step_counter);
            (*ptr_step_counter)++;
            step_counter = *ptr_step_counter;
            player_index++;
        }
        while (player_index == 2 && *ptr_step_counter < (n*n))
        {
            ritual_player_2(n, i, j, row, column, counter, board, player_index, step_counter, row_matrix, column_matrix, ptr_step_counter);
            (*ptr_step_counter)++;
            step_counter = *ptr_step_counter;
            player_index--;
        }
    }
    if (n == 1)
    {
        player_index++;
        print_winner(player_index);
    }
    else print_tie();
}
void ritual_player_1(int n, int i, int j, int row, int column, int counter, char board[N][N], int player_index, int step_counter, int row_matrix[N * N], int column_matrix[N * N], int *ptr_step_counter)
{
    print_player_turn(player_index);
    player_move(n, row, column, board, row_matrix, column_matrix, step_counter, player_index, i, j, counter, ptr_step_counter);
    does_player_1_win(board, row, column, n, counter, step_counter, player_index);
}

void ritual_player_2(int n, int i, int j, int row, int column, int counter, char board[N][N], int player_index, int step_counter, int row_matrix[N * N], int column_matrix[N * N], int* ptr_step_counter)
{
    print_player_turn(player_index);
    player_move(n, row, column, board, row_matrix, column_matrix, step_counter, player_index, i, j, counter,  ptr_step_counter);
    does_player_2_win(board, row, column, n, counter, step_counter, player_index);
}
void reset_board(int n, char board[N][N])
{
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < n; j++)
        {
            board[i][j] = '_';
        }
    }
}

void undo(int row, int step_counter, char row_matrix[N*N], char column_matrix[N*N], char board[N][N], int step_back, int n, int player_index, int column, int i, int j, int counter, int* ptr_step_counter)
{
    for (int i=0;  i < step_back; i++)
    {
        board[(row_matrix[(*ptr_step_counter)-1-i])][(column_matrix[(*ptr_step_counter)-1-i])] = '_';
    }
    print_board(board, n);
    if (player_index == 1)
    {
        player_index++;
        return 0;
    }
    else
    {
        player_index--;
        return 0;
    }
}
//print message to announce there is a tie (no one wins)
//1 lines
void print_tie()
{
    printf("It's a tie!\n");
}

int main()
{
    int n = 0, player_index = 1, i = 0, j = 0, row = 0, column = 0, counter = 0, step_counter = 0, *ptr_step_counter = &step_counter;
    char board[N][N] = { {0} }, row_matrix[N * N] = { 0 }, column_matrix[N * N] = { 0 };
    print_welcome();
    print_enter_board_size();
    scanf("%d", &n);
    reset_board( n, board);
    print_board(board, n);
    game_on(n, i, j, row, column, counter, board, player_index, step_counter, row_matrix, column_matrix, ptr_step_counter);
}



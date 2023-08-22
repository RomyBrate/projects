# In this script you can write your code.
# Start by writing all the functions.
# In the last part after if __name__ == "__main__": you can call the functions to play your game.
# If you run `python tic_tac_toe.py` in the command line the game will start. Try it out! ;)


# Board
board = [" ","1","2","3","4","5","6","7","8","9"] # First space is to match the index with the chosen number.
def create_board():
    print("-----")
    print (board[1] + "|" + board[2] + "|" + board[3])
    print (board[4] + "|" + board[5] + "|" + board[6])
    print (board[7] + "|" + board[8] + "|" + board[9])
    print("-----")
    return 

# Input Player 1
def input_1():              # Player 'x' always starts in our game (!)
    turn_player_x = input("Player 'x', please choose an available number in the board: ")
    if turn_player_x in board:
        board[int(turn_player_x)] = "x"
        create_board() 
    else:
        print("What's wrong with you? Look at the board again.") # Next step: Only show available numbers
        create_board() 
        input_1()
    return

# Input Player 2
def input_2():              # Analogue Player 'x'
    turn_player_o = input("Player 'o', please choose an available number in the board: ")
    if turn_player_o in board:
        board[int(turn_player_o)] = "o"
        create_board() 
    else:
        print("What's wrong with you? Look at the board again.")
        create_board() 
        input_2()
    return

def x_won(): # Eight possibilities of winning the game for Player 'x'
    if (board[1] == "x" and board[2] == "x" and board[3] == "x") or \
        (board[4] == "x" and board[5] == "x" and board[6] == "x") or \
        (board[7] == "x" and board[8] == "x" and board[9] == "x") or \
        (board[1] == "x" and board[4] == "x" and board[7] == "x") or \
        (board[2] == "x" and board[5] == "x" and board[8] == "x") or \
        (board[3] == "x" and board[6] == "x" and board[9] == "x") or \
        (board[1] == "x" and board[5] == "x" and board[9] == "x") or \
        (board[3] == "x" and board[5] == "x" and board[7] == "x"):
        print("Player 'x' won!")
        return True # 
    return False

def o_won(): # Same for Player 'o'
    if (board[1] == "o" and board[2] == "o" and board[3] == "o") or \
        (board[4] == "o" and board[5] == "o" and board[6] == "o") or \
        (board[7] == "o" and board[8] == "o" and board[9] == "o") or \
        (board[1] == "o" and board[4] == "o" and board[7] == "o") or \
        (board[2] == "o" and board[5] == "o" and board[8] == "o") or \
        (board[3] == "o" and board[6] == "o" and board[9] == "o") or \
        (board[1] == "o" and board[5] == "o" and board[9] == "o") or \
        (board[3] == "o" and board[5] == "o" and board[7] == "o"):
        print("Player 'o' won!")
        return True
    return False

print("Welcome to our game of Tic-Tac-Toe.") # Nice welcoming message
create_board()

def game():
    for i in range(1, 10): 
        if i % 2 != 0:
            input_1()
            if i >= 5 and (x_won() or o_won()): # Important: Check if the functions return True or False ...
                break                           # ... otherwise the Loop won't break
            elif i == 9 and (x_won() and o_won()) == False:
                print("Both of you won!(not)")
        else:
            input_2()
            if i >= 5 and (x_won() or o_won()): # Important: Check if the functions return True or False ...
                break                           # ... otherwise the Loop won't break
            elif i == 9 and (x_won() and o_won()) == False:
                print("Both of you won!(not)")
    return


# Tic-tac-toe game
if __name__ == "__main__":
   # while True:
        game()

"""
VISIONS
-Random choice of player
-Ask player to choose the team (x or o)
-Restart game (Loser starts next game)
-More dialog
-A Bundesliga (Database of results)




"""
# Tic-Tac-Toe


## Introduction

Today you're going to write code for your own [tic tac toe game](https://en.wikipedia.org/wiki/Tic-tac-toe)! This is a much more involved problem than any you've seen in this class so far. Thus, you need to write a helpful pseudocode and think about how to break up your solution into smaller parts before you start writing it. 

This file will give suggestions on how to write this program. Remember, though, that there's always more than one solution to any programming problem. So, if you want to do something that's not suggested by the assignment or structure your code differently, by all means give it a try! 


## Deliverables:

+ Pseudocode explaining the logic of your code
+ A working Python script that allows two people to play tic-tac-toe against each other. 
  + The game should be able to be started by running the script in the command line. 

Hints:
- Your first version of the game does not have to take into account everything that could go wrong. But should work in a 'happy flow' state where user takes only expected actions.
- Only if you are done with your MVP, you should go back to consider error handling, for example handling if the user types something outside a specific range or in the wrong format. 
- The game does not have to look nice! Keep it simple. There is no need for a fancy visual interface :)  

## Task Breakdown
### Step 1: Write Pseudocode
Before you start coding, think about the game. Your version of the game can have several degrees of complexity.  
But since it's your first coding challenge, let's keep it simple:

Take your time to write Pseudocode for the game. This is essential and not to be neglected!  
Already in your pseudocode consider to split the game into several, smaller functions, each for a specific task, instead of writing one big function. This makes it easier to write and debug your code. You can capture possible extensions in pseudocode. Read through your step by step code and determine if somethings can be listed as 'nice to have' that can be removed from the MVP and saved for any possible further versions.  
Have a look at the file [Intro_to_pseudocode.md](Intro_to_pseudocode.md), which will help you to write your Pseudocode.
 

### Step 2: Write your code
#### a) Getting started
Open the [tic_tac_toe.py](tic_tac_toe.py) file in VS Code.   
The first lines are already there - when you run the script name in the command line, your game will be started.  
Inside the main function structure you can call all the other functions to perform their tasks.   
**Hints**:   
- Since a game of Tic-tac-toe is basically repeating the same tasks over and over again (like asking the players for input) a `while True` loop can help you to get the game running. You have to make sure, however, that in case of certain events (win, draw,...) the loop will break so that the game will come to an end.
- Another challenge to think about is how to allow each player to take turns at making their moves. Here the **modulo operator** could be helpful.

#### b) Display the board 
To play a round of tic-tac-toe, we need a game board. We should start by defining a function that will display the board on the screen when it is called. There are several ways to display a tic-tac-toe board. Choose the implementation that you can work best with as we proceed.  

Maybe like this...  
1, 2, 3    
4, 5, 6   
7, 8, 9   

or this...   
(0, 0), (1, 0), (2, 0)   
(0, 1), (1, 1), (2, 1)   
(0, 2), (1, 2), (2, 2)   


#### c) Ask for player input 
Before we can start playing define what the markers will be for each player. Usually we just use "X" or "O".  
Now you need a function that asks the player (whose turn it is) where they want to put their marker.  
**Hint**:   
The built-in function `input()` will do this task for you.   
If you want, you can directly add a control mechanism that checks if the desired position was already occupied in a previous turn. 

#### d) Check for Winner
At the end of each turn, your script will have to determine if the most recent play resulted in a win. If it did, it should break the game loop, the player that just played will be declared the winner, the game will be over, and the script will terminate. If a winner is not found, play will continue. Keep in mind that there are 8 different ways for a player to get three in a row. The function you write to solve this part of the problem will have to implement a lot of logic.   

#### e) Check for Draw
There is a chance that a draw will occur in the game. If this happens, your script should be aware. If all of the squares have been filled in, and there is no winner, it should break the game loop and a draw should be declared. 

### Extra credit: Increase complexity 

Nice! At this point you should have a running Python script which let's two people play Tic-tac-toe against each other. If you have time and are still motivated, you can take it to the next level.   
**Some add-ons to think about**:   
- No matter how you implemented your game, you never know how users of your script will interact with it. What happens if they enter a square that is off the grid, outside the range of the board? What about if they don't enter properly formatted input? What if they try to play in a square that has already been played in? Can you make your script robust to these possibilities? Try to continually break your solution. It's both fun and can reveal bugs that you hadn't thought of before.

- A nice add-on would also be, if you could play the game several times without having to start it from the command line every time. Why not modify the game so that it offers you another round after finishing the first. 

### Step 3: Play your Game!
Last but not least, you could work on making what is printed to the screen prettier or you could just relax and play a game of Tic-tac-toe. You've earned it!


## Some words on debugging 

Within each of these steps, and frequently between them, you will likely need to do some debugging. One way to do this is by trying to play your game as you implement different parts of it. If something isn't working, you'll get an error message telling you why. In addition, Python will tell you where it ran into the error and give you the stack trace leading up to that line getting executed. Try reading these error messages and extracting the important information (in which line did the error occur, what kind of error was raised...).  
Understanding those messages is a necessary skill for a programmer to have, and one that can only be developed via practice. 

There are far too many programmers who can't debug on this fundamental level: reading an error message and thinking about/reading your code -> figuring out how that error could be produced -> fixing it -> starting over. You're not going to be one of those programmers. Debugging like this is also a great way to get very familiar with any language.

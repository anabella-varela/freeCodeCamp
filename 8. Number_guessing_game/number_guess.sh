#!/bin/bash

# Create variable PSQL for connecting to Postgres Database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Prompt user to enter their username
echo "Enter your username:"
read USERNAME

#Retreive in a single query all the information from database (for better performance of the script)
IFS="|" read GAMES_PLAYED BEST_GAME USER_ID <<< "$($PSQL "SELECT COUNT(game_id), MIN(number_of_guesses), user_id FROM games FULL JOIN users USING(user_id) WHERE username = '$USERNAME' GROUP BY user_id")"

# If user_id id null
if [[ -z $USER_ID ]]; then
  # Welcome message for new users
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  # Insert the new_user to the database and Retrieve user_id in a single command
  # The -q flag is used to suppress the output of the psql command, so only the returned user_id value is printed to the console.
  USER_ID="$($PSQL "INSERT INTO users(username) VALUES('$USERNAME') RETURNING user_id" -q)"

  # If there is that user_id in the database
  else
  # Welcome message for returning users
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Generate secret number between 1 and 1000
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
# Generate number_of_guesses variable. This is better than constantly connecting to the database and change the data
NUMBER_OF_GUESSES=0


  # Prompt the user to guess the secret number
  echo -e "\nGuess the secret number between 1 and 1000:"
  
  #Instead of calling a function is better a while loop that will run indefinitely until the code inside the loop issues a break command to exit the loop.
  while :
  do
  #Within the while loop, ((TRIES++)) increments the variable TRIES by 1 each time the loop iterates, indicating the number of attempts made so far.
    ((NUMBER_OF_GUESSES++))

    read NUMBER_GUESS

    # If the input is not an integer between 1 and 1000
    if [[ !($NUMBER_GUESS =~ ^[0-9]+$ && $NUMBER_GUESS -ge 1 && $NUMBER_GUESS -le 1000) ]]
      then
      echo -e "\nThat is not an integer, guess again:"
      # If number is an interger between 1 and 1000, check if the input is less than the secret number
      elif [[ $NUMBER_GUESS -lt $SECRET_NUMBER ]]
      then
      echo -e "\nIt's higher than that, guess again:"         
      # If the input is greater than the secret number
      elif [[ $NUMBER_GUESS -gt $SECRET_NUMBER ]]
      then
      echo -e "\nIt's lower than that, guess again:"       
      elif [[ $NUMBER_GUESS -eq $SECRET_NUMBER ]]
      then
      echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      # Insert a new game record into the database
      NEW_RECORD=$($PSQL "INSERT INTO games(user_id, number_of_guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES)")
      #Break out of the infinite loop, and end the game.
      break
    fi 
  done   

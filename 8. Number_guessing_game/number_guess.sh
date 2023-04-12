#!/bin/bash

# Create variable PSQL for connecting to Postgres Database
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Prompt user to enter their username
echo -e "Enter your username:"
read NAME

# Retreive user_id from database
USER_ID=$($PSQL"SELECT user_id FROM users WHERE name='$NAME'")

  # If user_id id null
if [[ -z $USER_ID ]]; then
  # Welcome message for new users
  echo -e "\nWelcome, $NAME! It looks like this is your first time here.\n"
  # Insert the new_user to the database
  NEW_USER=$($PSQL" INSERT INTO users(name) VALUES('$NAME')")
  # Retrieve user_id from the new_user
  USER_ID=$($PSQL"SELECT user_id FROM users WHERE name='$NAME'")
  # Create a new_game record for the new_user
  NEW_GAME=$($PSQL"INSERT INTO games(user_id, number_of_guesses) VALUES($USER_ID, 0)")
  # Retrieve the game_id of the new game
  GAME_ID=$($PSQL"SELECT game_id FROM games WHERE user_id=$USER_ID AND number_of_guesses=0")
  
  # If there is that user_id in the database
  else
  # Retrieve in a single query the number of games played by returning users and their best game
  GAMES_PLAYED_AND_BEST_GAME=$($PSQL"SELECT COUNT(user_id), MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID")
  # Extract the two values from the result. The tr command replace | with a space to separate the two values, which are then passed to the read command to store them in separate variables.
  read GAMES_PLAYED BEST_GAME <<< $(echo $GAMES_PLAYED_AND_BEST_GAME | tr '|' ' ')
  # Welcome message for returning users
  echo -e "\nWelcome back, $NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  # Create a new game record for returning users
  NEW_GAME=$($PSQL"INSERT INTO games(user_id, number_of_guesses) VALUES($USER_ID, 0)")
  # Retrieve the game_id of the new_game_record
  GAME_ID=$($PSQL"SELECT game_id FROM games WHERE user_id=$USER_ID AND number_of_guesses=0")
fi

# Generate secret number between 1 and 1000
SECRET_NUMBER=$(shuf -i 1-1000 -n 1)
# Prompt the user to guess the secret number
echo -e "\nGuess the secret number between 1 and 1000:"

# Create a recursive function for the game
GAME () {
  read NUMBER
  # If the input is not an integer between 1 and 1000
if [[ !($NUMBER =~ ^[0-9]+$ && $NUMBER -ge 1 && $NUMBER -le 1000) ]]
  then
  echo -e "\nThat is not an integer, guess again:"
  # Update the number of guesses for the current game 
  GUESS_INTENT=$($PSQL"UPDATE games SET number_of_ guesses=(SELECT SUM(number_of_guesses + 1) FROM games WHERE game_id = $GAME_ID) WHERE game_id = $GAME_ID")
  # Recursively call the GAME function again to prompt for a new guess
  GAME
  
  # If number is an interger between 1 and 1000, check if the input is less than the secret number
  elif [[ $NUMBER -lt $SECRET_NUMBER ]]
  then
  echo -e "\nIt's higher than that, guess again:"
  # Update the number of guesses for the current game and prompt for a new guess
  GUESS_INTENT=$($PSQL"UPDATE games SET number_of_guesses=(SELECT SUM(number_of_guesses + 1) FROM games WHERE game_id = $GAME_ID) WHERE game_id = $GAME_ID")
  GAME

  # If the input is greater than the secret number
  elif [[ $NUMBER -gt $SECRET_NUMBER ]]
  then
  echo -e "\nIt's lower than that, guess again:"
  # Update the number of guesses for the current game and prompt for a new guess
  GUESS_INTENT=$($PSQL"UPDATE games SET number_of_guesses=(SELECT SUM(number_of_guesses + 1) FROM games WHERE game_id = $GAME_ID) WHERE game_id = $GAME_ID")
  GAME

  else 
  # Update the number of guesses for the current game and prompt for a new guess
  GUESS_INTENT=$($PSQL"UPDATE games SET number_of_guesses=(SELECT SUM(number_of_guesses + 1) FROM games WHERE game_id = $GAME_ID) WHERE game_id = $GAME_ID")
  # Retrive user's game record and give a congratulation message
  NUMBER_OF_GUESSES=$($PSQL"SELECT number_of_guesses FROM games WHERE game_id=$GAME_ID")
  echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

fi 
}

GAME
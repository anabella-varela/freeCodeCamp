#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$PSQL "TRUNCATE TABLE teams, games"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do 

 if [[ $WINNER != 'winner' ]]
  then
    #get team ID
    TEAM_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")
    #if is null
      if [[ -z $TEAM_ID ]]
      then
      #insert winner team in teams table
      WINNER_TEAM=$($PSQL"INSERT INTO teams(name) VALUES ('$WINNER')")
        if [[ $WINNER_TEAM == "INSERT 0 1" ]]
        then
        echo Inserted $WINNER
        fi
      fi 
  fi   
#insert opponent team in team table
    if [[ $WINNER != 'winner' ]]
    then
    OPPONENT_TEAM=$($PSQL"INSERT INTO teams(name) VALUES ('$OPPONENT')")
          if [[ $OPPONENT_TEAM == "INSERT 0 1" ]]
          then
          echo Inserted $OPPONENT
          fi

    fi

      #get team_id from team teable
  WINNER_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL"SELECT team_id FROM teams WHERE name='$OPPONENT'")
  
  #insert data in games tables with the correct team_id
  GAME=$($PSQL"INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $GAME == "INSERT 0 1" ]]
  then
  echo Game $WINNER vs $OPPONENT inserted
  fi
 
    
done

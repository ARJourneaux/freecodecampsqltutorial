#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  if [[ $YEAR != "year" ]]
  then
    if [[ -z $YEAR || -z $ROUND || -z $WINNER || -z $OPPONENT || -z $WGOALS || -z $OGOALS ]]
    then
      echo "Error at round $YEAR $ROUND" 
    
    else
      
      # Get winning team id
      W_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      # If not found
      if [[ -z $W_TEAM_ID ]]
      then
        # Insert team
        INSERT_W_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_W_RESULT == "INSERT 0 1" ]]
        then
          echo "Inserted team $WINNNER"
        fi
        # Get new id
        W_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
      fi

      # Get opponent team id
      O_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      # If not found
      if [[ -z $O_TEAM_ID ]]
      then
        # Insert team
        INSERT_O_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_O_RESULT == "INSERT 0 1" ]]
        then
          echo "Inserted team $OPPONENT"
        fi
        # Get new id
        O_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
      fi

      # Insert game
      echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $W_TEAM_ID, $O_TEAM_ID, $WGOALS, $OGOALS)")
    fi
  fi
done

# Do not change code above this line. Use the PSQL variable above to query your database.


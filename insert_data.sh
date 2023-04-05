#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Delete previus table

echo "$($PSQL "truncate teams , games;")"

# Insert Football teams to database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS

do

if [[ $WINNER != winner ]]
then
  #get team id fro winner side


  WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")

  
  # if not found
 if [[ -z $WINNER_ID ]]
 then
   
  # insert team
  INSERT_TEAM=$($PSQL "Insert into teams(name) values('$WINNER')")

  # get new team_id
  WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")

  
  fi

fi
#Repeat process for losing teams

if [[ $OPPONENT != opponent ]]
then 
  OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")

  
  # if not found
  if [[ -z $OPPONENT_ID ]]
  then
   
  # insert team
  INSERT_TEAM=$($PSQL "Insert into teams(name) values('$OPPONENT')")

  # get new team_id
  OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")

  
  fi
fi


 #Get winners and opponents ids from teams table

if [[ $YEAR != year ]]
then  

  #Asing values to table.

INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES( $YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WGOALS , $OGOALS)")

  if [[ $INSERT_GAMES == "INSERT 0 1" ]]
  then
    echo "Inserted into games $WINNER vs $OPPONENT in $YEAR $ROUND"

  fi
fi

done

#!/bin/bash

#create a PSQL variable for querying the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if no argument is provided to the scrip
if [ $# -eq 0 ]; then
  echo "Please provide an element as an argument."
  exit
fi

# get the argument passed to the script
ELEMENT=$1

#If the input is a number from 1 to 10, 
if [[ $ELEMENT =~ ^[1-9]$|^10$ ]]
#The ^ symbol denotes the start of the line, and the $ symbol denotes the end of the line. The | symbol represents an OR condition, so the pattern matches either a single digit from 1 to 9 or the number 10. The =~ operator in the if statement is used to perform a regular expression match in Bash
then
ATOMIC_NUMBER=$ELEMENT
#Search for the name
NAME=$($PSQL"SELECT name FROM elements WHERE atomic_number = $ELEMENT")
#Search for the symbol
SYMBOL=$($PSQL"SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
#Search for the type
TYPE=$($PSQL"SELECT type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
#Search for the mass
MASS=$($PSQL"SELECT atomic_mass FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
#Search for the melting point
MELT_POINT=$($PSQL"SELECT melting_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
#Search for the boiling point
BOILING_POINT=$($PSQL"SELECT boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")

echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOILING_POINT celsius."


else
#if the input is not a number, check if it is a symbol or name and retrieve the name (case insensive)
NAME=$($PSQL"SELECT name FROM elements WHERE UPPER(symbol)=UPPER('$ELEMENT') OR UPPER(name)=UPPER('$ELEMENT')")
#search for the atomic number
ATOMIC_NUMBER=$($PSQL"SELECT atomic_number FROM elements WHERE UPPER(symbol)=UPPER('$ELEMENT') OR UPPER(name)=UPPER('$ELEMENT')")
#Search for the symbol
SYMBOL=$($PSQL"SELECT symbol FROM elements WHERE UPPER(symbol)=UPPER('$ELEMENT') OR UPPER(name)=UPPER('$ELEMENT')")
#Search for the type
TYPE=$($PSQL"SELECT type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE UPPER(symbol)=UPPER('$ELEMENT') OR UPPER(name)=UPPER('$ELEMENT')")
#Search for the mass
MASS=$($PSQL"SELECT atomic_mass FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE UPPER(symbol)=UPPER('$ELEMENT') OR UPPER(name)=UPPER('$ELEMENT')")
#Search for the melting point
MELT_POINT=$($PSQL"SELECT melting_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE UPPER(symbol)=UPPER('$ELEMENT') OR UPPER(name)=UPPER('$ELEMENT')")
#Search for the boiling point
BOILING_POINT=$($PSQL"SELECT boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE UPPER(symbol)=UPPER('$ELEMENT') OR UPPER(name)=UPPER('$ELEMENT')")

  if [[ -z "$NAME" ]]
  then
  echo "I could not find that element in the database."
  else
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi

fi

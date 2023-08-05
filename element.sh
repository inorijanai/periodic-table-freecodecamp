#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius.
# name, symbol from elements, type from types, melting and boiling point from properties

GET_ELEMENT() {
  # get atomic_number
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number::text = '$ELEMENT_TO_QUERY' OR symbol = '$ELEMENT_TO_QUERY' OR name = '$ELEMENT_TO_QUERY'")
  # if not found
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    IFS="|" read NAME SYMBOL TYPE MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS ATOMIC_MASS<<< $(echo $($PSQL "SELECT name, symbol, type, melting_point_celsius, boiling_point_celsius, atomic_mass FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER"))
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
}

ELEMENT_TO_QUERY=$1
if [[ -z $ELEMENT_TO_QUERY ]]
then
  echo "Please provide an element as an argument."
else
  GET_ELEMENT
fi
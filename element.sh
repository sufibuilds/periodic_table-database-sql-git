#!/bin/bash

# Define the PSQL variable to connect to the database
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# 1. Check if an argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# 2. Determine if input is a number, symbol, or name
if [[ $1 =~ ^[0-9]+$ ]]
then
  # Query using atomic_number
  ELEMENT_DATA=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = $1")
else
  # Query using symbol or name
  ELEMENT_DATA=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.symbol = '$1' OR e.name = '$1'")
fi

# 3. Check if element exists
if [[ -z $ELEMENT_DATA ]]
then
  echo "I could not find that element in the database."
else
  # 4. Parse the pipe-delimited output
  IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING <<< "$ELEMENT_DATA"
  
  # 5. Output the required message
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
fi
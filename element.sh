#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -v ON_ERROR_STOP=1"

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

element=$($PSQL -v lookup="$1" <<< "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE elements.atomic_number::text = :'lookup' OR LOWER(elements.symbol) = LOWER(:'lookup') OR LOWER(elements.name) = LOWER(:'lookup');")

if [[ -z "$element" ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r atomic_number name symbol element_type atomic_mass melting_point boiling_point <<< "$element"
printf "The element with atomic number %s is %s (%s). It's a %s, with a mass of %s amu. %s has a melting point of %s celsius and a boiling point of %s celsius.\n" \
  "$atomic_number" "$name" "$symbol" "$element_type" "$atomic_mass" "$name" "$melting_point" "$boiling_point"
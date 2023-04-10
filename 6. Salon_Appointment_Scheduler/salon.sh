#!/bin/bash
#create variable PSQL for connecting to postgres
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c" 
echo -e "\n~~~~~ MY SALON ~~~~~"
# create the function
MAIN_MENU() {
  # if a command-line argument is provided when MAIN_MENU is executed, it prints the argument on a new line.
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

#retrieve services from database
SERVICES=$($PSQL"SELECT * FROM services")
# format the output as a list with sed command
# s/ |/)/g replaces | with )
# s/[0-9])/\n&/g replaces all occurrences of a space followed by a number and a closing parenthesis with a newline character (\n) followed by the matched string (&).
SERVICES_FORMATED= echo $SERVICES | sed -e '
                                            s/ |/)/g
                                            s/[0-9])/\n&/g
                                            '

read SERVICE_ID_SELECTED
# If the input is not a number from 0 to 9 
if [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]+$ ]]
then
#send to main menu again
MAIN_MENU "I could not find that service. What would you like today?"
else
  #get customer phone
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  # get customer_id from database
  CUSTOMER_ID=$($PSQL"SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  #if the customer_id is not in the records
    if [[ -z $CUSTOMER_ID ]]
    then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    #add custmer details into the salon database
    ADD_CUSTOMER=$($PSQL"INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    fi
  #get customer name form database
  CUSTOMER_NAME=$($PSQL"SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  CUSTOMER_ID=$($PSQL"SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    #ask time of service
    echo -e "\nWhat time would you like your cut,$CUSTOMER_NAME?"
    read SERVICE_TIME
    #insert appointment details
    ADD_APPOINTMENT=$($PSQL"INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME') ")
   # share appointment details
   # first I need to know the service name for the ID selected
   SERVICE=$($PSQL"SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."


fi
}


# call the funtion
MAIN_MENU


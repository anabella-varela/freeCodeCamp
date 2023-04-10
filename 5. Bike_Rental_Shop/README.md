**Bike rental shop**

The file contains a interactive Bash program that stores rental information for a bike rental shop using PostgreSQL. The script uses a PostgreSQL database to store information about bikes, customers, and rentals. Here are the main functions of the script:
- MAIN_MENU(): Displays the main menu and handles the user's selection.
- RENT_MENU(): Allows the user to rent a bike. It displays the available bikes, asks the user to select a bike, prompts for the customer's phone number, creates a new customer if they don't already exist, inserts a new rental record into the database, and sets the availability of the bike to false.
- RETURN_MENU(): Allows the user to return a bike. It prompts for the customer's phone number, displays the bikes rented by the customer that haven't been returned, asks the user to select a bike to return, updates the rental record with the return date, and sets the availability of the bike to true.

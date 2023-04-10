The task for this proyect where

- display a numbered list of the services you offer before the first prompt for input, each with the format #) <service>. For example, 1) cut, where 1 is the service_id

- If you pick a service that doesn't exist, you should be shown the same list of services again

- Your script should prompt users to enter a service_id, phone number, a name if they aren’t already a customer, and a time. You should use read to read these inputs into variables named SERVICE_ID_SELECTED, CUSTOMER_PHONE, CUSTOMER_NAME, and SERVICE_TIME

- If a phone number entered doesn’t exist, you should get the customers name and enter it, and the phone number, into the customers table

- After an appointment is successfully added, you should output the message I have put you down for a <service> at <time>, <name>. For example, if the user chooses cut as

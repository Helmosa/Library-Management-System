## Library Management System

A simple SQL-based Library Management System that handles:

- Member and book management.
- Book lending and returns.
- Overdue suspension.

## Features

- Loan tracking.
- Member suspension for overdue returned books.
- Stored procedures for automation.

## Database Schema

### Tables:
- Books: Stores information about books available in the library (title, author, publisher, year, ISBN)
- Members: Contains details about library members (first name, last name, contact info, due dates, loan dates).
- Loans: Tracks the books loaned to members including loan dates, due dates, and return dates.
- Suspensions: Records instances where members' borrowing privileges are suspended due to overdue books including the suspension date and reason.



### Stored Procedure:

- LoanBook: Handles the process of loaning a book to a member and updates the 'Loans' table accordingly.
- ReturnBook: Handles the return of a book, suspends borrowing privileges for overdue books (if the return is more than 14 days late) and updates the 'Loans' and 'Suspensions' tables accordingly.




## Technologies Used

- MySQL RDBMS.
 
## Setup Instructions

1. Clone this repository
2. Import "Library management systemt.sql" into your RDBMS.
3. Run the stored procedures or test queries as needed.
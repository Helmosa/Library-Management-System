CREATE DATABASE library_system;
USE library_system;

# Books table
CREATE TABLE Books (
    BookID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    BookTitle VARCHAR(50) NOT NULL,
    Author VARCHAR(50) NULL,
    Publisher VARCHAR(50) NULL,
    YearPublished INT NULL,
    ISBN VARCHAR(15) UNIQUE
);

# Members table
CREATE TABLE Members (
    MemberID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(10) NOT NULL,
    LastName VARCHAR(10) NOT NULL,
    Email VARCHAR(30) NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE NOT NULL,
    LoanDate DATE NOT NULL,
    Phone VARCHAR(12) NOT NULL
);

# Loans table
CREATE TABLE Loans (
    LoanID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    BookID INT UNSIGNED,
    MemberID INT UNSIGNED,
    LoanDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

# Suspension table
CREATE TABLE Suspensions (
    SuspensionID INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    MemberID INT UNSIGNED NOT NULL,
    SuspensionDate DATE NOT NULL,
    Reason VARCHAR(100) DEFAULT 'Overdue return',
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
);

# B-Tree Indexing
CREATE INDEX idx_book_title ON Books (BookTitle);
CREATE INDEX idx_first_name ON Members (FirstName);
CREATE INDEX idx_loan_due ON Loans (DueDate);

# Procedure to loan a book
DELIMITER //
CREATE PROCEDURE LoanBook(IN p_BookTitle INT, IN p_MemberID INT, IN p_Days INT)
BEGIN
    DECLARE due DATE;
    SET due = DATE_ADD(CURDATE(), INTERVAL p_Days DAY);
    INSERT INTO Loans (BookTitle, MemberID, DueDate) VALUES (p_BookTitle, p_MemberID, due);
END;
//
DELIMITER ;

# Procedure to return a book and suspend borrowing privileges for long overdue items
DELIMITER //
CREATE PROCEDURE ReturnBook(IN p_LoanID INT)
BEGIN
    DECLARE due DATE;
    DECLARE today DATE;
    DECLARE memberId INT;
    DECLARE daysOverdue INT;

    SET today = CURDATE();

    -- Get due date and member ID
    SELECT DueDate, MemberID INTO due, memberId FROM Loans WHERE LoanID = p_LoanID;

    -- Update the return date
    UPDATE Loans SET ReturnDate = today WHERE LoanID = p_LoanID;

    -- Check if overdue and suspend borrowing if more than 14 days late
    IF today > due THEN
        SET daysOverdue = DATEDIFF(today, due);

        IF daysOverdue > 14 THEN
            -- Insert suspension record
            INSERT INTO Suspensions (MemberID, SuspensionDate)
            VALUES (memberId, today);
        END IF;
    END IF;
END;
//
DELIMITER ;

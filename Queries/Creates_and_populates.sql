-- -------------------------------------------------------------------
--  CREATE DATABASE
-- -------------------------------------------------------------------

CREATE DATABASE Library;
GO

USE Library;

-- -------------------------------------------------------------------
--  CREATE TABLES
-- -------------------------------------------------------------------

-- Create "Languages" table
CREATE TABLE Languages(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    -- BookLanguage renamed from Language due to reserved keyword
    BookLanguage VARCHAR(25) NOT NULL UNIQUE
);
GO

-- Create "Book Genres" table
CREATE TABLE BookGenres(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    Genre VARCHAR(15) NOT NULL UNIQUE
);
GO

-- Create "Availability Statuses" table
CREATE TABLE AvailabilityStatuses(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    -- AvailStatus renamed from Status due to reserved keyword
    AvailStatus VARCHAR(25) NOT NULL UNIQUE 
);
GO


-- Create "Rental Statuses" table
CREATE TABLE RentalStatuses(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    -- RentStatus renamed from Status due to reserved keyword
    RentStatus VARCHAR(10) NOT NULL UNIQUE,
    Fine VARCHAR(20)
);
GO


-- Create "Membership Types" table
CREATE TABLE MembershipTypes(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    MembershipType VARCHAR(20) NOT NULL UNIQUE
);
GO


-- Create "User Permission Levels" table
CREATE TABLE UserPermissionLevels(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    PermissionLevel VARCHAR(25) NOT NULL
);
GO


-- Create "Publishers" table
CREATE TABLE Publishers(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    -- PublisherName renamed from Name due to reserved keyword
    PublisherName VARCHAR(50) NOT NULL,
    Website VARCHAR(200),
    Email VARCHAR(60),
    Phone VARCHAR(25),
    -- PublisherAddress renamed from Address due to reserved keyword
    PublisherAddress VARCHAR(150),
    YearOfFounding VARCHAR(4) 
);
GO


-- Create "Authors" table
CREATE TABLE Authors(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(25) NOT NULL,
    LastName VARCHAR(25) NOT NULL,
    Bio XML,
    Email VARCHAR(60),
    Phone VARCHAR(25),
    Website VARCHAR(100)
);
GO


-- Create "Members" table
CREATE TABLE Members(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(25) NOT NULL,
    LastName VARCHAR(25) NOT NULL,
    Email VARCHAR(60) NOT NULL,
    Phone VARCHAR(25) NOT NULL,
    MembershipType TINYINT NOT NULL,
    MembershipActive BIT NOT NULL,
    DateOfJoining DATE NOT NULL,
    CONSTRAINT fk_Members_MembershipType FOREIGN KEY(MembershipType) REFERENCES MembershipTypes(ID) 
);
GO


-- Create "Credentials" table
CREATE TABLE Credentials(
    Username VARCHAR(15) PRIMARY KEY,
    -- UserPassword renamed from Password due to reserved keyword
    UserPassword CHAR(256) NOT NULL,
    PermissionLevel TINYINT NOT NULL,
    CredentialsActive BIT NOT NULL,
    CONSTRAINT fk_Credentials_PermissionLevel FOREIGN KEY (PermissionLevel) REFERENCES UserPermissionLevels(ID)
);
GO


-- Create "Staff" table
CREATE TABLE Staff(
    IDNumber VARCHAR(9) PRIMARY KEY,
    FirstName VARCHAR(25) NOT NULL,
    LastName VARCHAR(25) NOT NULL,
    HiringDate DATE NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email VARCHAR(60) NOT NULL UNIQUE,
    Phone VARCHAR(25) NOT NULL UNIQUE,
    Credentials VARCHAR(15) NOT NULL UNIQUE,
    -- EmployeeRole renamed from Role due to reserved keyword
    EmployeeRole VARCHAR(25) NOT NULL,
    CONSTRAINT fk_Staff_Credentials FOREIGN KEY (Credentials) REFERENCES Credentials(Username)
);
GO


-- Create "Books" table
CREATE TABLE Books (
    BookBarcode VARCHAR(40) PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Publisher INT NOT NULL,
    PublicationDate DATE NOT NULL,
    -- BookEdition renamed from Edition due to reserved keyword
    BookEdition VARCHAR(10) NOT NULL,
    -- BookDescription renamed from Description due to reserved keyword
    BookDescription XML,
    -- BookLanguage renamed from Language due to reserved keyword
    BookLanguage TINYINT NOT NULL,
    AlternativeTitles XML,
    Genre TINYINT NOT NULL,
    -- AvailabilityStatus renamed from Availability due to reserved keyword
    AvailabilityStatus TINYINT NOT NULL,
    CallNumber VARCHAR(20) NOT NULL,
    CONSTRAINT fk_Books_Publisher FOREIGN KEY (Publisher) REFERENCES Publishers(ID),
    CONSTRAINT fk_Books_Language FOREIGN KEY (BookLanguage) REFERENCES Languages(ID),
    CONSTRAINT fk_Books_Genre FOREIGN KEY (Genre) REFERENCES BookGenres(ID),
    CONSTRAINT fk_Books_Status FOREIGN KEY (AvailabilityStatus) REFERENCES AvailabilityStatuses(ID)
);
GO


-- Create "Rent Records" table
CREATE TABLE RentRecords(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    RentedBy INT NOT NULL,
    RentedBook VARCHAR(40) NOT NULL,
    DateOfRental DATETIME NOT NULL,
    DueDate DATETIME NOT NULL,
    AuthorizedBy VARCHAR(9) NOT NULL,
    -- RentStatus renamed from Status due to reserved keyword
    RentStatus TINYINT NOT NULL,
    CONSTRAINT fk_RentRecords_Members FOREIGN KEY (RentedBy) REFERENCES Members(ID),
    CONSTRAINT fk_RentRecords_Books FOREIGN KEY (RentedBook) REFERENCES Books(BookBarcode),
    CONSTRAINT fk_RentRecords_Staff FOREIGN KEY (AuthorizedBy) REFERENCES Staff(IDNumber),
    CONSTRAINT fk_RentRecords_Status FOREIGN KEY (RentStatus) REFERENCES RentalStatuses(ID)
);
GO


-- Create "Books/Authors" table
CREATE TABLE Books_Authors(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Book VARCHAR(40) NOT NULL,
    Author INT NOT NULL,
    CONSTRAINT fk_Books_Auhtors_Book FOREIGN KEY (Book) REFERENCES Books(BookBarcode),
    CONSTRAINT fk_Books_Auhtors_Author FOREIGN KEY (Author) REFERENCES Authors(ID)
);
GO


-- -------------------------------------------------------------------
--  POPULATE TABLES
-- -------------------------------------------------------------------

-- Populates "Rental Statuses" table
-- Statuses should be only "On Hold", "On Time", "Overdue", "Returned" or "Book Lost"
INSERT INTO RentalStatuses (RentStatus, Fine)
VALUES
('On Hold', ''),
('On Time', ''),
('Overdue', '0.50 EUR/hour'),
('Returned', ''),
('Book Lost', '10 EUR')
GO


-- Populates "User Permission Levels" table
-- Should correspond to possible staff roles
INSERT INTO UserPermissionLevels (PermissionLevel)
VALUES
('None'),
('Search only'),
('Rent and return'),
('Rent, Return, Register'),
('Manage Library'),
('Manage Library and Staff'),
('Admin')
GO


-- Populates "Membership Types" table
-- Should be only "Child", "Young Adult", "Adult", "Student"
-- "Professor", "Researcher" or "Visitor"
INSERT INTO MembershipTypes(MembershipType)
VALUES
('Child'),
('Young Adult'),
('Adult'),
('Student'),
('Professor'),
('Researcher'),
('Visitor')
GO


-- Populates "Languages" table
-- from https://en.wikipedia.org/wiki/List_of_languages_by_total_number_of_speakers
INSERT INTO Languages (BookLanguage)
VALUES
('English'),
('Mandarin Chinese'),
('Hindi'), 
('Spanish'),
('Modern Standard Arabic'),
('French'),
('Bengali'),
('Portuguese'),
('Indonesian'),
('Urdu'),
('Russian'),
('German'),
('Japanese'),
('Nigerian Pidgin'),
('Egyptian Arab'),
('Marathi'),
('Vietnamese'),
('Telugu'),
('Swahili'),
('Hausa'),
('Turkish'),
('Western Punjabi'),
('Tagalog'),
('Tamil'),
('Yue Chinese'),
('Wu Chinese'),
('Iranian Persian'),
('Korean'),
('Amharic'),
('Thai'),
('Javanese'),
('Italian'),
('Gujarati'),
('Kannada'),
('Levantine Arab'),
('Sudanese Arab'),
('Yoruba'),
('Bhojpuri')
GO


-- Populates "Book Genres" table
-- Genres decided beforehand to look up books to populate the table
INSERT INTO BookGenres (Genre)
VALUES
('Science'),
('Childrens lit.'),
('Young Adult'),
('Horror'),
('Philosophy'),
('Classics'),
('Fantasy'),
('Poetry'),
('Science Fiction'),
('Biographies')
GO


-- Populates "Availability Statuses" table
-- Should be only "Available", "Rented", "On Hold" or "Unavailable for Renting"
INSERT INTO AvailabilityStatuses (AvailStatus)
VALUES
('Available'),
('Rented'),
('On Hold'),
('Unavailable for Renting')
GO


-- Populates "Publishers" table
-- Information collected from publishers of books selected for Books table
-- Unfortunately, contact information was less forthcoming than expected,
-- and contact fields had to be changed to be nullable
INSERT INTO Publishers(PublisherName, Website, Email, Phone,
                        PublisherAddress, YearOfFounding)
VALUES
('Bantam Books', 'www.randomhousebooks.com/imprint/bantam-books/',
'', '', 'New York City, U.S.', '1945'), 
('MIT Press', 'https://mitpress.mit.edu/', '', 
'617-253-5646', '255 Main Street, 9th Floor, Cambridge, MA 02142', '1962'), 
('Penguin Classics', 'www.penguinclassics.com', '', '', 'London, England', '1935'), 
('W. W. Norton & Company', 'https://wwnorton.com/', '', '(212) 354-5500', 
'W. W. Norton & Company, Inc. 500 Fifth Avenue New York, New York 10110', '1923'),
('Folio Junior', 'https://www.foliojr.com/', '', '212-400-1494​​', 
'630 9th Avenue, Suite 1009, New York, NY 10036', '1972'), 
('Harper Collins', 'https://harpercollins.co.uk/',
'', '', '1 Robroyston Gate, Robroyston, Glasgow, G33 1JN', '1987'),
('Disney-Hyperion Books', 'https://books.disney.com/brand/other/disney-hyperion/',
'', '', '', '1990'),  
('Scholastic Press', 'https://www.scholastic.co.uk/', 'enquiries@scholastic.co.uk',
'+44 199 389 3474', 'Scholastic Building 557 Broadway, New York City, New York 10012, United States', '1920'),
('Knopf Books', 'https://knopfdoubleday.com/', 'knopfpublicity@penguinrandomhouse.com', '',
'New York City, U.S.', '1915'),
('Random House', 'https://randomhousebooks.com/', '', '', 'Random House Tower, 1745 Broadway, New York City, U.S.',
'1927'),
('Barnes & Noble', 'https://press.barnesandnoble.com/', '', '',
'33 East 17th Street, New York, NY 10003', '1931'),
('Harcourt', 'defunct', 'defunct', 'defunct', 'defunct', ''),
('BookSurge', 'defunct', 'defunct', 'defunct', 'defunct', ''),
('Cambridge University Press', 'https://www.cambridge.org/gb/universitypress', '',
'', 'Cambridge, England', '1534'),
('Simon & Schuster', 'https://www.simonandschuster.com/', '', '',
'Simon & Schuster Building, Manhattan, New York City, United States', '1924'),
('Prestwick House', 'https://www.prestwickhouse.com/', 'info@prestwickhouse.com', 
'800-932-4593', '58 Artisan Dr. Smyrna, DE 19977', '1983'),
('William Morrow', 'https://www.harpercollins.com/', '', '', 'New York City', '1926'),
('Tor Books', 'https://torpublishinggroup.com/imprints/tor-books/', '', '',
'Equitable Building, New York City', '1980'),
('Bloomsbury Arden Shakespeare', 'https://www.bloomsbury.com/uk/discover/bloomsbury-academic/the-arden-shakespeare/', 
'', '', '50 Bedford Square, London, WC1B 3DP', '1986'),
('Story Line Press', 'https://redhen.org/imprints-and-series/story-line-press/', 
'editorial@redhen.org', '(626) 356-4760', '1540 Lincoln Ave, Pasadena, CA 91103', '1985'),
('Companhia das Letras', 'http://www.companhiadasletras.com.br/', 
'', '', 'São Paulo', '1986'),
('Ballantine Books', 'https://www.randomhousebooks.com/imprint/ballantine-books/',
'', '', 'New York City, New York', '1952'),
('Ace', 'https://www.penguin.com/ace-overview/', '', '',
'New York City', '1952'),
('Walker Books', 'https://www.walker.co.uk/', 'onlineshop@walker.co.uk', '+44 (0)20 7793 0909', 
'87 Vauxhall Walk, London, SE11 5HJ', '1978'),
('Atria', 'https://www.simonandschusterpublishing.com/atria/', '', 
'', 'Simon & Schuster Building, New York City', '2002')
GO


-- Populates "Authors" table
-- Information collected from authors of books selected for Books table
-- Unfortunately, contact information was less forthcoming than expected,
-- and contact fields had to be changed to be nullable
INSERT INTO Authors(FirstName, LastName, Email, Phone, Website)
VALUES    
('Stephen', 'W. Hawking', '', '', 'https://www.hawking.org.uk/'),
('Thomas', 'H. Cormen', 'thc@cs.dartmouth.edu', '', 'https://www.cs.dartmouth.edu/~thc/'),
('Charles', 'E. Leiserson', '', '', 'https://people.csail.mit.edu/cel/'),
('Ronald', 'L. Rivest', 'rivest@mit.edu', '617-253-5880', 'https://people.csail.mit.edu/rivest/'),
('Clifford', 'Stein', 'cliff@ieor.columbia.edu', '(212) 854-5238', 'https://www.columbia.edu/~cs2035/'),
('Charles', 'Darwin', '', '', ''),
('Albert', 'Einstein', '', '', ''),
('Neil', 'deGrasse Tyson', '', '', 'https://neildegrassetyson.com/'),
('Antoine', 'de Saint-Exupéry', '', '', 'https://www.antoinedesaintexupery.org/'),
('C.S.', 'Lewis', '', '', 'https://harpercollins.co.uk/pages/cslewis'),
('Rick', 'Riordan', '', '', 'https://rickriordan.com/'),
('Suzanne', 'Collins', '', '', 'https://www.suzannecollinsbooks.com/'),
('Christopher', 'Paolini', '', '', 'https://www.paolini.net/'),
('Mark', 'Z. Danielewski', '', '', 'https://www.markzdanielewski.com/'),
('Bram', 'Stoker', '', '', ''),
('Oscar', 'Wilde', '', '', ''),
('Edgar', 'Allan Poe', '', '', ''),
('Niccolò', 'Machiavelli', '', '', ''),
('Plato', ' ', '', '', ''),
('Thomas', 'Hobbes', '', '', ''),
('Friedrich', 'Nietzsche', '', '', ''),
('Immanuel', 'Kant', '', '', ''),
('William', 'Shakespeare', '', '', ''),
('Homer', ' ', '', '', ''),
('Sophocles', ' ', '', '', ''),
('J.R.R', 'Tolkien', '', '', 'https://www.tolkienestate.com/'),
('Ursula', 'K. Le Guin', '', '', 'https://www.ursulakleguin.com/'),
('Brandon', 'Sanderson', '', '', 'https://www.brandonsanderson.com/'),
('John', 'Milton', '', '', ''),
('Harry', 'Martinson', '', '', ''),
('Carlos', 'Drummond de Andrade', '', '', 'http://www.carlosdrummond.com.br/'),
('Dante', 'Alighieri', '', '', ''),
('Philip', 'K. Dick', '', '', ''),
('Isaac', 'Asimov', '', '', ''),
('Frank', 'Herbert', '', '', ''),
('Peter', 'Watts', '', '', 'https://www.rifters.com/'),
('Andrew', 'Hodges', 'andrew@synth.co.uk', '', 'https://www.synth.co.uk/'),
('Douglas', 'R. Hofstadter', '', '', ''),
('Humphrey', 'Carpenter', '', '', ''),
('William', 'Kalush', '', '', ''),
('Larry', 'Sloman', '', '', 'http://www.ratso.org/ '),
('Hayden', 'Herrera', '', '', ''),
('Walter', 'Isaacson', '', '', '')
GO


-- Populates "Books" tables
-- Books searched and selected from https://www.goodreads.com/
-- Barcodes generated with https://orcascan.com/tools/code-39-generator
-- Dewey Decimal System CallNumber looked up with https://www.librarything.com/mds
INSERT INTO Books (BookBarcode, Title, Publisher, PublicationDate, BookEdition,
                    BookLanguage, Genre, AvailabilityStatus, CallNumber)
VALUES
('852112308018', 'A Brief History of Time', 
(SELECT ID from Publishers where PublisherName = 'Bantam Books'),
'1998-09-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'523.1'),

('1061988575523', 'Introduction to Algorithms', 
(SELECT ID from Publishers where PublisherName = 'MIT Press'),
'1989-01-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'005.1'),

('126620977745', 'The Origin of Species', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2003-09-02', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'575.0162'),

('113249352922', 'Relativity: The Special and the General Theory', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2006-06-25', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'530.112'),

('109584146703', 'Astrophysics for People in a Hurry', 
(SELECT ID from Publishers where PublisherName = 'W. W. Norton & Company'),
'2017-05-02', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'523.01'),

('451973311060', 'The Little Prince', 
(SELECT ID from Publishers where PublisherName = 'Harcourt'),
'2000-05-15', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Childrens lit.'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'843.912'),

('103044064583', 'Le Petit Prince', 
(SELECT ID from Publishers where PublisherName = 'Folio Junior'),
'1998-01-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'French'), 
(SELECT ID from BookGenres where Genre = 'Childrens lit.'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'843.912'),

('621844182299', 'The Lion, the Witch and the Wardrobe', 
(SELECT ID from Publishers where PublisherName = 'Harper Collins'),
'2013-01-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Childrens lit.'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'823.087661'),

('1093889941888', 'The Lightning Thief', 
(SELECT ID from Publishers where PublisherName = 'Disney-Hyperion Books'),
'2006-03-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Childrens lit.'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6'),

('298941326779', 'The Sea of Monsters', 
(SELECT ID from Publishers where PublisherName = 'Disney-Hyperion Books'),
'2006-05-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Childrens lit.'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6'),

('684329975194', 'The Hunger Games', 
(SELECT ID from Publishers where PublisherName = 'Scholastic Press'),
'2008-10-14', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Young Adult'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6'),

('295765267472', 'Catching Fire', 
(SELECT ID from Publishers where PublisherName = 'Scholastic Press'),
'2009-09-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Young Adult'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6'),

('1008747063973', 'Mockingjay', 
(SELECT ID from Publishers where PublisherName = 'Scholastic Press'),
'2010-08-24', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Young Adult'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6'),

('658137374877', 'Eragon', 
(SELECT ID from Publishers where PublisherName = 'Knopf Books'),
'2005-06-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Young Adult'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6'),

('602432211917', 'Eldest', 
(SELECT ID from Publishers where PublisherName = 'Knopf Books'),
'2007-03-13', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Young Adult'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6'),

('389361461145', 'House of Leaves', 
(SELECT ID from Publishers where PublisherName = 'Random House'),
'2000-03-07', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Horror'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.54'),

('1020681036880', 'Dracula', 
(SELECT ID from Publishers where PublisherName = 'Barnes & Noble'),
'2011-03-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Horror'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'823.087381'),

('611308683901', 'The Picture of Dorian Gray', 
(SELECT ID from Publishers where PublisherName = 'Random House'),
'2004-06-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Horror'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'823.8'),

('370140854718', 'The Tell-Tale Heart', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2015-02-26', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Horror'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.3'),

('240031867881', 'The Cask of Amontillado', 
(SELECT ID from Publishers where PublisherName = 'BookSurge'),
'2009-04-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Horror'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.3'),

('208913198036', 'The Prince', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2003-02-04', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Philosophy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'320.1'),

('633438264582', 'The Republic', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2003-02-25', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Philosophy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'321.07'),

('402050855286', 'Leviathan', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'1981-11-19', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Philosophy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'320.1'),

('370934540842', 'Beyond Good and Evil', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2003-04-29', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Philosophy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'193'),

('345922611896', 'Critique of Pure Reason', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'1999-02-28', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Philosophy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'121'),

('916922412061', 'A Midsummer Nights Dream', 
(SELECT ID from Publishers where PublisherName = 'Simon & Schuster'),
'2016-07-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Classics'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'822.33'),

('1064950153993', 'Hamlet', 
(SELECT ID from Publishers where PublisherName = 'Cambridge University Press'),
'2005-12-19', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Classics'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'822.33'),

('372760222061', 'The Iliad', 
(SELECT ID from Publishers where PublisherName = 'W. W. Norton & Company'),
'2023-09-26', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Classics'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'883.01'),

('789676336797', 'The Odyssey', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2006-10-31', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Classics'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'883.01'),

('1071580139839', 'Antigone', 
(SELECT ID from Publishers where PublisherName = 'Prestwick House'),
'2005-11-30', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Classics'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'882.01'),

('945875270706', 'The Silmarillion', 
(SELECT ID from Publishers where PublisherName = 'Harper Collins'),
'2011-02-03', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Fantasy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'823.087661'),

('776647164311', 'The Fellowship of the Ring', 
(SELECT ID from Publishers where PublisherName = 'William Morrow'),
'2022-06-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Fantasy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'823.912'),

('994157564023', 'A Wizard of Earthsea', 
(SELECT ID from Publishers where PublisherName = 'Harper Collins'),
'2012-09-11', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Fantasy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.087661'),

('504792120075', 'Words of Radiance', 
(SELECT ID from Publishers where PublisherName = 'Tor Books'),
'2014-03-04', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Fantasy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6'),

('1066363464544', 'The Way of Kings', 
(SELECT ID from Publishers where PublisherName = 'Tor Books'),
'2010-08-31', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Fantasy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6'),

('411974140204', 'Shakespeares Sonnets', 
(SELECT ID from Publishers where PublisherName = 'Bloomsbury Arden Shakespeare'),
'1997-08-21', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Poetry'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'821.3'),

('656593744147', 'Paradise Lost', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2003-04-29', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Poetry'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'821.4'),

('586090281027', 'Aniara', 
(SELECT ID from Publishers where PublisherName = 'Story Line Press'),
'1998-09-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Poetry'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'839.71'),

('323361697799', 'Sentimento do Mundo', 
(SELECT ID from Publishers where PublisherName = 'Companhia das Letras'),
'2012-01-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'Portuguese'), 
(SELECT ID from BookGenres where Genre = 'Poetry'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'869.915'),

('644251809883', 'The Divine Comedy - Volume 1: Hell', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'1999-07-12', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Poetry'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'851.1'),

('774529770221', 'Do Androids Dream of Electric Sheep?', 
(SELECT ID from Publishers where PublisherName = 'Ballantine Books'),
'2008-02-26', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science Fiction'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.0876220'),

('184943603669', 'I, Robot', 
(SELECT ID from Publishers where PublisherName = 'Bantam Books'),
'2004-06-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science Fiction'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.08762'),

('828075047644', 'Dune', 
(SELECT ID from Publishers where PublisherName = 'Ace'),
'2019-10-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science Fiction'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.087625'),

('239259338629', 'The Left Hand of Darkness', 
(SELECT ID from Publishers where PublisherName = 'Ace'),
'2000-07-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science Fiction'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.54'),

('606447069939', 'Blindsight', 
(SELECT ID from Publishers where PublisherName = 'Tor Books'),
'2006-10-03', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science Fiction'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6'),

('471381922983', 'Alan Turing: The Enigma', 
(SELECT ID from Publishers where PublisherName = 'Walker Books'),
'2000-03-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Biographies'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'510.92'),

('1014704193469', 'J.R.R. Tolkien: A Biography', 
(SELECT ID from Publishers where PublisherName = 'William Morrow'),
'2000-06-06', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Biographies'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'828.912'),

('1023486141416', 'The Secret Life of Houdini: The Making of Americas First Superhero', 
(SELECT ID from Publishers where PublisherName = 'Atria'),
'2006-10-31', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Biographies'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'793.8092'),

('352402167332', 'Frida: A Biography of Frida Kahlo', 
(SELECT ID from Publishers where PublisherName = 'Harper Collins'),
'2002-10-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Biographies'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'759.972'),

('157809483843', 'Einstein: His Life and Universe', 
(SELECT ID from Publishers where PublisherName = 'Simon & Schuster'),
'2007-04-10', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Biographies'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'530.092')
GO



INSERT INTO Books_Authors (Book, Author)
VALUES
((SELECT BookBarcode from Books where Title = 'A Brief History of Time'),
(SELECT ID from Authors where FirstName = 'Stephen' AND LastName = 'W. Hawking')),

((SELECT BookBarcode from Books where Title = 'Introduction to Algorithms'),
(SELECT ID from Authors where FirstName = 'Thomas' AND LastName = 'H. Cormen')),

((SELECT BookBarcode from Books where Title = 'Introduction to Algorithms'),
(SELECT ID from Authors where FirstName = 'Charles' AND LastName = 'E. Leiserson')),

((SELECT BookBarcode from Books where Title = 'Introduction to Algorithms'),
(SELECT ID from Authors where FirstName = 'Ronald' AND LastName = 'L. Rivest')),

((SELECT BookBarcode from Books where Title = 'Introduction to Algorithms'),
(SELECT ID from Authors where FirstName = 'Clifford' AND LastName = 'Stein')),

((SELECT BookBarcode from Books where Title = 'The Origin of Species'),
(SELECT ID from Authors where FirstName = 'Charles' AND LastName = 'Darwin')),

((SELECT BookBarcode from Books where Title = 'Relativity: The Special and the General Theory'),
(SELECT ID from Authors where FirstName = 'Albert' AND LastName = 'Einstein')),

((SELECT BookBarcode from Books where Title = 'Astrophysics for People in a Hurry'),
(SELECT ID from Authors where FirstName = 'Neil' AND LastName = 'deGrasse Tyson')),

((SELECT BookBarcode from Books where Title = 'The Little Prince'),
(SELECT ID from Authors where FirstName = 'Antoine' AND LastName = 'de Saint-Exupéry')),

((SELECT BookBarcode from Books where Title = 'Le Petit Prince'),
(SELECT ID from Authors where FirstName = 'Antoine' AND LastName = 'de Saint-Exupéry')),

((SELECT BookBarcode from Books where Title = 'The Lion, the Witch and the Wardrobe'),
(SELECT ID from Authors where FirstName = 'C.S.' AND LastName = 'Lewis')),

((SELECT BookBarcode from Books where Title = 'The Lightning Thief'),
(SELECT ID from Authors where FirstName = 'Rick' AND LastName = 'Riordan')),

((SELECT BookBarcode from Books where Title = 'The Sea of Monsters'),
(SELECT ID from Authors where FirstName = 'Rick' AND LastName = 'Riordan')),

((SELECT BookBarcode from Books where Title = 'The Hunger Games'),
(SELECT ID from Authors where FirstName = 'Suzanne' AND LastName = 'Collins')),

((SELECT BookBarcode from Books where Title = 'Catching Fire'),
(SELECT ID from Authors where FirstName = 'Suzanne' AND LastName = 'Collins')),

((SELECT BookBarcode from Books where Title = 'Mockingjay'),
(SELECT ID from Authors where FirstName = 'Suzanne' AND LastName = 'Collins')),

((SELECT BookBarcode from Books where Title = 'Eragon'),
(SELECT ID from Authors where FirstName = 'Christopher' AND LastName = 'Paolini')),

((SELECT BookBarcode from Books where Title = 'Eldest'),
(SELECT ID from Authors where FirstName = 'Christopher' AND LastName = 'Paolini')),

((SELECT BookBarcode from Books where Title = 'House of Leaves'),
(SELECT ID from Authors where FirstName = 'Mark' AND LastName = 'Z. Danielewski')),

((SELECT BookBarcode from Books where Title = 'Dracula'),
(SELECT ID from Authors where FirstName = 'Bram' AND LastName = 'Stoker')),

((SELECT BookBarcode from Books where Title = 'The Picture of Dorian Gray'),
(SELECT ID from Authors where FirstName = 'Oscar' AND LastName = 'Wilde')),

((SELECT BookBarcode from Books where Title = 'The Tell-Tale Heart'),
(SELECT ID from Authors where FirstName = 'Edgar' AND LastName = 'Allan Poe')),

((SELECT BookBarcode from Books where Title = 'The Cask of Amontillado'),
(SELECT ID from Authors where FirstName = 'Edgar' AND LastName = 'Allan Poe')),

((SELECT BookBarcode from Books where Title = 'The Prince'),
(SELECT ID from Authors where FirstName = 'Niccolò' AND LastName = 'Machiavelli')),

((SELECT BookBarcode from Books where Title = 'The Republic'),
(SELECT ID from Authors where FirstName = 'Plato')),

((SELECT BookBarcode from Books where Title = 'Leviathan'),
(SELECT ID from Authors where FirstName = 'Thomas' AND LastName = 'Hobbes')),

((SELECT BookBarcode from Books where Title = 'Beyond Good and Evil'),
(SELECT ID from Authors where FirstName = 'Friedrich' AND LastName = 'Nietzsche')),

((SELECT BookBarcode from Books where Title = 'Critique of Pure Reason'),
(SELECT ID from Authors where FirstName = 'Immanuel' AND LastName = 'Kant')),

((SELECT BookBarcode from Books where Title = 'A Midsummer Nights Dream'),
(SELECT ID from Authors where FirstName = 'William' AND LastName = 'Shakespeare')),

((SELECT BookBarcode from Books where Title = 'Hamlet'),
(SELECT ID from Authors where FirstName = 'William' AND LastName = 'Shakespeare')),

((SELECT BookBarcode from Books where Title = 'The Iliad'),
(SELECT ID from Authors where FirstName = 'Homer')),

((SELECT BookBarcode from Books where Title = 'The Odyssey'),
(SELECT ID from Authors where FirstName = 'Homer')),

((SELECT BookBarcode from Books where Title = 'Antigone'),
(SELECT ID from Authors where FirstName = 'Sophocles')),

((SELECT BookBarcode from Books where Title = 'The Silmarillion'),
(SELECT ID from Authors where FirstName = 'J.R.R' AND LastName = 'Tolkien')),

((SELECT BookBarcode from Books where Title = 'The Fellowship of the Ring'),
(SELECT ID from Authors where FirstName = 'J.R.R' AND LastName = 'Tolkien')),

((SELECT BookBarcode from Books where Title = 'A Wizard of Earthsea'),
(SELECT ID from Authors where FirstName = 'Ursula' AND LastName = 'K. Le Guin')),

((SELECT BookBarcode from Books where Title = 'Words of Radiance'),
(SELECT ID from Authors where FirstName = 'Brandon' AND LastName = 'Sanderson')),

((SELECT BookBarcode from Books where Title = 'The Way of Kings'),
(SELECT ID from Authors where FirstName = 'Brandon' AND LastName = 'Sanderson')),

((SELECT BookBarcode from Books where Title = 'Shakespeares Sonnets'),
(SELECT ID from Authors where FirstName = 'William' AND LastName = 'Shakespeare')),

((SELECT BookBarcode from Books where Title = 'Paradise Lost'),
(SELECT ID from Authors where FirstName = 'John' AND LastName = 'Milton')),

((SELECT BookBarcode from Books where Title = 'Aniara'),
(SELECT ID from Authors where FirstName = 'Harry' AND LastName = 'Martinson')),

((SELECT BookBarcode from Books where Title = 'Sentimento do Mundo'),
(SELECT ID from Authors where FirstName = 'Carlos' AND LastName = 'Drummond de Andrade')),

((SELECT BookBarcode from Books where Title = 'The Divine Comedy - Volume 1: Hell'),
(SELECT ID from Authors where FirstName = 'Dante' AND LastName = 'Alighieri')),

((SELECT BookBarcode from Books where Title = 'Do Androids Dream of Electric Sheep?'),
(SELECT ID from Authors where FirstName = 'Philip' AND LastName = 'K. Dick')),

((SELECT BookBarcode from Books where Title = 'I, Robot'),
(SELECT ID from Authors where FirstName = 'Isaac' AND LastName = 'Asimov')),

((SELECT BookBarcode from Books where Title = 'Dune'),
(SELECT ID from Authors where FirstName = 'Frank' AND LastName = 'Herbert')),

((SELECT BookBarcode from Books where Title = 'The Left Hand of Darkness'),
(SELECT ID from Authors where FirstName = 'Ursula' AND LastName = 'K. Le Guin')),

((SELECT BookBarcode from Books where Title = 'Blindsight'),
(SELECT ID from Authors where FirstName = 'Peter' AND LastName = 'Watts')),

((SELECT BookBarcode from Books where Title = 'Alan Turing: The Enigma'),
(SELECT ID from Authors where FirstName = 'Andrew' AND LastName = 'Hodges')),

((SELECT BookBarcode from Books where Title = 'Alan Turing: The Enigma'),
(SELECT ID from Authors where FirstName = 'Douglas' AND LastName = 'R. Hofstadter')),

((SELECT BookBarcode from Books where Title = 'J.R.R. Tolkien: A Biography'),
(SELECT ID from Authors where FirstName = 'Humphrey' AND LastName = 'Carpenter')),

((SELECT BookBarcode from Books where Title = 'The Secret Life of Houdini: The Making of Americas First Superhero'),
(SELECT ID from Authors where FirstName = 'William' AND LastName = 'Kalush')),

((SELECT BookBarcode from Books where Title = 'The Secret Life of Houdini: The Making of Americas First Superhero'),
(SELECT ID from Authors where FirstName = 'Larry' AND LastName = 'Sloman')),

((SELECT BookBarcode from Books where Title = 'Frida: A Biography of Frida Kahlo'),
(SELECT ID from Authors where FirstName = 'Hayden' AND LastName = 'Herrera')),

((SELECT BookBarcode from Books where Title = 'Einstein: His Life and Universe'),
(SELECT ID from Authors where FirstName = 'Walter' AND LastName = 'Isaacson'))
GO



-- Populates "Credentials" table
-- Usernames created from Staff information
-- Passwords created with https://1password.com/password-generator and
-- SHA-256 hash calculated with https://emn178.github.io/online-tools/sha256.html
INSERT INTO Credentials (Username, UserPassword, 
                        PermissionLevel, CredentialsActive)
VALUES
-- username: jsmith_17, password: Absorbed-exceed-candle
('jsmith_17', 
'b010255a9d6896ab77e8bde3f9356c58a0f5871fc451c5bcac8a48197c76a59e',
(SELECT ID from UserPermissionLevels where PermissionLevel = 'Admin'),
1),

-- username: jzaman_90, password: Mangoes-caterer-hour
('jzaman_90',
'9227b7aafc7fb130a2b27990c199216410577c83af69061436153c2dbd8227c9',
(SELECT ID from UserPermissionLevels where PermissionLevel = 'Rent, Return, Register'),
1),

-- username: lbenoit_54, password: Confided-chirp-vinyl
('lbenoit_54',
'55c3b6dedff7a6663cdf9220a8edffe1f0fdcd076e1a593a4ec832c07b3f7a84',
(SELECT ID from UserPermissionLevels where PermissionLevel = 'Rent and return'),
1),

-- username: eseraphine_75, password: Auto-wondered-freezing
('eseraphine_75',
'05dc8ceb1288c14f08ea0eaf8d0957325cdd496ad2df0450c1f4eb62ef07db0b',
(SELECT ID from UserPermissionLevels where PermissionLevel = 'Rent and return'),
1),

-- username: cfinn_01, password: Watch-trading-ravine
('cfinn_01',
'cc2b31fa53a6d96b128c80eaff4f9d609e6638772d4e4eb1f325f4bed5c0127b',
(SELECT ID from UserPermissionLevels where PermissionLevel = 'Manage Library'),
1),

-- username: lconstantin_95, password: Railroad-laughter-booted
('lconstantin_95',
'2ad7aafa10b35e3e4a93b10198819a092a4763ba8733a4aadad29e5a4f6cab20',
(SELECT ID from UserPermissionLevels where PermissionLevel = 'Search only'),
1)
GO


-- Populates "Staff" table
-- Employee ID numbers created with https://www.random.org/strings/
-- Names created with https://www.behindthename.com/ and https://surnames.behindthename.com/
-- Phone numbers created with https://dialaxy.com/lookups/phone-number-generator/
INSERT INTO Staff (IDNumber, FirstName, LastName, DateOfBirth,
                                HiringDate, Email, Phone, Credentials, EmployeeRole)
VALUES
('313512017', 'John', 'Smith', '1957-08-28', '1982-07-22', 
'jsmith_17@librarydomain.ie', '+353 822981454', 'jsmith_17', 'Branch Admin'),

('547088590', 'Jamil', 'Zaman', '1998-06-03', '2019-04-25', 
'jzaman_90@librarydomain.ie', '+353 855620862', 'jzaman_90', 'Librarian Manager'),

('728802054', 'Louise', 'Benoit', '1992-10-06', '2021-05-12', 
'lbenoit_54@librarydomain.ie', '+353 879525220', 'lbenoit_54', 'Librarian'),

('839808975', 'Emille', 'Seraphine', '1999-01-27', '2023-09-10', 
'eseraphine_75@librarydomain.ie', '+353 873343958', 'eseraphine_75', 'Librarian'),

('839953701', 'Caoimhe', 'Finn', '1991-03-15', '2023-11-07', 
'cfinn_01@librarydomain.ie', '+353 891219211', 'cfinn_01', 'Curator'),

('845176895', 'Lucas', 'Constantin', '2002-10-25', '2024-04-22', 
'lconstantin_95@librarydomain.ie', '+353 889761386', 'lconstantin_95', 'Librarian Assistant')
GO



-- Populates "Members" table
-- Names created with https://www.behindthename.com/ and https://surnames.behindthename.com/
-- Phone numbers created with https://dialaxy.com/lookups/phone-number-generator/
INSERT INTO Members (FirstName, LastName, Email, Phone, 
                        MembershipType, DateOfJoining, MembershipActive)
VALUES
('Lloyd', 'Desmond', 'silverthornn0@outlook.com', '+353 822470995',
(SELECT ID from MembershipTypes where MembershipType = 'Adult'),
'2018-11-23', 1),

('Diana', 'Florence', 'dianaflorencewrites@gmail.com', '+353 885575340',
(SELECT ID from MembershipTypes where MembershipType = 'Adult'),
'2020-06-11', 1),

('Helio', 'Silveira', 'helio_silveira@ulisbon.pt', '+351 169309882',
(SELECT ID from MembershipTypes where MembershipType = 'Researcher'),
'2023-04-01', 1),

('Carol', 'Whitaker', 'cwhittzz@hotmail.com', '+353 885379880',
(SELECT ID from MembershipTypes where MembershipType = 'Young Adult'),
'2024-05-17', 1),

('Emil', 'Sveda', 'eli_svd1@gmail.com', '+353 830219821',
(SELECT ID from MembershipTypes where MembershipType = 'Child'),
'2025-08-27', 1),

('Filipa', 'Sveda', 'eli_svd1@gmail.com', '+353 830219821',
(SELECT ID from MembershipTypes where MembershipType = 'Child'),
'2025-08-27', 1),

('Meena', 'Kumar', '20052692@dbs.ie', '+353 822470431',
(SELECT ID from MembershipTypes where MembershipType = 'Student'),
'2025-10-11', 1),

('Aisha', 'Jenkins', 'ajenkins@numass.us', '+1 5056464219',
(SELECT ID from MembershipTypes where MembershipType = 'Professor'),
'2026-03-29', 1),

('Mark', 'Blakesley', '20066598@dbs.ie', '+353 858614969',
(SELECT ID from MembershipTypes where MembershipType = 'Student'),
'2026-04-20', 1),

('Nikos', 'Ioannidis', 'ni.ioannidis@gmail.com', '+30 9432661135',
(SELECT ID from MembershipTypes where MembershipType = 'Visitor'),
'2026-05-22', 1)
GO

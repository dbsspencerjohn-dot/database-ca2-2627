USE Library;

CREATE TABLE Languages(
    ID INTEGER(250) IDENTITY(1,1) PRIMARY KEY,
    -- BookLanguage renamed from Language due to reserved keyword
    BookLanguage VARCHAR(25) NOT NULL UNIQUE
);

CREATE TABLE BookGenres(
    ID INTEGER(50) IDENTITY(1,1) PRIMARY KEY,
    Genre VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE AvailabilityStatuses(
    ID INTEGER(4) IDENTITY(1,1) PRIMARY KEY,
    -- AvailStatus renamed from Status due to reserved keyword
    AvailStatus VARCHAR(25) NOT NULL UNIQUE 
);

CREATE TABLE RentalStatuses(
    ID INTEGER(5) IDENTITY(1,1) PRIMARY KEY,
    -- RentStatus renamed from Status due to reserved keyword
    RentStatus VARCHAR(10) NOT NULL UNIQUE,
    Fine VARCHAR(20)
);

CREATE TABLE MembershipTypes(
    ID INTEGER(8) IDENTITY(1,1) PRIMARY KEY,
    MembershipType VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE UserPermissionLevels(
    ID INTEGER(15) IDENTITY(1,1) PRIMARY KEY,
    PermissionLevel VARCHAR(25) NOT NULL
);

CREATE TABLE Publishers(
    ID INTEGER IDENTITY(1,1) PRIMARY KEY,
    -- PublisherName renamed from Name due to reserved keyword
    PublisherName VARCHAR(50) NOT NULL,
    Website VARCHAR(50) NOT NULL UNIQUE,
    Email VARCHAR(60) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    -- PublisherAddress renamed from Address due to reserved keyword
    PublisherAddress VARCHAR(150) NOT NULL UNIQUE,
    DateOfFounding DATE NOT NULL 
);

CREATE TABLE Authors(
    ID INTEGER IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(25)  NOT NULL,
    LastName VARCHAR(25) NOT NULL,
    Bio XML,
    Email VARCHAR(60) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    Website VARCHAR(100) UNIQUE
    -- TODO: M2M relationships to Books
);

CREATE TABLE Members(
    ID INTEGER IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(25) NOT NULL,
    LastName VARCHAR(25) NOT NULL,
    Email VARCHAR(60) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    MembershipType INTEGER(8) NOT NULL,
    MembershipActive BOOL NOT NULL,
    DateOfJoining DATE NOT NULL,
    CONSTRAINT fk_MembershipType FOREIGN KEY(MembershipType) REFERENCES MembershipTypes(ID) 
);

CREATE TABLE Credentials(
    Username VARCHAR(15) PRIMARY KEY,
    -- UserPassword renamed from Password due to reserved keyword
    UserPassword CHAR(256) NOT NULL,
    PermissionLevel INTEGER(15) NOT NULL,
    CredentialsActive BOOL NOT NULL,
    CONSTRAINT fk_PermissionLevel FOREIGN KEY (UserPermissionLevels) REFERENCES UserPermissionLevels(ID)
);

CREATE TABLE Staff(
    IDNumber VARCHAR(9) PRIMARY KEY,
    FirstName VARCHAR(25) NOT NULL,
    LastName VARCHAR(25) NOT NULL,
    HiringDate DATE NOT NULL,
    DateOfBirth DATE NOT NULL,
    Email VARCHAR(60) NOT NULL UNIQUE,
    Phone VARCHAR(15) NOT NULL UNIQUE,
    Credentials VARCHAR(15) NOT NULL UNIQUE,
    -- EmployeeRole renamed from Role due to reserved keyword
    EmployeeRole VARCHAR(25) NOT NULL,
    CONSTRAINT fk_Credentials FOREIGN KEY (Credentials) REFERENCES Credentials(Username)
);

CREATE TABLE Books (
    BookBarcode VARCHAR(40) PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Publisher INTEGER NOT NULL,
    PublicationDate DATE NOT NULL,
    -- BookEdition renamed from Edition due to reserved keyword
    BookEdition VARCHAR(10) NOT NULL,
    -- BookDescription renamed from Description due to reserved keyword
    BookDescription XML,
    -- BookLanguage renamed from Language due to reserved keyword
    BookLanguage INTEGER(250) NOT NULL,
    AlternativeTitles XML,
    Genre INTEGER(50) NOT NULL,
    -- AvailabilityStatus renamed from Availability due to reserved keyword
    AvailabilityStatus INTEGER(4) NOT NULL,
    CallNumber VARCHAR NOT NULL,
    CONSTRAINT fk_Publisher FOREIGN KEY (Publishers) REFERENCES Publishers(ID),
    CONSTRAINT fk_Language FOREIGN KEY (Languages) REFERENCES Languages(ID),
    CONSTRAINT fk_Genre FOREIGN KEY (BookGenres) REFERENCES BookGenres(ID),
    CONSTRAINT fk_Status FOREIGN KEY (AvailabilityStatuses) REFERENCES AvailabilityStatuses(ID)
);

CREATE TABLE RentRecords(
    ID INTEGER IDENTITY(1,1) PRIMARY KEY,
    RentedBy INTEGER NOT NULL,
    RentedBook INTEGER NOT NULL,
    DateOfRental DATETIME NOT NULL,
    DueDate DATETIME NOT NULL,
    AuthorizedBy VARCHAR(9) NOT NULL,
    -- RentStatus renamed from Status due to reserved keyword
    RentStatus INTEGER(5) NOT NULL,
    CONSTRAINT fk_Members FOREIGN KEY (RentedBy) REFERENCES Members(ID),
    CONSTRAINT fk_Books FOREIGN KEY (RentedBook) REFERENCES Book(BookBarcode),
    CONSTRAINT fk_Staff FOREIGN KEY (AuthorizedBy) REFERENCES Staff(IDNumber),
    CONSTRAINT fk_Status FOREIGN KEY (RentalStatuses) REFERENCES RentalStatuses(ID)
);

-- Books/Authors
CREATE TABLE Books_Authors(
    ID INTEGER IDENTITY(1,1) PRIMARY KEY,
    Book VARCHAR(40) NOT NULL,
    Author INTEGER NOT NULL,
    CONSTRAINT fk_Book FOREIGN KEY (Book) REFERENCES Books(BookBarcode),
    CONSTRAINT fk_Author FOREIGN KEY (Author) REFERENCES Author(ID)
);
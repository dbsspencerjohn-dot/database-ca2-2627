USE Library;

CREATE TABLE Languages(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    -- BookLanguage renamed from Language due to reserved keyword
    BookLanguage VARCHAR(25) NOT NULL UNIQUE
);

CREATE TABLE BookGenres(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    Genre VARCHAR(15) NOT NULL UNIQUE
);

CREATE TABLE AvailabilityStatuses(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    -- AvailStatus renamed from Status due to reserved keyword
    AvailStatus VARCHAR(25) NOT NULL UNIQUE 
);

CREATE TABLE RentalStatuses(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    -- RentStatus renamed from Status due to reserved keyword
    RentStatus VARCHAR(10) NOT NULL UNIQUE,
    Fine VARCHAR(20)
);

CREATE TABLE MembershipTypes(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    MembershipType VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE UserPermissionLevels(
    ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    PermissionLevel VARCHAR(25) NOT NULL
);

CREATE TABLE Publishers(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    -- PublisherName renamed from Name due to reserved keyword
    PublisherName VARCHAR(50) NOT NULL,
    Website VARCHAR(200) NOT NULL,
    Email VARCHAR(60) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    -- PublisherAddress renamed from Address due to reserved keyword
    PublisherAddress VARCHAR(150) NOT NULL,
    YearOfFounding VARCHAR(4) NOT NULL 
);

CREATE TABLE Authors(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(25)  NOT NULL,
    LastName VARCHAR(25) NOT NULL,
    Bio XML,
    Email VARCHAR(60) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Website VARCHAR(100)
);

CREATE TABLE Members(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(25) NOT NULL,
    LastName VARCHAR(25) NOT NULL,
    Email VARCHAR(60) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    MembershipType TINYINT NOT NULL,
    MembershipActive BIT NOT NULL,
    DateOfJoining DATE NOT NULL,
    CONSTRAINT fk_Members_MembershipType FOREIGN KEY(MembershipType) REFERENCES MembershipTypes(ID) 
);

CREATE TABLE Credentials(
    Username VARCHAR(15) PRIMARY KEY,
    -- UserPassword renamed from Password due to reserved keyword
    UserPassword CHAR(256) NOT NULL,
    PermissionLevel TINYINT NOT NULL,
    CredentialsActive BIT NOT NULL,
    CONSTRAINT fk_Credentials_PermissionLevel FOREIGN KEY (PermissionLevel) REFERENCES UserPermissionLevels(ID)
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
    CONSTRAINT fk_Staff_Credentials FOREIGN KEY (Credentials) REFERENCES Credentials(Username)
);

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

-- Books/Authors
CREATE TABLE Books_Authors(
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Book VARCHAR(40) NOT NULL,
    Author INT NOT NULL,
    CONSTRAINT fk_Books_Auhtors_Book FOREIGN KEY (Book) REFERENCES Books(BookBarcode),
    CONSTRAINT fk_Books_Auhtors_Author FOREIGN KEY (Author) REFERENCES Authors(ID)
);
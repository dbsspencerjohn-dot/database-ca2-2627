CREATE TABLE Languages()

CREATE TABLE BookGenres()

CREATE TABLE AvailabilityStatuses()

CREATE TABLE RentalStatuses()

CREATE TABLE MembershipTypes()

CREATE TABLE UserPermissionLevels()

CREATE TABLE Publishers()

CREATE TABLE Authors()

CREATE TABLE Publishers()

CREATE TABLE Books (
    BookBarcode VARCHAR(40) PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    Publisher 
)
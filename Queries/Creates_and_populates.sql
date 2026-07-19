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
    DueDate DATE NOT NULL,
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
('Overdue', '0.50 EUR/day'),
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
-- Bio and awards from https://www.librarything.com/
INSERT INTO Authors(FirstName, LastName, Email, Phone, Website, Bio)
VALUES    
('Stephen', 'W. Hawking', '', '', 'https://www.hawking.org.uk/',
'<bio>
    <desc>
        Stephen William Hawking was born in Oxford, England on January 8, 1942. He received a first class honors degree in natural science from Oxford University and a Ph.D. from Cambridge University. He was a theoretical physicist and has held the post of Lucasian Professor of Mathematics at Cambridge University from 1982 until his death. In 1974, he was elected a Fellow of the Royal Society, the world''s oldest scientific organization. In 1963, he learned he had amyotrophic lateral sclerosis, a neuromuscular wasting disease also known as Lou Gehrig''s disease. The disease confined him to a wheelchair and reduced his bodily control to the flexing of a finger and voluntary eye movements, but left his mental faculties untouched. He became a leader in exploring gravity and the properties of black holes. He wrote numerous books including A Brief History of Time: From the Big Bang to Black Holes, Black Holes and Baby Universes, On the Shoulders of Giants, A Briefer History of Time, The Universe in a Nutshell, The Grand Design, and Brief Answers to the Big Questions. In 1982, he was named a commander of the British Empire. A film about his life, The Theory of Everything, was released in 2014 and was based on his first wife Jane Hawking''s book Traveling to Infinity: My Life with Stephen. He died on March 14, 2018 at the age of 76. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            Order of the British Empire (Commander, 1982)
        </award>
        <award>
            Order of the Companions of Honour (1989)
        </award>
        <award>
            Premio Príncipe de Asturias (1989)
        </award>
        <award>
            Lucasian Professorship of Mathematics, Cambridge (1979)
        </award>
        <award>
            Presidential Medal of Freedom (2009)
        </award>
        <award>
            Wolf Prize (1988)
        </award>
    </awards>
</bio>'),

('Thomas', 'H. Cormen', 'thc@cs.dartmouth.edu', '', 'https://www.cs.dartmouth.edu/~thc/',
'<bio>
    <desc>
        Thomas H. Cormen received a Ph. D. from MIT in 1992. He is an associate professor at Dartmouth College. Cormen is one of the authors of Introduction to Algorithms. (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('Charles', 'E. Leiserson', '', '', 'https://people.csail.mit.edu/cel/',
'<bio>
    <desc>
    </desc>
    <awards>
    </awards>
</bio>'),

('Ronald', 'L. Rivest', 'rivest@mit.edu', '617-253-5880', 'https://people.csail.mit.edu/rivest/',
'<bio>
    <desc>
    </desc>
    <awards>
        <award>
            Marconi Prize (2007)
        </award>
        <award>
            Turing Award (2002)
        </award>
        <award>
            Kobayashi Award (2000)
        </award>
        <award>
            Paris Kanellakis Theory and Practice Award (1996)
        </award>
    </awards>
</bio>'),

('Clifford', 'Stein', 'cliff@ieor.columbia.edu', '(212) 854-5238', 'https://www.columbia.edu/~cs2035/',
'<bio>
    <desc>
    </desc>
    <awards>
    </awards>
</bio>'),

('Charles', 'Darwin', '', '', '',
'<bio>
    <desc>
        Charles Robert Darwin, born in 1809, was an English naturalist who founded the theory of Darwinism, the belief in evolution as determined by natural selection. Although Darwin studied medicine at Edinburgh University, and then studied at Cambridge University to become a minister, he had been interested in natural history all his life. His grandfather, Erasmus Darwin, was a noted English poet, physician, and botanist who was interested in evolutionary development. Darwin''s works have had an incalculable effect on all aspects of the modern thought. Darwin''s most famous and influential work, On the Origin of Species, provoked immediate controversy. Darwin''s other books include Zoology of the Voyage of the Beagle, The Variation of Animals and Plants Under Domestication, The Descent of Man, and Selection in Relation to Sex. Charles Darwin died in 1882. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            Fellow of the Royal Society
        </award>
        <award>
            Wollaston Medal (1859)
        </award>
    </awards>
</bio>'),

('Albert', 'Einstein', '', '', '',
'<bio>
    <desc>
        Albert Einstein was born on March 14, 1879 in Ulm. He spent his childhood in Munich where his family owned a small machine shop. By the age of twelve, Einstein had taught himself Euclidean Geometry. His family moved to Milan, where he stayed for a year, and he used it as an excuse to drop out of school, which bored him. He finished secondary school in Aarau, Switzerland and entered the Swiss Federal Institute of Technology in Zurich. Einstein graduated in 1900, by studying the notes of a classmate since he did not attend his classes out of boredom, again. His teachers did not like him and would not recomend him for a position in the University. For two years, Einstein worked as a substitute teacher and a tutor before getting a job, in 1902, as an examiner for a Swiss patent office in Bern. In 1905, he received his doctorate from the University of Zurich for a theoretical dissertation on the dimension of molecules. Einstein also published three theoretical papers of central importance to the development of 20th Century physics. The first was entitled "Brownian Motion," and the second "Photoelectric Effort," which was a revolutionary way of thinking and contradicted tradition. No one accepted the proposals of the first two papers. Then the third one was published in 1905 and called "On the Electrodynamics of Moving Bodies." Einstein''s words became what is known today as the special theory of relativity and said that the physical laws are the same in all inertial reference systems and that the speed of light in a vacuum is a universal constant. Virtually no one understood or supported Einstein''s argument. Einstein left the patent office in 1907 and received his first academic appointment at the University of Zurich in 1909. In 1911, he moved to a German speaking university in Prague, but returned to Swiss National Polytechnic in Zurich in 1912. By 1914, Einstein was appointed director of the Kaiser Wilhelm Institute of Physics in Berlin. His chief patron in those early days was German physicist Max Planck and lent much credibility to Einstein''s work. Einstein began working on generalizing and extending his theory of relativity, but the full general theory was not published until 1916. In 1919, he predicted that starlight would bend in the vicinity of a massive body, such as the sun. This theory was confirmed during a solar eclipse and cause Einstein to become world renowned after the phenomenon. Einstein received be Nobel Prize in Physics in 1921. With his new fame, Einstein attempted to further his own political and social views. He supported pacifism and Zionism and opposed Germany''s involvement in World War I. His support of Zionism earned him attacks from both Anti-Semitic and right wing groups in Germany. Einstein left Germany for the United States when Hitler came into power, taking a position at the Institute for Advanced Study in Princeton, New Jersey. Once there, he renounced his stand on pacifism in the face of Nazi rising power. In 1939 he collaborated with other physicists in writing a letter to President Franklin D. Roosevelt informing him of the possibility that the Nazis may in fact be attempting to create an atomic bomb. The letter bore only Einstein''s signature but lent credence to the letter and spurred the U.S. race to create the bomb first. Einstein became an American citizen in 1940. After the war, Einstein was active in international disarmament as well as world government. He was offered the position of President of Israel but turned the honor down. Albert Einstein died on April 18, 1955 in Princeton, New Jersey. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            Nobel Prize (Physics ∙ 1921)
        </award>
        <award>
            Copley Medal (1925)
        </award>
        <award>
            Max Planck Medal (1929)
        </award>
        <award>
            Barnard Medal (1920)
        </award>
        <award>
            Matteucci Medal (1921) 
        </award>
    </awards>
</bio>'),

('Neil', 'deGrasse Tyson', '', '', 'https://neildegrassetyson.com/',
'<bio>
    <desc>
        Astrophysicist Neil deGrasse Tyson was born in New York City on October 5, 1958. Interested in astronomy since he was a child, Tyson gave lectures on the topic at the age of 15. He attended the Bronx High School of Science and was the editor-in-chief for its Physical Science Journal. After earning a B.A. in Physics from Harvard in 1980, Tyson received an M.A. in Astronomy from the University of Texas at Austin in 1983. He earned his Ph.D. in Astrophysics from Columbia in 1991. Since 1996, Tyson has held the position of Frederick P. Rose Director of the Hayden Planetarium at Manhattan''s American Museum of Natural History. In 2001, he was appointed by President George W. Bush to serve on the Commission on the Future of the United States Aerospace Industry. In 2004, Tyson joined the President''s Commission on Implementation of United States Space Exploration Policy. He has hosted PBS''s television show NOVA scienceNOW since 2006. Tyson can also be seen frequently as a guest on The Daily Show with Jon Stewart, The Colbert Report, and Late Night with Conan O''Brien. Tyson has written many popular books on astronomy, and he began his "Universe" column for Natural History magazine in 1995. In 2009, he published the bestselling book The Pluto Files: The Rise and Fall of America''s Favorite Planet to describe the controversy over Pluto''s demotion to dwarf planet. His other books include Accessory to War: The Unspoken alliance between astrophysics and the military. Tyson was recognized in 2004 with the NASA Distinguished Public Service Medal, and Time named him one of the 100 Most Influential People of 2007. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            Asteroid Namesake "1312 Tyson" (2001)
        </award>
        <award>
            Columbia University''s Medal of Excellence (2001)
        </award>
        <award>
            NASA Distinguished Public Service Medal (2004)
        </award>
        <award>
            Klopsteg Memorial Award (2007)
        </award>
    </awards>
</bio>'),

('Antoine', 'de Saint-Exupéry', '', '', 'https://www.antoinedesaintexupery.org/',
'<bio>
    <desc>
        Antoine de Saint-Exupery, 1900 - 1944 Antoine de Saint-Exupery was born in Lyon, France on June 29, 1900. Saint-Exupery was educated in Jesuit schools. He later attended a Catholic boarding school in Switzerland before entering the Ecole de Beaux-Arts as an architecture student. de Saint-Exupery began his military service in 1921 and was sent to Strasbourgh to be trained as a pilot. He received his pilot''s license in 1922 and, after a few dead end jobs as a bookkeeper and an automobile salesman, he began flying mail for a commercial airline company. His route over North Africa was the basis for his first novel, Southern Mail, in 1929. His second novel, Night Flight, became an international bestseller and was made into a film in 1933. By that time, de Saint-Exupery was married to Consuelo Gomez Castillo and was working as a test pilot for Air France. He was also working as a foreign correspondent covering May Day events in Moscow and writing a series on the Spanish Civil War. His book, Wind, Sand and Stars won the French Academy''s 1939 Grand Prix du Roman and the National Book Award in the United States. He came to the United States after France fell in World War II, but rejoined the French Air Force in North Africa in 1943. That same year he published The Little Prince, a children''s story of such universal appeal that it has been translated into close to fifty languages. Antoine de Saint-Exupery took off on a flight over Southern France on July 31, 1944 and was never seen again. In 1998, a fisherman found a bracelet with his name and his wife''s name engraved on it, 150 kilometers west of Marseilles. (Bowker Author Biography) After escaping death in several accidents while flying as a pilot over the most dangerous sections of the French airmail service in South America, Africa, and the South Atlantic, Saint-Exupery was reported missing over southern France in 1944. Night Flight (1931) was introduced by Andre Gide and was at once proclaimed a masterpiece. Wind, Sand and Stars (1939) is a series of tales, interspersed with philosophical reflections on earth as a planet and on the nobility of the common people. Flight to Arras (1942) is the author''s own account of a hopeless reconnaissance sortie during the tragic days of May 1940. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            Légion d''Honneur (1930, 1939)
        </award>
        <award>
            Croix de Guerre avec Palme (1944) (posthumous)
        </award>
        <award>
            Croix de Guerre (1940)
        </award>
        <award>
            Prix Femina (1929)
        </award>
        <award>
            Grand Prix de roman de l''Académie française (1939)
        </award>
        <award>
            U. S. National Book Award (1940)
        </award>
    </awards>
</bio>'),

('C.S.', 'Lewis', '', '', 'https://harpercollins.co.uk/pages/cslewis',
'<bio>
    <desc>
        C. S. (Clive Staples) Lewis, "Jack" to his intimates, was born on November 29, 1898 in Belfast, Ireland. His mother died when he was 10 years old and his lawyer father allowed Lewis and his brother Warren extensive freedom. The pair were extremely close and they took full advantage of this freedom, learning on their own and frequently enjoying games of make-believe. These early activities led to Lewis''s lifelong attraction to fantasy and mythology, often reflected in his writing. He enjoyed writing about, and reading, literature of the past, publishing such works as the award-winning The Allegory of Love (1936), about the period of history known as the Middle Ages. Although at one time Lewis considered himself an atheist, he soon became fascinated with religion. He is probably best known for his books for young adults, such as his Chronicles of Narnia series. This fantasy series, as well as such works as The Screwtape Letters (a collection of letters written by the devil), is typical of the author''s interest in mixing religion and mythology, evident in both his fictional works and nonfiction articles. Lewis served with the Somerset Light Infantry in World War I; for nearly 30 years he served as Fellow and tutor of Magdalen College at Oxford University. Later, he became Professor of Medieval and Renaissance English at Cambridge University. C.S. Lewis married late in life, in 1957, and his wife, writer Joy Davidman, died of cancer in 1960. He remained at Cambridge until his death on November 22, 1963. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            Carnegie Medal (1957)
        </award>
        <award>
            Sir Israel Gollancz Prize (1937)
        </award>
        <award>
            British Academy (Fellow, 1955)
        </award>
        <award>
            Order of the British Empire (Commander, 1951 - declined)
        </award>
    </awards>
</bio>'),

('Rick', 'Riordan', '', '', 'https://rickriordan.com/',
'<bio>
    <desc>
        Rick Riordan was born on June 5, 1964, in San Antonio, Texas. After graduating from the University of Texas at Austin with a double major in English and history, he taught in public and private middle schools for many years. He writes several children''s series including Percy Jackson and the Olympians, The Kane Chronicles, and The Heroes of Olympus, Magnus Chase and the Gods of Asgard, and The Trials of Apollo. He also writes the Tres Navarre mystery series for adults. He has won Edgar, Anthony, and Shamus Awards for his mystery novels. . (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('Suzanne', 'Collins', '', '', 'https://www.suzannecollinsbooks.com/',
'<bio>
    <desc>
        Suzanne Collins was born on August 10, 1962. She was born in Hartford, Connecticut and graduated from Indiana University with a double major in Drama and Telecommunications. Collins went on to receive an M.F.A. from New York University in dramatic writing. Since 1991, she has been a writer for children''s television shows. She has worked on the staffs of several shows including Clarissa Explains it All, The Mystery Files of Shelby Woo, Little Bear and Oswald. She also co-wrote the Rankin/Bass Christmas special, Santa, Baby! and was the head writer for Scholastic Entertainment''s Clifford''s Puppy Days. Her books include When Charlie McButton Lost Power, The Underland Chronicles, and the Hunger Games Trilogy. Book one of this trilogy, The Hunger Games, became a major motion picture in 2012 with Oscar-winning actress Jennifer Lawrence portraying the main character of Katniss Everdeen. Catching Fire, book 2 of the trilogy, became a major motion picture in 2013. Mockingjay - Part One was released as a film in 2014 and Part Two in 2015. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            Time Magazine''s 100 Most Influential People in The World (2010)
        </award>
        <award>
            California Young Reader Medal (2011)
        </award>
        <award>
            CYBIL Award (2008)
        </award>
    </awards>
</bio>'),

('Christopher', 'Paolini', '', '', 'https://www.paolini.net/',
'<bio>
    <desc>
        Christopher Paolini was born in Southern California on November 17, 1983, but grew up primarily in Paradise Valley, Montana. He was home schooled and at the age of 15, graduated from high school through an accredited correspondence course at American School in Chicago, Illinois. He decided to write a book and after three years of writing and editing, Eragon was self-published in 2001. The Paolini family spent the following year promoting the book themselves by giving presentations to the local library and high school and then eventually branching out to libraries, bookstores, and schools across the United States. After his step-son read a copy of the book, author Carl Hiaasen brought Eragon to the attention of publisher Alfred A. Knopf, who acquired the rights to publish Eragon and the rest of the Inheritance Cycle in 2003. The other books in the cycle include Eldest, Brisingr, and Inheritance. Eragon was made into a movie in December 2006. (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('Mark', 'Z. Danielewski', '', '', 'https://www.markzdanielewski.com/',
'<bio>
    <desc>
        Mark Z. Danielewski is the author of House of Leaves, The Whalestoe Letters, Only Revolutions, The Fifty Year Sword, and The Familiar. (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('Bram', 'Stoker', '', '', '',
'<bio>
    <desc>
        Bram Stoker was born in Dublin, Ireland on November 8, 1847. He was educated at Trinity College. He worked as a civil servant and a journalist before becoming the personal secretary of the famous actor Henry Irving. He wrote 15 works of fiction including Dracula, The Lady of the Shroud, and The Lair of the White Worm, which was made into film. He died on April 20, 1912. (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('Oscar', 'Wilde', '', '', '',
'<bio>
    <desc>
        Flamboyant man-about-town, Oscar Wilde had a reputation that preceded him, especially in his early career. He was born to a middle-class Irish family (his father was a surgeon) and was trained as a scholarship boy at Trinity College, Dublin. He subsequently won a scholarship to Magdalen College, Oxford, where he was heavily influenced by John Ruskin and Walter Pater, whose aestheticism was taken to its radical extreme in Wilde''s work. By 1879 he was already known as a wit and a dandy; soon after, in fact, he was satirized in Gilbert and Sullivan''s Patience. Largely on the strength of his public persona, Wilde undertook a lecture tour to the United States in 1882, where he saw his play Vera open---unsuccessfully---in New York. His first published volume, Poems, which met with some degree of approbation, appeared at this time. In 1884 he married Constance Lloyd, the daughter of an Irish lawyer, and within two years they had two sons. During this period he wrote, among others, The Picture of Dorian Gray (1891), his only novel, which scandalized many readers and was widely denounced as immoral. Wilde simultaneously dismissed and encouraged such criticism with his statement in the preface, "There is no such thing as a moral or an immoral book. Books are well written or badly written. That is all." In 1891 Wilde published A House of Pomegranates, a collection of fantasy tales, and in 1892 gained commercial and critical success with his play, Lady Windermere''s Fan He followed this comedy with A Woman of No Importance (1893), An Ideal Husband (1895), and his most famous play, The Importance of Being Earnest (1895). During this period he also wrote Salome, in French, but was unable to obtain a license for it in England. Performed in Paris in 1896, the play was translated and published in England in 1894 by Lord Alfred Douglas and was illustrated by Aubrey Beardsley. Lord Alfred was the son of the Marquess of Queensbury, who objected to his son''s spending so much time with Wilde because of Wilde''s flamboyant behavior and homosexual relationships. In 1895, after being publicly insulted by the marquess, Wilde brought an unsuccessful slander suit against the peer. The result of his inability to prove slander was his own trial on charges of sodomy, of which he was found guilty and sentenced to two years of hard labor. During his time in prison, he wrote a scathing rebuke to Lord Alfred, published in 1905 as De Profundis. In it he argues that his conduct was a result of his standing "in symbolic relations to the art and culture" of his time. After his release, Wilde left England for Paris, where he wrote what may be his most famous poem, The Ballad of Reading Gaol (1898), drawn from his prison experiences. Among his other notable writing is The Soul of Man under Socialism (1891), which argues for individualism and freedom of artistic expression. There has been a revived interest in Wilde''s work; among the best recent volumes are Richard Ellmann''s, Oscar Wilde and Regenia Gagnier''s Idylls of the Marketplace , two works that vary widely in their critical assumptions and approach to Wilde but that offer rich insights into his complex character. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            Newdigate Prize for poetry (1878)
        </award>
    </awards>
</bio>'),

('Edgar', 'Allan Poe', '', '', '',
'<bio>
    <desc>
        Edgar Allan Poe was born in Boston, Massachusetts on January 19, 1809. In 1827, he enlisted in the United States Army and his first collection of poems, Tamerlane and Other Poems, was published. In 1835, he became the editor of the Southern Literary Messenger. Over the next ten years, Poe would edit a number of literary journals including the Burton''s Gentleman''s Magazine and Graham''s Magazine in Philadelphia and the Broadway Journal in New York City. It was during these years that he established himself as a poet, a short story writer, and an editor. His works include The Fall of the House of Usher, The Tell-Tale Heart, The Murders in the Rue Morgue, The Mystery of Marie Roget, A Descent into the Maelstrom, The Masque of the Red Death, and The Raven. He struggle with depression and alcoholism his entire life and died on October 7, 1849 at the age of 40. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            The Hall of Fame for Great Americans (1910)
        </award>
    </awards>
</bio>'),

('Niccolò', 'Machiavelli', '', '', '',
'<bio>
    <desc>
        Niccolo Machiavelli was born on May 3, 1469 in Florence, Italy. He was a political philosopher, statesman, and court advisor. Starting out as a clerk, he quickly rose in the ranks because he understood balance of power issues involved in many of his diplomatic missions. His political pursuits quickly ended after he was imprisoned by the Medici family. He is best known for The Prince, his guide to power attainment and cutthroat leadership. He also wrote poetry and plays, including a comedy named Mandragola. He died on June 21, 1527 at the age of 58.
    </desc>
    <awards>
    </awards>
</bio>'),

('Plato', ' ', '', '', '', 
'<bio>
    <desc>
        Plato was born c. 427 B.C. in Athens, Greece, to an aristocratic family very much involved in political government. Pericles, famous ruler of Athens during its golden age, was Plato''s stepfather. Plato was well educated and studied under Socrates, with whom he developed a close friendship. When Socrates was publically executed in 399 B.C., Plato finally distanced himself from a career in Athenian politics, instead becoming one of the greatest philosophers of Western civilization. Plato extended Socrates''s inquiries to his students, one of the most famous being Aristotle. Plato''s The Republic is an enduring work, discussing justice, the importance of education, and the qualities needed for rulers to succeed. Plato felt governors must be philosophers so they may govern wisely and effectively. Plato founded the Academy, an educational institution dedicated to pursuing philosophic truth. The Academy lasted well into the 6th century A.D., and is the model for all western universities. Its formation is along the lines Plato laid out in The Republic. Many of Plato''s essays and writings survive to this day. Plato died in 347 B.C. at the age of 80. (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('Thomas', 'Hobbes', '', '', '',
'<bio>
    <desc>
        Thomas Hobbes was born in Malmesbury, the son of a wayward country vicar. He was educated at Magdalen Hall, Oxford, and was supported during his long life by the wealthy Cavendish family, the Earls of Devonshire. Traveling widely, he met many of the leading intellectuals of the day, including Francis Bacon, Galileo Galilei, and Rene Descartes. As a philosopher and political theorist, Hobbes established---along with, but independently of, Descartes---early modern modes of thought in reaction to the scholasticism that characterized the seventeenth century. Because of his ideas, he was constantly in dispute with scientists and theologians, and many of his works were banned. His writings on psychology raised the possibility (later realized) that psychology could become a natural science, but his theory of politics is his most enduring achievement. In brief, his theory states that the problem of establishing order in society requires a sovereign to whom people owe loyalty and who in turn has duties toward his or her subjects. His prose masterpiece Leviathan (1651) is regarded as a major contribution to the theory of the state. (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('Friedrich', 'Nietzsche', '', '', '',
'<bio>
    <desc>
        The son of a Lutheran pastor, Friedrich Wilhelm Nietzsche was born in 1844 in Roecken, Prussia, and studied classical philology at the Universities of Bonn and Leipzig. While at Leipzig he read the works of Schopenhauer, which greatly impressed him. He also became a disciple of the composer Richard Wagner. At the very early age of 25, Nietzsche was appointed professor at the University of Basel in Switzerland. In 1870, during the Franco-Prussian War, Nietzsche served in the medical corps of the Prussian army. While treating soldiers he contracted diphtheria and dysentery; he was never physically healthy afterward. Nietzsche''s first book, The Birth of Tragedy Out of the Spirit of Music (1872), was a radical reinterpretation of Greek art and culture from a Schopenhaurian and Wagnerian standpoint. By 1874 Nietzsche had to retire from his university post for reasons of health. He was diagnosed at this time with a serious nervous disorder. He lived the next 15 years on his small university pension, dividing his time between Italy and Switzerland and writing constantly. He is best known for the works he produced after 1880, especially The Gay Science (1882), Thus Spake Zarathustra (1883-85), Beyond Good and Evil (1886), On the Genealogy of Morals (1887), The Antichrist (1888), and Twilight of the Idols (1888). In January 1889, Nietzsche suffered a sudden mental collapse; he lived the last 10 years of his life in a condition of insanity. After his death, his sister published many of his papers under the title The Will to Power. Nietzsche was a radical questioner who often wrote polemically with deliberate obscurity, intending to perplex, shock, and offend his readers. He attacked the entire metaphysical tradition in Western philosophy, especially Christianity and Christian morality, which he thought had reached its final and most decadent form in modern scientific humanism, with its ideals of liberalism and democracy. It has become increasingly clear that his writings are among the deepest and most prescient sources we have for acquiring a philosophical understanding of the roots of 20th-century culture. (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('Immanuel', 'Kant', '', '', '',
'<bio>
    <desc>
        The greatest of all modern philosophers was born in the Baltic seaport of Konigsberg, East Prussia, the son of a saddler and never left the vicinity of his remote birthplace. Through his family pastor, Immanuel Kant received the opportunity to study at the newly founded Collegium Fredericianum, proceeding to the University of Konigsberg, where he was introduced to Wolffian philosophy and modern natural science by the philosopher Martin Knutzen. From 1746 to 1755, he served as tutor in various households near Konigsberg. Between 1755 and 1770, Kant published treatises on a number of scientific and philosophical subjects, including one in which he originated the nebular hypothesis of the origin of the solar system. Some of Kant''s writings in the early 1760s attracted the favorable notice of respected philosophers such as J. H. Lambert and Moses Mendelssohn, but a professorship eluded Kant until he was over 45. In 1781 Kant finally published his great work, the Critique of Pure Reason. The early reviews were hostile and uncomprehending, and Kant''s attempt to make his theories more accessible in his Prolegomena to Any Future Metaphysics (1783) was largely unsuccessful. Then, partly through the influence of former student J. G. Herder, whose writings on anthropology and history challenged his Enlightenment convictions, Kant turned his attention to issues in the philosophy of morality and history, writing several short essays on the philosophy of history and sketching his ethical theory in the Foundations of the Metaphysics of Morals (1785). Kant''s new philosophical approach began to receive attention in 1786 through a series of articles in a widely circulated Gottingen journal by the Jena philosopher K. L. Reinhold. The following year Kant published a new, extensively revised edition of the Critique, following it up with the Critique of Practical Reason (1788), treating the foundations of moral philosophy, and the Critique of Judgment (1790), an examination of aesthetics rounding out his system through a strikingly original treatment of two topics that were widely perceived as high on the philosophical agenda at the time - the philosophical meaning of the taste for beauty and the use of teleology in natural science. From the early 1790s onward, Kant was regarded by the coming generation of philosophers as having overthrown all previous systems and as having opened up a whole new philosophical vista. During the last decade of his philosophical activity, Kant devoted most of his attention to applications of moral philosophy. His two chief works in the 1790s were Religion Within the Bounds of Plain Reason (1793--94) and Metaphysics of Morals (1798), the first part of which contained Kant''s theory of right, law, and the political state. At the age of 74, most philosophers who are still active are engaged in consolidating and defending views they have already worked out. Kant, however, had perceived an important gap in his system and had begun rethinking its foundations. These attempts went on for four more years until the ravages of old age finally destroyed Kant''s capacity for further intellectual work. The result was a lengthy but disorganized manuscript that was first published in 1920 under the title Opus Postumum. It displays the impact of some of the more radical young thinkers Kant''s philosophy itself had inspired. Kant''s philosophy focuses attention on the active role of human reason in the process of knowing the world and on its autonomy in giving moral law. Kant saw the development of reason as a collective possession of the human species, a product of nature working through human history. For him the process of free communication between independent minds is the very life of reason, the vocation of which is to remake politics, religion, science, art, and morality as the completion of a destiny whose shape it is our collective task to frame for ourselves. (Bowker Author Biography) Philosopher Immanuel Kant was born in 1724 in Konigsberg, East Prussia. He studied at the University of Konigsberg, where he would act as a lecturer and professor after a brief career as a private tutor. Kant was an incredibly influential philosopher, his theories having impact on the likes of Schopenhauer and Hegel. Kant''s most prominent works include Critique of Pure Reason (1781), Foundations of the Metaphysics of Morals (1785) and Critique of Practical Reason (1788). He died in 1804. (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('William', 'Shakespeare', '', '', '',
'<bio>
    <desc>
        William Shakespeare, 1564 - 1616 Although there are many myths and mysteries surrounding William Shakespeare, a great deal is actually known about his life. He was born in Stratford-Upon-Avon, son of John Shakespeare, a prosperous merchant and local politician and Mary Arden, who had the wealth to send their oldest son to Stratford Grammar School. At 18, Shakespeare married Anne Hathaway, the 27-year-old daughter of a local farmer, and they had their first daughter six months later. He probably developed an interest in theatre by watching plays performed by traveling players in Stratford while still in his youth. Some time before 1592, he left his family to take up residence in London, where he began acting and writing plays and poetry. By 1594 Shakespeare had become a member and part owner of an acting company called The Lord Chamberlain''s Men, where he soon became the company''s principal playwright. His plays enjoyed great popularity and high critical acclaim in the newly built Globe Theatre. It was through his popularity that the troupe gained the attention of the new king, James I, who appointed them the King''s Players in 1603. Before retiring to Stratford in 1613, after the Globe burned down, he wrote more than three dozen plays (that we are sure of) and more than 150 sonnets. He was celebrated by Ben Jonson, one of the leading playwrights of the day, as a writer who would be "not for an age, but for all time," a prediction that has proved to be true. Today, Shakespeare towers over all other English writers and has few rivals in any language. His genius and creativity continue to astound scholars, and his plays continue to delight audiences. Many have served as the basis for operas, ballets, musical compositions, and films. While Jonson and other writers labored over their plays, Shakespeare seems to have had the ability to turn out work of exceptionally high caliber at an amazing speed. At the height of his career, he wrote an average of two plays a year as well as dozens of poems, songs, and possibly even verses for tombstones and heraldic shields, all while he continued to act in the plays performed by the Lord Chamberlain''s Men. This staggering output is even more impressive when one considers its variety. Except for the English history plays, he never wrote the same kind of play twice. He seems to have had a good deal of fun in trying his hand at every kind of play. Shakespeare wrote 154 sonnets, all published on 1609, most of which were dedicated to his patron Henry Wriothsley, The Earl of Southhampton. He also wrote 13 comedies, 13 histories, 6 tragedies, and 4 tragecomedies. He died at Stratford-upon-Avon April 23, 1616, and was buried two days later on the grounds of Holy Trinity Church in Stratford. His cause of death was unknown, but it is surmised that he knew he was dying. (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('Homer', ' ', '', '', '',
'<bio>
    <desc>
        Homer is the author of The Iliad and The Odyssey, the two greatest Greek epic poems. Nothing is known about Homer personally; it is not even known for certain whether there is only one true author of these two works. Homer is thought to have been an Ionian from the 9th or 8th century B.C. While historians argue over the man, his impact on literature, history, and philosophy is so significant as to be almost immeasurable. The Iliad relates the tale of the Trojan War, about the war between Greece and Troy, brought about by the kidnapping of the beautiful Greek princess, Helen, by Paris. It tells of the exploits of such legendary figures as Achilles, Ajax, and Odysseus. The Odyssey recounts the subsequent return of the Greek hero Odysseus after the defeat of the Trojans. On his return trip, Odysseus braves such terrors as the Cyclops, a one-eyed monster; the Sirens, beautiful temptresses; and Scylla and Charybdis, a deadly rock and whirlpool. Waiting for him at home is his wife who has remained faithful during his years in the war. Both the Iliad and the Odyssey have had numerous adaptations, including several film versions of each. (Bowker Author Biography)
    </desc>
    <awards>
    </awards>
</bio>'),

('Sophocles', ' ', '', '', '',
'<bio>
    <desc>
        Sophocles was born around 496 B.C. in Colonus (near Athens), Greece. In 480, he was selected to lead the paean (choral chant to a god) celebrating the decisive Greek sea victory over the Persians at the Battle of Salamis. He served as a treasurer and general for Athens when it was expanding its empire and influence. He wrote approximately 123 plays including Ajax, Antigone, Oedipus Tyrannus, Trachiniae, Electra, Philoctetes, and Oedipus at Colonus. His last recorded act was to lead a chorus in public mourning for Euripides. He died in 406 B. C. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            18 victories at the Athens Dionysia
        </award>
        <award>
            6 victories at the Athens Lenaia  
        </award>
    </awards>
</bio>'),

('J.R.R', 'Tolkien', '', '', 'https://www.tolkienestate.com/',
'<bio>
    <desc>
        A writer of fantasies, Tolkien, a professor of language and literature at Oxford University, was always intrigued by early English and the imaginative use of language. In his greatest story, the trilogy The Lord of the Rings (1954--56), Tolkien invented a language with vocabulary, grammar, syntax, even poetry of its own. Though readers have created various possible allegorical interpretations, Tolkien has said: "It is not about anything but itself. (Certainly it has no allegorical intentions, general, particular or topical, moral, religious or political.)" In The Adventures of Tom Bombadil (1962), Tolkien tells the story of the "master of wood, water, and hill," a jolly teller of tales and singer of songs, one of the multitude of characters in his romance, saga, epic, or fairy tales about his country of the Hobbits. Tolkien was also a formidable medieval scholar, as evidenced by his work, Beowulf: The Monster and the Critics (1936) and his edition of Anciene Wisse: English Text of the Anciene Riwle. Among his works published posthumously, are The Legend of Sigurd and Gudrún and The Fall of Arthur, which was edited by his son, Christopher. In 2013, his title, TheHobbit (Movie Tie-In) made The New York Times Best Seller List. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            Order of the British Empire (Commander ∙ 1972)
        </award>
        <award>
            Royal Society of Literature (Fellow, 1957)
        </award>
        <award>
            Benson Medal (1967)
        </award>
        <award>
            SF Hall Of Fame (2013)
        </award>
        <award>
            Gandalf Award (Grand Master of Fantasy ∙ 1974)
        </award>
    </awards>
</bio>'),

('Ursula', 'K. Le Guin', '', '', 'https://www.ursulakleguin.com/',
'<bio>
    <desc>
        Ursula K. Le Guin was born Ursula Kroeber in Berkeley, California on October 21, 1929. She received a bachelor''s degree from Radcliffe College in 1951 and a master''s degree in romance literature of the Middle Ages and Renaissance from Columbia University in 1952. She won a Fulbright fellowship in 1953 to study in Paris, where she met and married Charles Le Guin. Her first science-fiction novel, Rocannon''s World, was published in 1966. Her other books included the Earthsea series, The Left Hand of Darkness, The Dispossessed: An Ambiguous Utopia, The Lathe of Heaven, Four Ways to Forgiveness, and The Telling. A Wizard of Earthsea received an American Library Association Notable Book citation, a Horn Book Honor List citation, and the Lewis Carroll Shelf Award in 1979. She received the Medal for Distinguished Contribution to American Letters in 2014. She also received the Nebula Award and the Hugo Award. She also wrote books of poetry, short stories collections, collections of essays, children''s books, a guide for writers, and volumes of translation including the Tao Te Ching of Lao Tzu and selected poems by Gabriela Mistral. She died on January 22, 2018 at the age of 88. (Bowker Author Biography)
    </desc>
    <awards>
        <award>
            Damon Knight Memorial Grand Master Award (2003)
        </award>
        <award>
            Gandalf Award (1979)
        </award>
        <award>
            World Fantasy Award (Life Achievement, 1995)
        </award>
        <award>
            SFRA Pilgrim Award (1989)
        </award>
        <award>
            PEN/Malamud Award (2002)
        </award>
    </awards>
</bio>'),

('Brandon', 'Sanderson', '', '', 'https://www.brandonsanderson.com/',
'<bio>
    <desc>
        Brandon Sanderson was born on December 19, 1975 in Lincoln, Nebraska. He received a bachelor''s degree in English and a master''s degree in creative writing from Brigham Young University. His first book, Elantris, was published in 2005. His other works include the Mistborn series, the Stormlight Archive series, Alcatraz Versus the Evil Librarians series, and the Reckoners series. In 2007, he was chosen by Harriet Rigney to complete A Memory of Light, book twelve in Robert Jordan''s Wheel of Time series. He has continued the series with Towers of Midnight and A Memory of Light. In 2018 his title, White Sand Volume 2, made the Best Seller List.
    </desc>
    <awards>
        <award>
            John W. Campbell Award Nominee (2006 | 2007)
        </award>
    </awards>
</bio>'),

('John', 'Milton', '', '', '',
'<bio>
    <desc>
        John Milton, English scholar and classical poet, is one of the major figures of Western literature. He was born in 1608 into a prosperous London family. By the age of 17, he was proficient in Latin, Greek, and Hebrew. Milton attended Cambridge University, earning a B.A. and an M.A. before secluding himself for five years to read, write and study on his own. It is believed that Milton read evertything that had been published in Latin, Greek, and English. He was considered one of the most educated men of his time. Milton also had a reputation as a radical. After his own wife left him early in their marriage, Milton published an unpopular treatise supporting divorce in the case of incompatibility. Milton was also a vocal supporter of Oliver Cromwell and worked for him. Milton''s first work, Lycidas, an elegy on the death of a classmate, was published in 1632, and he had numerous works published in the ensuing years, including Pastoral and Areopagitica. His Christian epic poem, Paradise Lost, which traced humanity''s fall from divine grace, appeared in 1667, assuring his place as one of the finest non-dramatic poet of the Renaissance Age. Milton went blind at the age of 43 from the incredible strain he placed on his eyes. Amazingly, Paradise Lost and his other major works, Paradise Regained and Samson Agonistes, were composed after the lost of his sight. These major works were painstakingly and slowly dictated to secretaries. John Milton died in 1674.
    </desc>
    <awards>
    </awards>
</bio>'),

('Harry', 'Martinson', '', '', '',
'<bio>
    <desc>
        Harry Martinson was born in Jämshög, Sweden on May 6, 1904. When he was six his father died and then his mother immigrated to America, leaving him and his sisters as parish orphans, fostered out to various families. He ran away from his foster parents and went to sea from 1920 to 1927. After returning to Sweden, ill with tuberculosis and destitute, he came under the care of his future wife, Moa Swartz, who became a well-known author in her own right. His first book of poetry, Spökskepp (Ghost Ship), was published in 1929. He also wrote a collection of poetry entitled Passad (Trade Wind) and an epic poem about space travel entitled Aniara. His novels include Nässlorna Blomma (Flowering Nettle), Vägen Ut (The Way Out), Kap Farväl (Cape Farewell), and Vägen till Klockrike (The Road). He was elected to the Swedish Academy in 1949, a notable achievement for a writer with no formal education. He shared the 1974 Nobel Prize for Literature with novelist Eyvind Johnson. Their honors were considered controversial, since they were close friends and both had been long-time members of the Swedish Academy. He was offended by the insinuation of corruption and withdrew into depression. He committed suicide on February 11, 1978.
    </desc>
    <awards>
        <award>
        </award>
    </awards>
</bio>'),

('Carlos', 'Drummond de Andrade', '', '', 'http://www.carlosdrummond.com.br/',
'<bio>
    <desc>
        Carlos Drummond de Andrade remains one of the most celebrated Brazilian poets of the 20th century. His work, deeply rooted in the modernist movement, transcends the confines of a specific era. Drummond''s poetry delves into universal themes of love, loss, the human condition, and the intricacies of everyday life, making his work as relevant today as it was during his lifetime.
        Often reflecting a melancholic and introspective tone, Drummond''s poetry is characterized by its conversational style, stark imagery, and exploration of existential anxieties. He masterfully employs irony and humor to examine the complexities of modern life, creating a unique poetic voice that continues to resonate with readers across generations.
        Drummond''s work emerged alongside other prominent modernist poets of his time, such as Pablo Neruda and T.S. Eliot, who similarly sought to break free from traditional poetic forms and delve into the complexities of the modern world. While influenced by European modernism, Drummond''s poetry maintains a distinct Brazilian identity, drawing upon his own experiences and observations of his homeland. 
    </desc>
    <awards>
    </awards>
</bio>'),

('Dante', 'Alighieri', '', '', '',
'<bio>
    <desc>
        Dante Alighieri, (May 14/June 13, 1265 – September 13/14[1], 1321), was a Florentine Italian poet. Like many in the Florence of his day, he became involved in the conflict between the Guelph and Ghibelline factions. He fought in the Battle of Campaldino (1289) and held several political offices over the years. His central work, the Divina Commedia (Divine Comedy, originally called "Comedìa"), is composed of three parts: the Inferno, Purgatory, and Paradise. Dante was exiled from the city he loved, and addressed the pain of his loss in his work.
    </desc>
    <awards>
    </awards>
</bio>'),

('Philip', 'K. Dick', '', '', '',
'<bio>
    <desc>
        Phillip Kindred Dick was an American science fiction writer best known for his psychological portrayals of characters trapped in illusory environments. Born in Chicago, Illinois, on December 16, 1928, Dick worked in radio and studied briefly at the University of California at Berkeley before embarking on his writing career. His first novel, Solar Lottery, was published in 1955. In 1963, Dick won the Hugo Award for his novel, The Man in the High Castle. He also wrote a series of futuristic tales about artificial creatures on the loose; notable of these was Do Androids Dream of Electric Sheep?, which was later adapted into film as Blade Runner. Dick also published several collections of short stories. He died of a stroke in Santa Ana, California, in 1982.
    </desc>
    <awards>
        <award>
            Science Fiction Hall of Fame ( [2005])
        </award>
    </awards>
</bio>'),

('Isaac', 'Asimov', '', '', '',
'<bio>
    <desc>
        Isaac Asimov was born in Petrovichi, Russia, on January 2, 1920. His family emigrated to the United States in 1923 and settled in Brooklyn, New York, where they owned and operated a candy store. Asimov became a naturalized U.S. citizen at the age of eight. As a youngster he discovered his talent for writing, producing his first original fiction at the age of eleven. He went on to become one of the world''s most prolific writers, publishing nearly 500 books in his lifetime. Asimov was not only a writer; he also was a biochemist and an educator. He studied chemistry at Columbia University, earning a B.S., M.A. and Ph.D. In 1951, Asimov accepted a position as an instructor of biochemistry at Boston University''s School of Medicine even though he had no practical experience in the field. His exceptional intelligence enabled him to master new systems rapidly, and he soon became a successful and distinguished professor at Columbia and even co-authored a biochemistry textbook within a few years. Asimov won numerous awards and honors for his books and stories, and he is considered to be a leading writer of the Golden Age of science fiction. While he did not invent science fiction, he helped to legitimize it by adding the narrative structure that had been missing from the traditional science fiction books of the period. He also introduced several innovative concepts, including the thematic concern for technological progress and its impact on humanity. Asimov is probably best known for his Foundation series, which includes Foundation, Foundation and Empire, and Second Foundation. In 1966, this trilogy won the Hugo award for best all-time science fiction series. In 1983, Asimov wrote an additional Foundation novel, Foundation''s Edge, which won the Hugo for best novel of that year. Asimov also wrote a series of robot books that included I, Robot, and eventually he tied the two series together. He won three additional Hugos, including one awarded posthumously for the best non-fiction book of 1995, I. Asimov. "Nightfall" was chosen the best science fiction story of all time by the Science Fiction Writers of America. In 1979, Asimov wrote his autobiography, In Memory Yet Green. He continued writing until just a few years before his death from heart and kidney failure on April 6, 1992.
    </desc>
    <awards>
        <award>
            SFWA Grand Master (1986)
        </award>
        <award>
            Thomas Alva Edison Foundation Award (1957)
        </award>
        <award>
            Howard W. Blakeslee Award (1960)
        </award>
        <award>
            Boston University''s Publication Merit Award (1962)
        </award>
    </awards>
</bio>'),

('Frank', 'Herbert', '', '', '', 
'<bio>
    <desc>
        Frank Herbert was born Franklin Patrick Herbert, Jr. in Tacoma, Washington on October 8, 1920. He worked originally as a journalist, but then turned to science fiction. His Dune series has had a major impact on that genre. Some critics assert that Herbert is responsible for bringing in a new branch of ecological science fiction. He had a personal interest in world ecology, and consulted with the governments of Vietnam and Pakistan about ecological issues. The length of some of Herbert''s novels also helped make it acceptable for science fiction authors to write longer books. It is clear that, if the reader is engaged by the story - and Herbert certainly has the ability to engage his readers---length is not important. As is usually the case with popular fiction, it comes down to whether or not the reader is entertained, and Herbert is, above all, an entertaining and often compelling writer. His greatest talent is his ability to create new worlds that are plausible to readers, in spite of their alien nature, such as the planet Arrakis in the Dune series. Frank Herbert died of complications from pancreatic cancer on February, 11, 1986, in Madison, Wisconsin. He was 65.
    </desc>
    <awards>
        <award>
            SF Hall Of Fame (Posthumous Inductee, 2006)
        </award>
    </awards>
</bio>'),

('Peter', 'Watts', '', '', 'https://www.rifters.com/',
'<bio>
    <desc>
        Peter Watts is a reformed marine biologist whom Canada''s Globe and Mail has proclaimed "one of the very best hard-SF writers alive"
    </desc>
    <awards>
    </awards>
</bio>'),

('Andrew', 'Hodges', 'andrew@synth.co.uk', '', 'https://www.synth.co.uk/',
'<bio>
    <desc>
        Andrew Hodges was born in London, England in 1949. He is a mathematician, author, and activist in the gay liberation movement of the 1970s. Since the early 1970s, he has worked on twistor theory. He is also known as the author of Alan Turing: The Enigma, the story of the British computer pioneer and codebreaker Alan Turing. This book was the basis for the 2014 feature film The Imitation Game.
    </desc>
    <awards>
    </awards>
</bio>'),

('Douglas', 'R. Hofstadter', '', '', '',
'<bio>
    <desc>
        Douglas Hofstadter is College of Arts and Sciences Professor of Cognitive Science at Indiana University 
    </desc>
    <awards>
        <award>
            George Pólya Award (1983)
        </award>
        <award>
            American Book Award (Science ∙ 1980)
        </award>
        <award>
            American Academy of Arts and Sciences (2009)
        </award>
        <award>
            American Philosophical Society (2009)
        </award>
        <award>
            Royal Society of Sciences in Uppsala (2010)
        </award>
        <award>
            Pulitzer Prize (1980)
        </award>
    </awards>
</bio>'),

('Humphrey', 'Carpenter', '', '', '',
'<bio>
    <desc>
        Humphrey Carpenter is the award-winning author of biographies of Dennis Potter, J.R.R. Tolkien, W.H. Auden, and Ezra Pound. He broadcasts regularly on BBC radio. Carpenter is married with two children and lives in Oxford, England
    </desc>
    <awards>
        <award>
            Tolkien Society Gold Badge
        </award>
        <award>
            E. M. Forster Award (1984)
        </award>
        <award>
            Duff Cooper Memorial Prize (1988)
        </award>
    </awards>
</bio>'),

('William', 'Kalush', '', '', '',
'<bio>
    <desc>
        William Kalush is the founder of the Conjuring Arts Research Center and publisher of Gibeciere
    </desc>
    <awards>
        <award>
            The John Nevil Maskelyne Prize (2011)
        </award>
    </awards>
</bio>'),

('Larry', 'Sloman', '', '', 'http://www.ratso.org/ ',
'<bio>
    <desc>
    </desc>
    <awards>
    </awards>
</bio>'),

('Hayden', 'Herrera', '', '', '',
'<bio>
    <desc>
        Hayden Herrera is the author of the Pulitzer Prize-nominated Arshile Gorky: His Life and Work, as well as Frida: A Biography of Frida Kahlo and Matisse: A Portrait.
    </desc>
    <awards>
        <award>
            Bourse Guggenheim (1996)
        </award>
    </awards>
</bio>'),

('Walter', 'Isaacson', '', '', '',
'<bio>
    <desc>
        Walter Isaacson, University Professor of History at Tulane, has been CEO of the Aspen Institute, chairman of CNN, and editor of Time magazine. He is the author of Leonardo da Vinci; Steve Jobs; Einstein: His Life and Universe; Benjamin Franklin: An American Life; and Kissinger: A Biography. He is also the coauthor of The Wise Men: Six Friends and the World They Made.
    </desc>
    <awards>
        <award>
            Jefferson Lecture (2014)
        </award>
        <award>
            Gerald Loeb Award (2012)    
        </award>
        <award>
            American Philosophical Society (2005)
        </award>
        <award>
            American Academy of Arts &amp; Sciences (2016)
        </award>
    </awards>
</bio>')
GO


-- Populates "Books" tables
-- Books searched and selected from https://www.goodreads.com/
-- Barcodes generated with https://orcascan.com/tools/code-39-generator
-- Dewey Decimal System CallNumber looked up with https://www.librarything.com/mds
-- Book description, blurbs and awards from https://www.goodreads.com/
INSERT INTO Books (BookBarcode, Title, Publisher, PublicationDate, BookEdition,
                    BookLanguage, Genre, AvailabilityStatus, CallNumber, 
                    BookDescription, AlternativeTitles)
VALUES
('852112308018', 'A Brief History of Time', 
(SELECT ID from Publishers where PublisherName = 'Bantam Books'),
'1998-09-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'523.1', '<bookdesc>
    <blurb>
        A landmark volume in science writing by one of the great minds of our time, Stephen Hawking’s book explores such profound questions as: How did the universe begin—and what made its start possible? Does time always flow forward? Is the universe unending—or are there boundaries? Are there other dimensions in space? What will happen when it all ends?
        Told in language we all can understand, A Brief History of Time plunges into the exotic realms of black holes and quarks, of antimatter and “arrows of time,” of the big bang and a bigger God—where the possibilities are wondrous and unexpected. With exciting images and profound imagination, Stephen Hawking brings us closer to the ultimate secrets at the very heart of creation.
    </blurb>
    <awards>
        <award>
            Royal Society Science Book Prize Nominee for General Prize (1989)
        </award>
    </awards>
</bookdesc>', 
'<alternativetitles>
</alternativetitles>'),

('1061988575523', 'Introduction to Algorithms', 
(SELECT ID from Publishers where PublisherName = 'MIT Press'),
'1989-01-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'005.1', '<bookdesc>
    <blurb>
        A comprehensive update of the leading algorithms text, with new material on matchings in bipartite graphs, online algorithms, machine learning, and other topics.
        Some books on algorithms are rigorous but incomplete; others cover masses of material but lack rigor. Introduction to Algorithms uniquely combines rigor and comprehensiveness. It covers a broad range of algorithms in depth, yet makes their design and analysis accessible to all levels of readers, with self-contained chapters and algorithms in pseudocode. Since the publication of the first edition, Introduction to Algorithms has become the leading algorithms text in universities worldwide as well as the standard reference for professionals. This fourth edition has been updated throughout.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('126620977745', 'The Origin of Species', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2003-09-02', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'575.0162', '<bookdesc>
    <blurb>
    The classic that exploded into public controversy, revolutionized the course of science, and continues to transform our views of the world.
    Few other books have created such a lasting storm of controversy as The Origin of Species. Darwin''s theory that species derive from other species by a gradual evolutionary process and that the average level of each species is heightened by the "survival of the fittest" stirred up popular debate to a fever pitch. Its acceptance revolutionized the course of science.
    As Sir Julian Huxley, the noted biologist, points out in his illuminating introduction, the importance of Darwin''s contribution to modern scientific knowledge is almost impossible to evaluate: "a truly great book, one which after a century of scientific progress can still be read with profit by professional biologists."
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
    <English>
        On the Origin of Species
    </English>
</alternativetitles>'),

('113249352922', 'Relativity: The Special and the General Theory', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2006-06-25', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'530.112', '<bookdesc>
    <blurb>
        An accesible version of Einstein''s masterpiece of theory, written by the genius himself
        According to Einstein himself, this book is intended "to give an exact insight into the theory of Relativity to those readers who, from a general scientific and philosophical point of view, are interested in the theory, but who are not conversant with the mathematical apparatus of theoretical physics." When he wrote the book in 1916, Einstein''s name was scarcely known outside the physics institutes. Having just completed his masterpiece, The General Theory of Relativity—which provided a brand-new theory of gravity and promised a new perspective on the cosmos as a whole—he set out at once to share his excitement with as wide a public as possible in this popular and accessible book.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
    <German>
        Über die spezielle und die allgemeine Relativitätstheorie
    </German>
</alternativetitles>'),

('109584146703', 'Astrophysics for People in a Hurry', 
(SELECT ID from Publishers where PublisherName = 'W. W. Norton & Company'),
'2017-05-02', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'523.01', '<bookdesc>
    <blurb>
        What is the nature of space and time? How do we fit within the universe? How does the universe fit within us? There’s no better guide through these mind-expanding questions than acclaimed astrophysicist and best-selling author Neil deGrasse Tyson.
        But today, few of us have time to contemplate the cosmos. So Tyson brings the universe down to Earth succinctly and clearly, with sparkling wit, in tasty chapters consumable anytime and anywhere in your busy day.
        While you wait for your morning coffee to brew, for the bus, the train, or a plane to arrive, Astrophysics for People in a Hurry will reveal just what you need to be fluent and ready for the next cosmic headlines: from the Big Bang to black holes, from quarks to quantum mechanics, and from the search for planets to the search for life in the universe.
    </blurb>
    <awards>
        <award>
            Winner for Readers'' Favorite Science &amp; Technology (2017)
        </award>
        <award>
            #1 New York Times Bestseller
        </award>
        <award>
            Grammy Award Nominee for Best Spoken Word Album (2018)
        </award>
        <award>
            Goodreads Choice Award for Science &amp; Technology (2017)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('451973311060', 'The Little Prince', 
(SELECT ID from Publishers where PublisherName = 'Harcourt'),
'2000-05-15', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Childrens lit.'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Rented'), 
'843.912', '<bookdesc>
    <blurb>
        A pilot forced to land in the Sahara meets a little prince. The wise and enchanting stories the prince tells of his own planet with its three volcanoes and a haughty flower are unforgettable. A strange and wonderful parable for all ages, with super illustrations by the author.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
    <French>
        Le Petit Prince
    </French>
</alternativetitles>'),

('103044064583', 'Le Petit Prince', 
(SELECT ID from Publishers where PublisherName = 'Folio Junior'),
'1998-01-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'French'), 
(SELECT ID from BookGenres where Genre = 'Childrens lit.'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'843.912', '<bookdesc>
    <blurb>
        Imaginez-vous perdu dans le désert, loin de tout lieu habité, et face à un petit garçon tout blond, surgi de nulle part. Si de surcroît ce petit garçon vous demande avec insistance de dessiner un mouton, vous voilà plus qu''étonné ! À partir de là, vous n''aurez plus qu''une seule interrogation : savoir d''où vient cet étrange petit bonhomme et connaître son histoire.
        S''ouvre alors un monde étrange et poétique, peuplé de métaphores, décrit à travers les paroles d''un "petit prince" qui porte aussi sur notre monde à nous un regard tout neuf, empli de naïveté, de fraîcheur et de gravité. Très vite, vous découvrez d''étranges planètes, peuplées d''hommes d''affaires, de buveurs, de vaniteux, d''allumeurs de réverbères.
        Cette évocation onirique, à laquelle participent les aquarelles de l''auteur, a tout d''un parcours initiatique, où l''enfant apprendra les richesses essentielles des rapports humains et le secret qui les régit : "On ne voit bien qu''avec le coeur, l''essentiel est invisible pour les yeux."
        Oeuvre essentielle de la littérature, ce livre de Saint-Exupéry est un ouvrage que l''on aura à coeur de raconter à son enfant, page après page, histoire aussi de redécouvrir l''enfant que l''on était autrefois, avant de devenir une grande personne !
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
    <English>
        The Little Prince
    </English>
</alternativetitles>'),

('621844182299', 'The Lion, the Witch and the Wardrobe', 
(SELECT ID from Publishers where PublisherName = 'Harper Collins'),
'2013-01-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Childrens lit.'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'823.087661', '<bookdesc>
    <blurb>
        They open a door and enter a world
        NARNIA...the land beyond the wardrobe, the secret country known only to Peter, Susan, Edmund, and Lucy...the place where the adventure begins.
        Lucy is the first to find the secret of the wardrobe in the professor''s mysterious old house. At first, no one believes her when she tells of her adventures in the land of Narnia. But soon Edmund and then Peter and Susan discover the Magic and meet Aslan, the Great Lion, for themselves. In the blink of an eye, their lives are changed forever.
    </blurb>
    <awards>
        <award>
            Lewis Carroll Shelf Award (1962)
        </award>
        <award>
            Keith Barker Millennium Book Award for Children''s Book of the Century (2000)
        </award>
        <award>
            Retro Hugo Award Nominee for Best Novel (2001)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('1093889941888', 'The Lightning Thief', 
(SELECT ID from Publishers where PublisherName = 'Disney-Hyperion Books'),
'2006-03-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Childrens lit.'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6', '<bookdesc>
    <blurb>
        Percy Jackson is a good kid, but he can''t seem to focus on his schoolwork or control his temper. And lately, being away at boarding school is only getting worse - Percy could have sworn his pre-algebra teacher turned into a monster and tried to kill him. When Percy''s mom finds out, she knows it''s time that he knew the truth about where he came from, and that he go to the one place he''ll be safe. She sends Percy to Camp Half Blood, a summer camp for demigods (on Long Island), where he learns that the father he never knew is Poseidon, God of the Sea. Soon a mystery unfolds and together with his friends—one a satyr and the other the demigod daughter of Athena - Percy sets out on a quest across the United States to reach the gates of the Underworld (located in a recording studio in Hollywood) and prevent a catastrophic war between the gods.
    </blurb>
    <awards>
        <award>
            Young Readers'' Choice Award (2008) 
        </award>
        <award>
            Books I Loved Best Yearly (BILBY) Awards for Older Readers (2011)
        </award>
        <award>
            South Carolina Book Award for Junior Book Award (2008)
        </award>
        <award>
            Grand Canyon Reader Award for Tween Book (2008)
        </award>
        <award>
            Nene Award (2008) 
        </award>
        <award>
            Massachusetts Children''s Book Award (2008)
        </award>
        <award>
            Pennsylvania Young Readers'' Choice Award for Grades 6-8 (2008)
        </award>
        <award>
            Rhode Island Teen Book Award Nominee (2007)
        </award>
        <award>
            Sunshine State Young Readers Award for Grades 6-8 (2007)
        </award>
        <award>
            Pacific Northwest Library Association Young Reader''s Choice Award for Intermediate (2008)
        </award>
        <award>
            Iowa Teen Award (2009)
        </award>
        <award>
            Lincoln Award Nominee (2009)
        </award>
        <award>
            Oklahoma Sequoyah Book Award for YA (2008)
        </award>
        <award>
            Rebecca Caudill Young Readers'' Book Award (2009)
        </award>
        <award>
            Maud Hart Lovelace Award for Grades 6–8 (2009)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('298941326779', 'The Sea of Monsters', 
(SELECT ID from Publishers where PublisherName = 'Disney-Hyperion Books'),
'2006-05-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Childrens lit.'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6', '<bookdesc>
    <blurb>
        The heroic son of Poseidon makes an action-packed comeback in the second must-read installment of Rick Riordan''s amazing young readers series. Starring Percy Jackson, a "half blood" whose mother is human and whose father is the God of the Sea, Riordan''s series combines cliffhanger adventure and Greek mythology lessons that results in true page-turners that get better with each installment.
        In this episode, The Sea of Monsters, Percy sets out to retrieve the Golden Fleece before his summer camp is destroyed, surpassing the first book''s drama and setting the stage for more thrills to come.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('684329975194', 'The Hunger Games', 
(SELECT ID from Publishers where PublisherName = 'Scholastic Press'),
'2008-10-14', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Young Adult'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6', '<bookdesc>
    <blurb>
        Winning means fame and fortune. Losing means certain death. The Hunger Games have begun. . . .
        In the ruins of a place once known as North America lies the nation of Panem, a shining Capitol surrounded by twelve outlying districts. The Capitol is harsh and cruel and keeps the districts in line by forcing them all to send one boy and one girl between the ages of twelve and eighteen to participate in the annual Hunger Games, a fight to the death on live TV.
        Sixteen-year-old Katniss Everdeen regards it as a death sentence when she steps forward to take her sister''s place in the Games. But Katniss has been close to dead before-and survival, for her, is second nature. Without really meaning to, she becomes a contender. But if she is to win, she will have to start making choices that weigh survival against humanity and life against love.
    </blurb>
    <awards>
        <award>
            Locus Award Nominee for Best Young Adult Book (2009) and for Illustrated and Art Book (2025) 
        </award>
        <award>
            Georgia Peach Book Award (2009) 
        </award>
        <award>
            Buxtehuder Bulle (2009)
        </award>
        <award>
            Golden Duck Award for Young Adult (Hal Clement Award) (2009)
        </award>
        <award>
            Books I Loved Best Yearly (BILBY) Awards for Older Readers (2012)
        </award>
        <award>
            West Australian Young Readers'' Book Award (WAYRBA) for Older Readers (2010)
        </award>
        <award>
            Red House Children''s Book Award for Older Readers &amp; Overall (2010)
        </award>
        <award>
            South Carolina Book Award for Junior and Young Adult Book (2011)
        </award>
        <award>
            Charlotte Award (2010)
        </award>
        <award>
            Colorado Blue Spruce Young Adult Book Award (2010)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('295765267472', 'Catching Fire', 
(SELECT ID from Publishers where PublisherName = 'Scholastic Press'),
'2009-09-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Young Adult'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6', '<bookdesc>
    <blurb>
        Against all odds, Katniss Everdeen has won the Hunger Games. She and fellow District 12 tribute Peeta Mellark are miraculously still alive. Katniss should be relieved, happy even. After all, she has returned to her family and her longtime friend, Gale. Yet nothing is the way Katniss wishes it to be. Gale holds her at an icy distance. Peeta has turned his back on her completely. And there are whispers of a rebellion against the Capitol—a rebellion that Katniss and Peeta may have helped create.
        Much to her shock, Katniss has fueled an unrest that she''s afraid she cannot stop. And what scares her even more is that she''s not entirely convinced she should try. As time draws near for Katniss and Peeta to visit the districts on the Capitol''s cruel Victory Tour, the stakes are higher than ever. If they can''t prove, without a shadow of a doubt, that they are lost in their love for each other, the consequences will be horrifying.
        In Catching Fire, the second novel of the Hunger Games trilogy, Suzanne Collins continues the story of Katniss Everdeen, testing her more than ever before . . . and surprising readers at every turn.
    </blurb>
    <awards>
        <award>
            Locus Award Nominee for Best Young Adult Book (2010)
        </award>
        <award>
            Golden Duck Award for Young Adult (Hal Clement Award) (2010)
        </award>
        <award>
            Soaring Eagle Book Award (2011)
        </award>
        <award>
            Children''s Choice Book Award for Teen Choice Book of the Year (2010)
        </award>
        <award>
            Indies Choice Book Award for Young Adult (2010)
        </award>
        <award>
            Teen Read Award Nominee for Best Read (2010)
        </award>
        <award>
            DABWAHA Romance Tournament for Best Young Adult (2010)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('1008747063973', 'Mockingjay', 
(SELECT ID from Publishers where PublisherName = 'Scholastic Press'),
'2010-08-24', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Young Adult'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6', '<bookdesc>
    <blurb>
        Katniss Everdeen, girl on fire, has survived, even though her home has been destroyed. Gale has escaped. Katniss''s family is safe. Peeta has been captured by the Capitol. District 13 really does exist. There are rebels. There are new leaders. A revolution is unfolding.
        It is by design that Katniss was rescued from the arena in the cruel and haunting Quarter Quell, and it is by design that she has long been part of the revolution without knowing it. District 13 has come out of the shadows and is plotting to overthrow the Capitol. Everyone, it seems, has had a hand in the carefully laid plans—except Katniss.
        The success of the rebellion hinges on Katniss''s willingness to be a pawn, to accept responsibility for countless lives, and to change the course of the future of Panem. To do this, she must put aside her feelings of anger and distrust. She must become the rebels'' Mockingjay—no matter what the personal cost.
    </blurb>
    <awards>
        <award>
            Locus Award Nominee for Best Young Adult Book (2011)
        </award>
        <award>
            Children''s Choice Book Award Nominee for Teen Choice Book of the Year (2011)
        </award>
        <award>
            Andre Norton Award Nominee (2010)
        </award>
        <award>
            DABWAHA Romance Tournament for Best Young Adult Romance (2011)
        </award>
        <award>
            Goodreads Choice Award for Favorite Book and for Young Adult Fantasy (2010)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('658137374877', 'Eragon', 
(SELECT ID from Publishers where PublisherName = 'Knopf Books'),
'2005-06-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Young Adult'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6', '<bookdesc>
    <blurb>
        When Eragon finds a polished blue stone in the forest, he thinks it is the lucky discovery of a poor farm boy; perhaps it will buy his family meat for the winter. But when the stone brings a dragon hatchling, Eragon soon realizes he has stumbled upon a legacy nearly as old as the Empire itself.
        Overnight his simple life is shattered, and he is thrust into a perilous new world of destiny, magic, and power. With only an ancient sword and the advice of an old storyteller for guidance, Eragon and the fledgling dragon must navigate the dangerous terrain and dark enemies of an Empire ruled by a king whose evil knows no bounds.
        Can Eragon take up the mantle of the legendary Dragon Riders? The fate of the Empire may rest in his hands.
    </blurb>
    <awards>
        <award>
            Book Sense Book of the Year Award for Children''s Literature (2004)
        </award>
        <award>
            Books I Loved Best Yearly (BILBY) Awards for Older Readers (2007)
        </award>
        <award>
            South Carolina Book Award for Young Adult Book (2006)
        </award>
        <award>
            Grand Canyon Reader Award for Teen Book (2006)
        </award>
        <award>
            Nene Award (2006)
        </award>
        <award>
            Colorado Blue Spruce Young Adult Book Award (2005)
        </award>
        <award>
            Pennsylvania Young Readers'' Choice Award for Grades 6-8 (2005)
        </award>
        <award>
            Rhode Island Teen Book Award (2005)
        </award>
        <award>
            Beehive Book Award for Young Adult Book (2005)
        </award>
        <award>
            Evergreen Teen Book Award (2006)
        </award>
        <award>
            Golden Archer Award for Middle/Junior High (2006)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('602432211917', 'Eldest', 
(SELECT ID from Publishers where PublisherName = 'Knopf Books'),
'2007-03-13', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Young Adult'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6', '<bookdesc>
    <blurb>
        Darkness falls…despair abounds…evil reigns…Eragon and his dragon, Saphira, have just saved the rebel state from destruction by the mighty forces of King Galbatorix, cruel ruler of the Empire. Now Eragon must travel to Ellesmera, land of the elves, for further training in the skills of the Dragon Rider. Ages 12+.
        Darkness falls…despair abounds…evil reigns…
        Eragon and his dragon, Saphira, have just saved the rebel state from destruction by the mighty forces of King Galbatorix, cruel ruler of the Empire. Now Eragon must travel to Ellesmera, land of the elves, for further training in the skills of the Dragon Rider: magic and swordsmanship. Soon he is on the journey of a lifetime, his eyes open to awe-inspring new places and people, his days filled with fresh adventure. But chaos and betrayal plague him at every turn, and nothing is what it seems. Before long, Eragon doesn''t know whom he can trust.
        Meanwhile, his cousin Roran must fight a new battle–one that might put Eragon in even graver danger.
        Will the king''s dark hand strangle all resistance? Eragon may not escape with even his life. . . .
    </blurb>
    <awards>
        <award>
            West Australian Young Readers'' Book Award (WAYRBA) for Older Readers (2006)
        </award>
        <award>
            Colorado Blue Spruce Young Adult Book Award (2007)
        </award>
        <award>
            Teen Buckeye Book Award (2007)
        </award>
        <award>
            Soaring Eagle Book Award (2006)
        </award>
        <award>
            The Quill Award for Young Adult/Teen (2006)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('389361461145', 'House of Leaves', 
(SELECT ID from Publishers where PublisherName = 'Random House'),
'2000-03-07', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Horror'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.54', '<bookdesc>
    <blurb>
        A young family moves into a small home on Ash Tree Lane where they discover something is terribly wrong: their house is bigger on the inside than it is on the outside.
        Of course, neither Pulitzer Prize-winning photojournalist Will Navidson nor his companion Karen Green was prepared to face the consequences of that impossibility, until the day their two little children wandered off and their voices eerily began to return another story—of creature darkness, of an ever-growing abyss behind a closet door, and of that unholy growl which soon enough would tear through their walls and consume all their dreams.
    </blurb>
    <awards>
        <award>
            Bram Stoker Award Nominee for Best First Novel (2000)
        </award>
        <award>
            Locus Award Nominee for Best First Novel (2001)
        </award>
        <award>
            New York Public Library Young Lions Fiction Award (2001)
        </award>
        <award>
            Guardian First Book Award Nominee (2000)
        </award>
        <award>
            James Tait Black Memorial Prize Nominee for Fiction (2000)
        </award>
        <award>
            International Horror Guild Award Nominee for Best First Novel (2000)
        </award>
        <award>
            Premio Ignotus Nominee for Mejor novela extranjera (Best Foreign Novel) (2014)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('1020681036880', 'Dracula', 
(SELECT ID from Publishers where PublisherName = 'Barnes & Noble'),
'2011-03-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Horror'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'823.087381', '<bookdesc>
    <blurb>
        This is a beautiful leatherbound edition of Bram Stoker''s Dracula, first published in 1897. Acting on behalf of his firm of solicitors, Jonathan Harker travels to the Carpathian Mountains to finalise the sale of England''s Carfax Abbey to Transylvanian noble Count Dracula. Little does he realise that, in doing so, he endangers all that he loves. For Dracula is one of the Un-Dead; a centuries-old vampire who sleeps by day and stalks by night, feasting on the blood of his helpless victims. Once on English soil, the count sets his sights on Jonathan''s circle of associates, among them his beloved wife Mina. To thwart Dracula''s evil designs, Jonathan and his friends will have to accept as truth the most preposterous superstitions concerning vampires and in the company of legendary vampire hunter Abraham Van Helsing, embark on an unholy adventure for which even their worst nightmares have not prepared them. First published in 1897, "Bram Stoker''s Dracula" established the ground rules for virtually all vampire fiction written in its wake. This exquisite collectible edition features an elegant bonded-leather binding, a satin-ribbon bookmark, decorative stained edging, and decorative marbled endpapers. It''s the perfect gift for book-lovers and an attractive addition to any home library.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('611308683901', 'The Picture of Dorian Gray', 
(SELECT ID from Publishers where PublisherName = 'Random House'),
'2004-06-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Horror'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'823.8', '<bookdesc>
    <blurb>
        Dorian Gray, a handsome young man, receives a beautiful painting of himself from his good friend Basil Hallward. In the same moment, a new acquaintance, Lord Henry, introduces Dorian to the ideals of youthfulness and hedonism, of which Gray becomes immediately obsessed. Meanwhile, the painting in Dorian''s possession serves as a constant reminder of his passing beauty and youth, driving his obsession.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('370140854718', 'The Tell-Tale Heart', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2015-02-26', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Horror'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.3', '<bookdesc>
    <blurb>
        Just one line from the short story says it all: "Presently I heard a slight groan, and I knew it was a groan of mortal terror .. the low stifled sound that arises from the bottom of the soul." A man confronts himself and an unknown listener with his desire to murder an old man. Is it his father? Is the man mad? Is he in jail or an institution? A psychological thriller with many more questions than answers.
        Librarian''s note: this entry is for the story, "The Tell-Tale Heart." Collections of short stories and other writings by the author can be found elsewhere on Goodreads.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('240031867881', 'The Cask of Amontillado', 
(SELECT ID from Publishers where PublisherName = 'BookSurge'),
'2009-04-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Horror'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.3', '<bookdesc>
    <blurb>
        "The Cask of Amontillado" (sometimes spelled "The Casque ..") is a short story written by Edgar Allan Poe and first published in the November 1846 issue of "Godey''s Lady''s Book."
        It is set in a nameless Italian city in an unspecified year (possibly during the eighteenth century) and concerns the revenge taken by the narrator on a friend who he claims has insulted him. Like several of Poe''s stories, and in keeping with the 19th-century fascination with the subject, the narrative revolves around the possibility of a person being buried alive or enclosed in a small space with not possibility of escape (aka immurement).
        Librarian''s note: this entry relates to the story "The Cask of Amontillado." Collections of short stories by the author can be found elsewhere on Goodreads.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('208913198036', 'The Prince', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2003-02-04', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Philosophy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'320.1', '<bookdesc>
    <blurb>
        Machiavelli needs to be looked at as he really was. Hence: Can Machiavelli, who makes the following observations, be Machiavellian as we understand the disparaging term?
        1. So it is that to know the nature of a people, one need be a Prince; to know the nature of a Prince, one need to be of the people.
        2. If a Prince is not given to vices that make him hated, it is unsusal for his subjects to show their affection for him.
        3. Opportunity made Moses, Cyrus, Romulus, Theseus, and others; their virtue domi-nated the opportunity, making their homelands noble and happy. Armed prophets win; the disarmed lose.
        4. Without faith and religion, man achieves power but not glory.
        5. Prominent citizens want to command and oppress; the populace only wants to be free of oppression.
        6. A Prince needs a friendly populace; otherwise in diversity there is no hope.
        7. A Prince, who rules as a man of valor, avoids disasters,
        8. Nations based on mercenary forces will never be solid or secure.
        9. Mercenaries are dangerous because of their cowardice
        10. There are two ways to fight: one with laws, the other with force. The first is rightly man’s way; the second, the way of beasts.
    </blurb>
    <awards>
        <award>
            National Book Award Finalist for Translation (1978)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
    <Italian>
        Il principe
    </Italian>
</alternativetitles>'),

('633438264582', 'The Republic', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2003-02-25', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Philosophy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'321.07', '<bookdesc>
    <blurb>
        Presented in the form of a dialogue between Socrates and three different interlocutors, this classic text is an enquiry into the notion of a perfect community and the ideal individual within it. During the conversation, other questions are raised: what is goodness?; what is reality?; and what is knowledge? The Republic also addresses the purpose of education and the role of both women and men as guardians of the people. With remarkable lucidity and deft use of allegory, Plato arrives at a depiction of a state bound by harmony and ruled by philosopher kings.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
    <Greek>
        Πολιτεία
    </Greek>
</alternativetitles>'),

('402050855286', 'Leviathan', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'1981-11-19', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Philosophy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'320.1', '<bookdesc>
    <blurb>
        ''The life of man, solitary, poore, nasty, brutish, and short''
        Written during the chaos of the English Civil War, Thomas Hobbes'' Leviathan asks how, in a world of violence and horror, can we stop ourselves from descending into anarchy? Hobbes'' case for a ''common-wealth'' under a powerful sovereign - or ''Leviathan'' - to enforce security and the rule of law, shocked his contemporaries, and his book was publicly burnt for sedition the moment it was published. But his penetrating work of political philosophy - now fully revised and with a new introduction for this edition - opened up questions about the nature of statecraft and society that influenced governments across the world.
    </blurb>
    <awards>
        <award>
            British Academy Medal (2013)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
    <English>
            Leviathan, or The Matter, Forme and Power of a Common Wealth Ecclesiasticall and Civil
    </English>
</alternativetitles>'),

('370934540842', 'Beyond Good and Evil', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2003-04-29', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Philosophy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'193', '<bookdesc>
    <blurb>
        Friedrich Nietzsche''s Beyond Good and Evil is translated from the German by R.J. Hollingdale with an introduction by Michael Tanner in Penguin Classics.
        Beyond Good and Evil confirmed Nietzsche''s position as the towering European philosopher of his age. The work dramatically rejects the tradition of Western thought with its notions of truth and God, good and evil. Nietzsche demonstrates that the Christian world is steeped in a false piety and infected with a ''slave morality''. With wit and energy, he turns from this critique to a philosophy that celebrates the present and demands that the individual imposes their own ''will to power'' upon the world.
        This edition includes a commentary on the text by the translator and Michael Tanner''s introduction, which explains some of the more abstract passages in Beyond Good and Evil.
        Frederich Nietzsche (1844-1900) became the chair of classical philology at Basel University at the age of 24 until his bad health forced him to retire in 1879. He divorced himself from society until his final collapse in 1899 when he became insane. A powerfully original thinker, Nietzsche''s influence on subsequent writers, such as George Bernard Shaw, D.H. Lawrence, Thomas Mann and Jean-Paul Sartre, was considerable.
        If you enjoyed Beyond Good and Evil you might like Nietzsche''s Thus Spoke Zarathustra, also available in Penguin Classics.
        "One of the greatest books of a very great thinker." —Michael Tanner
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
    <German>
        Jenseits von Gut und Böse. Vorspiel einer Philosophie der Zukunft
    </German>
</alternativetitles>'),

('345922611896', 'Critique of Pure Reason', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'1999-02-28', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Philosophy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'121', '<bookdesc>
    <blurb>
        ''The purpose of this critique of pure speculative reason consists in the attempt to change the old procedure of metaphysics and to bring about a complete revolution''
        Kant''s Critique of Pure Reason (1781) is the central text of modern philosophy. It presents a profound and challenging investigation into the nature of human reason, its knowledge and its illusions. Reason, Kant argues, is the seat of certain concepts that precede experience and make it possible, but we are not therefore entitled to draw conclusions about the natural world from these concepts. The Critique brings together the two opposing schools of philosophy: rationalism, which grounds all our knowledge in reason, and empiricism, which traces all our knowledge to experience. Kant''s transcendental idealism indicates a third way that goes far beyond these alternatives.
        Marcus Weigelt''s lucid re-working of Max Müller''s classic translation makes the Critique accessible to a new generation of readers. His informative introduction places the work in context and elucidates Kant''s main arguments. This edition also contains a bibliography and explanatory notes.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
    <German>
        Kritik der reinen Vernunft
    </German>
</alternativetitles>'),

('916922412061', 'A Midsummer Nights Dream', 
(SELECT ID from Publishers where PublisherName = 'Simon & Schuster'),
'2016-07-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Classics'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'822.33', '<bookdesc>
    <blurb>
        In A Midsummer Night’s Dream, Shakespeare stages the workings of love. Theseus and Hippolyta, about to marry, are figures from mythology. In the woods outside Theseus’s Athens, two young men and two young women sort themselves out into couples—but not before they form first one love triangle, and then another.
        Also in the woods, the king and queen of fairyland, Oberon and Titania, battle over custody of an orphan boy; Oberon uses magic to make Titania fall in love with a weaver named Bottom, whose head is temporarily transformed into that of a donkey by a hobgoblin or “puck,” Robin Goodfellow. Finally, Bottom and his companions ineptly stage the tragedy of “Pyramus and Thisbe.”
        This edition includes:
        Freshly edited text based on the best early printed version of the play
        Full explanatory notes conveniently placed on pages facing the text of the play
        Scene-by-scene plot summaries
        A key to the play’s famous lines and phrases
        An introduction to reading Shakespeare’s language
        An essay by a leading Shakespeare scholar providing a modern perspective on the play
        Fresh images from the Folger Shakespeare Library’s vast holdings of rare books
        An annotated guide to further reading
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('1064950153993', 'Hamlet', 
(SELECT ID from Publishers where PublisherName = 'Cambridge University Press'),
'2005-12-19', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Classics'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'822.33', '<bookdesc>
    <blurb>
        Hamlet is the story of the Prince of Denmark who learns of the death of his father at the hands of his uncle, Claudius. Claudius murders Hamlet''s father, his own brother, to take the throne of Denmark and to marry Hamlet''s widowed mother. Hamlet is sunk into a state of great despair as a result of discovering the murder of his father and the infidelity of his mother. Hamlet is torn between his great sadness and his desire for the revenge of his father''s murder.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('372760222061', 'The Iliad', 
(SELECT ID from Publishers where PublisherName = 'W. W. Norton & Company'),
'2023-09-26', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Classics'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'883.01', '<bookdesc>
    <blurb>
        The greatest literary landmark of antiquity masterfully rendered by the most celebrated translator of our time.
        When Emily Wilson’s translation of The Odyssey appeared in 2017―revealing the ancient poem in a contemporary idiom that was “fresh, unpretentious and lean” (Madeline Miller, Washington Post)―critics lauded it as “a revelation” (Susan Chira, New York Times) and “a cultural landmark” (Charlotte Higgins, Guardian) that would forever change how Homer is read in English. Now Wilson has returned with an equally revelatory translation of Homer’s other great epic―the most revered war poem of all time.
        The Iliad roars with the clamor of arms, the bellowing boasts of victors, the fury and grief of loss, and the anguished cries of dying men. It sings, too, of the sublime magnitude of the world―the fierce beauty of nature and the gods’ grand schemes beyond the ken of mortals. In Wilson’s hands, this thrilling, magical, and often horrifying tale now gallops at a pace befitting its legendary battle scenes, in crisp but resonant language that evokes the poem’s deep pathos and reveals palpably real, even “complicated,” characters―both human and divine.
        The culmination of a decade of intense engagement with antiquity’s most surpassingly beautiful and emotionally complex poetry, Wilson’s Iliad now gives us a complete Homer for our generation.
    </blurb>
    <awards>
        <award>
            Audie Award for Literary Fiction &amp; Classics (2024)
        </award>
        <award>
            Premi Crítica Serra d''Or de Traducció (1998)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('789676336797', 'The Odyssey', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2006-10-31', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Classics'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'883.01', '<bookdesc>
    <blurb>
        Sing to me of the man, Muse, the man of twists and turns
        driven time and again off course, once he had plundered
        the hallowed heights of Troy.
        So begins Robert Fagles'' magnificent translation of the Odyssey.
        If the Iliad is the world''s greatest war epic, then the Odyssey is literature''s grandest evocation of everyman''s journey though life. Odysseus'' reliance on his wit and wiliness for survival in his encounters with divine and natural forces, during his ten-year voyage home to Ithaca after the Trojan War, is at once a timeless human story and an individual test of moral endurance.
        In the myths and legends that are retold here, Fagles has captured the energy and poetry of Homer''s original in a bold, contemporary idiom, and given us an Odyssey to read aloud, to savor, and to treasure for its sheer lyrical mastery.
        Renowned classicist Bernard Knox''s superb Introduction and textual commentary provide new insights and background information for the general reader and scholar alike, intensifying the strength of Fagles'' translation.
        This is an Odyssey to delight both the classicist and the public at large, and to captivate a new generation of Homer''s students.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('1071580139839', 'Antigone', 
(SELECT ID from Publishers where PublisherName = 'Prestwick House'),
'2005-11-30', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Classics'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'882.01', '<bookdesc>
    <blurb>
        The curse placed on Oedipus lingers and haunts a younger generation in this new and brilliant translation of Sophocles'' classic drama. The daughter of Oedipus and Jocasta, Antigone is an unconventional heroine who pits her beliefs against the King of Thebes in a bloody test of wills that leaves few unharmed. Emotions fly as she challenges the king for the right to bury her own brother. Determined but doomed, Antigone shows her inner strength throughout the play.
        Antigone raises issues of law and morality that are just as relevant today as they were more than two thousand years ago. Whether this is your first reading or your twentieth, Antigone will move you as few pieces of literature can.
        To make this quintessential Greek drama more accessible to the modern reader, this Prestwick House Literary Touchstone Edition includes a glossary of difficult terms, a list of vocabulary words, and convenient sidebar notes. By providing these, it is our intention that readers will more fully enjoy the beauty, wisdom, and intent of the play.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('945875270706', 'The Silmarillion', 
(SELECT ID from Publishers where PublisherName = 'Harper Collins'),
'2011-02-03', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Fantasy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'823.087661', '<bookdesc>
    <blurb>
        The forerunner to The Lord of the Rings, The Silmarillion fills in the background which lies behind the more popular work, and gives the earlier history of Middle-earth, introducing some of the key characters.
        The Silmarillion is an account of the Elder Days, of the First Age of Tolkien’s world. It is the ancient drama to which the characters in The Lord of the Rings look back, and in whose events some of them such as Elrond and Galadriel took part. The tales of The Silmarillion are set in an age when Morgoth, the first Dark Lord, dwelt in Middle-Earth, and the High Elves made war upon him for the recovery of the Silmarils, the jewels containing the pure light of Valinor.
        Included in the book are several shorter works. The Ainulindale is a myth of the Creation and in the Valaquenta the nature and powers of each of the gods is described. The Akallabeth recounts the downfall of the great island kingdom of Númenor at the end of the Second Age and Of the Rings of Power tells of the great events at the end of the Third Age, as narrated in The Lord of the Rings.
    </blurb>
    <awards>
        <award>
            Locus Award for Best Fantasy Novel (1978)
        </award>
        <award>
            Ditmar Award for Best International Long Fiction (1978)
        </award>
        <award>
            Gandalf Award (1978)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('776647164311', 'The Fellowship of the Ring', 
(SELECT ID from Publishers where PublisherName = 'William Morrow'),
'2022-06-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Fantasy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'823.912', '<bookdesc>
    <blurb>
        Sauron, the Dark Lord, has gathered to him all the Rings of Power – the means by which he intends to rule Middle-earth. All he lacks in his plans for dominion is the One Ring – the ring that rules them all – which has fallen into the hands of the hobbit, Bilbo Baggins.
        In a sleepy village in the Shire, young Frodo Baggins finds himself faced with an immense task, as his elderly cousin Bilbo entrusts the Ring to his care. Frodo must leave his home and make a perilous journey across Middle-earth to the Cracks of Doom, there to destroy the Ring and foil the Dark Lord in his evil purpose.
    </blurb>
    <awards>
        <award>
            British Book Award Nominee for Audiobook: Fiction (2022)
        </award>
        <award>
            Publieksprijs voor het Nederlandse Boek Nominee (2002)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('994157564023', 'A Wizard of Earthsea', 
(SELECT ID from Publishers where PublisherName = 'Harper Collins'),
'2012-09-11', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Fantasy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.087661', '<bookdesc>
    <blurb>
        Originally published in 1968, Ursula K. Le Guin’s A Wizard of Earthsea marks the first of the six now beloved Earthsea titles. Ged was the greatest sorcerer in Earthsea, but in his youth he was the reckless Sparrowhawk. In his hunger for power and knowledge, he tampered with long-held secrets and loosed a terrible shadow upon the world. This is the tumultuous tale of his testing, how he mastered the mighty words of power, tamed an ancient dragon, and crossed death''s threshold to restore the balance.
    </blurb>
    <awards>
        <award>
            Lewis Carroll Shelf Award (1979)
        </award>
        <award>
            Boston Globe-Horn Book Award for Fiction (1969)
        </award>
        <award>
            Złota Sepulka for Książka autora zagranicznego (1984)
        </award>
        <award>
            Margaret A. Edwards Award (2004)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('504792120075', 'Words of Radiance', 
(SELECT ID from Publishers where PublisherName = 'Tor Books'),
'2014-03-04', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Fantasy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6', '<bookdesc>
    <blurb>
        Expected by his enemies to die the miserable death of a military slave, Kaladin survived to be given command of the royal bodyguards, a controversial first for a low-status "darkeyes." Now he must protect the king and Dalinar from every common peril as well as the distinctly uncommon threat of the Assassin, all while secretly struggling to master remarkable new powers that are somehow linked to his honorspren, Syl.
        The Assassin, Szeth, is active again, murdering rulers all over the world of Roshar, using his baffling powers to thwart every bodyguard and elude all pursuers. Among his prime targets is Highprince Dalinar, widely considered the power behind the Alethi throne. His leading role in the war would seem reason enough, but the Assassin''s master has much deeper motives.
        Brilliant but troubled Shallan strives along a parallel path. Despite being broken in ways she refuses to acknowledge, she bears a terrible burden: to somehow prevent the return of the legendary Voidbringers and the civilization-ending Desolation that will follow. The secrets she needs can be found at the Shattered Plains, but just arriving there proves more difficult than she could have imagined.
        Meanwhile, at the heart of the Shattered Plains, the Parshendi are making an epochal decision. Hard pressed by years of Alethi attacks, their numbers ever shrinking, they are convinced by their war leader, Eshonai, to risk everything on a desperate gamble with the very supernatural forces they once fled. The possible consequences for Parshendi and humans alike, indeed, for Roshar itself, are as dangerous as they are incalculable.
    </blurb>
    <awards>
        <award>
            Locus Award Nominee for Best Fantasy Novel (2015)
        </award>
        <award>
            David Gemmell Legend Award for Best Fantasy Novel (2015)
        </award>
        <award>
            David Gemmell Ravenheart Award for Best Fantasy Cover Art (2015)
        </award>
        <award>
            Goodreads Choice Award Nominee for Fantasy (2014)
        </award>
        <award>
            Reddit r/fantasy Stabby Award for Best Novel (2014)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('1066363464544', 'The Way of Kings', 
(SELECT ID from Publishers where PublisherName = 'Tor Books'),
'2010-08-31', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Fantasy'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6', '<bookdesc>
    <blurb>
        Roshar is a world of stone and storms. Uncanny tempests of incredible power sweep across the rocky terrain so frequently that they have shaped ecology and civilization alike. Animals hide in shells, trees pull in branches, and grass retracts into the soilless ground. Cities are built only where the topography offers shelter.
        It has been centuries since the fall of the ten consecrated orders known as the Knights Radiant, but their Shardblades and Shardplate remain: mystical swords and suits of armor that transform ordinary men into near-invincible warriors. Men trade kingdoms for Shardblades. Wars were fought for them, and won by them.
        One such war rages on a ruined landscape called the Shattered Plains. There, Kaladin, who traded his medical apprenticeship for a spear to protect his little brother, has been reduced to slavery. In a war that makes no sense, where ten armies fight separately against a single foe, he struggles to save his men and to fathom the leaders who consider them expendable.
        Brightlord Dalinar Kholin commands one of those other armies. Like his brother, the late king, he is fascinated by an ancient text called The Way of Kings. Troubled by over-powering visions of ancient times and the Knights Radiant, he has begun to doubt his own sanity.
        Across the ocean, an untried young woman named Shallan seeks to train under an eminent scholar and notorious heretic, Dalinar''s niece, Jasnah. Though she genuinely loves learning, Shallan''s motives are less than pure. As she plans a daring theft, her research for Jasnah hints at secrets of the Knights Radiant and the true cause of the war.
        The result of over ten years of planning, writing, and world-building, The Way of Kings is but the opening movement of the Stormlight Archive, a bold masterpiece in the making.
        Speak again the ancient oaths:
        Life before death.
        Strength before weakness.
        Journey before Destination.
        and return to men the Shards they once bore.
        The Knights Radiant must stand again.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('411974140204', 'Shakespeares Sonnets', 
(SELECT ID from Publishers where PublisherName = 'Bloomsbury Arden Shakespeare'),
'1997-08-21', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Poetry'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'821.3', '<bookdesc>
    <blurb>
        The Arden Shakespeare has long been acclaimed as the established scholarly edition of Shakespeare''s work. Now being totally reedited for the third time, Arden editions offer the very best in contemporary scholarship. Each volume provides a clear and authoritative text, edited to the highest standards; detailed textual notes and commentary on the same page of the text; full contextual, illustrated introduction, including an in-depth survey of critical and performance approaches to the play; and selected bibliography.
    </blurb>
    <awards>
        <award>
            Filter vertaalprijs Nominee (2021)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('656593744147', 'Paradise Lost', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'2003-04-29', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Poetry'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'821.4', '<bookdesc>
    <blurb>
        John Milton''s Paradise Lost is one of the greatest epic poems in the English language. It tells the story of the Fall of Man, a tale of immense drama and excitement, of rebellion and treachery, of innocence pitted against corruption, in which God and Satan fight a bitter battle for control of mankind''s destiny. The struggle rages across three worlds - heaven, hell, and earth - as Satan and his band of rebel angels plot their revenge against God. At the center of the conflict are Adam and Eve, who are motivated by all too human temptations but whose ultimate downfall is unyielding love.
        Marked by Milton''s characteristic erudition, Paradise Lost is a work epic both in scale and, notoriously, in ambition. For nearly 350 years, it has held generation upon generation of audiences in rapt attention, and its profound influence can be seen in almost every corner of Western culture.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('586090281027', 'Aniara', 
(SELECT ID from Publishers where PublisherName = 'Story Line Press'),
'1998-09-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Poetry'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'839.71', '<bookdesc>
    <blurb>
        Eight thousand people aboard the space ship Aniara are diverted off course and plunge headlong in to the "void" where they must create a world in which they will be irretrievably trapped.
    </blurb>
    <awards>
        <award>
            American-Scandinavian Foundation Translation Prize (1986)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
    <Swedish>
            Aniara: En revy om människan i tid och rum
    </Swedish>
</alternativetitles>'),

('323361697799', 'Sentimento do Mundo', 
(SELECT ID from Publishers where PublisherName = 'Companhia das Letras'),
'2012-01-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'Portuguese'), 
(SELECT ID from BookGenres where Genre = 'Poetry'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'869.915', '<bookdesc>
    <blurb>
        Publicado pela primeira vez em 1940, ''Sentimento do Mundo'' traz o frescor e o impacto do ''vento revolucionário'' que sopra da obra de Carlos Drummond de Andrade (1902-1987), o mais estudado e lido poeta brasileiro. Neste livro está contido os poemas:Poema de Sete Faces, No meio do caminho, Quadrilha; e oemas menos conhecidos, mas igualmente antológicos como Poema do Jornal ou Poema da Purificação.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('644251809883', 'The Divine Comedy - Volume 1: Hell', 
(SELECT ID from Publishers where PublisherName = 'Penguin Classics'),
'1999-07-12', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Poetry'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'851.1', '<bookdesc>
    <blurb>
        The Inferno is the first part of The Divine Comedy, Dante''s epic poem describing man''s progress from hell to paradise. In it, the author is lost in a dark wood, threatened by wild beasts and unable to find the right path to salvation. Notable for its nine circles of hell, the poem vividly illustrates the poetic justice of punishments faced by earthly sinners. The Inferno is perhaps the most popular of the three books of The Divine Comedy, which is widely considered the preeminent work in Italian literature.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('774529770221', 'Do Androids Dream of Electric Sheep?', 
(SELECT ID from Publishers where PublisherName = 'Ballantine Books'),
'2008-02-26', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science Fiction'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.0876220', '<bookdesc>
    <blurb>
        By 2021, the World War has killed millions, driving entire species into extinction and sending mankind off-planet. Those who remain covet any living creature, and for people who can''t afford one, companies build incredibly realistic simulacra: horses, birds, cats, sheep. They''ve even built humans. Immigrants to Mars receive androids so sophisticated they are indistinguishable from true men or women. Fearful of the havoc these artificial humans could wreak, the government bans them from Earth. Driven into hiding, unauthorized androids live among human beings, undetected. Rick Deckard, an officially sanctioned bounty hunter, is commissioned to find rogue androids and "retire" them. But when cornered, androids fight back - with lethal force. The Inspiration for the Film BLADE RUNNER. Originally published in 1968, Do Androids Dream of Electric Sheep? remains a masterpiece ahead of its time, a prescient rendering of a dark future.
    </blurb>
    <awards>
        <award>
            Nebula Award Nominee for Best Novel (1968)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('184943603669', 'I, Robot', 
(SELECT ID from Publishers where PublisherName = 'Bantam Books'),
'2004-06-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science Fiction'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.08762', '<bookdesc>
    <blurb>
        Isaac Asimov''s I, Robot launches readers on an adventure into a not-so-distant future where man and machine , struggle to redefinelife, love, and consciousness—and where the stakes are nothing less than survival. Filled with unforgettable characters, mind-bending speculation, and nonstop action, I, Robot is a powerful reading experience from one of the master storytellers of our time.
        I, ROBOT
        They mustn''t harm a human being, they must obey human orders, and they must protect their own existence...but only so long as that doesn''t violate rules one and two. With these Three Laws of Robotics, humanity embarked on perhaps its greatest adventure: the invention of the first positronic man. It was a bold new era of evolution that would open up enormous possibilities—and unforeseen risks. For the scientists who invented the earliest robots weren''t content that their creations should '' remain programmed helpers, companions, and semisentient worker-machines. And soon the robots themselves; aware of their own intelligence, power, and humanity, aren''t either.
        As humans and robots struggle to survive together—and sometimes against each other—on earth and in space, the future of both hangs in the balance. Human men and women confront robots gone mad, telepathic robots, robot politicians, and vast robotic intelligences that may already secretly control the world. And both are asking the same questions: What is human? And is humanity obsolete?
        In l, Robot Isaac Asimov changes forever our perception of robots, and human beings and updates the timeless myth of man''s dream to play god. with all its rewards—and terrors.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('828075047644', 'Dune', 
(SELECT ID from Publishers where PublisherName = 'Ace'),
'2019-10-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science Fiction'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.087625', '<bookdesc>
    <blurb>
        Set on the desert planet Arrakis, Dune is the story of the boy Paul Atreides, heir to a noble family tasked with ruling an inhospitable world where the only thing of value is the “spice” melange, a drug capable of extending life and enhancing consciousness. Coveted across the known universe, melange is a prize worth killing for...
        When House Atreides is betrayed, the destruction of Paul’s family will set the boy on a journey toward a destiny greater than he could ever have imagined. And as he evolves into the mysterious man known as Muad’Dib, he will bring to fruition humankind’s most ancient and unattainable dream.
    </blurb>
    <awards>
        <award>
            Hugo Award for Best Novel (1966)
        </award>
        <award>
            Nebula Award for Best Novel (1965)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('239259338629', 'The Left Hand of Darkness', 
(SELECT ID from Publishers where PublisherName = 'Ace'),
'2000-07-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science Fiction'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.54', '<bookdesc>
    <blurb>
        A groundbreaking work of science fiction, The Left Hand of Darkness tells the story of a lone human emissary to Winter, an alien world whose inhabitants spend most of their time without a gender. His goal is to facilitate Winter''s inclusion in a growing intergalactic civilization. But to do so he must bridge the gulf between his own views and those of the completely dissimilar culture that he encounters.
        Embracing the aspects of psychology, society, and human emotion on an alien world, The Left Hand of Darkness stands as a landmark achievement in the annals of intellectual science fiction.
    </blurb>
    <awards>
        <award>
            Hugo Award for Best Novel (1970)
        </award>
        <award>
            Nebula Award for Best Novel (1969)
        </award>
        <award>
            James Tiptree Jr. Award for Retrospective (1995)
        </award>
        <award>
            Margaret A. Edwards Award (2004)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('606447069939', 'Blindsight', 
(SELECT ID from Publishers where PublisherName = 'Tor Books'),
'2006-10-03', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Science Fiction'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'813.6', '<bookdesc>
    <blurb>
        Two months since the stars fell...
        Two months since sixty-five thousand alien objects clenched around the Earth like a luminous fist, screaming to the heavens as the atmosphere burned them to ash. Two months since that moment of brief, bright surveillance by agents unknown.
        Two months of silence while a world holds its breath.
        Now some half-derelict space probe, sparking fitfully past Neptune’s orbit, hears a whisper from the edge of the solar system: a faint signal sweeping the cosmos like a lighthouse beam. Whatever’s out there isn’t talking to us. It’s talking to some distant star, perhaps. Or perhaps to something closer, something en route.
        So who do you send to force introductions on an intelligence with motives unknown, maybe unknowable? Who do you send to meet the alien when the alien doesn’t want to meet?
        You send a linguist with multiple personalities, her brain surgically partitioned into separate, sentient processing cores. You send a biologist so radically interfaced with machinery that he sees X-rays and tastes ultrasound, so compromised by grafts and splices he no longer feels his own flesh. You send a pacifist warrior in the faint hope she won’t be needed, and a fainter hope she’ll do any good if she is needed. You send a monster to command them all, an extinct hominid predator once called “vampire,” recalled from the grave with the voodoo of recombinant genetics and the blood of sociopaths. And you send a synthesist – an informational topologist with half his mind gone – as an interface between here and there, a conduit through which the Dead Center might hope to understand the Bleeding Edge.
        You send them all to the edge of interstellar space, praying you can trust such freaks and retrofits with the fate of a world. You fear they may be more alien than the thing they’ve been sent to find.
        But you’d give anything for that to be true, if you only knew what was waiting for them…
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('471381922983', 'Alan Turing: The Enigma', 
(SELECT ID from Publishers where PublisherName = 'Walker Books'),
'2000-03-01', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Biographies'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'510.92', '<bookdesc>
    <blurb>
        Alan Turing (1912-54) was a British mathematician who made history. His breaking of the German U-boat Enigma cipher in World War II ensured Allied-American control of the Atlantic. But Turing''s vision went far beyond the desperate wartime struggle. Already in the 1930s he had defined the concept of the universal machine, which underpins the computer revolution. In 1945 he was a pioneer of electronic computer design. But Turing''s true goal was the scientific understanding of the mind, brought out in the drama and wit of the famous "Turing test" for machine intelligence and in his prophecy for the twenty-first century.
        Drawn in to the cockpit of world events and the forefront of technological innovation, Alan Turing was also an innocent and unpretentious gay man trying to live in a society that criminalized him. In 1952 he revealed his homosexuality and was forced to participate in a humiliating treatment program, and was ever after regarded as a security risk. His suicide in 1954 remains one of the many enigmas in an astonishing life story.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('1014704193469', 'J.R.R. Tolkien: A Biography', 
(SELECT ID from Publishers where PublisherName = 'William Morrow'),
'2000-06-06', 'Paperback',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Biographies'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'828.912', '<bookdesc>
    <blurb>
        The authorized biography of the creator of Middle-earth. In the decades since his death in September 1973, millions have read THE HOBBIT, THE LORD OF THE RINGS, and THE SILMARILLION and become fascinated about the very private man behind the books. Born in South Africa in January 1892, John Ronald Reuel Tolkien was orphaned in childhood and brought up in near-poverty. He served in the first World War, surviving the Battle of the Somme, where he lost many of the closest friends he''d ever had. After the war he returned to the academic life, achieving high repute as a scholar and university teacher, eventually becoming Merton Professor of English at Oxford where he was a close friend of C.S. Lewis and the other writers known as The Inklings.
        Then suddenly his life changed dramatically. One day while grading essay papers he found himself writing ''In a hole in the ground there lived a hobbit'' -- and worldwide renown awaited him.
        Humphrey Carpenter was given unrestricted access to all Tolkien''s papers, and interviewed his friends and family. From these sources he follows the long and painful process of creation that produced THE LORD OF THE RINGS and THE SILMARILLION and offers a wealth of information about the life and work of the twentieth century''s most cherished author.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('1023486141416', 'The Secret Life of Houdini: The Making of Americas First Superhero', 
(SELECT ID from Publishers where PublisherName = 'Atria'),
'2006-10-31', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Biographies'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'793.8092', '<bookdesc>
    <blurb>
        Draws on newly uncovered archives and the co-author''s expertise in magic to reveal Houdini''s secret work as a spy for the United States and England, his post-war efforts to expose the fraudulent activities of spiritualist mediums, and the plot organized by Arthur Conan Doyle to have him murdered. 125,000 first printing.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('352402167332', 'Frida: A Biography of Frida Kahlo', 
(SELECT ID from Publishers where PublisherName = 'Harper Collins'),
'2002-10-01', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Biographies'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'759.972', '<bookdesc>
    <blurb>
        Hailed by readers and critics across the country, this engrossing biography of Mexican painter Frida Kahlo reveals a woman of extreme magnetism and originality, an artist whose sensual vibrancy came straight from her own experiences: her childhood near Mexico City during the Mexican Revolution; a devastating accident at age eighteen that left her crippled and unable to bear children; her tempestuous marriage to muralist Diego Rivera and intermittent love affairs with men as diverse as Isamu Noguchi and Leon Trotsky; her association with the Communist Party; her absorption in Mexican folklore and culture; and her dramatic love of spectacle.
        Here is the tumultuous life of an extraordinary twentieth-century woman -- with illustrations as rich and haunting as her legend.
    </blurb>
    <awards>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>'),

('157809483843', 'Einstein: His Life and Universe', 
(SELECT ID from Publishers where PublisherName = 'Simon & Schuster'),
'2007-04-10', 'Hardcover',
(SELECT ID from Languages where BookLanguage = 'English'), 
(SELECT ID from BookGenres where Genre = 'Biographies'), 
(SELECT ID from AvailabilityStatuses where AvailStatus = 'Available'), 
'530.092', '<bookdesc>
    <blurb>
        Einstein was a rebel and nonconformist from boyhood days, and these character traits drove both his life and his science. In this narrative, Walter Isaacson explains how his mind worked and the mysteries of the universe that he discovered.
    </blurb>
    <awards>
        <award>
            Audie Award for Biography/Memoir (2008)
        </award>
        <award>
            The Quill Award for Biography/memoir (2007)
        </award>
    </awards>
</bookdesc>',
'<alternativetitles>
</alternativetitles>')
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


INSERT INTO RentRecords(RentedBy, RentedBook, DateOfRental, 
                        DueDate, AuthorizedBy, RentStatus)
VALUES
((SELECT ID FROM Members WHERE FirstName = 'Lloyd' AND LastName = 'Desmond'),
(SELECT BookBarcode FROM Books WHERE Title = 'Eragon'),
(DATEADD(day, -43, CONVERT(DATE, GETDATE()))),
(DATEADD(day, -36, CONVERT(DATE, GETDATE()))),
(SELECT IDNumber FROM Staff WHERE FirstName = 'Emille' AND LastName = 'Seraphine'),
(SELECT ID FROM RentalStatuses WHERE RentStatus = 'Returned')
),

((SELECT ID FROM Members WHERE FirstName = 'Diana' AND LastName = 'Florence'),
(SELECT BookBarcode FROM Books WHERE Title = 'The Left Hand of Darkness'),
(DATEADD(day, -41, CONVERT(DATE, GETDATE()))),
(DATEADD(day, -34, CONVERT(DATE, GETDATE()))),
(SELECT IDNumber FROM Staff WHERE FirstName = 'Jamil' AND LastName = 'Zaman'),
(SELECT ID FROM RentalStatuses WHERE RentStatus = 'Returned')
),

((SELECT ID FROM Members WHERE FirstName = 'Aisha' AND LastName = 'Jenkins'),
(SELECT BookBarcode FROM Books WHERE Title = 'The Origin of Species'),
(DATEADD(day, -32, CONVERT(DATE, GETDATE()))),
(DATEADD(day, -2, CONVERT(DATE, GETDATE()))),
(SELECT IDNumber FROM Staff WHERE FirstName = 'Louise' AND LastName = 'Benoit'),
(SELECT ID FROM RentalStatuses WHERE RentStatus = 'Returned')
),

((SELECT ID FROM Members WHERE FirstName = 'Lloyd' AND LastName = 'Desmond'),
(SELECT BookBarcode FROM Books WHERE Title = 'Eldest'),
(DATEADD(day, -30, CONVERT(DATE, GETDATE()))),
(DATEADD(day, -23, CONVERT(DATE, GETDATE()))),
(SELECT IDNumber FROM Staff WHERE FirstName = 'Jamil' AND LastName = 'Zaman'),
(SELECT ID FROM RentalStatuses WHERE RentStatus = 'Returned')
),

((SELECT ID FROM Members WHERE FirstName = 'Filipa' AND LastName = 'Sveda'),
(SELECT BookBarcode FROM Books WHERE Title = 'The Little Prince'),
(DATEADD(day, -5, CONVERT(DATE, GETDATE()))),
(DATEADD(day, +5, CONVERT(DATE, GETDATE()))),
(SELECT IDNumber FROM Staff WHERE FirstName = 'Emille' AND LastName = 'Seraphine'),
(SELECT ID FROM RentalStatuses WHERE RentStatus = 'On Time')
)

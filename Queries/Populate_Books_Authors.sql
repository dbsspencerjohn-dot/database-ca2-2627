USE Library;

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
(SELECT ID from Authors where FirstName = 'J.R.R.' AND LastName = 'Tolkien')),

((SELECT BookBarcode from Books where Title = 'The Fellowship of the Ring'),
(SELECT ID from Authors where FirstName = 'J.R.R.' AND LastName = 'Tolkien')),

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
USE Library;

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
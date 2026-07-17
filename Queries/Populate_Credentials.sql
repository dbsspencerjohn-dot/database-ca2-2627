USE Library;

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
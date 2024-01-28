
// -----------------------------------------------------------------------------

CREATE KEYSPACE f211_student
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3};

DESCRIBE KEYSPACES

DESCRIBE f211_student

USE f211_student;

// -----------------------------------------------------------------------------

DROP TABLE users;

CREATE TABLE users (
    id INT PRIMARY KEY,
    fname TEXT,
    lname TEXT
);

CREATE TABLE users (
    id INT,
    fname TEXT,
    lname TEXT,
    PRIMARY KEY (id)
);

DESCRIBE TABLES

DESCRIBE TABLE users

INSERT INTO users (id, fname, lname)
VALUES (1, 'Irena', 'Holubova');

INSERT INTO users (fname, lname, id)
VALUES ('Martin', 'Svoboda', 2);

SELECT * FROM users;

SELECT * FROM users WHERE (id = 1);

// -----------------------------------------------------------------------------

SELECT * FROM users
WHERE (lname = 'Holubova');

SELECT * FROM users
WHERE (lname = 'Holubova')
ALLOW FILTERING;

CREATE INDEX ON users (lname);

// -----------------------------------------------------------------------------

CREATE TYPE person (
    first TEXT,
    last TEXT
);

CREATE TABLE contacts (
    id INT,
    name person,
    address TUPLE<TEXT, TEXT, INT>,
    emails SET<TEXT>,
    apps LIST<TEXT>,
    phones MAP<TEXT, TEXT>,
    PRIMARY KEY (id)
);

// -----------------------------------------------------------------------------

INSERT INTO contacts (id, name, address, emails, apps, phones)
VALUES (
    1,
    {first: 'Irena', last: 'Holubova'},
    ('Malostranske namesti', 'Praha', 11800),
    {'holubova@ksi.mff.cuni.cz'},
    ['WhatsApp', 'Messenger'],
    {'work' : '+420951554316'}
);

INSERT INTO contacts (id, name, emails, apps, phones)
VALUES (
    2,
    {first: 'Martin', last: 'Svoboda'},
    {'svoboda@ksi.mff.cuni.cz', 'martin.svoboda@mff.cuni.cz'},
    ['Viber', 'WhatsApp'],
    {'work' : '+420951554250', 'fax': '+420951554323'}
);

// -----------------------------------------------------------------------------

UPDATE contacts
SET
    address = ('Malostranske namesti 25', 'Praha', 11800),
    apps = ['Hangouts']
WHERE (id = 1);

UPDATE contacts
SET
    emails = emails + {'holubova@ksi.mff.cuni.cz'},
    apps = ['Messenger', 'WhatsApp'] + apps,
    phones = phones + {'home' : '+420123456789'}
WHERE (id = 1);

UPDATE contacts
SET
    emails = emails - {'irena.holubova@mff.cuni.cz'},
    apps = apps - ['Hangouts', 'Messenger'],
    phones = phones - {'home'}
WHERE (id = 1);

// -----------------------------------------------------------------------------

DELETE
    address,
    apps[0],
    phones['work']
FROM contacts
WHERE (id = 1);

// -----------------------------------------------------------------------------

CREATE TABLE messages (
    sender INT,
    app TEXT,
    date DATE,
    time TIME,
    recipient INT,
    message TEXT,
    PRIMARY KEY ((sender, app), date, time)
);

INSERT INTO messages (sender, app, date, time, recipient, message)
VALUES (2, 'WhatsApp', '2017-11-27', '10:00:00', 1, 'Hi Irena');

INSERT INTO messages (sender, app, date, time, recipient, message)
VALUES (2, 'WhatsApp', '2017-11-27', '10:15:00', 1, 'Are you there?');

INSERT INTO messages (sender, app, date, time, recipient, message)
VALUES (2, 'Messenger', '2017-11-27', '10:30:00', 1, 'Are you there?');

INSERT INTO messages (sender, app, date, time, recipient, message)
VALUES (1, 'Messenger', '2017-11-27', '10:45:00', 2, 'Yes, I am');

INSERT INTO messages (sender, app, date, time, recipient, message)
VALUES (1, 'Messenger', '2017-11-27', '10:50:00', 2, 'How are you?');

INSERT INTO messages (sender, app, date, time, recipient, message)
VALUES (2, 'Viber', '2017-11-28', '18:01:00', 1, 'I am fine');

INSERT INTO messages (sender, app, date, time, recipient, message)
VALUES (2, 'Viber', '2017-11-28', '18:02:00', 1, 'And you?');

SELECT * FROM messages;

// -----------------------------------------------------------------------------

SELECT *
FROM messages
WHERE sender = 2 AND app = 'WhatsApp'
ORDER BY date DESC, time DESC;

SELECT sender, app, date, COUNT(*)
FROM messages
WHERE sender = 2
GROUP BY sender, app, date
ALLOW FILTERING;

SELECT app, date, COUNT(*)
FROM messages
WHERE sender = 2
GROUP BY app, date
ALLOW FILTERING;

// -----------------------------------------------------------------------------


DROP DATABASE IF EXISTS hephaestus;
CREATE DATABASE hephaestus;
\c hephaestus;

DROP TABLE IF EXISTS member CASCADE;
CREATE TABLE member
(
    UserID SERIAL NOT NULL,
    Username VARCHAR(20) NOT NULL,
    Email VARCHAR(60),
    DispEmail BOOLEAN DEFAULT False,
    JoinDate DATE NOT NULL,
    PRIMARY KEY (UserID)
);

DROP TABLE IF EXISTS world CASCADE;
CREATE TABLE world
(
    WorldID SERIAL NOT NULL,
    CreatorID SERIAL NOT NULL,
    Name VARCHAR(50) DEFAULT 'Unnamed',
    Private BOOLEAN DEFAULT False,
    ShortDesc VARCHAR(140),
    LongDesc TEXT,
    PRIMARY KEY (WorldID),
    FOREIGN KEY (CreatorID) REFERENCES member(UserID)
);

DROP TABLE IF EXISTS genre;
CREATE TABLE genre
(
    WorldID SERIAL NOT NULL,
    Genre VARCHAR(20),
    FOREIGN KEY (WorldID) REFERENCES world(WorldID)
);

DROP TABLE IF EXISTS userworlds;
CREATE TABLE userworlds
(
    WorldID SERIAL NOT NULL,
    UserID SERIAL NOT NULL,
    Role VARCHAR(15) DEFAULT 'Editor',
    FOREIGN KEY (WorldID) REFERENCES world(WorldID)
);

DROP TABLE IF EXISTS category;
CREATE TABLE category
(
    CategoryID SERIAL NOT NULL,
    WorldID SERIAL NOT NULL,
    Name VARCHAR(50) DEFAULT 'Unnamed',
    PRIMARY KEY (CategoryID),
    FOREIGN KEY (WorldID) REFERENCES world(WorldID)
);

DROP TABLE IF EXISTS article;
CREATE TABLE article
(
    ArticleID SERIAL NOT NULL,
    WorldID SERIAL NOT NULL,
    CategoryID SERIAL NOT NULL,
    Name VARCHAR(50) DEFAULT 'Unnamed',
    Body TEXT,
    PRIMARY KEY (ArticleID),
    FOREIGN KEY (WorldID) REFERENCES world(WorldID),
    FOREIGN KEY (CategoryID) REFERENCES category(CategoryID)
);

DROP TABLE IF EXISTS password;
CREATE TABLE password
(
    PassID SERIAL NOT NULL,
    Salt VARCHAR(128) NOT NULL,
    Password TEXT NOT NULL,
    FOREIGN KEY (PassID) REFERENCES member(UserID)
);

CREATE USER heph WITH PASSWORD '4SrGY9gPFU72aJxh';
GRANT SELECT, INSERT, UPDATE ON member, world, genre, userworlds, category, article, password TO heph;

INSERT INTO member (Username, Email, DispEmail, JoinDate) VALUES ('Marty', 'mmclark317@gmail.com', TRUE, now());
INSERT INTO member (Username, Email, DispEmail, JoinDate) VALUES ('Evan', 'romannumeralii@gmail.com', FALSE, now());

INSERT INTO world (CreatorID, Name, ShortDesc, LongDesc) VALUES 
    ((SELECT member.UserID FROM member WHERE member.Username = 'Evan'), 
    'Earth',
    'This is literally just Earth. It''s only here for testing.',
    'Earth is the third planet from the Sun, the densest planet in the Solar System, the largest of the Solar System''s four terrestrial planets, and the only astronomical object known to harbor life.'
    );

INSERT INTO category (WorldID, Name) VALUES 
    ((SELECT world.WorldID FROM world JOIN member ON (world.CreatorID = member.UserID) WHERE world.Name = 'Earth' AND member.Username = 'Evan'),
    'Continents'
    );
INSERT INTO category (WorldID, Name) VALUES 
    ((SELECT world.WorldID FROM world JOIN member ON (world.CreatorID = member.UserID) WHERE world.Name = 'Earth' AND member.Username = 'Evan'),
    'Countries'
    );
    
INSERT INTO article (WorldID, CategoryID, Name, Body) VALUES
    ((SELECT world.WorldID FROM world JOIN member ON (world.CreatorID = member.UserID) WHERE world.Name = 'Earth' AND member.Username = 'Evan'),
    (SELECT category.CategoryID FROM category JOIN world ON (category.WorldID = world.WorldID) WHERE category.Name = 'Continents' AND world.Name = 'Earth'),
    'North America', 
    'North America is a continent entirely within the Northern Hemisphere and almost all within the Western Hemisphere. It can also be considered a northern subcontinent of the Americas. It is bordered to the north by the Arctic Ocean, to the east by the Atlantic Ocean, to the west and south by the Pacific Ocean, and to the southeast by South America and the Caribbean Sea.'
    );
    
INSERT INTO article (WorldID, CategoryID, Name, Body) VALUES
    ((SELECT world.WorldID FROM world JOIN member ON (world.CreatorID = member.UserID) WHERE world.Name = 'Earth' AND member.Username = 'Evan'),
    (SELECT category.CategoryID FROM category JOIN world ON (category.WorldID = world.WorldID) WHERE category.Name = 'Continents' AND world.Name = 'Earth'),
    'South America', 
    'South America is a continent situated in the Western Hemisphere, mostly in the Southern Hemisphere, with a relatively small portion in the Northern Hemisphere. It is also considered as a subcontinent of the Americas, which is the model used in Spanish-speaking nations and most of South America.'
    );
    
INSERT INTO article (WorldID, CategoryID, Name, Body) VALUES
    ((SELECT world.WorldID FROM world JOIN member ON (world.CreatorID = member.UserID) WHERE world.Name = 'Earth' AND member.Username = 'Evan'),
    (SELECT category.CategoryID FROM category JOIN world ON (category.WorldID = world.WorldID) WHERE category.Name = 'Countries' AND world.Name = 'Earth'),
    'United States', 
    'The United States of America (commonly referred to as the United States, U.S., USA, or America), is a federal republic composed of 50 states, a federal district, five major territories, and various possessions.'
    );

INSERT INTO article (WorldID, CategoryID, Name, Body) VALUES
    ((SELECT world.WorldID FROM world JOIN member ON (world.CreatorID = member.UserID) WHERE world.Name = 'Earth' AND member.Username = 'Evan'),
    (SELECT category.CategoryID FROM category JOIN world ON (category.WorldID = world.WorldID) WHERE category.Name = 'Countries' AND world.Name = 'Earth'),
    'Canada', 
    'Canada is a country in the northern part of North America. Its ten provinces and three territories extend from the Atlantic to the Pacific and northward into the Arctic Ocean, covering 9.98 million square kilometres (3.85 million square miles), making it the world''s second-largest country by total area and the fourth-largest country by land area.'
    );
    
INSERT INTO genre (WorldID, Genre) VALUES
    ((SELECT world.WorldID FROM world JOIN member ON (world.CreatorID = member.UserID) WHERE world.Name = 'Earth' AND member.Username = 'Evan'),
    'Modern'
    );
# I manually create a relational database of celestial bodies with postgres
 
CREATE DATABASE universe;
\c universe;


CREATE TABLE galaxy (
    galaxy_id SERIAL UNIQUE PRIMARY KEY, 
    name VARCHAR NOT NULL,
    constelation TEXT,
    distance_in_mly NUMERIC (4,2),
    shape TEXT,
    visible_to_the_naked_eye BOOLEAN
    );
    INSERT INTO galaxy (
        name,
        constelation,
        distance_in_mly
        shape,
        visible_to_the_naked_eye,
           )
           VALUES (
            'Milky way', 'Sagittarius', 0, 'Spiral' ,TRUE), 
           ('Nubecula major', 'Dorado', 0.16, 'Magellanic spiral', TRUE),
           ('Andromeda', 'Andromeda', 2.5, 'Barred spiral', TRUE),
           ('Antennae galaxies', 'Corvus', NULL,'Antenna', FALSE ),
           ('Whirpool','Canes venatici',31, 'Spiral', FALSE),
           ('Sombrero', 'Virgo', 28, 'Lenticular', FALSE)
           ;

CREATE TABLE star(
    star_id SERIAL UNIQUE PRIMARY KEY,
    name VARCHAR NOT NULL, 
    billions_of_stars INT,
    biggest_star VARCHAR,
    galaxy_id INT REFERENCES galaxy(galaxy_id)
    ); 
    INSERT INTO star (
        name,
        billion_of_stars,
        biggest_star,
        galaxy_id
    ) VALUES ('Milky way',400,'Sirius', 1),
    ('Nubecula major', 30,'R71',2),
    ('Andromeda',1,'Alpha andromeda',3),
    ('Antennae galaxies', , ,4),
    ('Whirpool', 100, ,5),
    ('Sombrero',100, ,6)
   
CREATE TABLE planet(
    planet_id SERIAL UNIQUE PRIMARY KEY, 
    name VARCHAR NOT NULL, 
    equatorial_diameter_km INT,
    mass_respect_earth NUMERIC (4,3),
    has_life BOOLEAN,
    star_id INT REFERENCES star (star_id)
    );
    INSERT INTO planet (
        planet_id,
        name,
        equatorial_diameter_km,
        mass_respect_earth,
        has_life,
        star_id
    ) VALUES ('Mercury',4878, 0.06, FALSE, 1),
    ('Jupiter',142800, 0.065,FALSE, 1),
    ('b_01', 5000, 1.2, FALSE, 2),
    ('b_02', 4506, 0.04, FALSE, 2),
    ('B032', NULL, NULL, FALSE, 3),
    ('B034' 9544, 0.99, FALSE, 3),
    ('B_0332', NULL, NULL, FALSE, 4),
    ('NB02', 10000, 2.3, FALSE, 4),
    ('B2_03', 8059, 1.2, FALSE, 5),
    ('B2_a', 5459, 0.2, FALSE, 5),
    ('B0_a3', 4059, 1.99, FALSE, 6),
    ('B2_43', 540, 1.0, FALSE, 6),

CREATE TABLE moon(
    moon_id SERIAL UNIQUE PRIMARY KEY, 
    name VARCHAR NOT NULL, 
    distance_from_earth INT,
    gravity NUMERIC,
    orbit TEXT,
    planet_id INT REFERENCES planet(planet_id)
    );
    INSERT INTO moon (
        moon_id,
        name,
        distance_from_earth,
        gravity,
        orbit,
        planet_id
    ) VALUES (),
    (),
    (1),
    (1),
    (2),
(2),
 (3),(3),
 (4),(4),
 (5),(5),
 (5),(5),
   

CREATE TABLE asteroids (
    asteroids_id SERIAL UNIQUE PRIMARY KEY,
    name VARCHAR NOT NULL,
    planet_id INT REFERENCES planet (planet_id)
)
   INSERT INTO asteroids (
    asteroids_id,
    name,
    planet_id
   ) VALUES (),
    (),
    (),

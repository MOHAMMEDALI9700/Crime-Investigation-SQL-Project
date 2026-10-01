INSERT INTO officers (name, rank) VALUES
('Singham', 'DCP'),
('Chulbul Pandey', 'Inspector'),
('Vartika Chaturvedi', 'DCP');

INSERT INTO suspects (name, car_model, last_seen) VALUES
('Vikram', 'BMW', 'Airport'),
('Anjali', 'Audi', 'Cafe'),
('Karan', 'Tesla', 'Office'),
('Pooja', 'Toyota', 'Mall'),
('Sameer', 'Honda', 'Gym'),
('Riya', 'Ford', 'Cinema'),
('Arjun', 'Tesla', 'Park');

INSERT INTO locations (address, danger_level) VALUES
('Airport', 5),
('Cafe', 2),
('Office', 3),
('Mall', 4),
('Gym', 1),
('Cinema', 2),
('Park', 3);

INSERT INTO crime_scenes (location_id, officer_id) VALUES
(1,1),
(2,2),
(3,3),
(4,1),
(5,2),
(6,3);

INSERT INTO evidence (item_description, scene_id) VALUES
('Blue Glove', 1),
('Cigarette Butt', 2),
('Phone Case', 3),
('Receipt', 4),
('Keyring', 5);

INSERT INTO witnesses (name, statement, scene_id) VALUES
('Ramesh', 'Saw a man running', 1),
('Sita', 'He was wearing black jacket', 2),
('Aman', 'Car was very fast', 3);

SELECT 
    name AS suspect_name,
    last_seen AS last_seen_location
FROM suspects;

SELECT 
    officer_id,
    name,
    rank
FROM officers
ORDER BY rank, name;

SELECT 
    e.item_description,
    l.address,
    l.danger_level
FROM evidence e
JOIN crime_scenes cs
    ON e.scene_id = cs.scene_id
JOIN locations l
    ON cs.location_id = l.location_id
WHERE l.danger_level >= 4;


SELECT DISTINCT car_model
FROM suspects;


SELECT 
    o.name AS officer_name,
    COUNT(e.evidence_id) AS total_evidence
FROM officers o
LEFT JOIN crime_scenes cs
    ON o.officer_id = cs.officer_id
LEFT JOIN evidence e
    ON cs.scene_id = e.scene_id
GROUP BY o.officer_id, o.name
ORDER BY total_evidence DESC;


SELECT
    l.address,
    l.danger_level,
    COUNT(cs.scene_id) AS crime_scenes,
    RANK() OVER (
        ORDER BY l.danger_level DESC,
                 COUNT(cs.scene_id) DESC
    ) AS location_rank
FROM locations l
LEFT JOIN crime_scenes cs
    ON l.location_id = cs.location_id
GROUP BY l.location_id, l.address, l.danger_level
ORDER BY location_rank
LIMIT 3;


SELECT
    o.name AS officer_name,
    AVG(l.danger_level) AS average_danger_level
FROM officers o
JOIN crime_scenes cs
    ON o.officer_id = cs.officer_id
JOIN locations l
    ON cs.location_id = l.location_id
GROUP BY o.officer_id, o.name;


WITH suspect_locations AS (
    SELECT name, last_seen
    FROM suspects
)
SELECT
    name,
    COUNT(last_seen) AS location_count
FROM suspect_locations
GROUP BY name
HAVING COUNT(last_seen) > 1;


SELECT
    o.name AS officer_name,
    COUNT(cs.scene_id) AS crime_scenes_handled,
    RANK() OVER (
        ORDER BY COUNT(cs.scene_id) DESC
    ) AS officer_rank
FROM officers o
LEFT JOIN crime_scenes cs
    ON o.officer_id = cs.officer_id
GROUP BY o.officer_id, o.name
ORDER BY officer_rank;


SELECT
    s.name AS suspect_name,
    s.last_seen,
    o.name AS officer_in_charge,
    e.item_description AS evidence,
    w.name AS witness_name,
    w.statement AS witness_statement
FROM suspects s
LEFT JOIN locations l
    ON s.last_seen = l.address
LEFT JOIN crime_scenes cs
    ON l.location_id = cs.location_id
LEFT JOIN officers o
    ON cs.officer_id = o.officer_id
LEFT JOIN evidence e
    ON cs.scene_id = e.scene_id
LEFT JOIN witnesses w
    ON cs.scene_id = w.scene_id
ORDER BY s.name;
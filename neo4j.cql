CREATE
(p1:PERSON { name: "Alice", age: 25, hobbies: ["reading"], birthplace: "Anytown"}),
(p2:PERSON { name: "Bob", age: 32, hobbies: ["playing guitar"], birthplace: "Samllvile"}),
(p3:PERSON { name: "Charlie", age: 45, hobbies: ["traveling", "reading"], birthplace: "Los Angeles"}),
(p4:PERSON { name: "Mark", age: 39, hobbies: ["traveling"], birthplace: "California"}),
(p5:PERSON { name: "David", age: 40, hobbies: ["poetry", "running"], birthplace: "Beachtown"}),

(c1:COMPANY { name: "Acme Inc", type: "Technology", employees: 1000, city: "San Francisco"}),
(c2:COMPANY { name: "Beta Corp", type: "Finance", employees: 500, city: "New York"}),
(c3:COMPANY { name: "Gamma LLC", type: "Retail", employees: 250, city: "Los Angeles"}),
(c4:COMPANY { name: "Alpha LLC", type: "Retail", employees: 125, city: "New York"}),
(c5:COMPANY { name: "BigSoft", type: "Software", employees: 40, city: "California"}),
(c6:COMPANY { name: "MegaApps", type: "Software", employees: 90, city: "California"}),

(p1)-[w1:WORK]->(c1),
(p1)-[w2:WORK]->(c3),
(p2)-[w3:WORK]->(c2),
(p3)-[w4:WORK]->(c3),
(p3)-[w5:WORK]->(c4),
(p3)-[w6:WORK]->(c5),
(p4)-[w7:WORK]->(c5),
(p5)-[w8:WORK]->(c5),
(p5)-[w9:WORK]->(c6);

// Select all companies with number of employees grater than 200
MATCH (c:COMPANY)
WHERE c.employees > 200
RETURN c;

// Retrieve the names of all people older than 35, that have "traveling" as a hobby
MATCH (p:PERSON)
WHERE p.age > 35 AND "traveling" IN p.hobbies
RETURN p;

// Change the type of all Company nodes with more than 500 employees to "Technology Services"
MATCH (c:COMPANY)
WHERE c.employees > 500
SET c.type = "Technology Services";

// Remove all relationships of people who have "Playing guitar" as a hobby
MATCH (p:PERSON)
WHERE "playing guitar" IN p.hobbies
DETACH DELETE p;

// Remove all companies in California
MATCH (c:COMPANY {city: "California"})
DETACH DELETE c;
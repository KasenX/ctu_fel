
//------------------------------------------------------------------------------
// #1

MATCH (m:MOVIE {id: "medvidek"})
RETURN m, m.title;

MATCH (m:MOVIE)
  WHERE m.id = "medvidek"
RETURN m, m.title;

//------------------------------------------------------------------------------
// #2

MATCH (a:ACTOR)
  WHERE a.year >= 1965
RETURN a.name, a.year 
  ORDER BY a.year DESC, a.name ASC;

... ORDER BY a.year DESCENDING, a.name ASCENDING;

... ORDER BY a.year DESCENDING, a.name;

//------------------------------------------------------------------------------
// #3

MATCH (:ACTOR {name: "Jiri Machacek"})<-[:PLAY]-(n:MOVIE)
RETURN n.title;

MATCH (n:MOVIE)-[:PLAY]->(:ACTOR {name: "Jiri Machacek"})
RETURN n.title;

MATCH (n:MOVIE)-[:PLAY]->(a:ACTOR)
  WHERE a.name = "Jiri Machacek"
RETURN n.title;

MATCH (:ACTOR {name: "Jiri Machacek"})<--(n:MOVIE)
RETURN n.title;

MATCH (:ACTOR {name: "Jiri Machacek"})--(n:MOVIE)
RETURN n.title;

MATCH (a:ACTOR {name: "Jiri Machacek"})
MATCH (n:MOVIE)-[:PLAY]->(a)
RETURN n.title;

MATCH (a:ACTOR {name: "Jiri Machacek"}), (n:MOVIE)-[:PLAY]->(a)
RETURN n.title;

//------------------------------------------------------------------------------
// #4

//#4-1
MATCH (a:ACTOR { name: "Jiri Machacek" })-[:KNOW]->(knownActors:ACTOR) 
RETURN knownActors.name AS Known_Actors;

//#4-2
MATCH (a:ACTOR { name: "Jiri Machacek" })-[:KNOW]-(knownActors:ACTOR) 
RETURN knownActors.name AS Known_Actors;

//------------------------------------------------------------------------------
// #5

MATCH (m:MOVIE)-[:PLAY]->(:ACTOR)
RETURN DISTINCT m;

MATCH (m:MOVIE)
  WHERE SIZE( (m)-[:PLAY]->(:ACTOR) ) >= 1
RETURN m;

MATCH (m:MOVIE)
  WHERE EXISTS( (m)-[:PLAY]->(:ACTOR) )
RETURN m;

MATCH (m:MOVIE)
  WHERE (m)-[:PLAY]->(:ACTOR)
RETURN m;

MATCH (m:MOVIE)
WITH m, SIZE( (m)-[:PLAY]->(:ACTOR) ) AS actors
  WHERE actors >= 1
RETURN m;

MATCH (m:MOVIE)-[:PLAY]->(a:ACTOR)
WITH m, COUNT(a) as actors
  WHERE actors >= 1
RETURN m;

MATCH (m:MOVIE)-[:PLAY]->(a:ACTOR)
WITH m, COUNT(a) as actors
RETURN m;

MATCH (m:MOVIE), (a:ACTOR)
  WHERE (m)-[:PLAY]->(a)
RETURN DISTINCT m;

//------------------------------------------------------------------------------
// #6

MATCH
  (s:ACTOR {name: "Ivan Trojan"})
    <-[:PLAY]-(m:MOVIE)-[:PLAY]->
  (a:ACTOR)
RETURN DISTINCT a;

MATCH
  (s:ACTOR {name: "Ivan Trojan"})<-[:PLAY]-(m:MOVIE),
  (m)-[:PLAY]->(a:ACTOR)
RETURN DISTINCT a;

MATCH (s:ACTOR {name: "Ivan Trojan"})<-[:PLAY]-(m:MOVIE)
MATCH (m)-[:PLAY]->(a:ACTOR)
  WHERE a <> s
RETURN DISTINCT a;

 ... WHERE a.name <> "Ivan Trojan"

MATCH (a:ACTOR)
  WHERE
    (a)<-[:PLAY]-(:MOVIE)-[:PLAY]->(:ACTOR {name: "Ivan Trojan"})
RETURN a;

//------------------------------------------------------------------------------
// #7

MATCH (s:ACTOR {name: "Ivan Trojan"})-[:KNOW *]-(a:ACTOR)
  WHERE s <> a
RETURN DISTINCT a.name;

MATCH (s:ACTOR {name: "Ivan Trojan"})-[:KNOW *1..]-(a:ACTOR)
  WHERE s <> a
RETURN DISTINCT a.name;

MATCH (a:ACTOR)
  WHERE
    EXISTS( (a)-[:KNOW *]-(:ACTOR {name: "Ivan Trojan"}) )
    AND
    (a.name <> "Ivan Trojan")
RETURN a.name;

//------------------------------------------------------------------------------
// #8

MATCH (m:MOVIE)
OPTIONAL MATCH (m)-[:PLAY]->(a:ACTOR)
RETURN m.title, a.name;

//------------------------------------------------------------------------------
// #9

MATCH (m:MOVIE)
WITH m, SIZE( (m)-[:PLAY]->(:ACTOR) ) AS actors
WITH AVG(actors) AS average
MATCH (m:MOVIE)
  WHERE SIZE( (m)-[:PLAY]->(:ACTOR) ) > average
MATCH (m)-[:PLAY]->(a:ACTOR)
WITH DISTINCT a;
RETURN a.name;

MATCH (m:MOVIE)
OPTIONAL MATCH (m)-[:PLAY]->(a:ACTOR)
WITH m, COUNT(a) AS actors
WITH AVG(actors) AS average
MATCH (m:MOVIE)
  WHERE SIZE( (m)-[:PLAY]->(:ACTOR) ) > average
MATCH (m)-[:PLAY]->(a:ACTOR)
WITH DISTINCT a;
RETURN a.name;

//------------------------------------------------------------------------------
// #10

//#10-1
MATCH (a1:ACTOR {name: "Jiri Machacek"})-[:PLAY]-(m:MOVIE)-[:PLAY]-(a2:ACTOR)
        WITH a2.name AS Actor, m.title AS Movies
        RETURN Actor, Movies;

//#10-2
MATCH (a1:ACTOR {name: "Jiri Machacek"})-[:PLAY]-(m:MOVIE)-[:PLAY]-(a2:ACTOR)
        WITH a2.name AS Actor, COLLECT(DISTINCT m.title) AS Movies
        RETURN Actor, Movies;

//------------------------------------------------------------------------------

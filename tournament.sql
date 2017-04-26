-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.


-- Drop Database if exists
DROP DATABASE IF EXISTS tournament;

-- Drop tables if eists
DROP TABLE IF EXISTS players CASCADE;
DROP TABLE IF EXISTS matches CASCADE;

-- Drop view if exists
DROP VIEW IF EXISTS result CASCADE;

-- Create database
CREATE DATABASE tournament;

-- Connect to database
\c tournament;

-- Create Players Table
CREATE TABLE players(
    name text,
    id serial PRIMARY KEY
);

-- Crete matches table
CREATE TABLE matches(
    id serial PRIMARY KEY,
    winner INTEGER,
    loser INTEGER,
    FOREIGN KEY(winner) REFERENCES players(id),
    FOREIGN KEY(loser) REFERENCES players(id)
);

-- Crete view results
CREATE VIEW results AS SELECT players.id, players.name,
COALESCE((SELECT COUNT(winner) FROM matches WHERE players.id = matches.winner),0) AS wins,
COALESCE((SELECT COUNT(*) FROM matches WHERE players.id = matches.winner OR players.id = matches.loser),0) as matches
FROM players LEFT JOIN matches ON players.id = matches.winner
GROUP BY players.id ORDER BY wins DESC;
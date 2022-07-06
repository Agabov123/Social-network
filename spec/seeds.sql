DROP TABLE IF EXISTS "public"."accounts" CASCADE;
DROP TABLE IF EXISTS "public"."posts" CASCADE;



CREATE TABLE accounts( 
id SERIAL PRIMARY KEY,
email text,
username text
);
CREATE TABLE posts(
id SERIAL PRIMARY KEY,
title text,
content text,
num_of_views text,
account_id int,
constraint fk_account foreign key(account_id) references 
accounts(id)
);

INSERT INTO "public"."accounts" ("id", "email", "username") VALUES 
(1, 'test1@example.com', 'A'),
(2, 'test2@example.com', 'B'),
(3, 'test3@example.com', 'C'),
(4, 'test4@example.com', 'D');

INSERT INTO "public"."posts" ("id", "title", "content", "num_of_views") VALUES 
(1, 'A', 'some words1', '1'),
(2, 'B', 'some words2', '2'),
(3, 'C', 'some words3', '3'),
(4, 'D', 'some words4', '4');
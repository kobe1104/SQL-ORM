DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL

  -- FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users(fname, lname)
VALUES
  ("Barack", "Obama"), ("Jesus", "Christ"), ("Lady", "Gaga");


DROP TABLE IF EXISTS questions;

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id)

);

INSERT INTO questions(title, body, author_id)
SELECT
  "Obama question", "Obama body", users.id
FROM
    users
WHERE
    users.fname = "Barack" AND users.lname = "Obama";

INSERT INTO questions(title, body, author_id)
SELECT
  "Gaga question", "Gaga body", users.id
FROM
    users
WHERE
    users.fname = "Lady" AND users.lname = "Gaga";

INSERT INTO questions(title, body, author_id)
SELECT
  "Jesus question", "Jesus body", users.id
FROM
    users
WHERE
    users.fname = "Jesus" AND users.lname = "Christ";


DROP TABLE IF EXISTS question_follows;

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  author_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)

);

INSERT INTO question_follows(author_id, question_id)
VALUES
  ((SELECT id FROM users WHERE lname = "Obama" AND fname = "Barack"),
  (SELECT id FROM questions WHERE title = "Obama question")),

  ((SELECT id FROM users WHERE lname = "Christ" AND fname = "Jesus"),
  (SELECT id FROM questions WHERE title = "Jesus question")),

  ((SELECT id FROM users WHERE lname = "Gaga" AND fname = "Lady"),
  (SELECT id FROM questions WHERE title = "Gaga question")
);




DROP TABLE IF EXISTS replies;

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  author_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREiGN KEY(parent_id) REFERENCES replies(id)
);

INSERT INTO replies(author_id, question_id, parent_id, body)
VALUES
((SELECT id FROM users WHERE lname = "Christ" AND fname = "Jesus"),
  (SELECT id FROM questions WHERE title = "Obama question"), NULL, "Wise words");

  INSERT INTO replies(author_id, question_id, parent_id, body)
  VALUES
  ((SELECT id FROM users WHERE lname = "Gaga" AND fname = "Lady"),
    (SELECT id FROM questions WHERE title = "Obama question"),
    (SELECT id FROM replies WHERE body = "Wise words")
    , "Lady Gaga reply");



DROP TABLE IF EXISTS question_likes;

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO question_likes(author_id, question_id)
VALUES
  ((SELECT id FROM users WHERE lname = "Christ" AND fname = "Jesus"),
  (SELECT id from questions WHERE title = "Obama question")),

  ((SELECT id FROM users WHERE lname = "Christ" AND fname = "Jesus"),
  (SELECT id from questions WHERE title = "Jesus question")),

  ((SELECT id FROM users WHERE lname = "Christ" AND fname = "Jesus"),
  (SELECT id from questions WHERE title = "Gaga question")),

  ((SELECT id FROM users WHERE lname = "Obama" AND fname = "Barack"),
  (SELECT id from questions WHERE title = "Obama question")),

  ((SELECT id FROM users WHERE lname = "Obama" AND fname = "Barack"),
  (SELECT id from questions WHERE title = "Jesus question")),

  ((SELECT id FROM users WHERE lname = "Obama" AND fname = "Barack"),
  (SELECT id from questions WHERE title = "Gaga question")),

  ((SELECT id FROM users WHERE lname = "Gaga" AND fname = "Lady"),
  (SELECT id from questions WHERE title = "Obama question")),

  ((SELECT id FROM users WHERE lname = "Gaga" AND fname = "Lady"),
  (SELECT id from questions WHERE title = "Gaga question")),

  ((SELECT id FROM users WHERE lname = "Gaga" AND fname = "Lady"),
  (SELECT id from questions WHERE title = "Jesus question")
);

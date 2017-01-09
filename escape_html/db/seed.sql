DROP TABLE escape_html_users;

CREATE TABLE escape_html_users (
  id SERIAL8 primary key,
  name varchar(32) not null,
  age int not null,
  bio text not null
);

INSERT INTO escape_html_users (name, age, bio) VALUES ('John', 21, '<p>Here is the bio.</p>');
INSERT INTO escape_html_users (name, age, bio) VALUES ('Malicious Mike', 25, '<script>alert("Malicious script running!");</script>');
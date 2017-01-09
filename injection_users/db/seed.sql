DROP TABLE injection_users;

CREATE TABLE injection_users(
  id SERIAL8 primary key,
  username varchar(16) not null,
  password varchar(16) not null
);

INSERT INTO injection_users (username, password) VALUES ('admin', 'password');
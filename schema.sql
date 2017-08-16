-- postgres, this is for you
BEGIN;

CREATE EXTENSION IF NOT EXISTS isn;

CREATE TABLE IF NOT EXISTS warehouses (
  name TEXT PRIMARY KEY
  );

CREATE TABLE IF NOT EXISTS books (
  id UUID PRIMARY KEY,
  isbn ISBN13 NULL,
  title TEXT NOT NULL,
  description TEXT NULL,
  acquisition TIMESTAMP WITH TIME ZONE NULL,
  current_warehouse TEXT REFERENCES warehouses(name)
  );

CREATE TABLE IF NOT EXISTS users (
  name TEXT PRIMARY KEY
  );

CREATE TABLE IF NOT EXISTS loans (
  borrower TEXT NOT NULL REFERENCES users(name),
  book UUID NOT NULL REFERENCES books(id),
  time TSTZRANGE NOT NULL,
  EXCLUDE USING GIST (time WITH &&)
  );

CREATE OR REPLACE VIEW books_enhanced AS
  SELECT books.*, loans.borrower, loans.time AS loan_time FROM books LEFT OUTER JOIN loans ON books.id = loans.book AND loans.time @> NOW();

COMMIT;

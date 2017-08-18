-- postgres, this is for you
BEGIN;

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS isn;

CREATE TABLE IF NOT EXISTS languages (
  code TEXT PRIMARY KEY,
  name TEXT
  );

CREATE TABLE IF NOT EXISTS warehouses (
  name TEXT PRIMARY KEY
  );

CREATE TABLE IF NOT EXISTS books (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  isbn ISBN13 NULL,
  title TEXT NOT NULL,
  description TEXT NULL,
  acquisition TIMESTAMP WITH TIME ZONE NULL,
  current_warehouse TEXT REFERENCES warehouses(name),
  author TEXT NULL,
  language TEXT REFERENCES languages(code)
  );

CREATE TABLE IF NOT EXISTS users (
  name TEXT PRIMARY KEY
  );

CREATE TABLE IF NOT EXISTS loans (
  borrower TEXT NOT NULL REFERENCES users(name),
  book UUID NOT NULL REFERENCES books(id),
  time TSTZRANGE NOT NULL,
  EXCLUDE USING GIST ((book::text) WITH =, "time" WITH &&)
  );

CREATE OR REPLACE VIEW books_enhanced AS
  SELECT books.id, books.isbn, books.title, books.description, books.acquisition, books.current_warehouse, loans.borrower, loans.time AS loan_time, books.author, books.language FROM books LEFT OUTER JOIN loans ON books.id = loans.book AND loans.time @> NOW();

COMMIT;

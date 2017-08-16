#!/usr/bin/env python3
from flask import Flask, g, render_template
import psycopg2

app = Flask(__name__)


@app.teardown_appcontext
def close_db(error):
    if hasattr(g, 'db'):
        g.db.close()

def open_db():
    if not hasattr(g, 'db'):
        g.db = psycopg2.connect('dbname=librarin user=librarin')
    return g.db

def books_list(db):
    cur = db.cursor()
    cur.execute("SELECT * FROM books_enhanced;")
    books = cur.fetchall()
    cur.close()
    return books

@app.route('/')
def list_books():
    db = open_db()
    books = books_list(db)
    return render_template('list_books.html', title='Books list', books=books)

if __name__ == '__main__':
    app.run(debug=True)

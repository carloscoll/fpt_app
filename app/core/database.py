from peewee import SqliteDatabase

DATABASE_URL = "/data/fpt.db"
database = SqliteDatabase(DATABASE_URL)

import psycopg, os
from dotenv import load_dotenv

load_dotenv()

def get_connection():
    return psycopg.connect(
        host = os.getenv("host"),
        port = os.getenv("port"),
        dbname = os.getenv("dbname"),
        user = os.getenv("user"),
        password = os.getenv("password")
    )


import os
import re
import socket
import ssl
from pathlib import Path
import pg8000

def load_dotenv_if_present():
    env_file = Path(__file__).resolve().parent.parent / ".env"
    if env_file.exists():
        with open(env_file, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    k, v = line.split("=", 1)
                    k = k.strip()
                    v = v.strip().strip("'").strip('"')
                    if k not in os.environ:
                        os.environ[k] = v

load_dotenv_if_present()

def get_db_url():
    url = os.environ.get("DB_URL") or os.environ.get("DATABASE_URL")
    if not url:
        # Check standard JDBC or postgres URL from env
        jdbc_url = os.environ.get("SPRING_DATASOURCE_URL")
        if jdbc_url and "postgresql://" in jdbc_url:
            url = jdbc_url.replace("jdbc:postgresql://", "postgresql://")
    
    if not url:
        # Fallback to local default if not set
        return "postgresql://postgres:postgres@127.0.0.1:5432/postgres"

    if url.startswith("jdbc:"):
        url = url.replace("jdbc:", "")

    # If JDBC contains ?prepareThreshold=0 or user/password separate
    user = os.environ.get("DB_USERNAME", "")
    pwd = os.environ.get("DB_PASSWORD", "")
    if user and pwd and "@" not in url:
        # construct full postgresql URL
        url = url.replace("postgresql://", f"postgresql://{user}:{pwd}@")

    return url

def get_db_connection():
    db_url = get_db_url()
    
    # Strip query parameters if present
    base_url = db_url.split("?")[0]
    
    part1, part2 = base_url.split("@")
    user_pass = part1.replace("postgresql://", "")
    user, password = user_pass.split(":", 1)
    host_port, database = part2.split("/")
    
    if ":" in host_port:
        host, port = host_port.split(":")
    else:
        host, port = host_port, "5432"

    if host in ("127.0.0.1", "localhost"):
        return pg8000.connect(
            user=user,
            password=password,
            host=host,
            port=int(port),
            database=database
        )

    host_dns = host if host.endswith('.') else host + '.'
    resolved_ip = socket.gethostbyname(host_dns)

    ssl_context = ssl.create_default_context()
    ssl_context.check_hostname = False
    ssl_context.verify_mode = ssl.CERT_NONE

    return pg8000.connect(
        user=user,
        password=password,
        host=resolved_ip,
        port=int(port),
        database=database,
        ssl_context=ssl_context
    )

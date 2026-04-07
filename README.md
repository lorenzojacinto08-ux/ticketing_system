# Flask Ticketing System

A web-based ticketing system built with Flask and MySQL.

## Features

- User authentication and role-based access control
- Ticket creation and management
- Dashboard with analytics
- User management (admin/super admin)
- CSV export functionality
- Audit logging

## Environment variables

Create a `.env` file in the project root (see `.env.example`). Typical keys:

| Variable | Notes |
|----------|--------|
| `DB_HOST` | Usually `localhost` |
| `DB_PORT` | Usually `3306` |
| `DB_USER` | MySQL user |
| `DB_PASSWORD` | MySQL password |
| `DB_NAME` | Database name (e.g. `ticketing_db`) |
| `SECRET_KEY` | Set a random string for production |
| `FLASK_ENV` | Optional: `development` enables Flask debug (not for production) |

---

## Windows — install and run

Use **Command Prompt** or **PowerShell**. Adjust the path if your folder is not `C:\Apps\ticketing_system`.

### 1. Prerequisites

- **Python 3.10+** from [python.org](https://www.python.org/downloads/) — during setup, enable **Add python.exe to PATH**.
- **MySQL** or **MariaDB** — install and start the Windows service (e.g. Services → MySQL → Start).

### 2. One-time setup (dependencies + virtual environment)

```bat
cd C:\path\to\ticketing_system
scripts\setup_windows.bat
```

This creates `venv\`, installs `requirements.txt`, and copies `.env.example` to `.env` if `.env` does not exist.

### 3. Database

Create the database (name must match `DB_NAME` in `.env`, default `ticketing_db`). Example using MySQL’s client (add `mysql.exe` to PATH or use full path):

```bat
cd C:\path\to\ticketing_system
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS ticketing_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p ticketing_db < march_31.sql
```

You will be prompted for the MySQL `root` password twice (or use your own user with suitable grants). Alternatively, create the database and import `march_31.sql` with **MySQL Workbench** or **HeidiSQL**.

### 4. Configure `.env`

Edit `.env` in the project folder so `DB_USER`, `DB_PASSWORD`, `DB_NAME`, and `DB_PORT` match your MySQL setup.

### 5. Start the app

- **Background (no console) + open browser:** double-click `scripts\start_ticketing_silent.bat` or run:

```bat
scripts\start_ticketing_silent.bat
```

- **Console with logs** (Ctrl+C to stop):

```bat
scripts\start_ticketing.bat
```

- **Stop** a background server: `scripts\stop_ticketing.bat`

Open **http://127.0.0.1:5000/** in the browser.

More detail and troubleshooting: **WINDOWS_SETUP.md**.

---

## macOS / Linux (optional)

```bash
cd /path/to/ticketing_system
python3 -m venv venv
source venv/bin/activate   # Linux/macOS
pip install -r requirements.txt
cp .env.example .env
# Edit .env, create DB, import march_31.sql
python app.py
```

GUI launcher (background + browser): `scripts/TicketingLauncher.app` on macOS.

---

## Database schema

Import **`march_31.sql`** into your database for the main schema. Extra SQL patches live under **`scripts\`** if your deployment needs them.

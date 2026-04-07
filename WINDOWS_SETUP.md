# Installing on Windows

This app is a normal Python project: you install prerequisites once, run a setup script, configure the database, then start the server with a shortcut or batch file.

## What you need to download / install

| Requirement | Why |
|-------------|-----|
| **Python 3.10+** | Runs the Flask app. [python.org/downloads](https://www.python.org/downloads/) — during install, enable **“Add python.exe to PATH”**. |
| **MySQL Server** or **MariaDB** | Stores tickets and users. [MySQL Installer](https://dev.mysql.com/downloads/installer/) or [MariaDB](https://mariadb.org/download/). |
| **This project** | Zip from GitHub or copy the folder — no separate “installer.exe” unless you build one later. |

Optional: **MySQL Workbench** or **HeidiSQL** to import SQL and manage the database.

## Quick install (first PC)

1. Install **Python** and **MySQL/MariaDB** (see above).
2. Copy the project folder anywhere, e.g. `C:\Apps\ticketing_system\`.
3. Open **Command Prompt** or **PowerShell**, `cd` to that folder, and run:
   ```bat
   scripts\setup_windows.bat
   ```
   Or double‑click `scripts\setup_windows.bat` in File Explorer.

   This creates a **`venv`** folder, installs packages from `requirements.txt`, and creates **`.env`** from `.env.example` if needed.

4. **Database**
   - Start the MySQL service (Services app → MySQL → Start).
   - Create an empty database (e.g. `ticketing_db`) and a user/password, **or** use `root` locally for testing only.
   - Import your schema (e.g. `march_31.sql`) with Workbench, HeidiSQL, or:
     ```bat
     mysql -u root -p ticketing_db < march_31.sql
     ```

5. Edit **`.env`** in the project root with your real values:
   - `DB_HOST` (usually `localhost`)
   - `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_PORT`

6. Start the app:
   - **No console, opens browser:** double‑click `scripts\start_ticketing_silent.bat`
   - **Console with logs:** `scripts\start_ticketing.bat`

7. Stop a background server: `scripts\stop_ticketing.bat`

The site is **`http://127.0.0.1:5000`** on this PC only (same idea as on Mac).

## “Downloadable” package for others

To give someone a **zip** they can unzip and run:

1. Zip the project folder **without**:
   - `venv\` (they run `setup_windows.bat` to recreate it)
   - `__pycache__\`
   - `.env` (secrets — send `.env.example` and tell them to copy to `.env`)

2. They install Python + MySQL, unzip, run `setup_windows.bat`, configure `.env`, import SQL, then `start_ticketing_silent.bat`.

## Troubleshooting

- **`python` is not recognized** — Reinstall Python with **Add to PATH**, then open a **new** terminal.
- **Port 5000 in use** — Stop the other program or set `PORT=5001` in the environment and use `http://127.0.0.1:5001` (you may need to match in launcher scripts or use `set PORT=5001` before `app.py`).
- **Can’t connect to MySQL** — Service running? Host/user/password in `.env` match what you created? Firewall rarely blocks localhost.
- **PowerShell scripts blocked** — `start_ticketing_silent.bat` runs PowerShell with `-ExecutionPolicy Bypass`. If your org blocks that, use `start_ticketing.bat` instead.

## Not included (by design)

- A single **.exe installer** that bundles Python + MySQL would need extra tools (e.g. PyInstaller + embedded MySQL or an installer builder). The flow above is the standard lightweight approach for a small team.

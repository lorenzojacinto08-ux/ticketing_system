# Flask Ticketing System

A web-based ticketing system built with Flask and MySQL.

## Features

- User authentication and role-based access control
- Ticket creation and management
- Dashboard with analytics
- User management (admin/super admin)
- CSV export functionality
- Audit logging

## Deployment on Railway

### Prerequisites
- Railway account
- GitHub repository

### Setup Steps

1. **Push to GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin <your-github-repo>
   git push -u origin main
   ```

2. **Deploy on Railway**
   - Go to [railway.app](https://railway.app)
   - Click "New Project" → "Deploy from GitHub repo"
   - Select your repository
   - Railway will automatically detect the Flask app

3. **Add MySQL Database**
   - In your Railway project, click "New Service"
   - Select "MySQL" as the service type
   - Railway will create a MySQL database

4. **Set Environment Variables**
   Railway will automatically set `DATABASE_URL` when you add MySQL.
   You can also set:
   - `SECRET_KEY`: Generate a random secret key
   - `FLASK_ENV`: Set to "production"

5. **Run Database Migrations**
   - Connect to your Railway MySQL database
   - Import your `new.sql` file to create the tables

### Environment Variables

Railway automatically provides:
- `PORT`: The port your app should listen on
- `DATABASE_URL`: MySQL connection string

Manual variables to set:
- `SECRET_KEY`: Your Flask secret key

### Accessing Your App

After deployment, Railway will provide you with a public URL where your app is accessible.

## Local Development

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your local database settings
   ```

3. Run the app:
   ```bash
   python app.py
   ```

## Database Setup

Import the `new.sql` file into your MySQL database to create the necessary tables.

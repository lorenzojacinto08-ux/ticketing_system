# Replit Deployment Guide

## Quick Start
1. Import this repository into Replit
2. Replit will automatically detect the Python configuration
3. Click "Run" to start the Flask application

## Configuration Files Created
- `.replit` - Configures Replit to run `python app.py`
- `replit.nix` - Sets up Python 3.12 environment

## Environment Variables
Set these in Replit's Secrets tab:
- `DATABASE_URL` - Your MySQL database connection string
- `SECRET_KEY` - Flask secret key for sessions
- Any other environment variables from `.env.example`

## Database Setup
Make sure your MySQL database is accessible from Replit's environment and update the connection string accordingly.

## Port Configuration
The app runs on port 5000, which Replit will automatically forward to the web interface.

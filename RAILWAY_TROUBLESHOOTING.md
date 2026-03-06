# Railway JO Generation Troubleshooting Guide

## Problem
Job Order (JO) auto-generation is not working on Railway deployment.

## Common Causes & Solutions

### 1. Missing job_order Column
**Issue**: Railway database may not have the `job_order` column.

**Solution**: 
- The migration function now checks and adds the `job_order` column automatically
- Railway deployment runs `railway_deploy.py` before starting the app

### 2. Missing UNIQUE Constraint
**Issue**: The `job_order` column lacks the UNIQUE constraint needed for proper JO generation.

**Solution**: 
- Migration now adds the `job_order_UNIQUE` constraint automatically

### 3. Database Connection Issues
**Issue**: Railway uses `DATABASE_URL` environment variable instead of individual DB variables.

**Solution**: 
- The `get_db_connection()` function already handles both formats
- Ensure `DATABASE_URL` is set in Railway environment variables

### 4. Migration Not Running
**Issue**: Database migrations aren't running on Railway startup.

**Solution**: 
- Updated `railway.toml` to run `railway_deploy.py` before starting the app
- This ensures all migrations run before the app starts

## Testing & Debugging

### Debug Endpoint
Access `/debug/jo-generation` (requires login) to see:
- Database columns
- Job order column existence
- Existing JO numbers
- Test JO generation
- Any error messages

### Manual Database Check
```sql
-- Check if job_order column exists
SHOW COLUMNS FROM entries LIKE 'job_order';

-- Check existing JO numbers
SELECT job_order FROM entries WHERE job_order IS NOT NULL ORDER BY job_order DESC;

-- Manually add job_order column if needed
ALTER TABLE entries ADD COLUMN job_order VARCHAR(10) DEFAULT NULL AFTER remedy;
ALTER TABLE entries ADD UNIQUE INDEX job_order_UNIQUE (job_order);
```

## Deployment Steps

1. **Deploy to Railway** - The updated code will automatically run migrations
2. **Check Logs** - Look for migration messages in Railway logs
3. **Test Debug Endpoint** - Visit `/debug/jo-generation` to verify setup
4. **Test Add Ticket** - Try creating a new ticket to verify JO generation

## Environment Variables Required

Ensure these are set in Railway:
- `DATABASE_URL` (full MySQL connection string)
- `SECRET_KEY` (for Flask sessions)
- `FLASK_ENV=production` (optional)

## What the Fixes Do

1. **Enhanced Migration Function**: Now checks for `job_order` column and adds it if missing
2. **Railway Deploy Script**: Runs database setup before app starts
3. **Better Error Handling**: JO generation has fallback if computation fails
4. **Debug Endpoint**: Helps identify specific issues
5. **Improved Logging**: More debug output for troubleshooting

## Expected Behavior

After fixes:
- Railway deployment will run migrations automatically
- `job_order` column will be created if missing
- UNIQUE constraint will be added if missing
- JO numbers will generate in format `jo-0001`, `jo-0002`, etc.
- Debug endpoint will show "status": "success" with next JO

## If Still Not Working

1. Check Railway deployment logs for migration messages
2. Visit `/debug/jo-generation` endpoint
3. Verify `DATABASE_URL` is correct and accessible
4. Check if MySQL permissions allow ALTER TABLE operations

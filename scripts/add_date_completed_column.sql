-- Add date_completed column to properly track completion dates
-- This will be separate from the original 'date' column (creation date)

ALTER TABLE entries ADD COLUMN date_completed DATETIME DEFAULT NULL AFTER service_done;

-- Update existing completed tickets to set date_completed from date column
UPDATE entries 
SET date_completed = date 
WHERE status IN ('completed', 'complete') 
AND date_completed IS NULL;

-- Set date_completed to NULL for non-completed tickets
UPDATE entries 
SET date_completed = NULL 
WHERE status NOT IN ('completed', 'complete');

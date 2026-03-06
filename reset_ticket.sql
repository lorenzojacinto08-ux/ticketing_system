-- Reset ticket counter SQL script
-- Run this command to reset the auto-increment counter to 1

-- First, check your current highest ticket number:
-- SELECT MAX(ticket_no) FROM entries;
-- or
-- SELECT MAX(id) FROM entries;

-- Then reset the counter (use the correct column name):
ALTER TABLE entries AUTO_INCREMENT = 1;

-- Note: This will make the next inserted ticket start from number 1
-- Existing tickets will keep their current numbers

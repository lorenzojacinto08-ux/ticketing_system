-- Add service_done and labor_fee columns to entries table
-- Migration script for adding new fields to ticketing system

ALTER TABLE entries 
ADD COLUMN service_done TEXT DEFAULT NULL AFTER job_order,
ADD COLUMN labor_fee DECIMAL(10, 2) DEFAULT NULL AFTER service_done;

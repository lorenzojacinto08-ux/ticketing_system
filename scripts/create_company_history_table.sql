-- Create company_history table to store unique company names
-- This table will maintain a history of all company names used in tickets

DROP TABLE IF EXISTS `company_history`;

CREATE TABLE `company_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `company_name` varchar(100) NOT NULL,
  `usage_count` int NOT NULL DEFAULT 1,
  `last_used` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_company_name` (`company_name`),
  KEY `idx_company_name` (`company_name`),
  KEY `idx_usage_count` (`usage_count`),
  KEY `idx_last_used` (`last_used`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Populate the table with existing company names from the entries table
INSERT IGNORE INTO `company_history` (company_name, usage_count, last_used)
SELECT 
    store_name as company_name,
    COUNT(*) as usage_count,
    MAX(date) as last_used
FROM entries 
WHERE store_name IS NOT NULL AND store_name != ''
GROUP BY store_name
ORDER BY usage_count DESC, last_used DESC;

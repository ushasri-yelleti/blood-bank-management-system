# blood-bank-management-system
Blood Bank Management System

A MySQL-based database project for managing blood donors, patients, donations, blood inventory, blood requests, and blood issue records. The project demonstrates relational database design and practical SQL concepts through sample data, indexes, views, stored procedures, triggers, and queries at basic, intermediate, and advanced levels.

## Project Overview

The database helps organize blood bank information and supports queries for checking inventory, tracking donations, reviewing pending requests, and recording blood issues. The included ER diagram illustrates the entities, their attributes, and the relationships between them.

## Features

- **Blood group management:** Stores the eight blood groups represented in the sample data.
- **Donor records:** Maintains donor details, contact information, blood group, and last donation date.
- **Patient records:** Stores patient details, hospital name, contact number, and required blood group.
- **Donation tracking:** Records donation dates and units donated.
- **Blood inventory:** Tracks stock units, collection dates, and expiry dates.
- **Blood requests:** Records requested units and request status (`Pending` or `Completed`).
- **Blood issue records:** Stores which stock record was used for an issue, the request, date, and units issued.
- **Views:** Provides reusable views for available stock, donor details, pending requests, and donation summaries.
- **Stored procedures:** Includes procedures to add a donor, create or complete a request, and check stock for a blood group.
- **Triggers:** Updates a donor's last donation date after a donation is inserted and deducts stock units after a blood issue is inserted.
- **SQL practice queries:** Includes basic, intermediate, and advanced examples using joins, aggregates, subqueries, grouping, and filtering.
- **Indexes:** Adds indexes to selected foreign-key and frequently queried columns.

## Database Schema

The SQL script creates the `Bloodbank_db` database and the following seven tables:

| Table | Purpose |
|---|---|
| `blood_group` | Blood group identifiers and names |
| `donor` | Donor details and blood group reference |
| `patient` | Patient details, hospital, and blood group reference |
| `donation` | Donation history, donor, blood group, date, and units |
| `blood_stock` | Inventory quantities, collection dates, and expiry dates |
| `blood_request` | Patient blood requests, required units, date, and status |
| `blood_issue` | Blood issued against a request and stock record |

### Relationships

- One blood group can be associated with multiple donors, patients, donations, stock records, and blood requests.
- One donor can have multiple donation records.
- One patient can create multiple blood requests.
- A blood request can be associated with blood issue records.
- A blood stock record can be referenced by multiple blood issue records.

See `Blood Bank Management System.png` for the ER diagram.

## SQL Concepts Demonstrated

- Database and table creation
- Primary keys and foreign keys
- `ENUM`, `DATE`, and other column data types
- Sample data insertion
- Index creation
- Views and joins
- Stored procedures and input parameters
- Triggers
- Aggregate functions such as `COUNT`, `SUM`, and `AVG`
- `GROUP BY` and `HAVING`
- Subqueries and correlated subqueries
- `LEFT JOIN`, filtering, and sorting/query logic

## Technologies Used

- **Database:** MySQL
- **Language:** SQL
- **Design:** Entity–Relationship (ER) diagram

## Project Files

```text
Blood-Bank-Management-System/
├── BLOOD BANK MANAGEMENT SYSTEM.sql
├── Blood Bank Management System.png
└── README.md
```

The filenames shown above match the uploaded files. You may rename them to simpler GitHub-friendly names if you prefer, and update the README references accordingly.

## Getting Started

### Prerequisites

- MySQL Server 8.0 or a compatible MySQL version
- MySQL Workbench, or another SQL client that can execute MySQL scripts

### Installation and Setup

1. Clone or download this repository.
2. Open MySQL Workbench and connect to your local MySQL server.
3. Open `BLOOD BANK MANAGEMENT SYSTEM.sql`.
4. Execute the script from top to bottom.
5. Refresh the **Schemas** panel and select `Bloodbank_db` to inspect the created database.

Alternatively, run the script from a terminal:

```bash
mysql -u root -p < "BLOOD BANK MANAGEMENT SYSTEM.sql"
```

> **Important:** The script starts with `DROP DATABASE IF EXISTS Bloodbank_db;`. Running it will delete and recreate an existing database with that name. Back up any important data before execution.

## Explore the Database

After running the script, try these queries:

```sql
USE Bloodbank_db;

-- View the available stock records
SELECT * FROM available_blood_stock;

-- View donors with their blood group names
SELECT * FROM donor_details;

-- View pending blood requests
SELECT * FROM pending_blood_requests;

-- Summarize donations by blood group
SELECT * FROM blood_donation_summary;

-- Count donors in each blood group
SELECT bg.blood_group_name, COUNT(d.donor_id) AS donor_count
FROM blood_group AS bg
LEFT JOIN donor AS d
    ON bg.blood_group_id = d.blood_group_id
GROUP BY bg.blood_group_id, bg.blood_group_name;

-- Count requests by status
SELECT status, COUNT(*) AS request_count
FROM blood_request
GROUP BY status;
```

The SQL file also contains example calls and verification queries for the stored procedures and triggers.

## Stored Procedures

| Procedure | Purpose |
|---|---|
| `add_donor` | Inserts a donor record |
| `create_blood_request` | Creates a blood request with a pending status |
| `complete_blood_request` | Marks a request as completed |
| `check_blood_stock` | Returns the total stock units for a specified blood group ID |

Review the parameter definitions in the SQL file before calling a procedure. Use IDs that exist in your own data and avoid inserting duplicate primary keys.

## Views

| View | Description |
|---|---|
| `available_blood_stock` | Shows stock records with units available and an expiry date that is not in the past |
| `donor_details` | Combines donor details with blood group names |
| `pending_blood_requests` | Lists pending requests with patient, hospital, and blood group details |
| `blood_donation_summary` | Summarizes donation counts and donated units by blood group |

## Triggers

- `trg_update_donor_last_donation`: After a new donation is inserted, updates the corresponding donor's last donation date.
- `trg_deduct_blood_stock`: After a blood issue is inserted, subtracts the issued units from the referenced stock record.

**Note:** These triggers implement basic automation for demonstration. The script does not include all production safeguards, such as validating that stock is sufficient before an issue, preventing negative inventory, or wrapping related changes in a carefully managed transaction. Review and test these safeguards before using the design in a real system.

## ER Diagram

The ER diagram documents the main entities, their attributes, primary/foreign keys, and relationships.

![Blood Bank Management System ER Diagram](Blood%20Bank%20Management%20System.png)

If the image does not render after uploading, check that the image filename in the Markdown matches the exact filename committed to the repository.

## Limitations and Future Improvements

- Add validation to prevent issuing more units than are available.
- Ensure stock quantities cannot become negative.
- Validate donor eligibility and donation intervals according to applicable medical guidelines.
- Add transactions and error handling for multi-step operations.
- Add automatic reconciliation between donations and inventory.
- Strengthen data validation with appropriate `NOT NULL`, `CHECK`, and uniqueness constraints.
- Add application-level authentication, role-based access, and a user interface if expanding beyond a database-only project.
- Use synthetic or anonymized data; protect real donor and patient information.

## Disclaimer

This is an educational SQL database project, not a certified medical or blood-bank management application. The sample records are for demonstration. Blood compatibility, donor eligibility, expiry handling, and transfusion decisions must follow qualified medical and regulatory guidance.

## Author

**Usha Sri Yelleti**

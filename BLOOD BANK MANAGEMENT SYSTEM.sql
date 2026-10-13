-- =====================================================================
--  BLOOD BANK MANAGEMENT SYSTEM | END-TO-END MYSQL PROJECT
-- =====================================================================
--  Contents:
--    PART 1  : Database & Table Creation (schema)
--    PART 2  : Sample Data (INSERT statements)
--    PART 3  : Indexes
--    PART 4  : Views
--    PART 5  : Stored Procedures
--    PART 6  : Triggers
--    PART 7  : Query Bank - Level 1 (Basic Queries) 
--    PART 8  : Query Bank - Level 2 (Intermediate Queries) 
--    PART 9  : Query Bank - Level 3 (Advanced Queries) 
--    PART 10 :  Demo calls and verification
-- =====================================================================

-- =====================================================================
-- PART 1: DATABASE & TABLE CREATION
-- =====================================================================
DROP DATABASE IF EXISTS Bloodbank_db;
CREATE DATABASE Bloodbank_db;
USE Bloodbank_db;

------------ Strong Entity:Blood_Group ----------
create table blood_group(
blood_group_id int primary key, 
blood_group_name varchar(20)
);
------------ Strong Entity:Donor ----------
create table donor(
donor_id int primary key,
name varchar(20),
age int,
gender varchar(10),
phone varchar(15),
blood_group_id int, 
last_donation_date DATE,
FOREIGN KEY (blood_group_id) REFERENCES blood_group(blood_group_id)
);
------------ Strong Entity:Patient ----------
create table patient(
patient_id int primary key,
name varchar(50),
age int,
gender enum('Male','Female','Transgender','Prefer not to say') default 'Prefer not to say',
hospital_name varchar(50),
phone varchar(10) unique,
blood_group_id int,
foreign key (blood_group_id) references blood_group(blood_group_id)
);
------------ Strong Entity:Donation ----------
create table donation(
donation_id int primary key,
donor_id int,
blood_group_id int,
donation_date DATE,
units_donated int,
FOREIGN KEY (donor_id) references donor(donor_id),
foreign key (blood_group_id) references blood_group(blood_group_id));

------------ Strong Entity:Blood_Stock ----------
create table blood_stock(
stock_id int primary key,
blood_group_id int,
units_available int,
expiry_date DATE,
collection_date DATE,
foreign key (blood_group_id)references blood_group(blood_group_id));

------------ Strong Entity:Blood_Request ----------
create table blood_request(
request_id int primary key,
patient_id int,
status enum('Pending','Completed') default 'Pending',
request_date date,
units_required int,
Blood_group_id int,
foreign key (blood_group_id) references blood_group(blood_group_id),
foreign key (patient_id) references patient(patient_id)
);
------------ Strong Entity:Blood_Issue ----------
create table blood_issue(
issue_id int primary key,
request_id int,
stock_id int,
issue_date DATE,
units_issued int,
foreign key(request_id) references blood_request(request_id),
foreign key(stock_id) references blood_stock(stock_id));

show tables;
-- =====================================================================
-- PART 2:  Sample Data (INSERT statements)
-- =====================================================================
-- Blood_Group
insert into blood_group values
(1, 'O+'),
(2, 'O-'), 
(3, 'A+'),
(4, 'A-'),
(5, 'B+'),
(6, 'B-'),
(7, 'AB+'),
(8, 'AB-');


-- Donor
insert into donor values
(1, 'Rahul', 25, 'Male', '9876543210', 1, '2026-08-15'),
(2, 'Priya', 28, 'Female', '9846358726',2,'2026-07-20'),
(3, 'Arjun', 32, 'Male', '8643975468', 3, '2026-06-10'),
(4, 'Sneha', 24, 'Female', '8642835971', 4, '2026-08-05'),
(5, 'Kiran', 30, 'Male', '9730184687', 5, '2026-05-25'),
(6, 'Anjali', 27, 'Female', '9106728106', 6, '2026-07-12'),
(7, 'Vikram', 35, 'Male', '9604380344', 7, '2026-04-18'),
(8, 'Meena', 29, 'Female', '7603486297', 8, '2026-06-30'),
(9, 'Ravi', 26, 'Male', '7692468031',1,'2026-08-22'),
(10, 'Pooja', 31, 'Female', '9346800173', 2, '2026-05-15');



-- Patient
insert into patient values
(1, 'Aarav Sharma', 34, 'Male', 'Apollo Hospital', '9875462310', 1),
(2, 'Priya Verma', 28, 'Female', 'Fortis Healthcare', '9876543221', 3),
(3, 'Alex Mercer', 42, 'Transgender', 'Max Super Speciality', '9875654323', 2),
(4, 'Sam Taylor', 19, 'Prefer not to say', 'Apollo Hospital', '9876543824', 4),
(5, 'Rajesh Patel', 55, 'Male', 'Manipal Hospital', '9876543925', 1);



-- Donation
INSERT INTO donation
VALUES
(1, 1, 1, '2026-08-15', 1),
(2, 2, 2, '2026-07-20', 1),
(3, 3, 3, '2026-06-10', 2),
(4, 4, 4, '2026-08-05', 1),
(5, 5, 5, '2026-05-25', 1),
(6, 6, 6, '2026-07-12', 2),
(7, 7, 7, '2026-04-18', 1),
(8, 8, 8, '2026-06-30', 1),
(9, 9, 1, '2026-08-22', 1),
(10, 10, 2, '2026-05-15', 2);



-- Blood_Stock
INSERT INTO blood_stock
VALUES
(1, 1, 15, '2026-10-15', '2026-09-20'),
(2, 2, 10, '2026-10-18', '2026-09-23'),
(3, 3, 20, '2026-10-20', '2026-09-25'),
(4, 4, 8,  '2026-10-12', '2026-09-18'),
(5, 5, 12, '2026-10-22', '2026-09-27'),
(6, 6, 18, '2026-10-25', '2026-09-28'),
(7, 7, 7,  '2026-10-10', '2026-09-16'),
(8, 8, 14, '2026-10-19', '2026-09-24');


-- Blood_Request
insert into blood_request values
(101, 1, 'Pending', '2026-09-25', 2, 1),
(102, 2, 'Completed', '2026-09-26', 1, 3),
(103, 3, 'Pending', '2026-09-28', 3, 2),
(104, 1, 'Completed', '2026-09-29', 1, 1),
(105, 5, 'Pending', '2026-09-30', 2, 1);



-- Bloodd_issue
INSERT INTO blood_issue
VALUES
(1, 101, 1, '2026-09-21', 2),
(2, 102, 2, '2026-09-22', 1),
(3, 103, 3, '2026-09-23', 2),
(4, 104, 4, '2026-09-24', 1),
(5, 105, 5, '2026-09-25', 2),
(6, 101, 6, '2026-09-26', 1),
(7, 104, 7, '2026-09-27', 1),
(8, 102, 8, '2026-09-28', 2),
(9, 105, 1, '2026-09-29', 1),
(10, 103, 2, '2026-09-30', 1);


-- =====================================================================
-- PART 3: INDEXES
-- =====================================================================
CREATE INDEX idx_donor_blood_group ON donor(blood_group_id);
CREATE INDEX idx_patient_blood_group ON patient(blood_group_id);
CREATE INDEX idx_donation_donor ON donation(donor_id);
CREATE INDEX idx_donation_blood_group ON donation(blood_group_id);
CREATE INDEX idx_stock_blood_group ON blood_stock(blood_group_id);
CREATE INDEX idx_request_patient ON blood_request(patient_id);
CREATE INDEX idx_request_blood_group ON blood_request(blood_group_id);
CREATE INDEX idx_request_status ON blood_request(status);
CREATE INDEX idx_issue_request ON blood_issue(request_id);
CREATE INDEX idx_issue_blood_group ON blood_issue(stock_id);
-- Verify indexes:
-- show index from donor


-- =====================================================================
-- PART 4: VIEWS
-- =====================================================================
-- View 1: Available Blood Stock
CREATE VIEW available_blood_stock AS
SELECT
    bg.blood_group_name,
    bs.stock_id,
    bs.units_available,
    bs.collection_date,
    bs.expiry_date
FROM blood_stock bs
JOIN blood_group bg
    ON bs.blood_group_id = bg.blood_group_id
WHERE bs.units_available > 0
  AND (bs.expiry_date IS NULL OR bs.expiry_date >= CURDATE());
  

-- view2:Donor Details
CREATE VIEW donor_details AS
SELECT
    d.donor_id,
    d.name AS donor_name,
    d.age,
    d.gender,
    bg.blood_group_name,
    d.phone,
    d.last_donation_date
FROM donor d
JOIN blood_group bg
   ON d.blood_group_id = bg.blood_group_id;

-- View 3: Pending Blood Requests
CREATE VIEW pending_blood_requests AS
SELECT
    br.request_id,
    p.name AS patient_name,
    p.hospital_name,
    bg.blood_group_name,
    br.units_required,
    br.request_date,
    br.status
FROM blood_request br
JOIN patient p
    ON br.patient_id = p.patient_id
JOIN blood_group bg
    ON br.blood_group_id = bg.blood_group_id
WHERE br.status = 'Pending';

-- View 4: Blood Donation Summary
CREATE VIEW blood_donation_summary AS
SELECT
    bg.blood_group_name,
    COUNT(d.donation_id) AS total_donations,
    SUM(d.units_donated) AS total_units_donated
FROM donation d
JOIN blood_group bg
    ON d.blood_group_id = bg.blood_group_id
GROUP BY bg.blood_group_name;
select * from blood_donation_summary;


-- =====================================================================
-- --    PART 5  : Stored Procedures
-- =====================================================================

-- Procedure 1: Add Donor
DELIMITER //

create procedure add_donor(
in p_donor_id int,
in p_name varchar(20),
in P_age int,
in p_gender varchar(10),
in p_blood_group_id int,
in p_phone varchar(15),
in p_last_donation_date date
)
begin
	insert into donor
    (
	 donor_id,
      name,
      age,
      gender,
      blood_group_id,
      phone,
      last_donation_date
     )
    values
    ( 
		p_donor_id,
		p_name,
        p_age,
        p_gender,
        p_blood_group_id,
        p_phone,
        p_last_donation_date
	);
end //

DELIMITER ;


-- Procedure 2: Create_Blood_Request

DELIMITER //
create procedure create_blood_request(
in p_request_id int,
in p_patient_id int,
in p_units_required int,
in p_blood_group_id int
)
BEGIN
	insert into blood_request(
		request_id,
        patient_id,
        status,
        request_date,
        units_required,
        blood_group_id
)
values(
	p_request_id,
    p_patient_id,
    'pending',
    curdate(),
    p_units_required,
    p_blood_group_id
);
End //
DELIMITER ;


-- Procedure 3:Complete_Blood_Request;
DELIMITER //
create procedure complete_blood_request(
	in p_request_id int
)
BEGIN
	update blood_request
    set status='Completed'
    where request_id=p_request_id;
End //
DELIMITER ;

-- Procedure 4: Check_Blood_Stock;
DELIMITER //

CREATE PROCEDURE check_blood_stock(
    IN p_blood_group_id INT
)
BEGIN
    SELECT 
        IFNULL(SUM(units_available), 0) AS total_units
    FROM blood_stock
    WHERE blood_group_id = p_blood_group_id;
END //

DELIMITER ;


-- =====================================================================
--  PART 6  : Triggers
-- =====================================================================
-- Trigger 1: Automatically update donor's last donation date on new donation
DELIMITER //

CREATE TRIGGER trg_update_donor_last_donation
AFTER INSERT ON donation
FOR EACH ROW
BEGIN
    UPDATE donor
    SET last_donation_date = NEW.donation_date
    WHERE donor_id = NEW.donor_id;
END //

DELIMITER ;

INSERT INTO donation (donation_id, donor_id, blood_group_id, donation_date, units_donated)
VALUES (11, 1, 1, '2026-10-10', 1);
SELECT donor_id, name, last_donation_date FROM donor WHERE donor_id = 1;

-- Trigger 2: Automatically deduct units available when blood is issued
DELIMITER //

CREATE TRIGGER trg_deduct_blood_stock
AFTER INSERT ON blood_issue
FOR EACH ROW
BEGIN
    UPDATE blood_stock
    SET units_available = units_available - NEW.units_issued
    WHERE stock_id = NEW.stock_id;
END //

DELIMITER ;

-- =====================================================================
-- PART 7: QUERY BANK - BASIC
-- =====================================================================

-- Q1. Display all blood groups.
SELECT * FROM blood_group;

-- Q2. Display all donors.
SELECT * FROM donor;

-- Q3. Display all patients.
SELECT * FROM patient;

-- Q4. Display all blood-stock records.
SELECT * FROM blood_stock;

-- Q5. Display donors who belong to O+.
SELECT d.*
FROM donor AS d
JOIN blood_group AS bg ON d.blood_group_id = bg.blood_group_id
WHERE bg.blood_group_name = 'O+';

-- Q6. Find donors older than 25.
SELECT *
FROM donor
WHERE age > 25;

-- Q7. Find pending blood requests.
SELECT *
FROM blood_request
WHERE status = 'Pending';

-- Q8. Find stock records with more than 5 units.
SELECT *
FROM blood_stock
WHERE units_available > 5;


-- =====================================================================
-- PART 8: QUERY BANK - INTERMEDIATE
-- =====================================================================

-- Q9. Count donors by blood group.
SELECT bg.blood_group_name, COUNT(d.donor_id) AS donor_count
FROM blood_group AS bg
LEFT JOIN donor AS d ON bg.blood_group_id = d.blood_group_id
GROUP BY bg.blood_group_id, bg.blood_group_name;

-- Q10. Total units donated by each blood group.
SELECT bg.blood_group_name,
       ifnull(SUM(dn.units_donated), 0) AS total_units_donated
FROM blood_group AS bg
LEFT JOIN donation AS dn ON bg.blood_group_id = dn.blood_group_id
GROUP BY bg.blood_group_id, bg.blood_group_name;

-- Q11. Show requests with patient names and blood groups.
SELECT br.request_id, p.name AS patient_name, bg.blood_group_name,
       br.units_required, br.request_date, br.status
FROM blood_request AS br
JOIN patient AS p ON br.patient_id = p.patient_id
JOIN blood_group AS bg ON br.blood_group_id = bg.blood_group_id;

-- Q12. Show blood groups with total available, unexpired units.
SELECT bg.blood_group_name,
       ifnull(SUM(bs.units_available), 0) AS available_units
FROM blood_group AS bg
LEFT JOIN blood_stock AS bs
    ON bg.blood_group_id = bs.blood_group_id
   AND (bs.expiry_date IS NULL OR bs.expiry_date >= CURDATE())
GROUP BY bg.blood_group_id, bg.blood_group_name;

-- Q13. Find blood groups with more than 1 total donated units.
SELECT bg.blood_group_name, SUM(dn.units_donated) AS total_units
FROM blood_group AS bg
JOIN donation AS dn ON bg.blood_group_id = dn.blood_group_id
GROUP BY bg.blood_group_id, bg.blood_group_name
HAVING SUM(dn.units_donated) > 1;

-- Q14. Count requests by status.
SELECT status, COUNT(*) AS request_count
FROM blood_request
GROUP BY status;

-- Q15. Show each donor's total number of donations.
SELECT d.donor_id, d.name,
       COUNT(dn.donation_id) AS donation_count
FROM donor AS d
LEFT JOIN donation AS dn ON d.donor_id = dn.donor_id
GROUP BY d.donor_id, d.name;


-- =====================================================================
-- PART 9: QUERY BANK - ADVANCED
-- =====================================================================

-- Q16. Find donors who have donated more units than the average donation.
SELECT DISTINCT d.donor_id, d.name
FROM donor AS d
JOIN donation AS dn ON d.donor_id = dn.donor_id
WHERE dn.units_donated > (SELECT AVG(units_donated) FROM donation);

-- Q17. Find blood groups that currently have no stock records.
SELECT bg.blood_group_id, bg.blood_group_name
FROM blood_group AS bg
LEFT JOIN blood_stock AS bs ON bg.blood_group_id = bs.blood_group_id
WHERE bs.stock_id IS NULL;

-- Q18. Find patients with more than one request.
SELECT p.patient_id, p.name, COUNT(br.request_id) AS request_count
FROM patient AS p
JOIN blood_request AS br ON p.patient_id = br.patient_id
GROUP BY p.patient_id, p.name
HAVING COUNT(br.request_id) > 1;


-- Q19. Display the most recent donation for each donor.
SELECT d.donor_id, d.name, dn.donation_date, dn.units_donated
FROM donor AS d
JOIN donation AS dn ON d.donor_id = dn.donor_id
WHERE dn.donation_date = (
    SELECT MAX(dn2.donation_date)
    FROM donation AS dn2
    WHERE dn2.donor_id = d.donor_id
);
-- =====================================================================
-- PART 10: DEMO CALLS AND VERIFICATION
-- =====================================================================
-- Check that the seven tables exist.
SHOW TABLES;

-- check of how many views 
show full tables where table_type='VIEW'
-- Test views.
SELECT * FROM available_blood_stock;
SELECT * FROM blood_donation_summary;
SELECT * FROM donor_details;
SELECT * FROM pending_blood_requests;

-- Test stored procedures using IDs that exist in your own tables.
 -- call add_donor('values')
 -- call check_blood_stock(1);
 -- call complete_blood_request(103)
 -- call create_blood_request('values')
 
 -- Verify triggers.
 SHOW TRIGGERS;
-- trigger 1
-- SELECT donor_id, name, last_donation_date FROM donor WHERE donor_id = 1;
-- INSERT INTO donation (donation_id, donor_id, blood_group_id, donation_date, units_donated) 
-- VALUES (11, 1, 1, '2026-10-10', 1);
-- SELECT donor_id, name, last_donation_date FROM donor WHERE donor_id = 1;

-- trigger 2
-- SELECT stock_id, units_available FROM blood_stock WHERE stock_id = 2;
-- INSERT INTO blood_issue (issue_id, request_id, stock_id, issue_date, units_issued)
-- VALUES (11, 103, 2, CURDATE(), 3);
-- SELECT stock_id, units_available FROM blood_stock WHERE stock_id = 2;

-- =====================================================================
-- END OF BLOOD BANK MANAGEMENT SYSTEM PROJECT SCRIPT
-- =====================================================================

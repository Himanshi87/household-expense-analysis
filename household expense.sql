-- creating table for expense--
CREATE TABLE expenses (
    expense_id SERIAL PRIMARY KEY,
    expense_date DATE NOT NULL,
    subcategory_id INTEGER NOT NULL,
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    payment_method_id INTEGER NOT NULL,
    member_id INTEGER,
    vendor_id INTEGER,
    is_recurring BOOLEAN DEFAULT FALSE
);

--creating table for expense categories--
CREATE TABLE expense_categories (
category_id SERIAL PRIMARY KEY,
category_name VARCHAR(100) NOT NULL UNIQUE, 
description TEXT 
);

--adding values in table expense with their discription--
INSERT INTO expense_categories 
(category_name, description)
VALUES
('Groceries', 'Daily household grocery and food purchases'),
('Utilities', 'Household utility bills and services'),
('Transportation', 'Travel and vehicle-related expenses'),
('Food & Dining', 'Restaurant and food delivery expenses'),
('Medical', 'Healthcare and medical-related expenses'),
('Education', 'Education and learning-related expenses');

INSERT INTO expense_categories
(category_name, description)
VALUES
('Clothing', 'Clothing and fashion-related expenses');

--creating tabl
CREATE TABLE expense_subcategories (
    subcategory_id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL,
    subcategory_name VARCHAR(100) NOT NULL,
    june NUMERIC(12,2) NOT NULL CHECK (june >= 0),
    july NUMERIC(12,2) NOT NULL CHECK (july >= 0),
    august NUMERIC(12,2) NOT NULL CHECK (august >= 0)
);

INSERT INTO expense_subcategories
(category_id, subcategory_name, june,july,august)
VALUES
(1, 'Kirana', 9000, 10000,9500),
(1, 'Vegetables', 2500,2000,2500),
(1, 'Fruits', 1500,1200,1000),
(1, 'Milk', 2400,2000,2300),
(2, 'Electricity', 1500,2000,1000),
(2, 'Gas', 1000, 950,1000),
(2, 'Internet',859,1129,1129),
(3, 'Petrol',1500,1200,1500),
(3, 'Auto/Taxi',200,50,100),
(3, 'Bus',1200,1300,1200),
(4, 'Restaurant',3000,3000,4000),
(4, 'Food Delivery', 1200,1500,1000),
(5, 'Medicines',2100,2000,2500),
(5, 'Doctor Consultation',400,300,500),
(5, 'Medical Tests',1000,900,1300),
(6, 'College Fees',9750,9750,19750),
(6, 'Books & Stationery',100,200,100),
(6, 'Room Rent',2200,2200,2200),
(6, 'Mess Rent',2200,2200,2200),
(6, 'Courses / Training',20000,20000,20000),
(7, 'Clothes', 2500,2000,1900),
(7, 'Accessories',100,300,500);

select * from expense_subcategories
CREATE TABLE payment_methods (
    payment_method_id SERIAL PRIMARY KEY,
    payment_method_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(200)
);

INSERT INTO payment_methods
(payment_method_name, description)
VALUES
('Cash', 'Payment made using physical cash'),
('UPI', 'Payment made using Unified Payments Interface'),
('Net Banking', 'Payment made through online banking');
CREATE TABLE family_members (
    member_id SERIAL PRIMARY KEY,
    member_name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50) NOT NULL,
    is_money_provider BOOLEAN DEFAULT FALSE
);
INSERT INTO family_members
(member_name, relationship, is_money_provider)
VALUES
('Me', 'Self', FALSE),
('Father', 'Father', TRUE),
('Sister', 'Sister', TRUE),
('Grandmother', 'Grandmother', FALSE);

CREATE TABLE vendors (
    vendor_id SERIAL PRIMARY KEY,
    vendor_name VARCHAR(150) NOT NULL UNIQUE
);
INSERT INTO vendors
(vendor_name)
VALUES
--groceries--
('S mart'),
('Local Vegetable Market'),
('Local Fruit Market'),
('Sharma milk shop'),

-- Utilities
('MSEDCL'),
('Municipal Water Department'),
('Indane Gas Agency'),
('Jio,Airtel,VI'),

-- Transportation
('Indian Oil Petrol Pump'),
('Local Auto Service'),
('MSRTC'),

-- Food & Dining
('Reataurant'),
('Swiggy'),

-- Medical
('Local Medical Store'),
('Local Clinic'),
('PathLabs'),

-- Education
('College Administration'),
('Local Stationery Shop'),

-- Clothing
('Reliance Trends'),
('Loacal Fashion Shops'),
('Local Accessories Shop')

SELECT * FROM expense_categories
SELECT * FROM expense_subcategories

--1.Maintain household expenses systematically.--
SELECT
    ec.category_name AS category,
    es.subcategory_name AS subcategory,
    es.june AS june_expense,
    es.july AS july_expense,
    es.august AS august_expense
FROM expense_subcategories es
JOIN expense_categories ec
    ON es.category_id = ec.category_id
ORDER BY ec.category_name, es.subcategory_name;
--2.	Categorize different types of expenses.--
SELECT
    ec.category_name AS category,
    es.subcategory_name AS subcategory
FROM expense_categories ec
JOIN expense_subcategories es
    ON ec.category_id = es.category_id
ORDER BY ec.category_name, es.subcategory_name;
--3.	Track expenses associated with family members.--

SELECT
    member_id,
    member_name,
    relationship,
    is_money_provider
FROM family_members;
SELECT
    fm.member_name,
    fm.relationship,
    SUM(e.amount) AS total_expense
FROM expenses e
JOIN family_members fm
    ON e.member_id = fm.member_id
GROUP BY
    fm.member_id,
    fm.member_name,
    fm.relationship
ORDER BY total_expense DESC;
--4.	Record different payment methods.--
SELECT*
FROM payment_methods
ORDER BY payment_method_id;

SELECT
    pm.payment_method_name,
    COUNT(e.expense_id) AS number_of_transactions,
    SUM(e.amount) AS total_expense
FROM payment_methods pm
LEFT JOIN expense_subcategorie
    ON pm.payment_method_id = e.payment_method_id
GROUP BY
    pm.payment_method_id,
    pm.payment_method_name
ORDER BY total_expense DESC;

--5.	Track vendors/service providers.--
SELECT
    v.vendor_name,
    COUNT(e.expense_id) AS number_of_transactions,
    SUM(e.amount) AS total_expense
FROM vendors v
LEFT JOIN expenses e
    ON v.vendor_id = e.vendor_id
GROUP BY v.vendor_id, v.vendor_name
ORDER BY total_expense DESC;
--6.	Identify high-value expenses.--
SELECT
    e.expense_id,
    e.expense_date,
    ec.category_name AS category,
    es.subcategory_name AS subcategory,
    e.amount,
    fm.member_name,
    v.vendor_name
FROM expenses e
JOIN expense_subcategories es
    ON e.subcategory_id = es.subcategory_id
JOIN expense_categories ec
    ON es.category_id = ec.category_id
LEFT JOIN family_members fm
    ON e.member_id = fm.member_id
LEFT JOIN vendors v
    ON e.vendor_id = v.vendor_id
WHERE e.amount > 5000
ORDER BY e.amount DESC;
--7.	Understand recurring expenses.--
SELECT
    e.expense_date,
    ec.category_name AS category,
    es.subcategory_name AS subcategory,
    e.amount,
    fm.member_name,
    v.vendor_name
FROM expenses e
JOIN expense_subcategories es
    ON e.subcategory_id = es.subcategory_id
JOIN expense_categories ec
    ON es.category_id = ec.category_id
LEFT JOIN family_members fm
    ON e.member_id = fm.member_id
LEFT JOIN vendors v
    ON e.vendor_id = v.vendor_id
WHERE e.is_recurring = TRUE
ORDER BY e.expense_date;
SELECT
    SUM(amount) AS total_recurring_expense
FROM expenses
WHERE is_recurring = TRUE;
--8.	Compare expenditure across three months.--
SELECT
    SUM(june) AS total_june,
    SUM(july) AS total_july,
    SUM(august) AS total_august
FROM expense_subcategories;
SELECT
    'June' AS month,
    SUM(june) AS total_expense
FROM expense_subcategories

UNION ALL

SELECT
    'July' AS month,
    SUM(july) AS total_expense
FROM expense_subcategories

UNION ALL

SELECT
    'August' AS month,
    SUM(august) AS total_expense
FROM expense_subcategories;
--9.	Identify major spending areas.--
SELECT
    ec.category_name AS category,
    SUM(es.june) AS june_total,
    SUM(es.july) AS july_total,
    SUM(es.august) AS august_total,
    SUM(es.june + es.july + es.august) AS three_month_total
FROM expense_subcategories es
JOIN expense_categories ec
    ON es.category_id = ec.category_id
GROUP BY ec.category_id, ec.category_name
ORDER BY three_month_total DESC;

SELECT
    ec.category_name AS category,
    SUM(es.june + es.july + es.august) AS three_month_total
FROM expense_subcategories es
JOIN expense_categories ec
    ON es.category_id = ec.category_id
GROUP BY ec.category_id, ec.category_name
ORDER BY three_month_total DESC
LIMIT 1;
--10.	Find opportunities to control unnecessary expenditure.this--
SELECT
    ec.category_name AS category,
    SUM(es.june) AS june_total,
    SUM(es.july) AS july_total,
    SUM(es.august) AS august_total
FROM expense_subcategories es
JOIN expense_categories ec
    ON es.category_id = ec.category_id
GROUP BY ec.category_id, ec.category_name
HAVING SUM(es.july) > SUM(es.june)
   AND SUM(es.august) > SUM(es.july)
ORDER BY august_total DESC;

SELECT
    ec.category_name AS category,
    es.subcategory_name AS subcategory,
    es.june,
    es.july,
    es.august
FROM expense_subcategories es
JOIN expense_categories ec
    ON es.category_id = ec.category_id
WHERE es.july > es.june
  AND es.august > es.july
ORDER BY es.august DESC;

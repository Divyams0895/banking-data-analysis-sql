CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    city VARCHAR(50),
    state VARCHAR(50),
    email VARCHAR(100),
    phONe VARCHAR(15),
    registration_date DATE
);

CREATE TABLE branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    ifsc_code VARCHAR(20)
);

CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    branch_id INT,
    account_type VARCHAR(30),
    account_balance DECIMAL(15,2),
    account_opening_date DATE,
    account_status VARCHAR(20),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    transaction_date DATETIME,
    transaction_type VARCHAR(30),
    transaction_amount DECIMAL(15,2),
    transaction_mode VARCHAR(30),
    transaction_status VARCHAR(20),
    DESCriptiON VARCHAR(255),

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    branch_id INT,
    loan_type VARCHAR(50),
    loan_amount DECIMAL(15,2),
    INterest_rate DECIMAL(5,2),
    loan_start_date DATE,
    loan_end_date DATE,
    loan_status VARCHAR(30),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);

CREATE TABLE loan_payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    loan_id INT,
    payment_date DATE,
    payment_amount DECIMAL(15,2),
    payment_status VARCHAR(20),

    FOREIGN KEY (loan_id)
        REFERENCES loans(loan_id)
);

CREATE TABLE cards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    card_type VARCHAR(20),
    issue_date DATE,
    expiry_date DATE,
    card_status VARCHAR(20),

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    issue_category VARCHAR(100),
    ticket_date DATE,
    resolution_date DATE,
    ticket_status VARCHAR(30),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

show tables;

SELECT * FROM customers;

-- 1	Find the total number of customers.
SELECT DISTINCT COUNT(customer_id) FROM customers; 

-- 2	Find the total number of accounts.
SELECT DISTINCT COUNT(account_id) FROM accounts; 

-- 3	Find the total number of transactions.
SELECT DISTINCT COUNT(transaction_id) FROM transactions; 

-- 4	Find the total number of branches.
SELECT DISTINCT COUNT(branch_id) FROM branches;
 
-- 5	Find the different types of bank accounts.
SELECT DISTINCT account_type FROM accounts; 

-- 6	Find the number of customers IN each state.
SELECT state,COUNT(customer_id) FROM customers GROUP BY state;

-- 7	Identify NULL values IN every table.
SELECT *
FROM accounts
WHERE customer_id IS NULL
   OR branch_id IS NULL
   OR account_type IS NULL
   OR account_balance IS NULL
   OR account_opening_date IS NULL
   OR account_status IS NULL;

-- 8	Identify duplicate emails IN the customers table.
SELECT email, COUNT(*) AS duplicate_count FROM customers GROUP BY email HAVING COUNT(*) > 1;

-- 9	Find the top 10 oldest customers.
SELECT * FROM customers ORDER BY registration_date ASc LIMIT 10;

-- 10	Calculate the number of male and female customers.
SELECT gender,COUNT(customer_id) AS total_customers FROM customers WHERE gender IN('Female','Male') GROUP BY gender;

-- 11	Find customers who have more than ONe bank account.
SELECT c.* FROM customers c JOIN accounts a ON c.customer_id=a.customer_id GROUP BY c.customer_id havINg COUNT(a.account_id)>1;

-- 12	Find customers who JOINed the bank IN each year.
SELECT YEAR(registration_date) AS year,COUNT(customer_id) AS total_customers FROM customers GROUP BY year;

-- 13	Find customers who do NOT have any bank accounts.
SELECT c.* FROM customers c LEFT JOIN accounts a ON c.customer_id=a.customer_id WHERE a.account_id IS NULL;

-- 14	Find the number of customers IN each city.
SELECT city,COUNT(customer_id) AS total_customers FROM customers GROUP BY city;

-- 15	Calculate the average age of bank customers.
SELECT AVG(timestampdiff(year,date_of_birth,curdate())) AS average_age FROM customers;

-- 16	Find the total balance across all bank accounts.
SELECT SUM(account_balance) AS total_balance FROM accounts;

-- 17	Find the average balance by account type.
SELECT account_type, AVG(account_balance) AS average_balance FROM accounts GROUP BY account_type;

-- 18	Identify the top 10 accounts with the highest balances.
SELECT * FROM accounts ORDER BY account_balance DESC LIMIT 10;

-- 19	Find the number of active, INactive and dormant accounts.
SELECT account_status,COUNT(account_id) AS total_accounts FROM accounts GROUP BY account_status;

-- 20	Find customers who have both SavINgs and Current accounts.
SELECT c.* FROM customers c JOIN accounts a ON c.customer_id=a.customer_id WHERE a.account_type 
IN('Savings','Current') GROUP BY c.customer_id HAVING COUNT(DISTINCT a.account_type)=2;

-- 21	Identify accounts that have never had a transaction.
SELECT a.* FROM accounts a LEFT JOIN transactions t ON a.account_id=t.account_id WHERE t.account_id IS NULL;

-- 22	Find the branch with the highest total account balance.
SELECT b.branch_name,SUM(a.account_balance) AS highest_balance FROM branches b JOIN accounts a ON b.branch_id=a.branch_id 
GROUP BY b.branch_id,b.branch_name ORDER BY highest_balance DESC LIMIT 1;

-- 23	Calculate the total number of successful transactions.
SELECT COUNT(transaction_id) AS success_transactions FROM transactions WHERE transaction_status='Success';

-- 24	Calculate the total deposit amount.
SELECT SUM(transaction_amount) AS total_amount FROM transactions WHERE transaction_type='Credit' AND description='Cash deposit';

-- 25	Calculate the total withdrawal amount.
SELECT SUM(transaction_amount) AS total_amount FROM transactions WHERE transaction_type='Debit';

-- 26	Find the average transaction amount.
SELECT AVG(transaction_amount) AS average_transaction FROM transactions;

-- 27	Find the top 10 customers by transaction amount.
SELECT c.customer_id, c.first_name, c.last_name, SUM(t.transaction_amount) AS total_transaction_amount
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_transaction_amount DESC
LIMIT 10;

-- 28	Find the most commonly used transaction mode.
SELECT transaction_mode,COUNT(transaction_id) AS total_transactions FROM transactions 
GROUP BY transaction_mode 
ORDER BY total_transactions DESC LIMIT 1;

-- 29	Calculate monthly transaction volume.
SELECT YEAR(transaction_date) AS year,MONTHNAME(transaction_date) AS month,COUNT(transaction_id) AS total_transactions
FROM transactions GROUP BY YEAR(transaction_date),MONTH(transaction_date),MONTHNAME(transaction_date)
ORDER BY year,MONTH(transaction_date);

-- 30	Identify the month with the highest transaction amount.
SELECT YEAR(transaction_date) AS year,MONTHNAME(transaction_date) AS month,SUM(transaction_amount) AS total_amount
FROM transactions
GROUP BY YEAR(transaction_date),MONTH(transaction_date),MONTHNAME(transaction_date)
ORDER BY total_amount DESC
LIMIT 1;

-- 31	Find transactions above ₹1,00,000.
SELECT * FROM transactions WHERE transaction_amount>100000;

-- 32	Calculate the failed transaction percentage.
SELECT COUNT(CASE
	WHEN transaction_status='Failed'
    THEN transaction_id
END) * 100.0/COUNT(transaction_id) AS failed_percentage
FROM transactions;

-- 33	Calculate the total loan amount issued.
SELECT SUM(loan_amount) AS total_loan_amount FROM loans;

-- 34	Find the number of loans by loan type.
SELECT loan_type,COUNT(loan_id) total_loans FROM loans GROUP BY loan_type;

-- 35	Find the average loan amount by loan type.
SELECT loan_type,AVG(loan_amount) AS average_loan_amount FROM loans GROUP BY loan_type;

-- 36	Identify customers who have multiple loans.
SELECT CONCAT(c.first_name,' ',c.last_name) AS customer_name,COUNT(l.loan_id) AS total_loans
FROM customers c JOIN loans l ON c.customer_id=l.customer_id
GROUP BY c.customer_id, c.first_name,c.last_name
HAVING COUNT(l.loan_id) > 1;

-- 37	Calculate total successful loan repayments.
SELECT SUM(payment_amount) AS total_repayment FROM loan_payments WHERE payment_status='Paid';

-- 38	Find loans with late or missed payments.
SELECT l.* FROM loans l JOIN loan_payments lp ON l.loan_id=lp.loan_id WHERE lp.payment_status IN('Late','Missed');

-- 39	Find the number of accounts opened by each branch.
SELECT b.branch_name,COUNT(a.account_id) AS number_of_accounts 
FROM branches b LEFT JOIN accounts a ON b.branch_id=a.branch_id
GROUP BY b.branch_id,b.branch_name;

-- 40	Find the branch with the highest number of transactions.
SELECT b.branch_name,COUNT(t.transaction_id) AS number_of_transactions 
FROM branches b JOIN accounts a ON b.branch_id=a.branch_id
JOIN transactions t ON t.account_id=a.account_id
GROUP BY b.branch_id,b.branch_name ORDER BY number_of_transactions DESC LIMIT 1;

-- 41	Calculate branch-wise total transaction amount.
SELECT b.branch_name,SUM(t.transaction_amount) AS total_transaction_amount 
FROM branches b JOIN accounts a ON b.branch_id=a.branch_id
JOIN transactions t ON t.account_id=a.account_id
GROUP BY b.branch_id,b.branch_name;

-- 42	Find the most common customer complaint category.
SELECT issue_category,COUNT(ticket_id) AS issue_counts FROM support_tickets 
GROUP BY issue_category ORDER BY issue_counts DESC LIMIT 1;

-- 43	Calculate the average ticket resolution time by issue category.
SELECT issue_category,AVG(DATEDIFF(resolution_date,ticket_date)) AS average_resolution_time FROM support_tickets 
GROUP BY issue_category;

-- 44	Rank the top 10 customers by total successful transaction amount.
SELECT CONCAT(c.first_name,' ',c.last_name) AS customer_name,SUM(t.transaction_amount) AS total_amount,
RANK() OVER(
		ORDER BY SUM(t.transaction_amount) DESC
    ) AS customer_rank
FROM customers c JOIN accounts a ON c.customer_id=a.customer_id
JOIN transactions t ON a.account_id=t.account_id 
WHERE t.transaction_status='Success'
GROUP BY c.customer_id,c.first_name,c.last_name
ORDER BY total_amount DESC LIMIT 10;

-- 45	Calculate month-over-month transaction growth percentage.
WITH monthly_transactions AS (
    SELECT
        YEAR(transaction_date) AS year,
        MONTH(transaction_date) AS month,
        SUM(transaction_amount) AS total_amount
    FROM transactions
    WHERE transaction_status = 'Success'
    GROUP BY
        YEAR(transaction_date),
        MONTH(transaction_date)
),
monthly_growth AS (
    SELECT
        year,
        month,
        total_amount,
        LAG(total_amount) OVER (
            ORDER BY year, month
        ) AS previous_month_amount
    FROM monthly_transactions
)
SELECT
    year,
    month,
    total_amount,
    previous_month_amount,
    ROUND(
        (total_amount - previous_month_amount)
        * 100.0 / NULLIF(previous_month_amount, 0),
        2
    ) AS growth_percentage
FROM monthly_growth
ORDER BY year, month;

-- 46	Find each customer's first and latest transaction date.
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    MIN(t.transaction_date) AS first_transaction_date,
    MAX(t.transaction_date) AS latest_transaction_date
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
JOIN transactions t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;
    
-- 47	Identify customers who haven't made a successful transaction in the last 90 days of the dataset.
WITH dataset_date AS (
    SELECT MAX(transaction_date) AS latest_date
    FROM transactions
)
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM accounts a
    JOIN transactions t
        ON a.account_id = t.account_id
    CROSS JOIN dataset_date d
    WHERE a.customer_id = c.customer_id
      AND t.transaction_status = 'Success'
      AND t.transaction_date >= DATE_SUB(
          d.latest_date, INTERVAL 90 DAY
      )
      AND t.transaction_date <= d.latest_date
);

-- 48	Calculate the running total of transactions for each account.
SELECT
    account_id,
    transaction_id,
    transaction_date,
    transaction_amount,
    SUM(transaction_amount) OVER (
        PARTITION BY account_id
        ORDER BY transaction_date, transaction_id
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS running_total
FROM transactions;

-- 49	Segment customers into High, Medium and Low-value customers based on total transaction amount.
WITH customer_totals AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(t.transaction_amount) AS total_amount
    FROM customers c
    JOIN accounts a
        ON c.customer_id = a.customer_id
    JOIN transactions t
        ON a.account_id = t.account_id
    WHERE t.transaction_status = 'Success'
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),
customer_segments AS (
    SELECT *,
        NTILE(3) OVER (
            ORDER BY total_amount DESC
        ) AS segment_number
    FROM customer_totals
)
SELECT
    customer_id,
    customer_name,
    total_amount,
    CASE
        WHEN segment_number = 1 THEN 'High'
        WHEN segment_number = 2 THEN 'Medium'
        WHEN segment_number = 3 THEN 'Low'
    END AS customer_segment
FROM customer_segments
ORDER BY total_amount DESC;

-- 50	Identify potentially unusual transactions based on unusually high transaction amounts or frequency.
WITH amount_stats AS (
    SELECT
        AVG(transaction_amount) AS avg_amount,
        STDDEV_POP(transaction_amount) AS std_amount
    FROM transactions
),
daily_frequency AS (
    SELECT
        account_id,
        DATE(transaction_date) AS transaction_day,
        COUNT(*) AS transaction_count
    FROM transactions
    GROUP BY account_id, DATE(transaction_date)
),
frequency_stats AS (
    SELECT
        AVG(transaction_count) AS avg_frequency,
        STDDEV_POP(transaction_count) AS std_frequency
    FROM daily_frequency
)
SELECT
    t.transaction_id,
    t.account_id,
    t.transaction_date,
    t.transaction_amount,
    df.transaction_count,
    CASE
        WHEN t.transaction_amount >
             ast.avg_amount + 2 * ast.std_amount
        THEN 'Unusually High Amount'

        WHEN df.transaction_count >
             fs.avg_frequency + 2 * fs.std_frequency
        THEN 'Unusually High Frequency'

    END AS unusual_reason

FROM transactions t
JOIN daily_frequency df
    ON t.account_id = df.account_id
    AND DATE(t.transaction_date) = df.transaction_day
CROSS JOIN amount_stats ast
CROSS JOIN frequency_stats fs
WHERE
    t.transaction_amount > ast.avg_amount + 2 * ast.std_amount
    OR
    df.transaction_count > fs.avg_frequency + 2 * fs.std_frequency;









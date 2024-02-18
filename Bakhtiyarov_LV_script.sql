--DROP TABLE task_1;
--DROP TABLE task_2_mid;
--DROP TABLE task_2;
--DROP TABLE task_3;
--DROP TABLE task_4_mid;
--DROP TABLE task_4;
--DROP TABLE task_5;
--DROP TABLE task_6;
--DROP TABLE task_7;
--DROP TABLE task_8;



-- TASK 1
----------------------------------
SELECT *, REPLACE(standard_cost, ',', '.') INTO task_1_mid
FROM transaction
WHERE standard_cost <> '';

ALTER TABLE task_1_mid DROP COLUMN standard_cost;
ALTER TABLE task_1_mid RENAME COLUMN replace TO standard_cost;
ALTER TABLE task_1_mid ALTER COLUMN standard_cost SET NOT NULL;

ALTER TABLE task_1_mid ALTER COLUMN standard_cost TYPE float4 USING standard_cost::float4;

SELECT DISTINCT brand INTO task_1
FROM task_1_mid
WHERE standard_cost > 1500;


-- TASK 2
----------------------------------
SELECT transaction_id INTO task_2
FROM transaction
WHERE (to_date(transaction_date, 'DD.MM.YYYY') between '2017-04-01' and '2017-04-09') and
       order_status = 'Approved';


-- TASK 3
----------------------------------
SELECT job_title INTO task_3
FROM customer
WHERE (job_industry_category = 'IT' OR 
       job_industry_category = 'Financial Services') AND 
       job_title LIKE 'Senior %';
      
      
-- TASK 4
----------------------------------
SELECT customer_id INTO task_4_mid
FROM customer
WHERE job_industry_category = 'Financial Services';
      
SELECT DISTINCT brand INTO task_4
FROM task_4_mid 
INNER JOIN transaction ON transaction.customer_id = task_4_mid.customer_id;

DROP TABLE task_4_mid;


-- TASK 5
----------------------------------
-- ЕСЛИ НУЖНО ПРОСТО ВЫБРАТЬ ЛЮБЫХ 10 КЛИЕНТОВ
SELECT customer_id INTO task_5
FROM transaction
WHERE online_order = TRUE AND 
     (brand = 'Giant Bicycles' OR brand = 'Norco Bicycles' OR brand = 'Trek Bicycles')
LIMIT 10;


-- TASK 6
----------------------------------
SELECT customer_id INTO task_6
FROM customer 
WHERE customer_id NOT IN 
   (
    SELECT customer_id
    FROM transaction
   );

  
-- TASK 7
----------------------------------
SELECT customer_id INTO task_7
FROM customer
WHERE job_industry_category = 'IT' AND
      customer_id IN 
    (
     SELECT customer_id
     FROM task_1_mid
     WHERE standard_cost = (SELECT MAX(standard_cost) FROM task_1_mid)
    );

   
-- TASK 8
----------------------------------
SELECT customer_id INTO task_8
FROM customer
WHERE job_industry_category = 'IT' OR job_industry_category = 'Health' AND 
      customer_id IN 
    (
     SELECT customer_id
     FROM transaction
     WHERE (to_date(transaction_date, 'DD.MM.YYYY') between '2017-07-07' and '2017-07-17') and
            order_status = 'Approved'
    );


----------------------------------
----------------------------------
DROP TABLE task_1_mid;
   
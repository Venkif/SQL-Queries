
--Inspecting Data
SELECT * FROM dbo.sales_data_sample

--Checking Unique Values
SELECT DISTINCT status FROM [dbo].[sales_data_sample]
SELECT DISTINCT year_id FROM [dbo].[sales_data_sample]
SELECT DISTINCT PRODUCTLINE FROM [dbo].[sales_data_sample]
SELECT DISTINCT COUNTRY FROM [dbo].[sales_data_sample]
SELECT DISTINCT DEALSIZE FROM [dbo].[sales_data_sample]
SELECT DISTINCT TERRITORY FROM [dbo].[sales_data_sample]

---ANALYSIS
----Let's start by grouping sales by productline, Year ID, Deal Size

SELECT PRODUCTLINE, SUM(SALES) Revenue
FROM [dbo].[sales_data_sample] 
GROUP BY PRODUCTLINE
ORDER BY 2 desc

SELECT YEAR_ID, SUM(sales) Revenue
FROM [dbo].[sales_data_sample]
GROUP BY YEAR_ID
ORDER BY 2 desc

SELECT DEALSIZE,  SUM(sales) Revenue
FROM [dbo].[sales_data_sample]
GROUP BY DEALSIZE
ORDER BY 2 desc


----What was the best month for sales in a specific year? How much was earned that month?
SELECT MONTH_ID, SUM(sales) Revenue, COUNT(ORDERNUMBER) Frequency
FROM [dbo].[sales_data_sample]
WHERE YEAR_ID = 2003 --change year to see the rest
GROUP BY MONTH_ID
ORDER BY 2 desc


--November seems to be the month, what product do they sell in November?
SELECT MONTH_ID,PRODUCTLINE, SUM(sales) Revenue, COUNT(ORDERNUMBER) Frequency
FROM [dbo].[sales_data_sample]
WHERE YEAR_ID = 2003 AND MONTH_ID = 11--change year to see the rest
GROUP BY MONTH_ID, PRODUCTLINE
ORDER BY 3 desc

--What city has the highest number of sales in a specific country
select city, sum (sales) Revenue
from [dbo].[sales_data_sample]
where country = 'UK'
group by city
order by 2 desc

---What is the best product in United States?
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from [dbo].[sales_data_sample]
where country = 'USA'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc
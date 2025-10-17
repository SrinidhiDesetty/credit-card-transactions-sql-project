# 💳 Credit Card Transactions SQL Analysis

This project analyzes a **Credit Card Transactions** dataset using SQL to uncover spending habits, trends, and insights such as city-wise spend patterns, gender-based contributions, and card-type performance.

---

## 📊 Dataset Source
Dataset: [Credit Card Spending Habits in India](https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india)

**Columns:**
- `transaction_id`
- `city`
- `transaction_date`
- `card_type`
- `exp_type`
- `gender`
- `amount`

---

## 🧠 Key SQL Concepts Used
- Aggregations: `SUM()`, `AVG()`, `COUNT()`
- Window Functions: `RANK()`, `DENSE_RANK()`, `LAG()`, `ROW_NUMBER()`
- Conditional Logic: `CASE WHEN`
- Common Table Expressions (CTEs)
- Date Functions: `YEAR()`, `MONTHNAME()`, `DAYNAME()`
- Subqueries and Percent Calculations

---

## 🧾 Sample Insights
1. Top 5 cities with the highest total spends and their contribution to total spending.  
2. Highest spending month per year and per card type.  
3. Cumulative analysis to identify when each card type reached ₹1,000,000 in total spending.  
4. Expense type with the highest and lowest spending per city.  
5. Percentage contribution of female customers by expense type.  
6. Card type and expense combination with the highest month-over-month growth.  
7. Weekend spending ratio and fastest city to reach 500 transactions.  

---

## 🚀 Tools & Environment
- SQL Server / MySQL
- Kaggle dataset
- Local database setup (for importing and exploring data)

---

## 🧩 How to Run
1. Download the dataset from Kaggle.  
2. Import it into your SQL environment as `credit_card_transactions`.  
3. Run the SQL file: `credit_card_transactions_project.sql`.  
4. Review query outputs and modify filters as needed.

---

## 🧑‍💻 Author
**Srinidhi Desetty**  
🎨 Passionate about Data Analytics, SQL, and turning raw data into insights.

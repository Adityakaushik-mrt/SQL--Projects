# 🧩 SQL Practice Questions: Level 1 — Basic SELECT

A beginner-friendly collection of foundational SQL queries designed to practice data retrieval, conditional filtering, and basic pattern matching.

---

## 📌 Topics Covered

- **Basic Selection:** `SELECT *`, specific column projections.
- **Filtering with `WHERE`:** Exact string matches and numerical threshold comparisons.
- **Pattern Matching:** Case-sensitive and wildcard searching using `LIKE ('A%', '%a')`.

---

## 🗂️ Database Schema Overview

The queries in this module assume the following standard relational tables:

| Table | Columns |
| :--- | :--- |
| `customers` | `customer_id`, `customer_name`, `city`, `gender`, ... |
| `products` | `product_id`, `product_name`, `category`, `unit_price`, `stock_qty`, ... |
| `orders` | `order_id`, `customer_id`, `order_date`, `status`, ... |

---

## 💻 SQL Queries & Solutions

### 1. Display all customers[cite: 1]
```sql
select * from customers;
```[cite: 1]

### 2. Display only customer name and city[cite: 1]
```sql
select customer_name,city from customers;
```[cite: 1]

### 3. Find all customers from Delhi[cite: 1]
```sql
select * from customers where city='Delhi';
```[cite: 1]

### 4. Find all female customers[cite: 1]
```sql
select * from customers where gender='Female';
```[cite: 1]

### 5. Display all products belonging to the Electronics category[cite: 1]
```sql
select * from products where category='Electronics';
```[cite: 1]

### 6. Find products with a unit price greater than ₹20,000[cite: 1]
```sql
select * from products where unit_price>'20000';
```[cite: 1]

### 7. Display products whose stock quantity is less than 20[cite: 1]
```sql
select * from products where stock_qty<'20';
```[cite: 1]

### 8. Find customers whose names start with A[cite: 1]
```sql
select * from customers where customer_name like 'A%';
```[cite: 1]

### 9. Find customers whose names end with a[cite: 1]
```sql
select * from customers where customer_name like '%a';
```[cite: 1]

### 10. Display orders having Completed status[cite: 1]
```sql
select * from orders where status='Completed';
```[cite: 1]

---
## 📬 Author

**Aditya Sharma **
Aspiring Data Analyst | SQL | Python | Power BI

---

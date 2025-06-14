# 🏦 Bank Customer Analysis – SQL Script

## 📝 Project Description  
Banking Intelligence aims to develop a supervised machine learning model to predict future customer behavior.  
The purpose of this SQL script is to create a **denormalized table** based on existing data, containing **indicators (features)** useful for model training.

## 🎯 Objective  
Create a **feature table at the customer level** (`id_cliente`) that combines:

- Customer personal information  
- Information about owned accounts  
- Details of performed transactions  

This table will serve as the foundation for training predictive models.

## 📌 Calculated Indicators  

### 🔹 Basic Indicators  
- Customer age  

### 🔹 Transactions (overall)  
- Number and total amount of incoming transactions  
- Number and total amount of outgoing transactions  

### 🔹 Accounts  
- Total number of accounts  
- Number of accounts by type:  
  - Base  
  - Business  
  - Personal  
  - Family  

### 🔹 Transactions by Account Type  
For each account type:
- Number of incoming and outgoing transactions  
- Total amount of incoming and outgoing transactions  

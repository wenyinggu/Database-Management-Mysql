#Wenying Gu 
#wenying.gu@vanderbilt.edu
#Project2_loanmega

-- create database
DROP DATABASE IF EXISTS  loans;
CREATE DATABASE IF NOT EXISTS  loans;
USE loans;

-- create mega table 
DROP TABLE IF EXISTS  loanmega;
CREATE TABLE IF NOT EXISTS loanmega(
loan_id    DOUBLE,                      
member_id   DOUBLE,                     
loan_amnt   DOUBLE,                      
funded_amnt   DOUBLE,                   
funded_amnt_inv    DOUBLE,             
term       VARCHAR(50),                    
int_rate     DECIMAL(10,2),                  
installment   DECIMAL(10,2),               
grade        VARCHAR(25),                  
sub_grade      VARCHAR(25),                  
emp_title      VARCHAR(100),            
emp_length         VARCHAR(100),               
home_ownership       VARCHAR(50),          
annual_inc           DOUBLE,          
issue_d             VARCHAR(50),         
loan_status         VARCHAR(50),              
purpose          VARCHAR(100),          
title            VARCHAR(100),                 
zip_code          VARCHAR(50),               
addr_state         VARCHAR(25),             
dti                 varchar(20),         
delinq_2yrs        DOUBLE,
earliest_cr_line      VARCHAR(50),         
mths_since_last_delinq     VARCHAR(25),      
revol_bal               DOUBLE,         
initial_list_status       VARCHAR(25),        
total_pymnt               DECIMAL(15,3),        
total_pymnt_inv             DECIMAL(15,2),      
total_rec_prncp               DECIMAL(10,2),    
total_rec_int                DECIMAL(10,2),    
total_rec_late_fee        DOUBLE,       
last_pymnt_d               VARCHAR(50),      
last_pymnt_amnt               DECIMAL(10,2),  
next_pymnt_d               VARCHAR(50),      
mths_since_last_major_derog     VARCHAR(25),
policy_code                   DOUBLE,   
application_type              VARCHAR(50),  
annual_inc_joint            VARCHAR(25),     
num_accts_ever_120_pd          DOUBLE,  
num_actv_bc_tl              DOUBLE,     
num_actv_rev_tl               DOUBLE,    
num_bc_sats                    DOUBLE,
num_bc_tl                      DOUBLE,  
num_il_tl                    DOUBLE,  
num_op_rev_tl                 DOUBLE,  
num_rev_accts                   DOUBLE,
num_rev_tl_bal_gt_0               DOUBLE,
num_sats                        DOUBLE, 
num_tl_120dpd_2m             varchar(200),
sec_app_earliest_cr_line       VARCHAR(50),
sec_app_mths_since_last_major_derog  VARCHAR(25),
disbursement_method          VARCHAR(50)
);


SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE '~/Desktop/dbms_pj2/lending-club-loan-data/loan_inf.csv' 
INTO TABLE loanmega
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
  
select *
from loanmega;
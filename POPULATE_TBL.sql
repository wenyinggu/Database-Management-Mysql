-- 1.GRADE_INFO;
DROP TABLE IF EXISTS GRADE_INFO;
CREATE TABLE  IF NOT EXISTS GRADE_INFO(
SUB_GRADE VARCHAR(25),
GRADE VARCHAR(25),
CONSTRAINT GRADE_INFO_PK
PRIMARY KEY (SUB_GRADE)
);



INSERT INTO GRADE_INFO
SELECT DISTINCT  SUB_GRADE,GRADE
FROM LOANMEGA 
ORDER BY GRADE,SUB_GRADE;

-- 2. MEMBER_BG;

DROP TABLE IF EXISTS MEMBER_BG;
CREATE TABLE  IF NOT EXISTS MEMBER_BG(
member_id   DOUBLE, 
emp_title      VARCHAR(100),            
emp_length         VARCHAR(100),     
annual_inc           DOUBLE,           
home_ownership       VARCHAR(50),          
zip_code          VARCHAR(50),               
addr_state         VARCHAR(25),  
CONSTRAINT MEMBER_BG_PK
PRIMARY KEY (member_id)
);

INSERT INTO MEMBER_BG
SELECT DISTINCT member_id, 
emp_title ,        
emp_length,  
annual_inc ,      
home_ownership ,       
zip_code ,           
addr_state 
FROM LOANMEGA ;


-- 3.LOAN_INF;
DROP TABLE IF EXISTS LOAN_INF;
CREATE TABLE  IF NOT EXISTS LOAN_INF(
loan_id   DOUBLE, 
member_id Double,
policy_code DOUBLE, 
purpose    VARCHAR(100),          
title      VARCHAR(100), 
loan_amnt   DOUBLE,    
issue_d     VARCHAR(50),                        
funded_amnt   DOUBLE,                   
funded_amnt_inv    DOUBLE,  
term       VARCHAR(50), 
installment   DECIMAL(10,2), 
int_rate     DECIMAL(10,2), 
disbursement_method   VARCHAR(50),
application_type     VARCHAR(50),  
SUB_GRADE VARCHAR(25),
CONSTRAINT LOAN_INF_PK
PRIMARY KEY (loan_Id),
CONSTRAINT LOAN_INF_FK1
FOREIGN KEY (SUB_GRADE)
REFERENCES GRADE_INFO(SUB_GRADE ),
CONSTRAINT LOAN_INF_FK2
FOREIGN KEY (member_id )
REFERENCES MEMBER_BG(member_id  )
);

INSERT INTO LOAN_INF
SELECT DISTINCT loan_id ,
member_id,
policy_code,
purpose ,         
title ,
loan_amnt,
issue_d ,                     
funded_amnt ,                 
funded_amnt_inv ,
term ,
installment ,
int_rate ,
disbursement_method ,
application_type ,
SUB_GRADE
FROM LOANMEGA ;


-- 4.OVERALL_ACC;
DROP TABLE IF EXISTS OVERALL_ACC;
CREATE TABLE  IF NOT EXISTS OVERALL_ACC(
member_id   DOUBLE,  
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
CONSTRAINT OVERALL_ACC_PK
PRIMARY KEY (member_id ),
CONSTRAINT OVERALL_ACC_FK
FOREIGN KEY (member_id )
REFERENCES MEMBER_BG(member_id  )
);

INSERT INTO OVERALL_ACC
SELECT DISTINCT member_id,
num_accts_ever_120_pd,
num_actv_bc_tl ,
num_actv_rev_tl ,
num_bc_sats ,
num_bc_tl ,
num_il_tl  ,
num_op_rev_tl ,
num_rev_accts ,
num_rev_tl_bal_gt_0 ,
num_sats ,
num_tl_120dpd_2m 
FROM LOANMEGA ;

-- 5.REPAY_ABILITY;
DROP TABLE IF EXISTS REPAY_ABILITY;
CREATE TABLE  IF NOT EXISTS REPAY_ABILITY(
member_id   DOUBLE,  
ndelinq_2yrs        DOUBLE,
earliest_cr_line      VARCHAR(50), 
dti                 varchar(20), 
mths_since_last_delinq     VARCHAR(25),      
revol_bal               DOUBLE,   
mths_since_last_major_derog     VARCHAR(25),
CONSTRAINT REPAY_ABILITY_PK
PRIMARY KEY (member_id ),
CONSTRAINT REPAY_ABILITY_FK
FOREIGN KEY (member_id )
REFERENCES MEMBER_BG(member_id  )
);

INSERT INTO REPAY_ABILITY
SELECT DISTINCT member_id,
delinq_2yrs ,
earliest_cr_line  ,
dti  ,
mths_since_last_delinq ,
revol_bal ,
mths_since_last_major_derog 
FROM LOANMEGA ;


-- 6.PAYMENT_INF;
DROP TABLE IF EXISTS PAYMENT_INF;
CREATE TABLE  IF NOT EXISTS PAYMENT_INF(
loan_id    DOUBLE,  
last_pymnt_d               VARCHAR(50),      
last_pymnt_amnt               DECIMAL(10,2),  
loan_status         VARCHAR(50),   
loan_amnt   DOUBLE, 
next_pymnt_d               VARCHAR(50), 
total_pymnt               DECIMAL(15,3),        
total_pymnt_inv             DECIMAL(15,2),      
total_rec_prncp               DECIMAL(10,2),    
total_rec_int                DECIMAL(10,2),    
total_rec_late_fee        DOUBLE ,     
CONSTRAINT PAYMENT_INF_PK
PRIMARY KEY (loan_id ),
CONSTRAINT PAYMENT_INF_FK
FOREIGN KEY (loan_id )
REFERENCES LOAN_INF(loan_id  )
);

INSERT INTO PAYMENT_INF
SELECT DISTINCT loan_id ,
last_pymnt_d ,
last_pymnt_amnt,
loan_status ,
loan_amnt ,
next_pymnt_d ,
total_pymnt ,     
total_pymnt_inv ,  
total_rec_prncp  ,
total_rec_int ,
total_rec_late_fee 
FROM LOANMEGA ;


-- 7.SEC_APPLICANT_INF;
DROP TABLE IF EXISTS SEC_APPLICANT_INF;
CREATE TABLE  IF NOT EXISTS SEC_APPLICANT_INF(
loan_id    DOUBLE,  
sec_app_earliest_cr_line       VARCHAR(50),
sec_app_mths_since_last_major_derog  VARCHAR(25), 
annual_inc_joint            VARCHAR(25),  
CONSTRAINT SEC_APPLICANT_INF_PK
PRIMARY KEY (loan_id ),
CONSTRAINT SEC_APPLICANT_INF_FK
FOREIGN KEY (loan_id )
REFERENCES LOAN_INF(loan_id)
);

INSERT INTO SEC_APPLICANT_INF
SELECT DISTINCT loan_id ,
sec_app_earliest_cr_line ,
sec_app_mths_since_last_major_derog ,
annual_inc_joint 
FROM LOANMEGA
WHERE APPLICATION_TYPE='Joint App' ;



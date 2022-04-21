

/**
This file is used to import loan_inf data to mysql system, create relations and build functionality.

The content is as below:


								===================================
									A. Create database
									B. Create mega table
									C. Populate tables
									D. Build functionalities
										- Create new account
										- Pay bill
										- Create new loan
								====================================
    
    
    **/
    
/**----------------- A. create database------------------------- **/

DROP DATABASE IF EXISTS  loans;
CREATE DATABASE IF NOT EXISTS  loans;
USE loans;

/**----------------- B. create mega table------------------------- **/


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
  
-- select * from loanmega;

/**------------------------- C. POPULATE TABLES -------------------------**/

USE LOANS;

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
member_id   DOUBLE AUTO_INCREMENT, 
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
loan_id   DOUBLE AUTO_INCREMENT,  
member_id Double,
policy_code DOUBLE,          
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


-- 8. account_set
DROP TABLE IF EXISTS account_set;
CREATE TABLE  IF NOT EXISTS account_set(
member_id DOUBLE,
pasword varchar(30),
CONSTRAINT account_set_PK
PRIMARY KEY (member_id ),
CONSTRAINT account_set_FK
FOREIGN KEY (member_id )
REFERENCES MEMBER_BG(member_id  )
);

INSERT INTO account_set
SELECT DISTINCT MEMBER_ID,MEMBER_ID 
FROM LOANMEGA;

-- 9. payment_audit
DROP TABLE IF EXISTS payment_audit;
CREATE TABLE  IF NOT EXISTS payment_audit(
payment_id int auto_increment,
loan_id double,
payment_amnt double,
payment_datetime datetime,
CONSTRAINT payment_audit_PK
PRIMARY KEY (payment_id),
CONSTRAINT payment_audit_FK
FOREIGN KEY (loan_id )
REFERENCES LOAN_INF(loan_id)
);

/**------------------------- D. BULD FUNCTIONALITY -------------------------**/

-- ////////////  Create new account ////////////////

DROP PROCEDURE IF EXISTS create_new_acc ;

DELIMITER //
CREATE PROCEDURE create_new_acc(
IN iemp_title VARCHAR(30),
IN iemp_length VARCHAR(30),
IN iannual_inc DOUBLE,
IN ihome_ownership VARCHAR(30),
IN izip_code VARCHAR(30),
IN iaddr_state VARCHAR(30),
OUT IMEMBER_ID DOUBLE)

BEGIN
	
	DECLARE SQL_ERROR INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET SQL_ERROR= TRUE;
    
    
	START TRANSACTION;

    
    INSERT INTO MEMBER_BG 
    (emp_title,emp_length,annual_inc,home_ownership,zip_code,addr_state)
	VALUES (iemp_title,iemp_length,iannual_inc,ihome_ownership,izip_code,iaddr_state);
    
	SELECT MAX(MEMBER_ID) 
    FROM MEMBER_BG
    INTO iMEMBER_ID;
    
    INSERT INTO account_set
    VALUES (iMEMBER_ID,iMEMBER_ID);
    

    IF SQL_ERROR=FALSE THEN
		COMMIT;
		SELECT 'COMMITTED SUCCESSFULLY' ;
	ELSE
		ROLLBACK;
        SELECT 'Your request failed' ;
	END IF;
END//

DELIMITER ;


-- ////////////  pay bill ////////////////

DROP PROCEDURE IF EXISTS pay_bill ;

DELIMITER //
CREATE PROCEDURE pay_bill(
IN ipay_amt DOUBLE,
IN ILOAN_ID DOUBLE)

BEGIN
	DECLARE LOAN_ST VARCHAR(30)  ;
    DECLARE ACTUAL_PYMNT DOUBLE  ;
    SELECT LOAN_STATUS INTO LOAN_ST FROM PAYMENT_INF WHERE LOAN_ID=ILOAN_ID;
    
    IF (LOAN_ST='Fully Paid') THEN
		ROLLBACK;
		SELECT "This loan is fully paid so you don't need to pay for it any more," AS MSG;
	ELSEIF (ipay_amt<=0) THEN
		ROLLBACK;
		SELECT 'The payment amount should be more than 0.' AS MSG;
	ELSE
		UPDATE PAYMENT_INF
		SET total_pymnt=total_pymnt+IPAY_AMT,
		last_pymnt_amnt =IPAY_AMT,
        LOAN_STATUS='Current',
		last_pymnt_d =CURDATE(),
		next_pymnt_d=CURDATE() + INTERVAL 1 MONTH
		WHERE LOAN_ID=ILOAN_ID;
        
        SELECT LAST_PYMNT_AMNT INTO ACTUAL_PYMNT 
        FROM PAYMENT_INF 
        WHERE LOAN_ID=ILOAN_ID;
        
        
        IF ACTUAL_PYMNT < IPAY_AMT THEN
			SELECT CONCAT('You only need to pay ', CONVERT(ACTUAL_PYMNT,CHAR),' to you loan ',CONVERT(ILOAN_ID,CHAR),' so your payment amount was automatically reduced.') AS MSG;
		ELSE 
			SELECT CONCAT('You successfully paid ',CONVERT(ACTUAL_PYMNT,CHAR),' to you loan ',CONVERT(ILOAN_ID,CHAR),'.') AS MSG;
		END IF;	
        
      
	END IF;
END//

DELIMITER ;



-- CREATE TRIGGER PAYMENT_INF_before_update

DROP TRIGGER IF EXISTS PAYMENT_INF_before_update;

DELIMITER //

CREATE TRIGGER PAYMENT_INF_before_update
BEFORE UPDATE
ON PAYMENT_INF
FOR EACH ROW
BEGIN
	IF (NEW.total_pymnt>=OLD.loan_amnt) THEN
		SET NEW.LOAN_STATUS='Fully paid';
		SET NEW.total_pymnt=OLD.loan_amnt;
        SET NEW.last_pymnt_amnt=OLD.loan_amnt-OLD.total_pymnt;
    END IF;
END //

DELIMITER ;


-- CREATE TRIGGER PAYMENT_INF_AFTER_update
DROP TRIGGER IF EXISTS PAYMENT_INF_AFTER_update;

DELIMITER //

CREATE TRIGGER PAYMENT_INF_AFTER_update
AFTER UPDATE
ON PAYMENT_INF
FOR EACH ROW
BEGIN
	IF (NEW.total_pymnt<>OLD.total_pymnt) THEN
		INSERT INTO payment_audit (LOAN_id,PAYMENT_AMNT,payment_datetime)
        VALUES (NEW.LOAN_ID,NEW.LAST_PYMNT_AMNT,NOW());
    END IF;
END //

DELIMITER ;


-- ////////////  create new loan ////////////////

DROP PROCEDURE IF EXISTS create_new_loan ;

DELIMITER //
CREATE PROCEDURE create_new_loan(
IN imember_id double,
IN ititle VARCHAR(30),
IN iterm VARCHAR(30),
IN idisbursement_method VARCHAR(30),
IN iapplication_type VARCHAR(30),
IN iloan_amnt DOUBLE,
OUT Iloan_ID DOUBLE)

BEGIN
	
	DECLARE SQL_ERROR INT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET SQL_ERROR= TRUE;
    
    
	START TRANSACTION;

    
    INSERT INTO loan_inf 
    (member_id,title,term,disbursement_method,application_type,loan_amnt)
	VALUES (imember_id,ititle,iterm,idisbursement_method,iapplication_type,iloan_amnt);
    
	SELECT MAX(loan_ID) 
    FROM loan_inf
    INTO iloan_ID;
    
    INSERT INTO payment_inf
    (loan_id,loan_status,loan_amnt,total_pymnt)
    VALUES (iloan_ID,'Current',iloan_amnt,0);
    

    IF SQL_ERROR=FALSE THEN
		COMMIT;
		SELECT 'COMMITTED SUCCESSFULLY' ;
	ELSE
		ROLLBACK;
        SELECT 'Your request failed' ;
	END IF;
END//

DELIMITER ;












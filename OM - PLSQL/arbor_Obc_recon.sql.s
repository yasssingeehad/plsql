CREATE OR REPLACE PROCEDURE ARBOR.B_ARBOR_OBC_ANALYSIS1 AS

CURSOR C1 IS
SELECT * FROM OBB_ACTIVE_SUBSCRIBER_BASE@OMPROD
WHERE SUBNO IS NOT NULL 
AND SUBNO LIKE '2%';

CURSOR C2 IS
SELECT A.EXTERNAL_ID FROM EXTERNAL_ID_EQUIP_MAP@BPPRODUCTION A, EXTERNAL_ID_EQUIP_MAP@BPPRODUCTION B
WHERE A.ACCOUNT_NO=B.ACCOUNT_NO
AND A.SUBSCR_NO=B.SUBSCR_NO
AND A.SUBSCR_NO_RESETS=B.SUBSCR_NO_RESETS
AND A.EXTERNAL_ID_TYPE=200
AND A.INACTIVE_DATE IS NULL
AND B.EXTERNAL_ID_TYPE=53
AND B.INACTIVE_DATE IS NULL
MINUS
SELECT SUBNO FROM OBB_ACTIVE_SUBSCRIBER_BASE@OMPROD
WHERE SUBNO IS NOT NULL 
AND SUBNO LIKE '2%';

ROW_C NUMBER;
ROW_C1 NUMBER;
ROW_C2 NUMBER:=0;
V_EXTERNAL_ID VARCHAR2(20);
V_SUBSCR_NO VARCHAR2(20);
V_ACCOUNT_NO VARCHAR2(20);
V_ACTIVE_DATE DATE;
V_ARBOR_RL_NO VARCHAR2(20);
V_ITEM_DATE DATE;
V_EXTERNAL_ACC_NO VARCHAR2(20);
V_RL_REF_NO VARCHAR2(20);

BEGIN
    FOR V1 IN C1 LOOP
        V_EXTERNAL_ID:=NULL;
        V_SUBSCR_NO:=NULL;
        V_ACCOUNT_NO:=NULL;
        V_ACTIVE_DATE:=NULL;
        V_EXTERNAL_ACC_NO:=NULL;
        V_ARBOR_RL_NO:=NULL;
        V_ITEM_DATE:=NULL;
        
        BEGIN
        SELECT EXTERNAL_ID,SUBSCR_NO,ACCOUNT_NO,ACTIVE_DATE INTO V_EXTERNAL_ID,V_SUBSCR_NO,V_ACCOUNT_NO,V_ACTIVE_DATE
        FROM EXTERNAL_ID_EQUIP_MAP@BPPRODUCTION
        WHERE EXTERNAL_ID=V1.SUBNO
        AND EXTERNAL_ID_TYPE=200
        AND INACTIVE_DATE IS NULL
        AND ROWNUM=1;
        EXCEPTION WHEN NO_DATA_FOUND THEN 
            V_EXTERNAL_ID :=NULL;
            V_SUBSCR_NO :=NULL;
            V_ACCOUNT_NO:=NULL;
            
        END;
        
        IF(V_EXTERNAL_ID IS NOT NULL) THEN
            BEGIN
                    SELECT A.EXTERNAL_ID INTO V_EXTERNAL_ACC_NO
                    FROM EXTERNAL_ID_ACCT_MAP@BPPRODUCTION A
                    WHERE A.ACCOUNT_NO=V_ACCOUNT_NO
                    AND A.EXTERNAL_ID_TYPE=100
                    AND A.INACTIVE_DATE IS NULL;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                    V_EXTERNAL_ACC_NO:=NULL;    
            END;
            
            V_RL_REF_NO:= V1.RLREFERENCENUMBER;
            IF(V1.RLREFERENCENUMBER LIKE '%A') THEN
                V_RL_REF_NO:=SUBSTR(V1.RLREFERENCENUMBER,1,LENGTH(V1.RLREFERENCENUMBER) - 1);
            END IF;
        
            BEGIN      
                SELECT COUNT(1)  INTO ROW_C FROM ORDER_ITEM_AUG05@OMPRODUCTION
                WHERE ACCOUNT_NO=V_ACCOUNT_NO
                AND ID_NO=V_SUBSCR_NO
                AND MEMBER_TYPE=16
                AND MEMBER_ID=53
                AND ACTION_CODE=1;

                IF(ROW_C>0) THEN
                    SELECT ORDER_ID,ITEM_DATE INTO V_ARBOR_RL_NO,V_ITEM_DATE
                    FROM ORDER_ITEM_AUG05@OMPRODUCTION
                    WHERE ACCOUNT_NO=V_ACCOUNT_NO
                    AND ID_NO=V_SUBSCR_NO
                    AND MEMBER_TYPE=16
                    AND MEMBER_ID=53
                    AND ACTION_CODE=1
                    AND ROWNUM=1;
                ELSE
                    SELECT COUNT(1) INTO ROW_C1 FROM ORDER_ITEM@OMPRODUCTION
                    WHERE ACCOUNT_NO=V_ACCOUNT_NO
                    AND ID_NO=V_SUBSCR_NO
                    AND MEMBER_TYPE=16
                    AND MEMBER_ID=53
                    AND ACTION_CODE=1;                
                    IF(ROW_C1>0) THEN
                        SELECT ORDER_ID,ITEM_DATE INTO V_ARBOR_RL_NO,V_ITEM_DATE
                        FROM ORDER_ITEM@OMPRODUCTION
                        WHERE ACCOUNT_NO=V_ACCOUNT_NO
                        AND ID_NO=V_SUBSCR_NO
                        AND MEMBER_TYPE=16
                        AND MEMBER_ID=53
                        AND ACTION_CODE=1
                        AND ROWNUM=1;
                    ELSE
                        V_ARBOR_RL_NO:=NULL;
                        V_ITEM_DATE:=NULL;    
                    END IF;    
                END IF;
            END;
            
            BEGIN
                    INSERT INTO ARBOR_NEP_OBC_DATA_1 VALUES(V_EXTERNAL_ACC_NO,V1.ACCOUNT_LINK_CODE_N,V_EXTERNAL_ID,V_SUBSCR_NO,V1.RLREFERENCENUMBER,V_ARBOR_RL_NO,V_ACTIVE_DATE,V_ITEM_DATE);
            END;
            ROW_C2:=ROW_C2+1;
            IF(ROW_C2>100) THEN
                COMMIT;
                ROW_C2:=0;
            END IF;
        END IF;

    END LOOP;
    
    FOR V2 IN C2 LOOP
        
        V_EXTERNAL_ID:=NULL;
        V_SUBSCR_NO:=NULL;
        V_ACCOUNT_NO:=NULL;
        V_ACTIVE_DATE:=NULL;
        V_EXTERNAL_ACC_NO:=NULL;
        V_ARBOR_RL_NO:=NULL;
        V_ITEM_DATE:=NULL;
        
        BEGIN
        SELECT EXTERNAL_ID,SUBSCR_NO,ACCOUNT_NO,ACTIVE_DATE INTO V_EXTERNAL_ID,V_SUBSCR_NO,V_ACCOUNT_NO,V_ACTIVE_DATE
        FROM EXTERNAL_ID_EQUIP_MAP@BPPRODUCTION
        WHERE EXTERNAL_ID=V2.EXTERNAL_ID
        AND EXTERNAL_ID_TYPE=200
        AND INACTIVE_DATE IS NULL
        AND ROWNUM=1;
        EXCEPTION WHEN NO_DATA_FOUND THEN 
            V_EXTERNAL_ID :=NULL;
            V_SUBSCR_NO :=NULL;
            V_ACCOUNT_NO:=NULL;
            
        END;
        
        IF(V_EXTERNAL_ID IS NOT NULL) THEN
            BEGIN
                    SELECT A.EXTERNAL_ID INTO V_EXTERNAL_ACC_NO
                    FROM EXTERNAL_ID_ACCT_MAP@BPPRODUCTION A
                    WHERE A.ACCOUNT_NO=V_ACCOUNT_NO
                    AND A.EXTERNAL_ID_TYPE=100
                    AND A.INACTIVE_DATE IS NULL;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                    V_EXTERNAL_ACC_NO:=NULL;    
            END;
            
            BEGIN      
                    SELECT ORDER_ID,ITEM_DATE INTO V_ARBOR_RL_NO,V_ITEM_DATE
                    FROM ORDER_ITEM_AUG05@OMPRODUCTION
                    WHERE ACCOUNT_NO=V_ACCOUNT_NO
                    AND ID_NO=V_SUBSCR_NO
                    AND MEMBER_TYPE=16
                    AND MEMBER_ID=200
                    AND ACTION_CODE=1
                    AND ROWNUM=1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                    BEGIN
                        SELECT ORDER_ID,ITEM_DATE INTO V_ARBOR_RL_NO,V_ITEM_DATE
                        FROM ORDER_ITEM_AUG05@OMPRODUCTION
                        WHERE ACCOUNT_NO=V_ACCOUNT_NO
                        AND ID_NO=V_SUBSCR_NO
                        AND MEMBER_TYPE=16
                        AND MEMBER_ID=200
                        AND ACTION_CODE=1
                        AND ROWNUM=1;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                         V_ARBOR_RL_NO:=0;       
                    END;    
                    
            END;
            
            BEGIN
                    INSERT INTO ARBOR_NEP_OBC_DATA_1 VALUES(V_EXTERNAL_ACC_NO,NULL,V_EXTERNAL_ID,V_SUBSCR_NO,NULL,V_ARBOR_RL_NO,V_ACTIVE_DATE,V_ITEM_DATE);
            END;
            ROW_C2:=ROW_C2+1;
            IF(ROW_C2>100) THEN
                COMMIT;
                ROW_C2:=0;
            END IF;
        
            
        END IF;    
    END LOOP;
COMMIT;
END;
/

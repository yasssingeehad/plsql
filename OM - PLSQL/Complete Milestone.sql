--Complete Milestone
--BEGIN    arbor.COMPLETE_MILESTONE_BY_TID(1076390777);  commit;  END;

SELECT O.ORDER_ID,R.CREATE_DT ORDER_DATE,O.ACTION_CODE ACTION,DECODE(O.ACTION_CODE,1,'Add',2,'Change',3,'Delete',5,'Disconnet',6,'Suspend',7,'Resume',8,'TransCon',9,'TransDis',10,'SwapOut',11,'SwapIn',12,'MoveOut',13,'MoveIn',O.ACTION_CODE) ACTION
,O.MEMBER_TYPE MEMBER_T,DECODE(O.MEMBER_TYPE,2,'contract_type',3,'emf_config_id',4,'element_id',5,'contract',6,'package_id',7,'component_id',16,'external_id_type',O.MEMBER_TYPE) MEMBER_TYPE
,O.MEMBER_ID
,case 
when O.MEMBER_TYPE=3 then (select display_value from arbor.emf_config_id_VALUES WHERE LANGUAGE_CODE=1 and emf_config_id=O.MEMBER_ID)
when O.MEMBER_TYPE=4 then (select D.DESCRIPTION_TEXT from arbor.product_elements p, arbor.descriptions d where d.language_code=1 and P.description_code=d.description_code and element_id=O.MEMBER_ID)
when O.MEMBER_TYPE=5 then (select D.DESCRIPTION_TEXT from arbor.contract_types p, arbor.descriptions d where d.language_code=1 and P.description_code=d.description_code and contract_type=O.MEMBER_ID)
when O.MEMBER_TYPE=6 then (select display_value from arbor.package_definition_values where language_code=1 and package_id=O.MEMBER_ID)
when O.MEMBER_TYPE=7 then (select display_value from arbor.component_definition_values where language_code=1 and component_id=O.MEMBER_ID)
when O.MEMBER_TYPE=16 then (select display_value from arbor.external_id_type_values where language_code=1 and external_id_type=O.MEMBER_ID)
else 'Other' end as "MEMBER_ID_NAME"
,MEMBER_INST_ID3
,O.ITEM_DATE,O.ACCOUNT_NO,O.ID_NO,O.PARENT_EXTERNAL_ID,R.CHG_WHO
FROM ARBOR.ORDER_ITEM O, arbor.customer_order_revision R
WHERE O.ORDER_ID=R.ORDER_ID
AND O.ORDER_ID=246613565-- IN (239387317)--238713086,239387317 --AND MEMBER_TYPE=16
--AND ID_NO = 244748167
--AND O.MEMBER_ID IN (SELECT PRODUCT_ID MEMBER_ID FROM ARBOR.CAT_DEVICE_COMMITMENTS@OMPROD)
--AND O.MEMBER_TYPE=16
--AND O.MEMBER_ID IN (1592376)

SELECT * FROM ACTION_VALUES

select * FROM ARBOR.ORDER_ITEM O
WHERE  O.ORDER_ID=246613565-- IN (239387317)--238713086,239387317 --AND MEMBER_TYPE=16
--AND O.MEMBER_ID IN (SELECT PRODUCT_ID MEMBER_ID FROM ARBOR.CAT_DEVICE_COMMITMENTS@OMPROD)
--AND O.MEMBER_TYPE=16

SELECT * FROM ORDER_ITEM WHERE ACCOUNT_NO=4733635 AND PARENT_EXTERNAL_ID=99576355 ORDER BY ITEM_DATE DESC

SELECT * FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%ADSL_LOG%'

SELECT DISTINCT NAME FROM ALL_SOURCE WHERE UPPER(NAME) LIKE '%COMPLETE_MILE%'

select * from ubcc.ubcct_subscription where subscr_no='215245767'

select * from ubcc.ubcct_si_transaction where subscr_no='215245767'

select * from arbor_pcrf_master where component_id=1593087

select ROWID,O.* FROM ARBOR.ORDER_WORK_QUEUE O
WHERE  O.ORDER_ID=246613565--245762262
--AND TRANSACTION_ID=200446--AND STATUS<>50
 order by chg_date desc

select ROWID,O.* FROM ARBOR.ORDER_WORK_QUEUE_ERROR O
WHERE  O.ORDER_ID=246613565 order by chg_date desc

SELECT M.DISPLAY_VALUE,sv.display_value--,CO.ORDER_STATUS
,OW.ROWID,OW.* FROM ARBOR.ORDER_WORK_QUEUE OW,ARBOR.CUSTOMER_ORDER CO, arbor.milestone_values m,arbor.status_values sv
WHERE OW.ORDER_ID IN (159360345)  AND
 OW.ORDER_ID=CO.ORDER_ID --AND CO.ORDER_STATUS NOT IN (5,6) 
--AND OW.PARENT_ID1=159360345 AND M.DISPLAY_VALUE LIKE '%ADSL%'
--AND OW.STATUS NOT IN (50)
and M.LANGUAGE_CODE=1 and OW.TRANSACTION_ID=M.MILESTONE_ID and SV.LANGUAGE_CODE=1 and OW.STATUS=SV.STATUS_ID
ORDER BY CHG_DATE DESC

select * from web_uoms_log where ORDER_ID=223766885

SELECT CO.ORDER_STATUS,ROWID,CO.* FROM ARBOR.CUSTOMER_ORDER CO WHERE --master_account_no=6552918--
CO.ORDER_ID=159360345

SELECT ROWID,CO.* FROM ARBOR.CUSTOMER_ORDER_REVISION CO WHERE --master_account_no=6552918--
CO.ORDER_ID=238634605

SELECT * FROM ITEM_MILESTONES WHERE ORDER_ID=125598187

SELECT * FROM ARBOR.ORDER_WORK_QUEUE_error OW WHERE OW.ORDER_ID IN (159360345) ORDER BY CHG_DATE DESC

SELECT * FROM ARBOR.PACKAGE_CMF_ELIGIBILITY P, ACCOUNT_CATEGORY_VALUES A 
WHERE P.PACKAGE_ID=1285070 AND A.ACCOUNT_CATEGORY=P.ACCOUNT_CATEGORY --AND A.LANGUAGE_CODE=1

SELECT * FROM ARBOR.PACKAGE_DEFINITION_VALUES WHERE PACKAGE_ID=1285070

SELECT ARBOR.OWQ_TRACKING_ID_SQL.NEXTVAL FROM DUAL

SELECT ROWID,OD.* FROM ARBOR.ORDER_DEPENDENCY OD WHERE --OD.ORDER_ID=245762262
OD.DEPENDENT_UPON_ORDER_ID=245762262


TRACKING_ID,TRANSACTION_ID,QUEUE_TYPE,ORDER_ID,ORDER_ID_RESETS,ITEM_ID,ITEM_ID_RESETS,PROV_GROUP_ID,STATUS
OWQ_TRACKING_ID_SQL,99,1,ORDER_ID,0,0,0,0,22

SELECT CO.ORDER_STATUS,ROWID,CO.* FROM ARBOR.CUSTOMER_ORDER CO WHERE CO.MASTER_ACCOUNT_NO=9943560 AND ORDER_STATUS NOT IN (5,6)

SELECT * FROM ARBOR.QUEUE_TYPE_VALUES WHERE QUEUE_TYPE=46

SELECT * FROM ARBOR.PEN_CHG WHERE ORDER_ID IN (244404647)

SELECT * FROM ARBOR.PEN_Cmf WHERE ORDER_ID IN (244404647)

SELECT rowid,e.* FROM ARBOR.PEN_emf e WHERE ORDER_ID IN (244404647)--al araimi

SELECT A.ORDER_ID,A.CHG_DATE,SQL_ERROR FROM ARBOR.ORDER_WORK_QUEUE_ERROR A,
(SELECT ORDER_ID, MAX(CHG_DATE) CHG_DATE FROM ARBOR.ORDER_WORK_QUEUE_ERROR OWE 
WHERE OWE.ORDER_ID IN (238049357) 
GROUP BY OWE.ORDER_ID) B
WHERE A.ORDER_ID=B.ORDER_ID AND A.CHG_DATE=B.CHG_DATE --TO_CHAR(CHG_DATE,'DD-MM-YYYY HH:MI:SS')

SELECT * FROM arbor.customer_order_revision WHERE ORDER_ID IN (212952341,212980657,237242449)

SELECT * FROM ARBOR.GSM_SMS_DETAILS@TO_BP WHERE --MSISDN=95960983
FIXED_NO='24272137'
ORDER BY MESSAGE_SENT_DATE DESC

SELECT ROWID,O.* FROM ARBOR.BSS_PRODUCT_MASTER O WHERE COMPONENT_ID=1273500

SELECT DISTINCT NAME FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%INT%DELETE%' AND UPPER(NAME) LIKE '%DELETE%' --AND NAME IN (SELECT NAME FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%ERP%')

B_COMMIT_ORDER

B_CREATE_ADDITIONAL_ORDERS

SELECT DISTINCT NAME FROM ALL_SOURCE WHERE UPPER(NAME) LIKE '%DELETE%' AND NAME IN (SELECT NAME FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%DELETE%')

SELECT DISTINCT NAME FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%PACKAGE%NOT%ELIGIBLE%WITH%PROVIDED%ACCOUNT%'

SELECT DISTINCT NAME FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%200447%' AND NAME IN (
SELECT DISTINCT NAME FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%200443%')

SELECT * FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%200911%'

GET_LMS_DETAILS

B_CUSTOM_PACKAGE_ELIGIBILITY

TIMS_NI_PROVISIOING

GET_NEP_PROV_DET

COMPTEL_NI_UPDATE_MILESTONES

GET_TIMS_NI_MAPPING

SELECT * FROM ALL_SOURCE WHERE UPPER(TEXT) LIKE '%CB_CALCULATED_CHARGES%'

SELECT * FROM CANCELL_ORDER_LOG WHERE ORDER_ID=233635578

SELECT * FROM CANCEL_ORDER_LOGS WHERE ORDER_ID=233635578

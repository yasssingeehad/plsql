SELECT * FROM ARBOR.CAT_MAIN@OMPROD WHERE --PRODUCT_ID=1243980   -- IN (1810761,1810758,1593974)
UPPER(PRODUCT_NAME) LIKE '%BAQATI%9%'

SELECT DISTINCT PRODUCT_ID, PRODUCT_NAME 
FROM ARBOR.CAT_MAIN_VIEW@OMPROD WHERE PRODUCT_ID=1243980   -- IN (1810761,1810758,1593974)
--UPPER(PRODUCT_NAME) LIKE '%FREE%LOCAL%MINUTE%'

SELECT *--DISTINCT PRODUCT_ID, PRODUCT_NAME 
FROM ARBOR.CAT_MAIN_VIEW@OMPROD --WHERE PRODUCT_ID=1243980-- PRODUCT_END IS NULL

SELECT * FROM ARBOR.CAT_PRODUCT_GROUP@OMPROD WHERE PRODUCT_GROUP='TARIFF_PACKAGE_NAMA_BUNDLE'

SELECT * FROM ARBOR.CAT_ORDER_ELIGIBILITY@OMPROD WHERE PRODUCT_ID=1243980

SELECT * FROM ARBOR.CAT_PRODUCT_DEPENDENCY@OMPROD  WHERE PRODUCT_ID='40930'   -- DEPENDENT_UPON_PRODUCT_ID IN (1810761,1810758,1593974)

SELECT * FROM ARBOR.CAT_PRODUCT_MAP_MASTER WHERE PRODUCT_ID='40930'   -- PRODUCT_ID IN (1810761,1810758,1593974)

SELECT * FROM ARBOR.CAT_PRODUCT_PROPERTIES WHERE PRODUCT_ID='40911'   -- PRODUCT_ID IN ('1810761','1810758','1593974')

SELECT * FROM ARBOR.CAT_CHARGE_PRE

SELECT * FROM ARBOR.CAT_POS_ITEM_CONFIG

SELECT * FROM ARBOR.CAT_CHARGE_POST

SELECT * FROM ARBOR.CAT_PLAN_COMMITMENTS@OMPROD-- WHERE PRODUCT_ID IN (1810761,1810758,1593974)

SELECT * FROM ARBOR.CAT_DEVICE_COMMITMENTS@OMPROD 

SELECT PRODUCT_ID,COMMITMENT_AMOUNT,COMMITMENT_DURATION,COMMITMENT_TEMPLATE FROM ARBOR.CAT_PLAN_COMMITMENTS@OMPROD-- WHERE PRODUCT_ID IN (1810761,1810758,1593974)

SELECT * FROM ARBOR.CAT_DEVICE_COMMITMENTS@OMPROD

SELECT * FROM ARBOR.CAT_CUSTOMER_ELIGIBILITY@OMPROD WHERE PRODUCT_ID=40930

SELECT AR.ACCOUNT_CATEGORY,AR.IS_BUSINESS,AV.DISPLAY_VALUE FROM ARBOR.ACCOUNT_CATEGORY_REF AR, ARBOR.ACCOUNT_CATEGORY_VALUES AV
WHERE AR.ACCOUNT_CATEGORY IN (1,2,3,4,23,206,207,7,6,10)
AND AR.ACCOUNT_CATEGORY=AV.ACCOUNT_CATEGORY AND AV.LANGUAGE_CODE=1

SELECT * FROM ARBOR.CMF@TO_BP WHERE ACCOUNT_NO=15281455

SELECT * FROM ARBOR.CAT_PRODUCT_POS_MAP WHERE PRODUCT_ID IN (1810761,1810758,1593974)

SELECT * FROM ARBOR.CAT_UI_PROPERTIES

SELECT * FROM ARBOR.CAT_FINAL_SUBMIT_CONDITIONS

SELECT * FROM ARBOR.CAT_NRC

SELECT * FROM ARBOR.CAT_DEVICE_COMMITMENTS@OMPROD

SELECT * FROM ARBOR.CAT_DISCOUNTS WHERE PRODUCT_ID IN (1810761,1810758,1593974)

SELECT * FROM ARBOR.CAT_RTBDS_MAP_MASTER

SELECT * FROM ARBOR.CAT_PRODUCT_PROPERTIES WHERE PRODUCT_ID= '40930'-- IN ('1810761','1810758','1593974')

SELECT * FROM ARBOR.CAT_FREE_UNITS

SELECT * FROM ARBOR.CAT_RTBDS_PRODUCT_DETAILS

SELECT * FROM ARBOR.CAT_DEVICE_BRAND_NAME

SELECT * FROM ARBOR.CAT_PRODUCT_DESCRIPTIONS@OMPROD where product_id=40911

SELECT * FROM ARBOR.CAT_RTBDS_REVENUE_ALLOCATION where product_id=40911

SELECT * FROM ARBOR.CAT_RTBDS_PROD_CLASSIFICATION where product_id=40911

SELECT * FROM ARBOR.CAT_SMS_NOTIFICATIONS

SELECT * FROM ARBOR.CICM_PRODUCT_NOTIFICATION@OMPROD

SELECT * FROM ARBOR.CAT_PRODUCT_CUSTOM_PLANS where product_id=40911

SELECT * FROM ARBOR.CAT_ORDER_TYPE_MAP@OMPROD

SELECT * FROM ARBOR.CAT_CHARGE_FIXED

--Company Registration Product
SELECT * FROM arbor.CAT_PRODUCT_CUSTOM_PLANS@OMPROD A WHERE A.ID_NUMBER = '1321584' 
--AND PRODUCT_ID IN (40911,40912,40913,40914,40915,40916)
order by 1
 
SELECT B.*, A.PRODUCT_NAME,C.PRODUCT_NAME FROM arbor.CAT_PRODUCT_DEPENDENCY@omprod B , ARBOR.CAT_MAIN@OMPROD A, ARBOR.CAT_MAIN@OMPROD C
WHERE B.PRODUCT_ID IN (SELECT A.PRODUCT_ID FROM arbor.CAT_PRODUCT_CUSTOM_PLANS A WHERE A.ID_NUMBER = '3895865')
AND B.DEPENDENT_UPON_PRODUCT_ID IN (SELECT A.PRODUCT_ID FROM arbor.CAT_PRODUCT_CUSTOM_PLANS A WHERE A.ID_NUMBER = '3895865')
AND B.DEPENDENT_UPON_PRODUCT_ID IN (40911,40912,40913,40914,40915,40916)
AND A.PRODUCT_ID = B.DEPENDENT_UPON_PRODUCT_ID
AND B.PRODUCT_ID = C.PRODUCT_ID
--Company Registration Product

--Consumer Postpaid Tariff
SELECT A.PRODUCT_ID, A.PRODUCT_NAME, C.PRODUCT_ID, C.PRODUCT_NAME 
FROM ARBOR.CAT_MAIN@OMPROD A, ARBOR.CAT_PRODUCT_DEPENDENCY@OMPROD B, ARBOR.CAT_MAIN@OMPROD C
WHERE A.LINE_OF_BUSINESS = 13 AND A.PACKAGE_GROUP = 'TARIFF_PACKAGE' AND A.SUBSCRIPTION_SUB_TYPE IN ( 'BAQATI','BAQATI_DATA_ONLY')
AND A.PRODUCT_ID = B.DEPENDENT_UPON_PRODUCT_ID
AND B.PRODUCT_ID = C.PRODUCT_ID
AND A.PRODUCT_END IS NULL
AND C.LINE_OF_BUSINESS = 13  AND C.PACKAGE_GROUP = 'PLAN_COMMITMENTS'
ORDER BY A.PRODUCT_ID

select *--DISTINCT PACKAGE_GROUP 
from CAT_MAIN_VIEW@OMprod A
WHERE A.PRODUCT_ID IN (17793)
AND A.PACKAGE_GROUP = 'DATA_TARIFF'

SELECT *--DISTINCT COMPONENT_ID 
FROM ARBOR.WEB_EFORM_ARBOR_PLAN_MAP@OMPROD
WHERE COMPONENT_ID=1579180

E_FORM_ID IN (30042,1271270,1271730,1273120,1273110,20048,30043,1271280,1271230,15500,1271240,1271290,1273150,1271250,30040,30041,1271260,1272070,1272080,13377 --P
,1592923,1593258,17759,17769,17770,17761,1593911,1593914--H
,1540780,1540790,1540800,1592824,1592822,1592823,1593091,1593520,1593525,1593092,1593521,1593526,1593093,1593522,1593527,1593094
,1593523,1593528,1593095,1593524,1593529,1592818,1592894,1592819,1592895,1592820,1592896,17868)

--TARIF
select DISTINCT A.PRODUCT_ID--SUBSCRIPTION_SUB_TYPE 
from CAT_MAIN@OMprod A
WHERE A.PRODUCT_ID IN
(1201420,1201500,1201520,1271810,1271820,1271830,1271840,1272130,1272140,14196,15496,15497,15498,15499,18796,18797,9022 --P
,1592917,1592918,1576800,17791,17792,17793,17795,1593910,1593913--H
,1540740,1540750,1540760,1541060,1541070,1541080,1593086,1593087,1593088,1593089,1593090,17862,17863,17864)--W
AND A.PACKAGE_GROUP IN ('DATA_TARIFF','TARIFF_PACKAGE')--,'DATA_PROVISIOINING'
AND A.SUBSCRIPTION_SUB_TYPE IN ('FIBER','BAQATI','5G','BAQATI_DATA_ONLY')
AND A.LINE_OF_BUSINESS IN (13,331,351)

--COMMIT
select DISTINCT C.LINE_OF_BUSINESS--SUBSCRIPTION_SUB_TYPE 
from CAT_MAIN@OMprod C
WHERE C.PRODUCT_ID IN
(30042,1271270,1271730,1273120,1273110,20048,30043,1271280,1271230,15500,1271240,1271290,1273150,1271250,30040,30041,1271260,1272070,1272080,13377 --P
,1592923,1593258,17759,17769,17770,17761,1593911,1593914--H
,1540780,1540790,1540800,1592824,1592822,1592823,1593091,1593520,1593525,1593092,1593521,1593526,1593093,1593522,1593527,1593094
,1593523,1593528,1593095,1593524,1593529,1592818,1592894,1592819,1592895,1592820,1592896,17868)--W
AND C.PACKAGE_GROUP IN ('COMMITMENT_WFBB_5G','HBB_COMMITMENT','PLAN_COMMITMENTS')
AND C.SUBSCRIPTION_SUB_TYPE IN ('FIBER','BAQATI','5G','BAQATI_DATA_ONLY')
AND C.LINE_OF_BUSINESS IN (13,331,351)

SELECT DISTINCT PRODUCT_ID
FROM ARBOR.CAT_PRODUCT_DEPENDENCY@OMPROD
WHERE PRODUCT_ID IN
(1201420,1201500,1201520,1271810,1271820,1271830,1271840,1272130,1272140,14196,15496,15497,15498,15499,18796,18797,9022 --P
,1592917,1592918,1576800,17791,17792,17793,17795,1593910,1593913--H
,1540740,1540750,1540760,1541060,1541070,1541080,1593086,1593087,1593088,1593089,1593090,17862,17863,17864)

-- chargers cases 

SELECT CBA.IDENTIFICATION_NUM_V ID,F.ACCOUNT_CODE_N ACCOUNT_NO,cba.SUBSCRIBER_CATEGORY_V,cba.SUBSCRIBER_SUB_CATEGORY_V,
(select SERVICE_INFO_V from TT_MIG_PROD.cb_account_service_list where ACCOUNT_LINK_CODE_N = IAL.SERV_ACCOUNT_LINK_CODE_N) SUBNO,
(select SUB_SERVICE_CODE_V from TT_MIG_PROD.cb_account_service_list where ACCOUNT_LINK_CODE_N = IAL.SERV_ACCOUNT_LINK_CODE_N) SERVICE_TYPE,
SUBSTR(INVOICE_NUM_V,2,LENGTH(INVOICE_NUM_V)) BILL_NO,
nvl(SUM(MON_CHG),0)/1000000 RENTAL,
0 INSTALLATION,
nvl(SUM(LOC_CHG),0)/1000000 LOCALCHARGES,
nvl(SUM(INT_CHG),0)/1000000 INTCALLCHARGES,
nvl(SUM(DATA_CHG),0)/1000000 DATACHARGES,
nvl(SUM(ROAM_CHG),0)/1000000 ROAMINGCHARGES,
nvl(SUM(DISCOUNTS),0)/1000000 DISCOUNTS, --
nvl(SUM(OTH_CHG),0)/1000000 OTHERCHARGES,--
nvl(SUM(SLA),0)/1000000 DEDUCTION,--
nvl(sum(TAX),0)/1000000 Tax,
nvl(SUM(MON_CHG)+SUM(LOC_CHG)+SUM(DATA_CHG)+SUM(INT_CHG)+SUM(ROAM_CHG)+SUM(OTH_CHG)+SUM(SLA)+SUM(DISCOUNTS)+sum(TAX),0)/1000000 TOTALCURRENTCHARGES,
nvl(SUM(ACCT_CHG),0)/1000000 ACCOUNT_CHARGES,
nvl(SUM(MON_CHG)+SUM(LOC_CHG)+SUM(DATA_CHG)+SUM(INT_CHG)+SUM(ROAM_CHG)+SUM(OTH_CHG)+SUM(ACCT_CHG)+SUM(SLA)+SUM(DISCOUNTS)+sum(TAX),0)/1000000 NETCURRENTCHARGES,
--LAST_DAY(CIA.CHARGE_TILL_DATE_D)
LAST_DAY(TO_DATE(SUBSTR(CIA.BILL_CYCLE_FULL_CODE_N,10,6),'YYYYMM'))  STATEMENT_DATE,CBA.ACCOUNT_NAME_V
FROM TT_MIG_PROD.cb_account_master CBA ,TT_MIG_PROD.CB_BILL_INV_ACC_LIST CIA, TT_MIG_PROD.CB_BILL_SERV_ACC_LIST IAL,
(
SELECT T.ACCOUNT_CODE_N, T.ACCOUNT_LINK_CODE_N, T.SERV_ACCOUNT_LINK_CODE_N,SRV,BILL_CYCLE_FULL_CODE_N,
NVL(T.MON_CHGS,0) MON_CHG, NVL(T.LOC_CHGS,0) LOC_CHG, NVL(T.DATA_CHGS,0) DATA_CHG,
NVL(T.INT_CHGS,0) INT_CHG, NVL(T.ROAM_CHGS,0) ROAM_CHG,NVL(T.DISCOUNTS,0)DISCOUNTS,NVL(T.OTH_CHGS,0) OTH_CHG,NVL(T.ACCT_CHG,0) ACCT_CHG,NVL(T.SLA,0) SLA,
nvl(t.TAX,0) Tax
FROM
(
SELECT  A.ACCOUNT_CODE_N, A.ACCOUNT_LINK_CODE_N, B.SERV_ACCOUNT_LINK_CODE_N,A.BILL_CYCLE_FULL_CODE_N,
CBS_BD_BILL_EXTERNAL_PROD.PRN_GET_SERVICE_DETAILS(B.SERV_ACCOUNT_LINK_CODE_N,B.SERVICE_CODE_V) SRV,
CASE WHEN C.ARTICLE_CODE_V in (select article_code_v from CBS_TBL_CORE_PROD.xml_charge_group_details where group_id_n = 101) THEN DECODE(C.DB_CR_V,'D',-1,1) * NVL(TRANS_AMT_N,0) END AS MON_CHGS,
CASE WHEN C.ARTICLE_CODE_V in (select article_code_v from CBS_TBL_CORE_PROD.xml_charge_group_details where  (group_id_n between 401 and 424 or group_id_n=102) ) THEN DECODE(C.DB_CR_V,'D',-1,1) * NVL(TRANS_AMT_N,0) END AS LOC_CHGS,
CASE WHEN C.ARTICLE_CODE_V in (select article_code_v from CBS_TBL_CORE_PROD.xml_charge_group_details where  group_id_n between 201 and 282) THEN DECODE(C.DB_CR_V,'D',-1,1) * NVL(TRANS_AMT_N,0) END AS DATA_CHGS,
CASE WHEN C.ARTICLE_CODE_V in (select article_code_v from CBS_TBL_CORE_PROD.xml_charge_group_details where group_id_n in (303,304,414)) THEN DECODE(C.DB_CR_V,'D',-1,1) * NVL(TRANS_AMT_N,0) END AS INT_CHGS,
CASE WHEN C.ARTICLE_CODE_V in (select article_code_v from CBS_TBL_CORE_PROD.xml_charge_group_details where group_id_n in (301,302)) THEN DECODE(C.DB_CR_V,'D',-1,1) * NVL(TRANS_AMT_N,0) END AS ROAM_CHGS,
CASE WHEN C.ARTICLE_CODE_V in (select article_code_v from CBS_TBL_CORE_PROD.xml_charge_group_details where group_id_n =113) THEN DECODE(C.DB_CR_V,'D',-1,1) * NVL(TRANS_AMT_N,0) END AS DISCOUNTS,
CASE WHEN C.ARTICLE_CODE_V in (select article_code_v from CBS_TBL_CORE_PROD.xml_charge_group_details where group_id_n in (110,111,112,500) and  ARTICLE_CODE_V not in ('1000000001','1000000002')) THEN DECODE(C.DB_CR_V,'D',-1,1) * NVL(TRANS_AMT_N,0) END AS OTH_CHGS,
CASE WHEN C.ARTICLE_CODE_V in (select article_code_v from CBS_TBL_CORE_PROD.xml_charge_group_details where group_id_n in (500)) THEN DECODE(C.DB_CR_V,'C',-1,1) * NVL(ARTICLE_DISC_AMT_N,0) END AS SLA,
CASE WHEN C.ARTICLE_CODE_V in (select article_code_v from CBS_TBL_CORE_PROD.xml_charge_group_details where group_id_n=114) THEN DECODE(C.DB_CR_V,'D',-1,1) * NVL(TRANS_AMT_N,0) END AS ACCT_CHG,
CASE WHEN C.ARTICLE_CODE_V in ('1000000001','1000000002') THEN DECODE(C.DB_CR_V,'D',-1,1) * NVL(TRANS_AMT_N,0) END AS TAX
FROM TT_MIG_PROD.CB_BILL_INV_ACC_LIST A, TT_MIG_PROD.CB_BILL_SERV_ACC_LIST B, TT_MIG_PROD.CB_INVOICE_DETAILS C
WHERE  A.ACCOUNT_CODE_N = B.ACCOUNT_CODE_N 
AND A.BILL_CYCLE_FULL_CODE_N = B.BILL_CYCLE_FULL_CODE_N 
AND B.SERV_ACCOUNT_LINK_CODE_N = C.SERV_ACC_LINK_CODE_N 
AND A.INVOICE_NUM_V = C.TRANS_NUM_V
) T
) F
WHERE 
 CBA.SUBSCRIBER_CATEGORY_V  in (1,6)
and CBA.IDENTIFICATION_NUM_V='1708724' ----- INPUT
and CBA.ACCOUNT_CODE_N=CIA.ACCOUNT_CODE_N
and CIA.ACCOUNT_CODE_N = IAL.ACCOUNT_CODE_N
AND CIA.BILL_CYCLE_FULL_CODE_N=ial.BILL_CYCLE_FULL_CODE_N
--AND IAL.SERV_ACCOUNT_LINK_CODE_N = CUR.SERV_ACC_LINK_CODE_N
AND IAL.SERV_ACCOUNT_LINK_CODE_N = F.SERV_ACCOUNT_LINK_CODE_N
AND F.ACCOUNT_LINK_CODE_N=CIA.ACCOUNT_LINK_CODE_N
AND F.BILL_CYCLE_FULL_CODE_N=CIA.BILL_CYCLE_FULL_CODE_N
AND F.ACCOUNT_CODE_N=CIA.ACCOUNT_CODE_N
AND CIA.BILL_CYCLE_FULL_CODE_N = 1010000012024090---- INPUT
--AND CIA.ACCOUNT_CODE_N in ('100450520','108660539','109184531','109225223','109251751','109275068','109517581','136132698')
GROUP BY CBA.IDENTIFICATION_NUM_V,F.ACCOUNT_CODE_N,cba.SUBSCRIBER_CATEGORY_V,cba.SUBSCRIBER_SUB_CATEGORY_V,INVOICE_NUM_V,IAL.SERV_ACCOUNT_LINK_CODE_N,IAL.SERVICE_CODE_V
,cia.CHARGE_TILL_DATE_D,SRV,CIA.ACCOUNT_LINK_CODE_N,CIA.CHARGE_FROM_DATE_D,CIA.BILL_CYCLE_FULL_CODE_N,CBA.ACCOUNT_NAME_V;
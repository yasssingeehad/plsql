/* Formatted on 11/2/2024 2:51:03 AM (QP5 v5.139.911.3011) */
CREATE MATERIALIZED VIEW FN_OM_FEASIBILITY_DETAILS
BUILD IMMEDIATE
REFRESH FORCE
START WITH SYSDATE
NEXT SYSDATE + INTERVAL '1' HOUR
AS
SELECT 
    b.ERROR_CODE,
    b.error_message,
    TRIM(REPLACE(REPLACE(OE.SQL_ERROR, CHR(10), ' '), CHR(9), ' ')) AS ERROR,
    owq.tracking_id,
    owq.order_id,
    oi.parent_external_id AS external_id,
    co.master_account_no,
    owq.parent_id1,
    mv.display_value AS milestone,
    OWQ.transaction_id,
    OWQ.ACTION_ID
FROM 
    arbor.ORDER_WORK_QUEUE_ERROR@omcmsdb OE
JOIN 
    arbor.ORDER_WORK_QUEUE@omcmsdb OWQ ON OE.TRACKING_ID = OWQ.TRACKING_ID
JOIN 
    arbor.customer_order@omcmsdb co ON OWQ.order_id = co.order_id
LEFT JOIN 
    arbor.order_item@omcmsdb oi ON oi.order_id = owq.order_id AND oi.item_id = owq.item_id
LEFT JOIN 
    arbor.milestone_values@omcmsdb mv ON mv.language_code = 1 AND mv.milestone_id = OWQ.transaction_id
LEFT JOIN 
    fn_process_order_errors b ON b.order_id = owq.order_id
WHERE 
    OWQ.QUEUE_TYPE IN (46, 47)
    AND OE.CHG_DATE = (SELECT MAX(CHG_DATE)
                       FROM arbor.ORDER_WORK_QUEUE_ERROR@omcmsdb
                       WHERE TRACKING_ID = OWQ.TRACKING_ID)
    AND OWQ.STATUS = 100
    AND OWQ.TRANSACTION_ID IN (SELECT DISTINCT milestone_id
                               FROM arbor.item_type_milestone@omcmsdb
                               WHERE queue_type = 47)
    AND co.order_status IN (1, 2, 3);

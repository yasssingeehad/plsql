/* Formatted on 11/2/2024 3:50:12 AM (QP5 v5.139.911.3011) */
DECLARE
   CURSOR c1 IS
      SELECT A.ACTIVE_NODE,
             A.ARBOR_ORDER_ID,
             A.AREA_CODE,
             A.COPPER_FIBER_TECNOLOGY,
             A.ERROR_CODE,
             A.ERROR_MESSAGE,
             A.EXCHANGE1,
             A.FULL_NAME,
             A.HAS_FLOW,
             A.INSERTDATE,
             A.OBC_TAG,
             A.SUBSCRIBER_NO,
             A.TASK_NAME,
             A.WO_NO,
             A.WO_OPERATION,
             A.WO_STATUS
        FROM FN_INTERRUPTED_ORDER a;

   v_count_onu       NUMBER;
   v_onu_node_name   VARCHAR2(100);
BEGIN
   FOR t1 IN c1
   LOOP
      BEGIN
         SELECT COUNT(*)
           INTO v_count_onu
           FROM fn_onu_mview
          WHERE subno = t1.SUBSCRIBER_NO;

         SELECT NODE_NAME
           INTO v_onu_node_name
           FROM fn_onu_mview
          WHERE subno = t1.SUBSCRIBER_NO
          AND ROWNUM = 1;

         IF (t1.error_message LIKE '%The ONTSN does not exist%'
             AND t1.WO_OPERATION LIKE '%speed%')
         THEN
            DBMS_OUTPUT.put_line(
                  'speed change order '
               || t1.ARBOR_ORDER_ID
               || ' failing with error '
               || t1.ERROR_MESSAGE);

            -- Start checking the subscriber trail
            DELETE FROM service_trail
             WHERE subscriber = (SELECT id
                                   FROM subscriber
                                  WHERE subscriber_number = t1.SUBSCRIBER_NO);

            DELETE FROM fn_service_trail
             WHERE subscriber_no = t1.SUBSCRIBER_NO;

            IF (v_count_onu > 0)
            THEN
               DELETE FROM service_trail_lookup
                WHERE SUBSCRIBER_NO = t1.SUBSCRIBER_NO
                  AND ACTIVE_NODE NOT LIKE '%OLT%';
            end if;

            IF v_onu_node_name LIKE '%OLT%'
            THEN
               DELETE FROM service_trail_lookup
                WHERE SUBSCRIBER_NO = t1.SUBSCRIBER_NO
                  AND ACTIVE_NODE != v_onu_node_name;
            END IF;

            COMMIT;
            DBMS_OUTPUT.put_line(
                  'Order ID '
               || t1.ARBOR_ORDER_ID
               || ' deleted trail for SUBSCRIBER_NO '
               || t1.SUBSCRIBER_NO);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.put_line('NO DATA FOUND FOR ' || t1.SUBSCRIBER_NO);
      END;
   END LOOP;
END;

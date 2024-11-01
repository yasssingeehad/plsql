DECLARE
   CURSOR c1 IS
      SELECT ERROR_CODE,
             ERROR_MESSAGE,
             ERROR,
             TRACKING_ID,
             ORDER_ID,
             EXTERNAL_ID,
             MASTER_ACCOUNT_NO,
             PARENT_ID1,
             MILESTONE,
             TRANSACTION_ID,
             ACTION_ID,
             ARBOR_ORDER_ID,
             WO_STATUS,
             WO_OPERATION,
             INSERTDATE,
             START_DATE
        FROM temp_feasibility_29_Oct_03 t
       WHERE order_id IN (
            245610775, 244733081, 245560514, 244964822, 244754805, 224306191, 
            221120482, 240375227, 172132293, 222527147, 164148368, 143669203, 
            243905401, 202170694, 230214392, 229268529, 171428818, 236541967, 
            224896807, 239416709, 235187355, 243141066, 203266182, 242594370, 
            237625369, 238756633, 242079749, 200091558, 144084312, 234187791, 
            200090095, 207092377, 198690590, 225213865, 206794743, 244695581, 
            158528260, 244720582, 244142106, 244250253, 243805168, 162125798, 
            238756578, 215454425, 244153589, 243863811, 228830324, 244454477, 
            231336577, 225188440, 200673688, 215488459, 203630999, 233148086, 
            242381322, 242810522, 242370116, 223599517, 234187791
       );

   v_count_pending_order NUMBER := 0;
   v_pen_order           VARCHAR2(100);
   v_pen_order_operation VARCHAR2(100);
   v_pen_order_status    VARCHAR2(100);
   v_service_type        VARCHAR2(200);
   v_sub_status          VARCHAR2(200);
   v_external_id_active  NUMBER := 0;

BEGIN
   FOR t1 IN c1 LOOP
      BEGIN
         -- Fetch service details and active external ID count
         SELECT service_type, status INTO v_service_type, v_sub_status
           FROM fn_subscriber_details_view
          WHERE subscriber_number = t1.external_id;

         SELECT COUNT(*) INTO v_external_id_active
           FROM arbor.external_id_equip_map@bpcmsdb
          WHERE inactive_date IS NULL AND external_id = t1.external_id;

         -- Handling for ERROR_CODE = '10001' and ACTION_ID conditions
         IF (t1.ERROR_CODE = '10001' AND t1.ACTION_ID IN (1, 5)) THEN
            DBMS_OUTPUT.put_line('Processing order: ' || t1.ORDER_ID);

            -- Count pending orders for the subscriber
            SELECT COUNT(*) INTO v_count_pending_order
              FROM fn_work_order
             WHERE wo_status NOT IN ('completed', 'cancelled') 
               AND subscriber_no = t1.EXTERNAL_ID;

            IF (v_count_pending_order > 0) THEN
               -- Retrieve details of the pending order
               SELECT MAX(ARBOR_ORDER_ID), wo_operation, wo_status 
                 INTO v_pen_order, v_pen_order_operation, v_pen_order_status
                 FROM fn_work_order
                WHERE wo_status NOT IN ('completed', 'cancelled') 
                  AND subscriber_no = t1.EXTERNAL_ID;

               IF (t1.ACTION_ID = 5) THEN
                  -- Complete pending order if ACTION_ID is 5
                  UPDATE fn_work_order
                     SET wo_status = 'completed'
                   WHERE arbor_order_id = v_pen_order 
                     AND arbor_order_id IS NOT NULL
                     AND subscriber_no = t1.EXTERNAL_ID;

                  DBMS_OUTPUT.put_line('Completed pending order: ' || v_pen_order);
               ELSE
                  -- Log details for manual handling if ACTION_ID is 1
                  DBMS_OUTPUT.put_line(
                     'Pending order found for manual handling: ' || 
                     t1.EXTERNAL_ID || ' Order: ' || v_pen_order || 
                     ' Operation: ' || v_pen_order_operation || 
                     ' Status: ' || v_pen_order_status);
               END IF;
            ELSE
               DBMS_OUTPUT.put_line('No pending order for: ' || t1.EXTERNAL_ID);
            END IF;

            -- Update subscriber status based on conditions
            IF t1.ACTION_ID = 5 OR (v_count_pending_order = 0 AND v_sub_status = 'Terminated'
               AND (t1.milestone LIKE '%Speed%' OR t1.milestone LIKE '%Shift%')) THEN
               
               IF v_external_id_active > 0 THEN
                  update_subscriber_status(V_EXTERNAL_ID , 'active');

                  UPDATE temp_feasibility_29_Oct_03
                     SET action = 'REQUEUE Milestone'
                   WHERE order_id = t1.order_id;

                  DBMS_OUTPUT.put_line('Subscriber set to active: ' || t1.EXTERNAL_ID);
               ELSE
                  UPDATE temp_feasibility_29_Oct_03
                     SET action = 'Cancel order in OM - Subscriber is inactive !!'
                   WHERE order_id = t1.order_id;

                  DBMS_OUTPUT.put_line('Subscriber inactive: ' || t1.EXTERNAL_ID);
               END IF;

               COMMIT;
            END IF;
         END IF;

      EXCEPTION
         WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('Error encountered: ' || SQLERRM);
      END;
   END LOOP;

   COMMIT;
END;

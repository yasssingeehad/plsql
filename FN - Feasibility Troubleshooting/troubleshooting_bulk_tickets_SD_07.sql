DECLARE
   CURSOR c1 IS
      SELECT 
             ERROR,
             TRACKING_ID,
             ORDER_ID,
             EXTERNAL_ID,
             MASTER_ACCOUNT_NO,
             PARENT_ID1,
             MILESTONE,
             TRANSACTION_ID,
             ACTION_ID
             
          
        FROM FN_FEASIBILITY_FAIL_ARBOR  t;
      
   v_action_date date := (SYSDATE);
   v_count_pending_order NUMBER := 0;
   v_pen_order           VARCHAR2(100);
   v_pen_order_operation VARCHAR2(100);
   v_pen_order_status    VARCHAR2(100);
   v_service_type        VARCHAR2(200);
   v_sub_status          VARCHAR2(200);
   v_external_id_active  NUMBER := 0;
   v_error_code          VARCHAR2(100);
   v_error_message       VARCHAR2(100);
   v_start_date       date;

BEGIN
   FOR t1 IN c1 LOOP

      BEGIN
      select error_code ,error_message , start_date into v_error_code , v_error_message , v_start_date from fn_process_order where arbor_order_id like (t1.order_id || '%') and start_date >= (SYSDATE - 0.5) and row_number = 1 ;
      DBMS_OUTPUT.put_line('error_message for ' || t1.order_id  || ' is ' v_error_message  );
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

                  --UPDATE temp_feasibility_29_Oct_03 SET action = 'REQUEUE Milestone' WHERE order_id = t1.order_id;

                  DBMS_OUTPUT.put_line('Subscriber set to active: ' || t1.EXTERNAL_ID);
               ELSE
                  UPDATE temp_feasibility_29_Oct_03 SET action = 'Cancel order in OM - Subscriber is inactive !!' WHERE order_id = t1.order_id;

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

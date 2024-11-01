--troubleshooting

select distinct trunc (aa.CREATE_DT)as CREATE_DT  ,aa.EXTERNAL_ID, aa.ORDER_ID||'.0' as order_id, bb.DISPLAY_VALUE as milestone ,dd.DISPLAY_VALUE as  status ,bb.MILESTONE_ID,cc.SQL_ERROR  
from  arbor.item_milestones aa , arbor.milestone_values bb , arbor.ORDER_WORK_QUEUE_ERROR  cc,  arbor.status_values dd
where aa.STATUS_ID in  (100  )and  aa.MILESTONE_ID=bb.MILESTONE_ID and aa.ORDER_ID=cc.ORDER_ID
and aa.STATUS_ID = dd.STATUS_ID-- and cc.SQL_ERarbom
and cc.CHG_DATE in (select max(CHG_DATE) from arbor.order_work_queue_error z where z.order_id = aa.order_id and z.item_id = aa.item_id ) and aa.ORDER_ID in (
select ORDER_ID from arbor.order_work_queue where QUEUE_TYPE = 44 and STATUS = 100) and bb.MILESTONE_ID in ( 200911)

--requeue order 
update  arbor.order_work_queue  set STATUS = 22 where 
 TRANSACTION_ID = 200911      --- for milstone number 
 and QUEUE_TYPE  = 44  --- for QUEUE_TYPE
and  STATUS =100  
------------------

select distinct trunc (aa.CREATE_DT)as CREATE_DT  ,aa.EXTERNAL_ID, aa.ORDER_ID||'.0' as order_id, bb.DISPLAY_VALUE as milestone ,dd.DISPLAY_VALUE as  status ,bb.MILESTONE_ID,cc.SQL_ERROR  
from  arbor.item_milestones aa , arbor.milestone_values bb , arbor.ORDER_WORK_QUEUE_ERROR  cc,  arbor.status_values dd
where aa.STATUS_ID in  (100  )and  aa.MILESTONE_ID=bb.MILESTONE_ID and aa.ORDER_ID=cc.ORDER_ID
and aa.STATUS_ID = dd.STATUS_ID-- and cc.SQL_ERarbom
and cc.CHG_DATE in (select max(CHG_DATE) from arbor.order_work_queue_error z where z.order_id = aa.order_id and z.item_id = aa.item_id ) and aa.ORDER_ID in (
select ORDER_ID from arbor.order_work_queue where EXTERNAL_ID='93589293') 

 ------------------------
select count (ORDER_ID) from ARBOR.order_work_queue a where TRANSACTION_ID = 99 and STATUS = 22 and trunc (CHG_DATE) >= to_date('9/24/2023','mm/dd/yyyy')

--upadte arbor
select *from ARBOR.order_work_queue_error a where TRANSACTION_ID = 99 and STATUS = 60 and trunc (CHG_DATE) >= to_date('12/12/2023','mm/dd/yyyy')
--------------------------


select count(*),CHG_WHO from arbor.customer_order co, arbor.customer_order_revision cor where co.order_id=COR.ORDER_ID and co.order_id_resets=COR.order_id_resets and 
co.CREATE_DT between TO_DATE( TO_CHAR(SYSDATE-1/24 ,'DD-MON-YYYY HH24:MI:SS'), 'DD-MON-YYYY HH24:MI:SS'  ) AND SYSDATE
group by CHG_WHO order by count(*) desc

----------------------------


declare
  L_TRACK_ID NUMBER;
  L_SERV_ID NUMBER;
  L_STATUS1 NUMBER;
  w_orderid NUMBER;
  w_itemid  NUMBER;
  w_parent_me NUMBER;
  w_parent_id NUMBER;
  w_action_code NUMBER;
  x_orderid NUMBER;
  x_itemid  NUMBER;
  x_parent_me NUMBER;
  x_parent_id NUMBER;
  x_action_code NUMBER;
  w_requeue NUMBER;
  w_complete NUMBER;
  cnt1 NUMBER;
  cnt2 NUMBER;
  cnt3 NUMBER;
  seq_num NUMBER;
  w_comp_status NUMBER;
  w_queuetype NUMBER;
  x_WORKFLOW_ID NUMBER;
  pre_status NUMBER;
  cursor c1 is
    SELECT  im.order_id , im.item_id ,parent_member_type, parent_id1, OI.ACTION_CODE, im.WORKFLOW_ID FROM arbor.item_milestones im, arbor.customer_order co, arbor.ORDER_ITEM oi
      WHERE status_id = w_comp_status
      and im.order_id = co.order_id
      and co.order_id = oi.order_id
      and im.ITEM_ID = oi.ITEM_ID
      and co.order_status in (2)
      and im.MILESTONE_ID = w_complete
      and im.order_id in (
'244080719');
begin
  w_comp_status := 22; -- status of milestone to be completed 
  w_complete := 200865; 
  open c1;
  fetch c1 into x_orderid, x_itemid, x_parent_me, x_parent_id, x_action_code, x_WORKFLOW_ID;
  while c1%found loop
    select STATUS_ID into pre_status from arbor.item_milestones where order_id = x_orderid and WORKFLOW_ID = x_WORKFLOW_ID and ITEM_ID = x_itemid 
      and MILESTONE_ID = (select MILESTONE_ID from arbor.ITEM_TYPE_MILESTONE where WORKFLOW_ID = x_WORKFLOW_ID 
      and SEQUENCE_NUMBER = (select SEQUENCE_NUMBER-1 from arbor.ITEM_TYPE_MILESTONE where WORKFLOW_ID = x_WORKFLOW_ID and MILESTONE_ID = w_complete))
      ;
    select count(1) into cnt1 from arbor.order_work_queue where order_id = x_orderid and ITEM_ID = x_itemid and PARENT_ID1 = x_parent_id and TRANSACTION_ID = w_complete and STATUS = w_comp_status
      ;
      select MILESTONE_ID into w_requeue from item_milestones where order_id = x_orderid and WORKFLOW_ID = x_WORKFLOW_ID and ITEM_ID = x_itemid
      and MILESTONE_ID = (select MILESTONE_ID from arbor.ITEM_TYPE_MILESTONE where WORKFLOW_ID = x_WORKFLOW_ID 
      and SEQUENCE_NUMBER = (select SEQUENCE_NUMBER+1 from arbor.ITEM_TYPE_MILESTONE where WORKFLOW_ID = x_WORKFLOW_ID and MILESTONE_ID = w_complete))
      ;
      select count(1) into cnt2 from arbor.order_work_queue where order_id = x_orderid and ITEM_ID = x_itemid and PARENT_ID1 = x_parent_id and TRANSACTION_ID = w_requeue
    ;
    select count(unique MILESTONE_ID) into cnt3 from arbor.item_milestones where order_id = x_orderid and status_id = w_comp_status
    ;
      if cnt1 = 1 and pre_status = 50 and cnt3 = 1 then
        update arbor.order_work_queue set STATUS = 50 where order_id = x_orderid and ITEM_ID = x_itemid and PARENT_ID1 = x_parent_id and TRANSACTION_ID = w_complete;
        update arbor.item_milestones set STATUS_ID = 50, CHG_WHO = lower(user) where order_id = x_orderid and ITEM_ID = x_itemid and PARENT_ID1 = x_parent_id and MILESTONE_ID = w_complete;
        if cnt2 = 0 then  
          select QUEUE_TYPE into w_queuetype from arbor.ITEM_TYPE_MILESTONE where WORKFLOW_ID = x_WORKFLOW_ID and MILESTONE_ID = w_requeue;
          SELECT  im.order_id , im.item_id ,parent_member_type, parent_id1, OI.ACTION_CODE into w_orderid, w_itemid, w_parent_me, w_parent_id, w_action_code
            FROM arbor. item_milestones im, arbor.customer_order co, arbor.ORDER_ITEM oi
            WHERE status_id = 1
            and im.order_id = co.order_id
            and co.order_id = oi.order_id
            and im.ITEM_ID = oi.ITEM_ID
            and co.order_status in (2)
            and im.MILESTONE_ID = w_requeue
            and im.order_id = x_orderid
            and parent_id1 = x_parent_id
            and im.ITEM_ID = x_itemid;
        arbor.ORD_SQL_GET_SEQ_NUM('ORDER_WORK_QUEUE',L_TRACK_ID,L_SERV_ID,L_STATUS1);
            -- 20 : waiting to be processed
            -- 22 : waiting to be sent
          insert into arbor.order_work_queue values (L_TRACK_ID,w_requeue, w_queuetype,w_orderid,0,w_itemid, 0, 0, 20,0,w_action_code,sysdate,0, trunc(sysdate),w_parent_me,w_parent_id,0,null,1, null,null,null);
        end if;
      update arbor.item_milestones set STATUS_ID = 22 where order_id = x_orderid and ITEM_ID = x_itemid and PARENT_ID1 = x_parent_id and MILESTONE_ID = w_requeue;
      update arbor.order_work_queue set STATUS = 22 where order_id = x_orderid and ITEM_ID = x_itemid and PARENT_ID1 = x_parent_id and TRANSACTION_ID = w_requeue;
      end if;
      commit;
    fetch c1 into x_orderid, x_itemid, x_parent_me, x_parent_id, x_action_code, x_WORKFLOW_ID;
  end loop;
  close c1;
end;

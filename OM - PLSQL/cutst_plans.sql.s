--custplans
select m.account_no, m.external_id, c.id_value, v.display_value, c.package_id, c.component_id, c.active_dt, c.inactive_dt, component_instance_id 
from arbor.cmf_package_components@to_bp c, arbor.component_definition_values@to_bp v , arbor. external_id_equip_map@to_bp  m
where   id_value  =m.subscr_no
and m.external_id in ('21014953' )
and m.external_id_type in(9,200,41,14)  and m.inactive_date is  null 
and c.component_id = v.component_id 
--and c.component_id=628
and v.language_code =1  
and inactive_dt is null
order by  m.external_id

SELECT * FROM DMA_PAYMENT_TRANSACTION@POSNEW B WHERE --DEP_ORDER_ACCOUNT_NO LIKE '14225622%' AND 
DEP_ORDER_SUBSCRIPTION_NO='99228011'
ORDER BY SYS_CREATION_DATE DESC

DECLARE 
  V_ACCOUNT_NO VARCHAR2(32767);
  V_EXTERNAL_ID VARCHAR2(32767);
  V_SUBSCR_NO VARCHAR2(32767);
  V_SUBSCR_NO_RESETS VARCHAR2(32767);
  V_COMPONENT_ID VARCHAR2(32767);
  V_PACKAGE_ID VARCHAR2(32767);
  V_USER_ID VARCHAR2(32767);
  V_ORDER_ID VARCHAR2(32767);
  V_ORDER_ID_RESETS VARCHAR2(32767);
  V_ITEM_DATE VARCHAR2(32767);
  cursor c1 is
  select * from arbor.external_id_equip_map@to_bp where external_id='91113001' and external_id_type in (200,9,41) and inactive_date is null;
BEGIN 
  V_COMPONENT_ID := '1943394';
  V_USER_ID := 'IM3057130';
  V_ORDER_ID := NULL;  V_ORDER_ID_RESETS := NULL;  V_ITEM_DATE := NULL;
  Begin
    select package_id into V_PACKAGE_ID from arbor.package_components@TO_BP where component_id=V_COMPONENT_ID;
    For v1 in c1
    Loop
  ARBOR.INTFC_SELFCARE_DELETE_COMP ( v1.account_no, v1.external_id, v1.SUBSCR_NO, v1.SUBSCR_NO_RESETS, V_COMPONENT_ID, V_PACKAGE_ID, V_USER_ID, V_ORDER_ID, V_ORDER_ID_RESETS, V_ITEM_DATE );
  dbms_output.put_line('V_ORDER_ID - '||V_ORDER_ID||' ');
  End loop;
  END;
END;

COMMIT;


create index orders_order_customer_id_idx
on orders(order_customer_id);

create index order_items_order_item_order_id_idx
on order_items (order_item_order_id)
-- adding indexes on ids

select count(*) 
from orders as o
	join order_items as oi
		 on o.order_id = oi.order_item_order_id
where order_customer_id = 5;

-- this will improve query time by not going in to sequence scanning of the entire table

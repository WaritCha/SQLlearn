alter table order_items ADD	
	foreign key (order_item_order_id) REFERENCES orders (order_id);

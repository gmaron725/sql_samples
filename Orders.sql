CREATE TABLE `orders_status` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),
    status_name VARCHAR(255) UNIQUE NOT NULL,

    PRIMARY KEY (uuid)    
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;



/*Монтаж Демонтаж Гарантия Починка и тд в одном (было Тема и Тип)*/
CREATE TABLE `order_types` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),
    type_name VARCHAR(255) UNIQUE NOT NULL,
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;


/*Низкий Средний Высокий*/
CREATE TABLE `orders_priorities`  (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),
    priority_name VARCHAR(255) UNIQUE NOT NULL,
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;









CREATE TABLE `orders` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),
    order_name varchar(255),

    order_status_id VARCHAR(36),
    FOREIGN KEY FK_orders_orders_status(order_status_id)
    REFERENCES orders_status(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    order_type_id VARCHAR(36),
    FOREIGN KEY FK_orders_order_types(order_type_id)
    REFERENCES order_types(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    order_cost decimal(15,3), /*Стоимость*/

    order_priority_id VARCHAR(36),
    FOREIGN KEY FK_orders_orders_priorities(order_priority_id)
    REFERENCES orders_priorities(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    order_client_id VARCHAR(36),
    FOREIGN KEY FK_orders_clients(order_client_id)
    REFERENCES clients(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    order_address_id VARCHAR(36),
    FOREIGN KEY FK_orders_addresses(order_address_id)
    REFERENCES addresses(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    personnel_id VARCHAR(36), /*Штат сотрудников*/
    FOREIGN KEY FK_orders_personnel(personnel_id)
    REFERENCES personnel(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    /*qualifications будет через м-м orders_qualifications*/

    responsible_id VARCHAR(36), /*Ответственный*/
    plan_date_start datetime,
    plan_date_stop  datetime,
    date_start      datetime,
    date_stop       datetime,
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;















/*M-M (Необходимая квалификация для заказа)*/
CREATE TABLE `orders_qualifications`  (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),

    order_id VARCHAR(36),
    FOREIGN KEY FK_orders_qualifications_orders(order_id)
    REFERENCES orders(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    qualification_id VARCHAR(36),
    FOREIGN KEY FK_orders_qualifications_qualifications(qualification_id)
    REFERENCES qualifications(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;
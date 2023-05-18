/*Определить Человек Или Компания*/
CREATE TABLE `client_types` (
    uuid VARCHAR(36) NOT NULL DEFAULT ( uuid() ),
    type_name	varchar(255) NOT NULL,

    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;


CREATE TABLE `clients` (
    uuid VARCHAR(36) NOT NULL DEFAULT ( uuid() ),
    client_name	varchar(255) NOT NULL,
    client_name_2 varchar(255),

    client_type_id VARCHAR(36) NOT NULL,
    FOREIGN KEY FK_clients_client_types(client_type_id)
    REFERENCES client_types(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,    
	
    /*contact_id	VARCHAR(36),
    FOREIGN KEY FK_clients_contacts(contact_id)
    REFERENCES contacts(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,*/
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;





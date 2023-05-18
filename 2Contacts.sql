/*ТипКОнтактаУдален*/
CREATE TABLE `contacts` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    middle_name varchar(255),
    
    phone varchar(10) NOT NULL,
    email varchar(255),

/*    contact_type_id VARCHAR(36) NOT NULL,
    FOREIGN KEY FK_contacts_contact_types(contact_type_id)
    REFERENCES contact_types(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,*/
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;


/*Для М-М*/
CREATE TABLE `contacts_clients` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),

	contact_id VARCHAR(36) NOT NULL,
    FOREIGN KEY FK_contacts_clients_contacts(contact_id)
    REFERENCES contacts(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,    
	
    client_id VARCHAR(36),
    FOREIGN KEY FK_contacts_clients_clients(client_id)
    REFERENCES clients(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT, 
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;
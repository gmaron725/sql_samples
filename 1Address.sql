/*Personal/Corporate*/
CREATE TABLE `address_types` (
    uuid VARCHAR(36) NOT NULL DEFAULT ( uuid() ),
    type varchar(255) NOT NULL,
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;



CREATE TABLE `addresses` (
    uuid VARCHAR(36) NOT NULL DEFAULT ( uuid() ),
    city varchar(255) NOT NULL,
    street varchar(255) NOT NULL,
    house  varchar(255) NOT NULL,
    apartments varchar(255) NOT NULL,
    note varchar(255), /*dop stolbec primechaniya*/
    postal_code varchar(6),

    address_type_id VARCHAR(36) NOT NULL,
    FOREIGN KEY FK_addresses_address_types(address_type_id)
    REFERENCES address_types(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,  
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;



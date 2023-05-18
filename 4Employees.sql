CREATE TABLE `employee_contacts` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),
    phone VARCHAR(10) NOT NULL,
    email VARCHAR(255),
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;



CREATE TABLE `employees` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),
    employee_first_name VARCHAR(255) NOT NULL,
    employee_last_name VARCHAR(255) NOT NULL,
    employee_middle_name VARCHAR(255) NOT NULL,
    job_title VARCHAR(255) NOT NULL,
    department VARCHAR(255),

    manager_id VARCHAR(36),

    employee_contact_id VARCHAR(36),
    FOREIGN KEY FK_employees_employee_contacts(employee_contact_id)
    REFERENCES employee_contacts(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    address_id VARCHAR(36),
    FOREIGN KEY FK_employees_addresses(address_id)
    REFERENCES addresses(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    /*qualification_employee_id VARCHAR(36),*/
	

    photo_path VARCHAR(255),

    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;

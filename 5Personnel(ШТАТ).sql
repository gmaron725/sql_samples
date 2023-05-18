CREATE TABLE `personnel` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),
    personnel_name VARCHAR(255) UNIQUE NOT NULL,
 
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;



CREATE TABLE `personnel_employee` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),

    personnel_id VARCHAR(36),
    FOREIGN KEY FK_personnel_employee_personnel(personnel_id)
    REFERENCES personnel(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    employee_id  VARCHAR(36),
    FOREIGN KEY FK_personnel_employee_employees(employee_id)
    REFERENCES employees(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
    
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;

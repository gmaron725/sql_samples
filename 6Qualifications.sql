CREATE TABLE `qualification_types` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),
    type varchar(255) NOT NULL,
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;


CREATE TABLE `qualifications` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),
    skill_name varchar(255) NOT NULL,
    skill_des  varchar(255) NOT NULL,

    qualification_type_id VARCHAR(36) NOT NULL,
    FOREIGN KEY FK_qualifications_qualification_types(qualification_type_id)
    REFERENCES qualification_types(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
    
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;



CREATE TABLE `qualification_employee` (
    uuid VARCHAR(36) UNIQUE NOT NULL DEFAULT ( uuid() ),

    qualification_id VARCHAR(36) NOT NULL,
    FOREIGN KEY FK_qualification_employee_qualifications(qualification_id)
    REFERENCES qualifications(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    employee_id      VARCHAR(36) NOT NULL,
    FOREIGN KEY FK_qualification_employee_employees(employee_id)
    REFERENCES employees(uuid)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
    
	
    PRIMARY KEY (uuid)
) ENGINE = InnoDB CHARSET=utf8 COLLATE utf8_general_ci;


/*
===================================================
FK_ChildTable_ParentTable
===================================================
*/



DELIMITER //

DROP PROCEDURE IF EXISTS getAllEmployees //

CREATE PROCEDURE 
  getAllEmployees( )
BEGIN  
   SELECT * FROM employees
   ORDER BY employees.employee_last_name
   ;  
END 
//

DELIMITER ;



//Пример вызова---------------------------
//$sql = "SELECT * FROM employees";
	$sql = "call getAllEmployees()";
//---------------------------------------------------------





DELIMITER //

DROP PROCEDURE IF EXISTS getEmployees //

CREATE PROCEDURE 
  getEmployees( in_FIO VARCHAR(36) )
BEGIN




if LENGTH(in_FIO) > 0 then

   SELECT * FROM employees
   WHERE employee_first_name LIKE in_FIO 
   OR employee_last_name LIKE in_FIO
   OR employee_middle_name LIKE in_FIO
   ; 

else 

   SELECT * FROM employees
   ;
   
end if;   


END 
//

DELIMITER ;














DELIMITER //

DROP PROCEDURE IF EXISTS getAllAddressTypes //

CREATE PROCEDURE 
  getAllAddressTypes( )
BEGIN  
   SELECT * FROM address_types
   ;  
END 
//

DELIMITER ;










DELIMITER //

DROP PROCEDURE IF EXISTS getAllClientTypes //

CREATE PROCEDURE 
  getAllClientTypes( )
BEGIN  
   SELECT * FROM client_types
   ;  
END 
//

DELIMITER ;





DELIMITER //

DROP PROCEDURE IF EXISTS getAllDepartments //

CREATE PROCEDURE 
  getAllDepartments( )
BEGIN  
   SELECT * FROM departments
   ;  
END 
//

DELIMITER ;









DELIMITER //

DROP PROCEDURE IF EXISTS getAllJobTitles //

CREATE PROCEDURE 
  getAllJobTitles( )
BEGIN  
   SELECT * FROM job_titles
   ORDER BY job_titles.department_id
   ;  
END 
//

DELIMITER ;







DELIMITER //

DROP PROCEDURE IF EXISTS getManagerByDepartment //

CREATE PROCEDURE 
  getManagerByDepartment( in_department_id VARCHAR(36) )
BEGIN

if LENGTH(in_department_id) > 0 then

   SELECT * FROM employees
   INNER JOIN job_titles ON job_titles.uuid = employees.job_title_id
   INNER JOIN departments ON departments.uuid = job_titles.department_id
   WHERE departments.uuid = in_department_id
   ; 

else 

   SELECT * FROM employees
   INNER JOIN job_titles ON job_titles.uuid = employees.job_title_id
   INNER JOIN departments ON departments.uuid = job_titles.department_id
   ; 
   
end if;   
   
END 
//

DELIMITER ;



/*
DELIMITER //

DROP PROCEDURE IF EXISTS getAllAddresses //

CREATE PROCEDURE 
  getAllAddresses( )
BEGIN  
   SELECT * FROM addresses
   ;  
END 
//

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS getAllEmployeeAddresses //

CREATE PROCEDURE 
  getAllEmployeeAddresses( )
BEGIN  
   SELECT * FROM addresses
   WHERE addresses.address_type_id = '452cc461-f211-11ec-8a52-002ed15969ac'
   ;  
END 
//

DELIMITER ;
*/





/*Выводит 1 адресс сотрудника*/
DELIMITER //

DROP PROCEDURE IF EXISTS getEmployeeAddress //

CREATE PROCEDURE 
  getEmployeeAddress( in_employee_id VARCHAR(36) )
BEGIN

   SELECT addresses.* FROM addresses
   INNER JOIN employees ON employees.address_id = addresses.uuid
   WHERE employees.uuid = in_employee_id
   LIMIT 1; 

END 
//

DELIMITER ;





DELIMITER //

DROP PROCEDURE IF EXISTS getAddress //

CREATE PROCEDURE 
  getAddress( in_uuid VARCHAR(36) )
BEGIN

   SELECT addresses.* FROM addresses
   WHERE addresses.uuid = in_uuid;

END 
//

DELIMITER ;










DELIMITER //

DROP PROCEDURE IF EXISTS getEmployeeContactsByEmployeeId //

CREATE PROCEDURE 
  getEmployeeContactsByEmployeeId( in_employee_id VARCHAR(36) )
BEGIN

   SELECT * FROM employee_contacts
   WHERE employee_id = in_employee_id
   ; 

END 
//

DELIMITER ;















DELIMITER //

DROP PROCEDURE IF EXISTS getEmployeeQualificationsByEmployeeId //

CREATE PROCEDURE 
  getEmployeeQualificationsByEmployeeId( in_employee_id VARCHAR(36) )
BEGIN

	SELECT qualifications.uuid, qualifications.skill_name, qualifications.skill_des, qualifications.qualification_type_id
	FROM qualification_employee
	INNER JOIN qualifications ON qualifications.uuid = qualification_employee.qualification_id
	WHERE employee_id = in_employee_id
	;

END 
//

DELIMITER ;







DELIMITER //

DROP PROCEDURE IF EXISTS getAllOrders //

CREATE PROCEDURE 
  getAllOrders( )
BEGIN  
    SELECT * FROM orders
	LEFT JOIN orders_status ON orders_status.uuid = orders.order_status_id
	LEFT JOIN order_types ON order_types.uuid = orders.order_type_id
	LEFT JOIN orders_priorities ON orders_priorities.uuid = orders.order_priority_id
	LEFT JOIN clients ON clients.uuid = orders.order_client_id
	LEFT JOIN client_types ON client_types.uuid = clients.client_type_id
	LEFT JOIN addresses ON addresses.uuid = orders.order_address_id
	LEFT JOIN personnel ON personnel.uuid = orders.personnel_id
	;
END 
//

DELIMITER ;







-------УдалитьСотрудника
-------Сначала удалить все связи(мешающие удалению), потом сотрудника
(удалить все где связь 1 ко многим считая от empoyees)
----------------------------------------
DELETE FROM qualification_employee
WHERE qualification_employee.employee_id = in_employee_id
--------------------------------------
DELETE FROM personnel_employee
WHERE personnel_employee.employee_id = in_employee_id
---------------------------------------------------------------
DELETE FROM employee_contacts
WHERE employee_contacts.employee_id = in_employee_id
----------------------------------------------------------------------------
DELETE FROM employees
WHERE employees.uuid = in_employee_id





DELIMITER //

DROP PROCEDURE IF EXISTS deleteEmployee //

CREATE PROCEDURE 
  deleteEmployee( in_employee_id VARCHAR(36) )
proc_label:BEGIN

IF LENGTH(in_employee_id) < 36 THEN
          LEAVE proc_label;
END IF;

DELETE FROM qualification_employee
WHERE qualification_employee.employee_id = in_employee_id;

DELETE FROM personnel_employee
WHERE personnel_employee.employee_id = in_employee_id;

DELETE FROM employee_contacts
WHERE employee_contacts.employee_id = in_employee_id;

DELETE FROM personnel_employee
WHERE personnel_employee.employee_id = in_employee_id;

DELETE FROM personnel
WHERE personnel.uuid = in_employee_id;

/*--- save address_id*/
CREATE TEMPORARY TABLE TempTable (uuid VARCHAR(36)); 
INSERT INTO TempTable
SELECT employees.address_id FROM employees WHERE employees.uuid = in_employee_id;
/*---*/

DELETE FROM employees
WHERE employees.uuid = in_employee_id;

/*--- удалить адрес только если на него больше никто не ссылается*/
SELECT COUNT(*) INTO @cc FROM employees WHERE employees.address_id IN (SELECT uuid FROM TempTable);
IF(@cc = 0)
THEN
	/*для отладки UPDATE employees SET address_id = NULL WHERE address_id IN (SELECT uuid FROM TempTable);*/
	DELETE FROM addresses
	WHERE addresses.uuid IN (SELECT uuid FROM TempTable); 
END IF;
/*---*/


END 
//

DELIMITER ;

/*Проблема в том что для удаления адреса нужно удалить всех сотрудников(заказов и тд) или поменять им адрес*/
/*Но у простых юзеров и не должно быть доступа к таблице. И удалять адрес без сотрудника(заказа) не нужно*/







DELIMITER //

DROP PROCEDURE IF EXISTS deleteEmployeeContact //

CREATE PROCEDURE 
  deleteEmployeeContact( in_contact_id VARCHAR(36) )
proc_label:BEGIN

IF LENGTH(in_contact_id) < 36 THEN
          LEAVE proc_label;
END IF;

DELETE FROM employee_contacts
WHERE uuid = in_contact_id; 

END 
//

DELIMITER ;






DELIMITER //

DROP PROCEDURE IF EXISTS resetEmployeePassword //

CREATE PROCEDURE 
  resetEmployeePassword( in_employee_id VARCHAR(36), in_password VARCHAR(255) )
proc_label:BEGIN

IF LENGTH(in_employee_id) < 36 THEN
          LEAVE proc_label;
END IF;

UPDATE employees
	SET password = in_password,
		is_pass_initial = 1,
WHERE employees.uuid = in_employee_id;

END 
//

DELIMITER ;












DELIMITER //

DROP PROCEDURE IF EXISTS getQualificationsByName //

CREATE PROCEDURE 
  getQualificationsByName( in_qualification VARCHAR(255) )
proc_label:BEGIN


if LENGTH(in_qualification) > 0 then

   SELECT * FROM qualifications
   WHERE skill_name LIKE in_qualification 
   OR skill_des LIKE in_qualification
   ; 

else 

   SELECT * FROM qualifications
   ;
   
end if;


END 
//

DELIMITER ;






DELIMITER //

DROP PROCEDURE IF EXISTS getQualificationsByQualificationTypeId //

CREATE PROCEDURE 
  getQualificationsByQualificationTypeId( in_uuid VARCHAR(36) )
proc_label:BEGIN

IF LENGTH(in_uuid) < 36 THEN
          LEAVE proc_label;
END IF;

SELECT * 
FROM qualifications
WHERE qualification_type_id = in_uuid;



END 
//

DELIMITER ;








DELIMITER //

DROP PROCEDURE IF EXISTS getQualificationTypes //

CREATE PROCEDURE 
  getQualificationTypes( in_qualificationType VARCHAR(255) )
proc_label:BEGIN


if LENGTH(in_qualificationType) > 0 then

   SELECT * FROM qualifications
   WHERE skill_name LIKE in_qualificationType 
   ; 

else 

   SELECT * FROM qualification_types
   ;
   
end if;   


END 
//

DELIMITER ;










/*
DELIMITER //

DROP PROCEDURE IF EXISTS addEmployeeOLD //

CREATE PROCEDURE 
  addEmployeeOLD(
  in_first_name VARCHAR(36),
  in_last_name VARCHAR(36),
  in_middle_name VARCHAR(36),
  in_job_title_id VARCHAR(36),
  in_manager_id VARCHAR(36), 
  in_address_id VARCHAR(36),
  in_photo_path VARCHAR(36)
  )
BEGIN
   INSERT INTO employees 
   ( employee_first_name,
   employee_last_name,
   employee_middle_name,
   job_title_id,
   manager_id, 
   address_id,
   photo_path )
   
   VALUES
   (in_first_name,
   in_last_name,
   in_middle_name,
   (CASE WHEN in_job_title_id IS NULL OR LENGTH(in_job_title_id) = 0 THEN NULL ELSE in_job_title_id END),
   (CASE WHEN in_manager_id IS NULL OR LENGTH(in_manager_id) = 0 THEN NULL ELSE in_manager_id END),
   (CASE WHEN in_address_id IS NULL OR LENGTH(in_address_id) = 0 THEN NULL ELSE in_address_id END),
   (CASE WHEN in_photo_path IS NULL OR LENGTH(in_photo_path) = 0 THEN NULL ELSE in_photo_path END)
   );
END 
//

DELIMITER ;
*/




DELIMITER //
DROP PROCEDURE IF EXISTS addEmployee //
CREATE PROCEDURE 
  addEmployee(
  in_first_name VARCHAR(36),
  in_last_name VARCHAR(36),
  in_middle_name VARCHAR(36),
  in_job_title_id VARCHAR(36),
  in_manager_id VARCHAR(36), 
  in_photo VARCHAR(1),
  in_login VARCHAR(36),
  in_password VARCHAR(255)
  )
BEGIN
	SET @uuid=UUID();
	
	INSERT INTO employees(
	uuid,
	employee_first_name,
	employee_last_name,
	employee_middle_name,
	job_title_id,
	manager_id,
	photo_path,
	login,
	password
	)

	VALUES
	(@uuid,
	in_first_name,
	in_last_name,
	in_middle_name,
	(CASE WHEN IFNULL(in_job_title_id, '') = '' THEN NULL ELSE in_job_title_id END),/*job_title_id*/
	(CASE WHEN IFNULL(in_manager_id, '') = '' THEN NULL ELSE in_manager_id END),/*manager_id*/
	(CASE WHEN in_photo = "1" THEN CONCAT(@uuid,'.png') ELSE photo_path END), /*photo_path*/
	in_login, /*login*/
	in_password /*password*/
	);

	/*Для каждого нового юзера создать Бригаду состоящуюю из 1го человека*/
	INSERT INTO personnel(uuid, personnel_name) VALUES (@uuid, CONCAT(in_last_name,in_first_name,in_middle_name));
	INSERT INTO personnel_employee(uuid, personnel_id, employee_id) VALUES (@uuid, @uuid, @uuid);
	
	SET @uuid = IF(ROW_COUNT(),@uuid,null);
	SELECT @uuid;
END 
//
DELIMITER ;











DELIMITER //
DROP PROCEDURE IF EXISTS changeEmployee //
CREATE PROCEDURE 
  changeEmployee(
  in_employee_id VARCHAR(36),
  in_first_name VARCHAR(36),
  in_last_name VARCHAR(36),
  in_middle_name VARCHAR(36),
  in_job_title_id VARCHAR(36),
  in_manager_id VARCHAR(36), 
  in_photo VARCHAR(1),
  in_login VARCHAR(36)
  )
proc_label:BEGIN

IF LENGTH(in_employee_id) < 36
	THEN
	SELECT 'employee_id IS NULL';
	LEAVE proc_label;
END IF;

IF (in_job_title_id = 'null' OR in_job_title_id = '')
	THEN SET in_job_title_id  = NULL;
END IF;

IF (in_manager_id = 'null' OR in_manager_id = '')
	THEN SET in_manager_id  = NULL;
END IF;

UPDATE employees
	SET employee_first_name = in_first_name,
		employee_last_name = in_last_name,
		employee_middle_name = in_middle_name,
		job_title_id = in_job_title_id,
		manager_id = in_manager_id, 
		photo_path = (CASE WHEN @in_photo = "1" THEN CONCAT(@uuid,'.png') ELSE photo_path END)
		/*,
		login = in_login*/
WHERE employees.uuid = in_employee_id;

/*SET @uuid = IF(ROW_COUNT(),in_employee_id,null);
SELECT @uuid;*/

SELECT in_employee_id, in_photo, ROW_COUNT(); 

END
//
DELIMITER ;











DELIMITER //
DROP PROCEDURE IF EXISTS changeEmployeeContact //
CREATE PROCEDURE 
  changeEmployeeContact(
  in_contact_id VARCHAR(36),
  in_phone VARCHAR(10),
  in_email VARCHAR(255)
  )
BEGIN



UPDATE employee_contacts
	SET phone = in_phone,
		email = in_email
WHERE uuid = in_contact_id;


IF(ROW_COUNT()>0)
	THEN
		SELECT in_contact_id;
END IF;


END 
//
DELIMITER ;













DELIMITER //

DROP PROCEDURE IF EXISTS addEmployeeContact //

CREATE PROCEDURE 
  addEmployeeContact(
  in_employee_id VARCHAR(36),
  in_phone VARCHAR(10),
  in_mail VARCHAR(255)
  )
BEGIN
   INSERT INTO employee_contacts (employee_id, phone, email)
   VALUES(in_employee_id, in_phone, in_mail)
   ;
END 
//

DELIMITER ;


/*-----------------------*/
DELIMITER //

SELECT COUNT(*)
INTO @cc
FROM address_types WHERE type_name = 'EmployeeAddress'//

IF (@cc=0) THEN
	INSERT INTO address_types (uuid, type_name) VALUES ('452cc461-f211-11ec-8a52-002ed15969ac', 'EmployeeAddress');
END IF //
/*-----------------------*/
/*-----------------------*/
DELIMITER //

SELECT COUNT(*)
INTO @cc
FROM address_types WHERE type_name = 'OrderAddress'//

IF (@cc=0) THEN
	INSERT INTO address_types (uuid, type_name) VALUES ('b3b3d583-0263-11ed-893c-002ed15969ac', 'OrderAddress');
END IF //
/*-----------------------*/
/*-----------------------ТипКвалификации=Монтаж*/
DELIMITER //

SELECT COUNT(*)
INTO @cc
FROM qualification_types WHERE type = 'Монтаж'//

IF (@cc=0) THEN
	INSERT INTO qualification_types (uuid, type) VALUES ('9ba960d6-07e3-11ed-89ac-002ed15969ac', 'Монтаж');
END IF //
/*-----------------------*/
/*-----------------------ТипКвалификации=Ремонт*/
DELIMITER //

SELECT COUNT(*)
INTO @cc
FROM qualification_types WHERE type = 'Ремонт'//

IF (@cc=0) THEN
	INSERT INTO qualification_types (uuid, type) VALUES ('d1e4f0ec-07e3-11ed-89ac-002ed15969ac', 'Ремонт');
END IF //
/*-----------------------*/












DELIMITER //

DROP PROCEDURE IF EXISTS addOrChangeEmployeeAddress //

CREATE PROCEDURE 
  addOrChangeEmployeeAddress(
  in_employee_id VARCHAR(36),
  in_city VARCHAR(255),
  in_street VARCHAR(255),
  in_house VARCHAR(255),
  in_apartments VARCHAR(255),
  in_note VARCHAR(255),
  in_postal_code VARCHAR(255)
  )
BEGIN

/*Проверяем есть ли уже такой адрес*/
SELECT addresses.uuid INTO @lv_uuid
FROM addresses
WHERE addresses.city = in_city
AND addresses.street = in_street
AND addresses.house = in_house
AND addresses.apartments = in_apartments
AND addresses.address_type_id = '452cc461-f211-11ec-8a52-002ed15969ac'
LIMIT 1;

SET @uuid=UUID();
SET @result_set = 0;
IF( LENGTH(@lv_uuid) = 36) 
THEN
	/*Адрес уже есть. Назначаем Адрес Сотруднику*/
	SET @uuid=@lv_uuid;
	CALL setEmployeeAddress(in_employee_id, @uuid, @result_set);
	IF @result_set = 1
		THEN
			SELECT @uuid;
	END IF;
	
ELSE
	/*Адреса нет. создать и назначить сотруднику*/
	INSERT INTO addresses (
	uuid,
	city,
	street,
	house,
	apartments,
	note,
	postal_code, 
	address_type_id
	)
	VALUES(@uuid, in_city, in_street, in_house, in_apartments, in_note, in_postal_code, '452cc461-f211-11ec-8a52-002ed15969ac');
	
	IF(ROW_COUNT() > 0)
	THEN
		CALL setEmployeeAddress(in_employee_id, @uuid, @result_set);
		IF @result_set = 1
			THEN
				SELECT @uuid;
		END IF;
	END IF;

END IF;


END 
//

DELIMITER ;
/*----------------------------------------------------------------------------------------------*/
















DELIMITER //

DROP PROCEDURE IF EXISTS setEmployeeAddress //

CREATE PROCEDURE 
  setEmployeeAddress(
  in_employee_id VARCHAR(36),
  in_address_id VARCHAR(36),
  OUT my_result TINYINT(1)
  )
BEGIN

UPDATE employees
SET employees.address_id = in_address_id
WHERE employees.uuid = in_employee_id;

IF(ROW_COUNT() > 0) THEN
	SET my_result = 1;
END IF;
   
END 
//

DELIMITER ;
/*----------------------------------------------------------------------------------------------*/











/*------------------------
IF tablename IS NULL THEN
          LEAVE proc_label;
END IF;
---------------------------------


Для каждой добавить проверку на NULL
commit
rol
продумать индексы и удаление (CASCADE или SET NULL)
*/




DELIMITER //

DROP PROCEDURE IF EXISTS changePass //

CREATE PROCEDURE 
  changePass(
  inputEmail VARCHAR(255),
  inputPhone VARCHAR(255),
  inputPassword VARCHAR(255),
  inputLogin VARCHAR(255),
  )
BEGIN




UPDATE employees 
SET password = inputPassword, is_pass_initial = 0
WHERE employees.uuid IN (SELECT employee_contacts.employee_id FROM employee_contacts WHERE employee_contacts.email = inputEmail)
OR employees.uuid IN (SELECT employee_contacts.employee_id FROM employee_contacts WHERE employee_contacts.phone = inputPhone)
OR employees.login IN (SELECT employees.login FROM employees WHERE employees.login = inputLogin);

IF(ROW_COUNT() > 0 )
THEN 
	SELECT inputPassword;
END IF;

END
//

DELIMITER ;










/*Квалификации*/
DELIMITER //

DROP PROCEDURE IF EXISTS getAllQualificationTypes //

CREATE PROCEDURE 
	getAllQualificationTypes()
BEGIN
	SELECT * FROM qualification_types;
END
//

DELIMITER ;



DELIMITER //
DROP PROCEDURE IF EXISTS addQualificationType //
CREATE PROCEDURE 
  addQualificationType(
  in_type_name VARCHAR(36)
  )
BEGIN
	SET @uuid=UUID();
	
	INSERT INTO qualification_types(
		uuid,
		type
	)

	VALUES
	(
		@uuid,
		in_type_name
	);

	SET @uuid = IF(ROW_COUNT(),@uuid,null);
	SELECT @uuid;
END 
//
DELIMITER ;








DELIMITER //

DROP PROCEDURE IF EXISTS deleteQualificationType //

CREATE PROCEDURE 
  deleteQualificationType( in_uuid VARCHAR(36) )
proc_label:BEGIN

IF LENGTH(in_uuid) < 36 THEN
          LEAVE proc_label;
END IF;


/*
CREATE TEMPORARY TABLE TempTable (uuid VARCHAR(36)); 
INSERT INTO TempTable
SELECT qualifications.uuid FROM qualifications WHERE qualifications.type = in_uuid;
-*/

DELETE FROM qualification_employee
WHERE qualification_employee.qualification_id IN (SELECT qualifications.uuid FROM qualifications WHERE qualifications.qualification_type_id = in_uuid);

DELETE FROM qualifications
WHERE qualifications.qualification_type_id = in_uuid;

DELETE FROM qualification_types
WHERE qualification_types.uuid = in_uuid;

END 
//

DELIMITER ;




DELIMITER //
DROP PROCEDURE IF EXISTS changeQualificationType //
CREATE PROCEDURE 
  changeQualificationType(
  in_uuid VARCHAR(36),
  in_type VARCHAR(36)
  )
proc_label:BEGIN

IF LENGTH(in_uuid) < 36
THEN
	LEAVE proc_label;
END IF;


UPDATE qualification_types
	SET qualification_types.type = in_type
WHERE uuid = in_uuid;


IF(ROW_COUNT()>0)
	THEN
		SELECT in_uuid;
END IF;


END 
//
DELIMITER ;






DELIMITER //
DROP PROCEDURE IF EXISTS addQualification//
CREATE PROCEDURE 
  addQualification(
  in_type_id VARCHAR(36),
  in_skill_name VARCHAR(255),
  in_skill_des VARCHAR(255)
  )
proc_label:BEGIN

IF LENGTH(in_type_id) < 36
THEN
	LEAVE proc_label;
END IF;

	SET @uuid=UUID();
	
	INSERT INTO qualifications(
		uuid,
		skill_name,
		skill_des,
		qualification_type_id
	)

	VALUES
	(
		@uuid,
		in_skill_name,
		in_skill_des,
		in_type_id
	);

	SET @uuid = IF(ROW_COUNT(),@uuid,null);
	SELECT @uuid;
END 
//
DELIMITER ;






DELIMITER //

DROP PROCEDURE IF EXISTS deleteQualification //

CREATE PROCEDURE 
  deleteQualification( in_uuid VARCHAR(36) )
proc_label:BEGIN

IF LENGTH(in_uuid) < 36 THEN
          LEAVE proc_label;
END IF;

DELETE FROM qualification_employee
WHERE qualification_employee.qualification_id = in_uuid;

DELETE FROM qualifications
WHERE qualifications.uuid = in_uuid;


END 
//

DELIMITER ;






DELIMITER //
DROP PROCEDURE IF EXISTS changeQualification //
CREATE PROCEDURE 
  changeQualification(
  in_uuid VARCHAR(36),
  in_skill_name VARCHAR(255),
  in_skill_des VARCHAR(255)
  )
proc_label:BEGIN

IF LENGTH(in_uuid) < 36
THEN
	LEAVE proc_label;
END IF;


UPDATE qualifications
	SET qualifications.skill_name = in_skill_name,
		qualifications.skill_des = in_skill_des
WHERE qualifications.uuid = in_uuid;


IF(ROW_COUNT()>0)
	THEN
		SELECT in_uuid;
END IF;


END 
//
DELIMITER ;
















/*-----------------------*/
DELIMITER //

SELECT COUNT(*)
INTO @cc
FROM client_types WHERE type_name = 'Company'//

IF (@cc=0) THEN
	INSERT INTO client_types (uuid, type_name) VALUES ('1ebbd032-099e-11ed-89ac-002ed15969ac', 'Company');
END IF //
/*-----------------------*/
/*-----------------------*/
DELIMITER //

SELECT COUNT(*)
INTO @cc
FROM client_types WHERE type_name = 'Individual'//

IF (@cc=0) THEN
	INSERT INTO client_types (uuid, type_name) VALUES ('a008b22f-099e-11ed-89ac-002ed15969ac', 'Individual');
END IF //
/*-----------------------*/



DELIMITER //

DROP PROCEDURE IF EXISTS getAllClients //

CREATE PROCEDURE 
  getAllClients( )
BEGIN  
   SELECT clients.uuid,
		  clients.client_name,
		  clients.client_name2,
		  clients.client_type_id,
		  client_types.type_name
   FROM clients
   INNER JOIN client_types ON client_types.uuid = clients.client_type_id
   ORDER BY clients.client_name
   ;  
END 
//

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS getAllClientTypes //

CREATE PROCEDURE 
  getAllClientTypes( )
BEGIN
   SELECT * FROM client_types;  
END 
//

DELIMITER ;



DELIMITER //

DROP PROCEDURE IF EXISTS getClientContacts //

CREATE PROCEDURE 
  getClientContacts(in_uuid VARCHAR(36))
proc_label:BEGIN

IF LENGTH(in_uuid) < 36
THEN
	LEAVE proc_label;
END IF;

   SELECT contacts.* FROM contacts
   WHERE uuid IN (SELECT contact_id FROM contacts_clients WHERE client_id = in_uuid)
   ; 

END 
//

DELIMITER ;
















DELIMITER //
DROP PROCEDURE IF EXISTS addClient//
CREATE PROCEDURE 
  addClient(
  in_client_name VARCHAR(255),
  in_client_name2 VARCHAR(255),
  in_client_type_id VARCHAR(36)
  )
BEGIN



	SET @uuid=UUID();
	
	INSERT INTO clients(
		uuid,
		client_name,
		client_name2,
		client_type_id
	)

	VALUES
	(
		@uuid,
		in_client_name,
		in_client_name2,
		in_client_type_id
	);

	SET @uuid = IF(ROW_COUNT(),@uuid,null);
	SELECT @uuid;
END 
//
DELIMITER ;













DELIMITER //
DROP PROCEDURE IF EXISTS changeClient //
CREATE PROCEDURE 
  changeClient(
  in_uuid VARCHAR(36),
  in_client_name VARCHAR(255),
  in_client_name2 VARCHAR(255),
  in_client_type_id VARCHAR(36)
  )
proc_label:BEGIN

IF LENGTH(in_uuid) < 36
THEN
	LEAVE proc_label;
END IF;


UPDATE clients
	SET clients.client_name = in_client_name,
	    clients.client_name2 = in_client_name2,
	    clients.client_type_id = in_client_type_id
WHERE clients.uuid = in_uuid;

IF(ROW_COUNT()>0)
	THEN
		SELECT in_uuid;
END IF;


END 
//
DELIMITER ;

-- MySQL dump 10.13  Distrib 5.5.60, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: radius
-- ------------------------------------------------------
-- Server version	5.5.60-0+deb8u1-log
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'radius'
--
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`freeradius`@`%` PROCEDURE `beforeauth`(
 IN v_ip VARCHAR(15) charset utf8,
 IN v_login VARCHAR(64) charset utf8
 )
BEGIN

DECLARE halyava INT DEFAULT 0;
select count(*)into halyava from radfreecharge as rad where rad.ip = v_ip;

IF ( halyava > 0) THEN
 (select 2 as id, v_login as username, 'Cleartext-Password' as attribute, v_login as value, ':=' as op)
 union
 (select 1 as id, v_login as username, 'Framed-IP-Address' as attribute, v_ip as value, '==' as op); 
ELSE
 (SELECT 
 rad_b.id as id, rad_b.mac as username, 'Cleartext-Password' as attribute, rad_b.mac as value, ':=' as op 
 FROM 
 radbilling as rad_b left join radpackets as rad_p on (rad_b.pid = rad_p.pid) 
 WHERE 
 rad_b.mac = v_login 
 AND 
 rad_p.value = v_ip 
 AND 
 rad_b.status = 0 
 AND 
 rad_b.date1 <= CURDATE() 
 AND 
 ( 
 rad_b.date2 >= CURDATE() 
 OR 
 rad_b.date2 IS NULL 
 )) 
 UNION 
 ( 
 SELECT 
 '1' as id, 
 v_login as username, 
 'Framed-IP-Address' as attribute, 
 v_ip as value, 
 '==' as op 
 );
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`freeradius`@`%` PROCEDURE `beforeauth_work`(IN v_ip VARCHAR(15),

 IN v_login VARCHAR(64))
BEGIN

	DECLARE before_check INT DEFAULT 0;
	DECLARE before_packets INT DEFAULT 0;

	select count(*) into before_check from radfreecharge as rad where rad.ip = v_ip;
	SELECT count(*) into before_packets 
	FROM radbilling as rad_b
		left join radpackets as rad_p on (rad_b.pid = rad_p.pid) 
	WHERE rad_b.mac = v_login 
		AND rad_p.value = v_ip
		AND rad_b.pid = 6
		AND rad_b.status = 0 
		AND rad_b.date1 <= CURDATE() 
		AND (rad_b.date2 >= CURDATE() OR rad_b.date2 IS NULL);

	IF ( before_check > 0 OR before_packets > 0) THEN

		(select 2 as id, v_login as username, 'Cleartext-Password' as attribute, v_login as value, ':=' as op)
		union
		(select 1 as id, v_login as username, 'Framed-IP-Address' as attribute, v_ip as value, '==' as op); 

	ELSE

		(SELECT 
			rad_b.id as id,
			rad_b.mac as username,
			'Cleartext-Password' as attribute,
			rad_b.mac as value,
			':=' as op 
		FROM radbilling as rad_b
			left join radpackets as rad_p on (rad_b.pid = rad_p.pid) 
		WHERE rad_b.mac = v_login 
			AND rad_p.value = v_ip
			AND rad_b.pid <> 6 
			AND rad_b.status = 0 
			AND rad_b.date1 <= CURDATE() 
			AND (rad_b.date2 >= CURDATE() OR rad_b.date2 IS NULL)
		LIMIT 1

		)UNION( 
			SELECT 
				'1' as id, 
				v_login as username, 
				'Framed-IP-Address' as attribute, 
				v_ip as value, 
				'==' as op 
			);

	END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`freeradius`@`%` PROCEDURE `postauth`(
 IN login VARCHAR(64) charset utf8,
 IN v_pass VARCHAR(64) charset utf8,
 IN v_reply VARCHAR(32) charset utf8,
 IN v_authdate TIMESTAMP,
 IN v_ip VARCHAR(15) charset utf8,
 IN v_nasip VARCHAR(15) charset utf8,
 IN v_nasport INTEGER(2),
 IN v_nasident VARCHAR(100) charset utf8
 )
BEGIN

IF ( v_reply = 'Access-Reject') THEN

INSERT INTO radpostauth_reject (username, pass, reply, authdate, framedip, nasip, nasport, nasident) 
 VALUES (login, v_pass, v_reply, v_authdate, v_ip, v_nasip, v_nasport, v_nasident);

ELSE

INSERT INTO radpostauth (username, pass, reply, authdate, framedip, nasip, nasport, nasident) 
 VALUES (login, v_pass, v_reply, v_authdate, v_ip, v_nasip, v_nasport, v_nasident);

END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-07-18 12:02:18

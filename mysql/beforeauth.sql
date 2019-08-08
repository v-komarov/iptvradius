DROP PROCEDURE `beforeauth_work`;
DELIMITER ;;
CREATE DEFINER=`freeradius`@`%` PROCEDURE `beforeauth_work`(IN v_ip VARCHAR(15),IN v_login VARCHAR(64))
BEGIN

	DECLARE before_check INT DEFAULT 0;
	DECLARE before_packets INT DEFAULT 0;

	select count(*) into before_check from radfreecharge as rad where rad.ip = v_ip;
	SELECT count(*) into before_packets 
	FROM radbilling as rad_b
		left join radpackets as rad_p on (rad_b.pid = rad_p.pid) 
	WHERE rad_b.mac = v_login 
		AND rad_p.value = v_ip
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

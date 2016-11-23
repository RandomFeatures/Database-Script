USE lands;
DELIMITER $$

DROP PROCEDURE IF EXISTS lands.dsp_Regen_Power $$
CREATE DEFINER=`lands_game`@`%` PROCEDURE lands.`dsp_Regen_Power`( )
BEGIN

  
	UPDATE 
		lands.tbl_Players 
	SET 
		Energy = Energy + Recharge
	WHERE 
		Energy < MaxEnergy;


	UPDATE 
		lands.tbl_Config 
	SET 
		ConfigValue = NOW()
	WHERE 
		KeyName = 'lastRegen';


END $$


DELIMITER ;


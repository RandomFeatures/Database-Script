/*
Created		3/11/2010
Modified		9/11/2010
Project		Lands of Adventure
Model		
Company		A Little Entertainment
Author		Allen Halsted
Version		0.3
Database		mySQL 5 
*/


CREATE DATABASE IF NOT EXISTS lands;
USE lands;


drop table IF EXISTS tbl_Player_Start_Values;
drop table IF EXISTS tbl_Published_Realm;
drop table IF EXISTS tbl_Player_Room_Items;
drop table IF EXISTS tbl_ModFactor_Lookup;
drop table IF EXISTS tbl_Level_Progression;
drop table IF EXISTS tbl_Equipment_Actions;
drop table IF EXISTS tbl_Equipment;
drop table IF EXISTS tbl_Player_Adventure;
drop table IF EXISTS tbl_Achievements;
drop table IF EXISTS tbl_Player_Achievements;
drop table IF EXISTS tbl_Players;
drop table IF EXISTS tbl_Player_Inventory;
drop table IF EXISTS tbl_Player_Rooms;
drop table IF EXISTS tbl_Player_Realmz;
drop table IF EXISTS tbl_Lookup;




Create table tbl_Lookup (
	id Int NOT NULL AUTO_INCREMENT,
	LookupType Varchar(25) NOT NULL,
	LookupCode Int NOT NULL,
	LookupDesc Varchar(50) NOT NULL,
	Active Bit(1) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Player_Realmz (
	id Int NOT NULL AUTO_INCREMENT,
	UserID Int NOT NULL,
	GameID Int NOT NULL,
	FloorCount Int NOT NULL DEFAULT 1,
	RoomCount Int NOT NULL,
	MonsterCount Int NOT NULL,
	TrapCount Int NOT NULL,
	GridRows Int NOT NULL,
	GridCols Int NOT NULL,
	StartRoom Int NOT NULL,
	ChestRoom Int NOT NULL,
	KeeperID Int NOT NULL,
	LastClean Datetime NOT NULL,
	ElaspedTime Int NOT NULL,
	KeeperState Int NOT NULL,
	ChestID Int NOT NULL,
	ChestX Int NOT NULL,
	ChestY Int NOT NULL,
	ChestDir Int NOT NULL,
	RealmLevel Int NOT NULL,
	MonsterLevel Int NOT NULL,
	TrapLevel Int NOT NULL,
	Active Bit(1) NOT NULL DEFAULT 1,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Player_Rooms (
	id Int NOT NULL AUTO_INCREMENT,
	RealmID Int NOT NULL,
	RoomID Int NOT NULL,
	TemplateID Int NOT NULL,
	GridY Int NOT NULL,
	GridX Int NOT NULL,
	Floor Int NOT NULL DEFAULT 1,
	MonsterCount Int NOT NULL,
	TrapCount Int NOT NULL,
	SFXType Int,
	SFX Varchar(250),
	Deleted Bit(1) NOT NULL DEFAULT 0,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Player_Inventory (
	id Int NOT NULL AUTO_INCREMENT,
	UserID Int NOT NULL,
	RealmID Int NOT NULL,
	ObjectType Int NOT NULL,
	ObjectID Int NOT NULL,
	Count Int NOT NULL,
	Deleted Bit(1) NOT NULL DEFAULT 0,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Players (
	id Int NOT NULL AUTO_INCREMENT,
	UserID Int NOT NULL,
	RealmID Int NOT NULL,
	Gender Int NOT NULL,
	Experince Int NOT NULL,
	Level Int NOT NULL,
	Gold Int NOT NULL,
	Bucks Int NOT NULL,
	MaxEnergy Int NOT NULL,
	Energy Int NOT NULL,
	Recharge Int NOT NULL,
	BaseID Int NOT NULL,
	BaseColor Varchar(10) NOT NULL,
	HairID Int NOT NULL,
	HairColor Varchar(10) NOT NULL,
	HeadID Int,
	HeadColor Varchar(10),
	BodyID Int,
	BodyColor Varchar(10),
	MainHandID Int,
	MainHandColor Varchar(10),
	OffHandID Int,
	OffHandColor Varchar(10),
	AccessoryID Int,
	AccessoryColor Varchar(10),
	FaceID Int NOT NULL,
	FaceColor Varchar(10) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Player_Achievements (
	id Int NOT NULL AUTO_INCREMENT,
	UserID Int NOT NULL,
	PlayerID Int NOT NULL,
	RealmID Int NOT NULL,
	AchievementID Int NOT NULL,
	Value Int NOT NULL,
	Goal Int NOT NULL,
	Complete Bit(1) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Achievements (
	id Int NOT NULL AUTO_INCREMENT,
	Description Varchar(100) NOT NULL,
	Goal Int NOT NULL,
	ObjectType Int NOT NULL,
	RewardID Int NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Player_Adventure (
	id Int NOT NULL AUTO_INCREMENT,
	UserID Int NOT NULL,
	RealmID Int NOT NULL,
	Completed Bit(1) NOT NULL DEFAULT 0,
	Favorite Bit(1) NOT NULL,
	Rating Int NOT NULL,
	RepeatCount Int NOT NULL DEFAULT 1,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Equipment (
	id Int NOT NULL AUTO_INCREMENT,
	Layer Int NOT NULL,
	TileSetID Int NOT NULL,
	Color Varchar(20) NOT NULL,
	ItemName Varchar(50) NOT NULL,
	ToolTip Varchar(50) NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	SellValue Int NOT NULL,
	IconFile Varchar(250) NOT NULL,
	PaperDoll Varchar(250) NOT NULL,
	Gender Bit(1) NOT NULL,
	ModType Int NOT NULL,
	ModValue Int NOT NULL,
	Status Int NOT NULL,
	Active Bit(1) NOT NULL DEFAULT 1,
	OldID Int,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Equipment_Actions (
	id Int NOT NULL AUTO_INCREMENT,
	EquipmentID Int NOT NULL,
	Action Int NOT NULL,
	Width Int NOT NULL,
	Height Int NOT NULL,
	FrameCount Int NOT NULL,
	AnimationType Int NOT NULL,
	Image Varchar(250) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Level_Progression (
	id Int NOT NULL AUTO_INCREMENT,
	Level Int NOT NULL,
	Experince Int NOT NULL,
	RewardType Int NOT NULL,
	Reward Int NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_ModFactor_Lookup (
	id Int NOT NULL AUTO_INCREMENT,
	ModType Int NOT NULL,
	ModFactor Decimal(10,3) NOT NULL,
	Active Bit(1) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Player_Room_Items (
	id Int NOT NULL AUTO_INCREMENT,
	RealmID Int NOT NULL,
	RoomID Int NOT NULL,
	ObjectType Int NOT NULL,
	ObjectID Int NOT NULL,
	GridX Int NOT NULL,
	GridY Int NOT NULL,
	Direction Int NOT NULL,
	DataType Int NOT NULL DEFAULT 0,
	Data Varchar(50),
	Deleted Bit(1) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Published_Realm (
	id Int NOT NULL AUTO_INCREMENT,
	UserID Int NOT NULL,
	RealmID Int NOT NULL,
	RoomCount Int NOT NULL,
	Deleted Bit(1) NOT NULL DEFAULT 0,
	Realm Mediumtext NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Player_Start_Values (
	id Int NOT NULL AUTO_INCREMENT,
	Gender Int NOT NULL,
	Experince Int NOT NULL,
	Level Int NOT NULL,
	Gold Int NOT NULL,
	Bucks Int NOT NULL,
	Energy Int NOT NULL,
	BaseID Int NOT NULL,
	BaseColor Varchar(10) NOT NULL,
	HairID Int NOT NULL,
	HairColor Varchar(10) NOT NULL,
	HeadID Int NOT NULL,
	HeadColor Varchar(10) NOT NULL,
	BodyID Int NOT NULL,
	BodyColor Varchar(10) NOT NULL,
	MainHandID Int NOT NULL,
	MainHandColor Varchar(10) NOT NULL,
	OffHandID Int NOT NULL,
	OffHandColor Varchar(10) NOT NULL,
	AccessoryID Int NOT NULL,
	AccessoryColor Varchar(10) NOT NULL,
	FaceID Int NOT NULL,
	FaceColor Varchar(10) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;



Create Index lutype ON tbl_Lookup (LookupType);
Create Index lucode ON tbl_Lookup (LookupCode);
Create Index typecode ON tbl_Lookup (LookupType,LookupCode);
Create Index user ON tbl_Player_Realmz (UserID);
Create Index RealmTemp ON tbl_Player_Rooms (RealmID,TemplateID);
Create Index realm ON tbl_Player_Rooms (RealmID,Deleted);
Create Index room ON tbl_Player_Rooms (RoomID);
Create Index realmroom ON tbl_Player_Rooms (RealmID,RoomID);
Create Index userid ON tbl_Player_Inventory (UserID);
Create Index userobj ON tbl_Player_Inventory (UserID,ObjectType);
Create Index userid ON tbl_Players (UserID,RealmID);
Create Index realm ON tbl_Players (RealmID);
Create Index user ON tbl_Player_Achievements (UserID);
Create Index player ON tbl_Player_Achievements (PlayerID);
Create Index userach ON tbl_Player_Achievements (UserID,AchievementID);
Create Index userid ON tbl_Player_Adventure (UserID);
Create Index userfav ON tbl_Player_Adventure (UserID,Favorite);
Create Index layer ON tbl_Equipment (Layer,Gender,Active);
Create Index tileset ON tbl_Equipment (Layer,TileSetID,Gender,Active);
Create Index eqid ON tbl_Equipment_Actions (EquipmentID);
Create Index eqAction ON tbl_Equipment_Actions (EquipmentID,Action);
Create Index level ON tbl_Level_Progression (Level);
Create Index exp ON tbl_Level_Progression (Experince);
Create Index modtype ON tbl_ModFactor_Lookup (ModType,Active);
Create Index realmroom ON tbl_Player_Room_Items (RealmID,RoomID,Deleted);
Create Index room ON tbl_Player_Room_Items (RoomID,Deleted);
Create Index uid ON tbl_Published_Realm (UserID,RealmID,Deleted);
Create Index realmid ON tbl_Published_Realm (RealmID,Deleted,RoomCount);


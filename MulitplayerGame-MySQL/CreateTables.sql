/*
Created		3/11/2010
Modified		9/14/2010
Project		Lands of Adventure
Model		
Company		A Little Entertainment
Author		Allen Halsted
Version		0.3
Database		mySQL 5 
*/



CREATE DATABASE IF NOT EXISTS lands;
USE lands;

drop table IF EXISTS tbl_Game_Store;
drop table IF EXISTS tbl_Rooms;
drop table IF EXISTS tbl_Chests_Actions;
drop table IF EXISTS tbl_Keepers_Actions;
drop table IF EXISTS tbl_Chests;
drop table IF EXISTS tbl_Keepers;
drop table IF EXISTS tbl_Room_Set;
drop table IF EXISTS tbl_Tileset;
drop table IF EXISTS tbl_Room_Traps;
drop table IF EXISTS tbl_Monster_Actions;
drop table IF EXISTS tbl_Room_Monsters;
drop table IF EXISTS tbl_Item_ActionFacings;
drop table IF EXISTS tbl_Room_Items;
drop table IF EXISTS tbl_Room_Structures;
drop table IF EXISTS tbl_Config;
drop table IF EXISTS tbl_Room_Templates;




Create table tbl_Room_Templates (
	id Int NOT NULL AUTO_INCREMENT,
	ItemName Varchar(50) NOT NULL,
	ToolTip Varchar(50) NOT NULL,
	IconFile Varchar(250) NOT NULL,
	GridRows Int NOT NULL,
	GridCols Int NOT NULL,
	OffsetX Int NOT NULL,
	OffsetY Int NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	SellValue Int NOT NULL DEFAULT 0,
	LWallX Int NOT NULL,
	LWallY Int NOT NULL,
	RWallX Int NOT NULL,
	RWallY Int NOT NULL,
	FloorX Int NOT NULL,
	FloorY Int NOT NULL,
	DisplayOrder Int,
	Active Bit(1) NOT NULL,
	Status Int NOT NULL,
	OldID Int,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Config (
	id Int NOT NULL AUTO_INCREMENT,
	KeyName Varchar(25) NOT NULL,
	ConfigValue Varchar(100) NOT NULL,
	GameID Int,
	SourceID Int,
	Active Bit(1) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Room_Structures (
	id Int NOT NULL AUTO_INCREMENT,
	TemplateID Int NOT NULL,
	TileSetID Int NOT NULL,
	ObjectType Int NOT NULL,
	FileName Varchar(250) NOT NULL,
	OffsetX Int NOT NULL,
	OffsetY Int NOT NULL,
	ItemName Varchar(50) NOT NULL,
	ToolTip Varchar(50) NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	SellValue Int NOT NULL DEFAULT 0,
	IconFile Varchar(250) NOT NULL,
	Active Bit(1) NOT NULL,
	Status Int NOT NULL,
	OldID Int,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Room_Items (
	id Int NOT NULL AUTO_INCREMENT,
	TileSetID Int NOT NULL,
	ObjectType Int NOT NULL,
	FileName Varchar(250) NOT NULL,
	Layer Int NOT NULL,
	Walkable Bit(1) NOT NULL,
	Overlap Bit(1) NOT NULL,
	Facings Int NOT NULL DEFAULT 1,
	Direction Char(2) NOT NULL DEFAULT 'SE',
	Width Int NOT NULL,
	Height Int NOT NULL,
	ItemName Varchar(50) NOT NULL,
	ToolTip Varchar(50) NOT NULL,
	IconFile Varchar(250) NOT NULL,
	SFX Varchar(250),
	SFXType Int NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	SellValue Int NOT NULL DEFAULT 0,
	Active Bit(1) NOT NULL,
	Status Int NOT NULL,
	OldId Int,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Item_ActionFacings (
	id Int NOT NULL AUTO_INCREMENT,
	ItemID Int NOT NULL,
	Direction Int NOT NULL,
	Action Int NOT NULL,
	OffsetX Int NOT NULL,
	OffsetY Int NOT NULL,
	MaskRows Int NOT NULL,
	MaskCols Int NOT NULL,
	FPS Int NOT NULL DEFAULT 10,
	FrameCount Int NOT NULL,
	Animation Int NOT NULL,
	Frames Varchar(50) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Room_Monsters (
	id Int NOT NULL AUTO_INCREMENT,
	TileSetID Int NOT NULL,
	ObjectType Int NOT NULL,
	ThreatRow Int NOT NULL,
	ThreatCol Int NOT NULL,
	Moveable Bit(1) NOT NULL,
	OffsetY Int NOT NULL,
	OffsetX Int NOT NULL,
	Color Varchar(20) NOT NULL,
	DefaultAI Int NOT NULL,
	ItemName Varchar(50) NOT NULL,
	ToolTip Varchar(50) NOT NULL,
	IconFile Varchar(250) NOT NULL,
	SFX Varchar(250),
	SFXType Int NOT NULL,
	Level Int NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	SellValue Int NOT NULL DEFAULT 0,
	Active Bit(1) NOT NULL,
	Status Int NOT NULL,
	OldID Int,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Monster_Actions (
	id Int NOT NULL AUTO_INCREMENT,
	MonsterID Int NOT NULL,
	Action Int NOT NULL,
	Width Int NOT NULL,
	Height Int NOT NULL,
	FrameCount Int NOT NULL,
	fps Int NOT NULL,
	AnimationType Int NOT NULL,
	Image Varchar(250) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Room_Traps (
	id Int NOT NULL AUTO_INCREMENT,
	TileSetID Int NOT NULL,
	ObjectType Int NOT NULL,
	FileName Varchar(250) NOT NULL,
	ThreatRow Int NOT NULL,
	ThreatCol Int NOT NULL,
	ThreatMask Varchar(100) NOT NULL,
	Activate Int NOT NULL,
	OffsetX Int NOT NULL,
	OffsetY Int NOT NULL,
	FPS Int DEFAULT 10,
	FrameCount Int NOT NULL,
	Frames Varchar(50) NOT NULL,
	Width Int NOT NULL,
	Height Int NOT NULL,
	Animation Int NOT NULL,
	ItemName Varchar(50) NOT NULL,
	ToolTip Varchar(50) NOT NULL,
	IconFile Varchar(250) NOT NULL,
	SFX Varchar(250),
	SFXType Int NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	SellValue Int NOT NULL DEFAULT 0,
	Active Bit(1) NOT NULL,
	Status Int NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Tileset (
	id Int NOT NULL,
	SetName Varchar(50) NOT NULL,
	IconFile Varchar(250) NOT NULL,
	Active Bit(1) NOT NULL) ENGINE = InnoDB;

Create table tbl_Room_Set (
	id Int NOT NULL AUTO_INCREMENT,
	TemplateID Int NOT NULL,
	TileSetID Int NOT NULL,
	FloorID Int NOT NULL,
	LeftWallID Int NOT NULL,
	RightWallID Int NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	SellValue Int NOT NULL,
	ObjectType Int NOT NULL,
	Active Bit(1) NOT NULL,
	OldID Int,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Keepers (
	id Int NOT NULL AUTO_INCREMENT,
	TileSet Int NOT NULL,
	Level Int NOT NULL,
	Mod_Time Int NOT NULL,
	Mod_Gold Int NOT NULL,
	Item Int NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	ItemName Varchar(50) NOT NULL,
	ToolTip Varchar(50) NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	Width Int NOT NULL,
	Height Int NOT NULL,
	Image Varchar(250) NOT NULL,
	SFX Varchar(250) NOT NULL,
	SFXType Int NOT NULL,
	Active Bit(1) NOT NULL,
	OldID Int,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Chests (
	id Int NOT NULL AUTO_INCREMENT,
	TileSet Int NOT NULL,
	Level Int NOT NULL,
	Mod_Gold Int NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	ItemName Varchar(50) NOT NULL,
	ToolTip Varchar(50) NOT NULL,
	SFX Varchar(250) NOT NULL,
	SFXType Int NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	Width Int NOT NULL,
	Height Int NOT NULL,
	Image Varchar(250) NOT NULL,
	Item Int NOT NULL,
	Active Bit(1) NOT NULL,
	OldID Int,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Keepers_Actions (
	id Int NOT NULL AUTO_INCREMENT,
	KeeperID Int NOT NULL,
	Direction Int NOT NULL,
	Action Int NOT NULL,
	OffsetX Int NOT NULL,
	OffsetY Int NOT NULL,
	FPS Int NOT NULL,
	FrameCount Int NOT NULL,
	Animation Int NOT NULL,
	Frames Varchar(50) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Chests_Actions (
	id Int NOT NULL AUTO_INCREMENT,
	ChestID Int NOT NULL,
	Direction Int NOT NULL,
	Action Int NOT NULL,
	OffsetX Int NOT NULL,
	OffsetY Int NOT NULL,
	MaskRows Int NOT NULL,
	MaskCols Int NOT NULL,
	FPS Int NOT NULL,
	FrameCount Int NOT NULL,
	Animation Int NOT NULL,
	Frames Varchar(50) NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Rooms (
	id Int NOT NULL AUTO_INCREMENT,
	TemplateID Int NOT NULL,
	TileSetID Int NOT NULL,
	ObjectType Int NOT NULL DEFAULT 15,
	ItemName Varchar(50) NOT NULL,
	ToolTip Varchar(50) NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	SellValue Int NOT NULL,
	IconFile Varchar(250) NOT NULL,
	Active Bit(1) NOT NULL,
	Status Int NOT NULL,
	OldID Int,
 Primary Key (id)) ENGINE = InnoDB;

Create table tbl_Game_Store (
	id Int NOT NULL AUTO_INCREMENT,
	ItemName Varchar(20) NOT NULL,
	ItemDesc Varchar(30) NOT NULL,
	ItemType Int NOT NULL,
	CostType Int NOT NULL,
	Cost Int NOT NULL,
	RestrictionType Int NOT NULL,
	Restriction Int NOT NULL,
	IconFile Varchar(250) NOT NULL,
	Active Bit(1) NOT NULL,
	ActionScript Text NOT NULL,
 Primary Key (id)) ENGINE = InnoDB;



Create Index 'size' ON tbl_Room_Templates (GridRows,GridCols);
Create Index keyname ON tbl_Config (KeyName);
Create Index roomtile ON tbl_Room_Structures (TemplateID,TileSetID,Active);
Create Index room ON tbl_Room_Structures (TemplateID,Active);
Create Index roomtileobect ON tbl_Room_Structures (TemplateID,TileSetID,ObjectType,Active);
Create Index tileset ON tbl_Room_Items (TileSetID,Active);
Create Index tileobject ON tbl_Room_Items (TileSetID,ObjectType,Active);
Create Index Item ON tbl_Item_ActionFacings (ItemID);
Create Index tileset ON tbl_Room_Monsters (TileSetID,Active);
Create Index tilesetobject ON tbl_Room_Monsters (TileSetID,ObjectType,Active);
Create Index Monster ON tbl_Monster_Actions (MonsterID);
Create Index tileset ON tbl_Room_Traps (TileSetID,Active);
Create Index tileobject ON tbl_Room_Traps (TileSetID,ObjectType,Active);
Create Index tempid ON tbl_Room_Set (TemplateID);
Create Index tempobjtile ON tbl_Room_Set (TemplateID,TileSetID);
Create Index ts ON tbl_Keepers (TileSet);
Create Index ts ON tbl_Chests (TileSet);
Create Index typeactive ON tbl_Game_Store (ItemType,Active);








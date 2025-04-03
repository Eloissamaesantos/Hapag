USE [master]
GO
/****** Object:  Database [hapag_database]    Script Date: 3/4/2025 1:31:49 PM ******/
CREATE DATABASE [hapag_database] ON  PRIMARY 
( NAME = N'hapag_database', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\hapag_database.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'hapag_database_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\hapag_database_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [hapag_database] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [hapag_database].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [hapag_database] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [hapag_database] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [hapag_database] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [hapag_database] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [hapag_database] SET ARITHABORT OFF 
GO
ALTER DATABASE [hapag_database] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [hapag_database] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [hapag_database] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [hapag_database] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [hapag_database] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [hapag_database] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [hapag_database] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [hapag_database] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [hapag_database] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [hapag_database] SET  DISABLE_BROKER 
GO
ALTER DATABASE [hapag_database] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [hapag_database] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [hapag_database] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [hapag_database] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [hapag_database] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [hapag_database] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [hapag_database] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [hapag_database] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [hapag_database] SET  MULTI_USER 
GO
ALTER DATABASE [hapag_database] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [hapag_database] SET DB_CHAINING OFF 
GO
USE [hapag_database]
GO
/****** Object:  Table [dbo].[administrator]    Script Date: 3/4/2025 1:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[administrator](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[deals] [varchar](50) NULL,
	[price] [varchar](50) NULL,
	[tax] [varchar](50) NULL,
 CONSTRAINT [PK_administrator] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[menu]    Script Date: 3/4/2025 1:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[menu](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[product_name] [varchar](50) NULL,
	[price] [varchar](50) NULL,
	[no_of_serving] [varchar](50) NULL,
 CONSTRAINT [PK_menu] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order]    Script Date: 3/4/2025 1:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[subtotal] [varchar](50) NULL,
	[shipping_fee] [varchar](50) NULL,
	[tax] [varchar](50) NULL,
 CONSTRAINT [PK_order] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transactions]    Script Date: 3/4/2025 1:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transactions](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[payment_method] [varchar](50) NULL,
	[subtotal] [varchar](50) NULL,
	[total] [varchar](50) NULL,
	[discount] [varchar](50) NULL,
	[driver] [varchar](50) NULL,
 CONSTRAINT [PK_transaction] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 3/4/2025 1:31:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NULL,
	[password] [varchar](50) NULL,
	[display_name] [varchar](50) NULL,
	[contact] [varchar](50) NULL,
	[address] [varchar](50) NULL,
	[user_type] [varchar](50) NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[menu] ON 

INSERT [dbo].[menu] ([user_id], [product_name], [price], [no_of_serving]) VALUES (1, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[menu] OFF
GO
SET IDENTITY_INSERT [dbo].[transactions] ON 

INSERT [dbo].[transactions] ([user_id], [payment_method], [subtotal], [total], [discount], [driver]) VALUES (1, N'1', N'awa', N'223', N'aw', N'2awa')
SET IDENTITY_INSERT [dbo].[transactions] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [address], [user_type]) VALUES (1, N'Eloissa Mae', N'1234', N'Eli', N'09757324823', N'Quezon Cit', N'1')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [address], [user_type]) VALUES (2, N'Jhon Orlan', N'1234', N'Tero', N'097676677492', N'Navotas City', N'1')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [address], [user_type]) VALUES (3, N'Jessica', N'1234', N'Jessik', N'097676677492', N'Valenzuela City', N'2')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [address], [user_type]) VALUES (4, N'James ', N'1234', N'Orbase', N'098754543780', N'Valenzuela City', N'2')
SET IDENTITY_INSERT [dbo].[users] OFF
GO
USE [master]
GO
ALTER DATABASE [hapag_database] SET  READ_WRITE 
GO

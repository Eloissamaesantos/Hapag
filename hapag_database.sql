USE [master]
GO
/****** Object:  Database [hapag_database]    Script Date: 4/4/2025 2:40:34 AM ******/
CREATE DATABASE [hapag_database] ON  PRIMARY 
( NAME = N'hapag_database', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL10.SQLEXPRESS\MSSQL\DATA\hapag_database.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
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
/****** Object:  Table [dbo].[cart]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cart](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[is_deal] [bit] NULL,
	[deal_id] [int] NULL,
	[special_instructions] [nvarchar](255) NULL,
	[price] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[customer_addresses]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[customer_addresses](
	[address_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[address_name] [nvarchar](100) NULL,
	[recipient_name] [nvarchar](100) NOT NULL,
	[contact_number] [nvarchar](20) NOT NULL,
	[address_line] [nvarchar](255) NOT NULL,
	[city] [nvarchar](100) NOT NULL,
	[postal_code] [nvarchar](20) NULL,
	[is_default] [bit] NOT NULL,
	[date_added] [datetime] NOT NULL,
	[coordinates] [nvarchar](50) NULL,
 CONSTRAINT [PK_customer_addresses] PRIMARY KEY CLUSTERED 
(
	[address_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[deals]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[deals](
	[deals_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[value] [varchar](50) NULL,
	[value_type] [varchar](50) NULL,
	[start_date] [varchar](50) NULL,
	[valid_until] [varchar](50) NULL,
	[date_created] [varchar](50) NULL,
	[description] [varchar](50) NULL,
	[image] [varchar](50) NULL,
 CONSTRAINT [PK_deals] PRIMARY KEY CLUSTERED 
(
	[deals_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[deals_item]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[deals_item](
	[deal_item_id] [int] IDENTITY(1,1) NOT NULL,
	[item_id] [varchar](50) NULL,
	[ref] [varchar](50) NULL,
	[date_created] [varchar](50) NULL,
 CONSTRAINT [PK_deals_item] PRIMARY KEY CLUSTERED 
(
	[deal_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[discounts]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[discounts](
	[discount_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[value] [varchar](50) NULL,
	[value_type] [varchar](50) NULL,
	[date_created] [varchar](50) NULL,
	[description] [varchar](50) NULL,
	[discount_type] [int] NOT NULL,
	[applicable_to] [int] NOT NULL,
	[start_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[min_order_amount] [decimal](10, 2) NULL,
	[status] [int] NOT NULL,
	[created_at] [datetime] NOT NULL,
 CONSTRAINT [PK_discounts] PRIMARY KEY CLUSTERED 
(
	[discount_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[menu]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[menu](
	[item_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[price] [varchar](50) NULL,
	[category] [varchar](50) NULL,
	[type] [varchar](50) NULL,
	[availability] [varchar](50) NULL,
	[image] [varchar](255) NULL,
	[category_id] [int] NULL,
	[type_id] [int] NULL,
	[description] [varchar](255) NULL,
	[no_of_serving] [varchar](50) NULL,
 CONSTRAINT [PK_menu] PRIMARY KEY CLUSTERED 
(
	[item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[menu_categories]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[menu_categories](
	[category_id] [int] IDENTITY(1,1) NOT NULL,
	[category_name] [varchar](50) NOT NULL,
	[description] [varchar](255) NULL,
	[is_active] [bit] NOT NULL,
 CONSTRAINT [PK_menu_categories] PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[menu_types]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[menu_types](
	[type_id] [int] IDENTITY(1,1) NOT NULL,
	[type_name] [varchar](50) NOT NULL,
	[description] [varchar](255) NULL,
	[is_active] [bit] NOT NULL,
 CONSTRAINT [PK_menu_types] PRIMARY KEY CLUSTERED 
(
	[type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_items]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_items](
	[order_item_id] [int] IDENTITY(1,1) NOT NULL,
	[transaction_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[order_id] [int] NULL,
 CONSTRAINT [PK_order_items] PRIMARY KEY CLUSTERED 
(
	[order_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_items_backup]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_items_backup](
	[order_item_id] [int] IDENTITY(1,1) NOT NULL,
	[transaction_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[price] [decimal](10, 2) NOT NULL,
	[order_id] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders](
	[order_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[order_date] [datetime] NOT NULL,
	[transaction_id] [int] NULL,
	[subtotal] [varchar](50) NULL,
	[shipping_fee] [varchar](50) NULL,
	[tax] [varchar](50) NULL,
	[total_amount] [decimal](10, 2) NOT NULL,
	[status] [varchar](20) NOT NULL,
	[driver_name] [varchar](50) NULL,
	[delivery_service] [varchar](50) NULL,
	[tracking_link] [varchar](max) NULL,
	[delivery_notes] [varchar](500) NULL,
 CONSTRAINT [PK_orders] PRIMARY KEY CLUSTERED 
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orders_backup]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orders_backup](
	[item_id] [int] IDENTITY(1,1) NOT NULL,
	[subtotal] [varchar](50) NULL,
	[shipping_fee] [varchar](50) NULL,
	[tax] [varchar](50) NULL,
	[total_amount] [decimal](10, 2) NOT NULL,
	[status] [varchar](20) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[promotions]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[promotions](
	[promotion_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[value] [varchar](50) NULL,
	[value_type] [varchar](50) NULL,
	[start_date] [varchar](50) NULL,
	[valid_until] [varchar](50) NULL,
	[date_created] [varchar](50) NULL,
	[description] [varchar](50) NULL,
	[image] [varchar](50) NULL,
 CONSTRAINT [PK_promotions] PRIMARY KEY CLUSTERED 
(
	[promotion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[transactions]    Script Date: 4/4/2025 2:40:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[transactions](
	[transaction_id] [int] IDENTITY(1,1) NOT NULL,
	[payment_method] [varchar](50) NULL,
	[subtotal] [varchar](50) NULL,
	[total] [varchar](50) NULL,
	[discount] [varchar](50) NULL,
	[driver] [varchar](50) NULL,
	[user_id] [int] NOT NULL,
	[total_amount] [decimal](10, 2) NOT NULL,
	[status] [varchar](20) NOT NULL,
	[reference_number] [varchar](50) NULL,
	[sender_name] [varchar](100) NULL,
	[sender_number] [varchar](20) NULL,
	[transaction_date] [datetime] NOT NULL,
 CONSTRAINT [PK_transactions] PRIMARY KEY CLUSTERED 
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 4/4/2025 2:40:35 AM ******/
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
	[email] [varchar](50) NULL,
	[address] [varchar](50) NULL,
	[user_type] [varchar](50) NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[cart] ON 

INSERT [dbo].[cart] ([cart_id], [user_id], [item_id], [quantity], [is_deal], [deal_id], [special_instructions], [price]) VALUES (1, 4, 5, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[cart] ([cart_id], [user_id], [item_id], [quantity], [is_deal], [deal_id], [special_instructions], [price]) VALUES (2, 4, 4, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[cart] ([cart_id], [user_id], [item_id], [quantity], [is_deal], [deal_id], [special_instructions], [price]) VALUES (4, 5, 4, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[cart] ([cart_id], [user_id], [item_id], [quantity], [is_deal], [deal_id], [special_instructions], [price]) VALUES (41, 3, 10, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[cart] ([cart_id], [user_id], [item_id], [quantity], [is_deal], [deal_id], [special_instructions], [price]) VALUES (42, 3, 7, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[cart] ([cart_id], [user_id], [item_id], [quantity], [is_deal], [deal_id], [special_instructions], [price]) VALUES (43, 3, 9, 1, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[cart] OFF
GO
SET IDENTITY_INSERT [dbo].[customer_addresses] ON 

INSERT [dbo].[customer_addresses] ([address_id], [user_id], [address_name], [recipient_name], [contact_number], [address_line], [city], [postal_code], [is_default], [date_added], [coordinates]) VALUES (2, 3, N'Home', N'Eloissa Mae', N'09123456789', N'QC QC QC', N'Quezon City', N'1234', 1, CAST(N'2025-04-03T19:20:20.000' AS DateTime), N'14.676041,121.043700')
SET IDENTITY_INSERT [dbo].[customer_addresses] OFF
GO
SET IDENTITY_INSERT [dbo].[deals] ON 

INSERT [dbo].[deals] ([deals_id], [name], [value], [value_type], [start_date], [valid_until], [date_created], [description], [image]) VALUES (1, N'1233', N'232', N'1', N'03/04/2025', N'03/29/2025', NULL, N'hgjkl', N'')
INSERT [dbo].[deals] ([deals_id], [name], [value], [value_type], [start_date], [valid_until], [date_created], [description], [image]) VALUES (3, N'1233', N'5', N'1', N'03/29/2025', N'03/29/2025', NULL, NULL, NULL)
INSERT [dbo].[deals] ([deals_id], [name], [value], [value_type], [start_date], [valid_until], [date_created], [description], [image]) VALUES (4, N'1233', N'5', N'1', N'03/29/2025', N'04/26/2025', NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[deals] OFF
GO
SET IDENTITY_INSERT [dbo].[discounts] ON 

INSERT [dbo].[discounts] ([discount_id], [name], [value], [value_type], [date_created], [description], [discount_type], [applicable_to], [start_date], [end_date], [min_order_amount], [status], [created_at]) VALUES (1, N'Adobong Sitaw', N'5', NULL, NULL, N'adad', 1, 1, CAST(N'2025-03-04T00:00:00.000' AS DateTime), CAST(N'2025-03-31T00:00:00.000' AS DateTime), CAST(500.00 AS Decimal(10, 2)), 1, CAST(N'2025-03-31T18:08:01.150' AS DateTime))
INSERT [dbo].[discounts] ([discount_id], [name], [value], [value_type], [date_created], [description], [discount_type], [applicable_to], [start_date], [end_date], [min_order_amount], [status], [created_at]) VALUES (2, N'AW', N'5', NULL, NULL, NULL, 1, 1, CAST(N'2025-03-31T00:00:00.000' AS DateTime), CAST(N'2025-03-31T00:00:00.000' AS DateTime), CAST(500.00 AS Decimal(10, 2)), 1, CAST(N'2025-03-31T18:48:57.357' AS DateTime))
SET IDENTITY_INSERT [dbo].[discounts] OFF
GO
SET IDENTITY_INSERT [dbo].[menu] ON 

INSERT [dbo].[menu] ([item_id], [name], [price], [category], [type], [availability], [image], [category_id], [type_id], [description], [no_of_serving]) VALUES (1, N'awaw', N'232', N'Breakfast', N'Dessert', N'1', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[menu] ([item_id], [name], [price], [category], [type], [availability], [image], [category_id], [type_id], [description], [no_of_serving]) VALUES (4, N'1233', N'230', N'Breakfast', N'Dessert', N'1', NULL, 1, 5, N'awaw', N'33')
INSERT [dbo].[menu] ([item_id], [name], [price], [category], [type], [availability], [image], [category_id], [type_id], [description], [no_of_serving]) VALUES (5, N'aaaaaaaaaa', N'2999', N'Breakfast', N'Appetizer', N'1', NULL, 1, 1, N'adwada', N'33')
INSERT [dbo].[menu] ([item_id], [name], [price], [category], [type], [availability], [image], [category_id], [type_id], [description], [no_of_serving]) VALUES (6, N'AWAW', N'300', N'Breakfast', N'Beverage', N'1', N'', 1, 4, N'AWAW', N'12')
INSERT [dbo].[menu] ([item_id], [name], [price], [category], [type], [availability], [image], [category_id], [type_id], [description], [no_of_serving]) VALUES (7, N'AW', N'23', N'Dessert', N'Appetizer', N'1', N'', 5, 1, N'AWA', N'2')
INSERT [dbo].[menu] ([item_id], [name], [price], [category], [type], [availability], [image], [category_id], [type_id], [description], [no_of_serving]) VALUES (9, N'hakdog', N'12', N'Breakfast', N'Appetizer', N'1', N'~/Assets/Images/Menu/fda52806-4d86-4513-86a1-22880fd3d559.png', 1, 1, N'awaw', N'3')
INSERT [dbo].[menu] ([item_id], [name], [price], [category], [type], [availability], [image], [category_id], [type_id], [description], [no_of_serving]) VALUES (10, N'hakdog', N'100', N'Breakfast', N'Side Dish', N'1', N'', 1, 3, N'hatdog na may sabaw', N'1')
SET IDENTITY_INSERT [dbo].[menu] OFF
GO
SET IDENTITY_INSERT [dbo].[menu_categories] ON 

INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (1, N'Breakfast', N'Morning meals and breakfast items', 1)
INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (2, N'Lunch', N'Midday meals and lunch specials', 1)
INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (3, N'Dinner', N'Evening meals and dinner options', 1)
INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (4, N'Drinks', N'Beverages and refreshments', 1)
INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (5, N'Dessert', N'Sweet treats and desserts', 1)
INSERT [dbo].[menu_categories] ([category_id], [category_name], [description], [is_active]) VALUES (7, N'option1', N'option1', 1)
SET IDENTITY_INSERT [dbo].[menu_categories] OFF
GO
SET IDENTITY_INSERT [dbo].[menu_types] ON 

INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (1, N'Appetizer', N'Starters and small plates', 1)
INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (2, N'Main Course', N'Primary dishes', 1)
INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (3, N'Side Dish', N'Accompaniments and side orders', 1)
INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (4, N'Beverage', N'Drinks and refreshments', 1)
INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (5, N'Dessert', N'Sweet treats and desserts', 1)
INSERT [dbo].[menu_types] ([type_id], [type_name], [description], [is_active]) VALUES (6, N'awaw', N'awwdwa', 1)
SET IDENTITY_INSERT [dbo].[menu_types] OFF
GO
SET IDENTITY_INSERT [dbo].[order_items] ON 

INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (1, 7, 10, 2, CAST(100.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (2, 7, 7, 1, CAST(23.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (3, 8, 4, 2, CAST(230.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (4, 9, 4, 1, CAST(230.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (5, 9, 7, 2, CAST(23.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (6, 9, 5, 1, CAST(2999.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (8, 11, 9, 1, CAST(12.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (9, 12, 7, 1, CAST(23.00 AS Decimal(10, 2)), 3)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (10, 13, 7, 1, CAST(23.00 AS Decimal(10, 2)), 4)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (11, 14, 5, 1, CAST(2999.00 AS Decimal(10, 2)), 5)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (12, 15, 7, 1, CAST(23.00 AS Decimal(10, 2)), 6)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (13, 16, 5, 1, CAST(2999.00 AS Decimal(10, 2)), 7)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (14, 17, 7, 1, CAST(23.00 AS Decimal(10, 2)), 8)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (15, 18, 7, 1, CAST(23.00 AS Decimal(10, 2)), 9)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (16, 19, 9, 1, CAST(12.00 AS Decimal(10, 2)), 10)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (17, 20, 5, 1, CAST(2999.00 AS Decimal(10, 2)), 11)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (18, 21, 1, 1, CAST(232.00 AS Decimal(10, 2)), 12)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (19, 21, 4, 1, CAST(230.00 AS Decimal(10, 2)), 12)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (20, 22, 9, 1, CAST(12.00 AS Decimal(10, 2)), 13)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (21, 23, 4, 1, CAST(230.00 AS Decimal(10, 2)), 14)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (22, 23, 5, 1, CAST(2999.00 AS Decimal(10, 2)), 14)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (23, 24, 10, 1, CAST(100.00 AS Decimal(10, 2)), 15)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (24, 25, 4, 1, CAST(230.00 AS Decimal(10, 2)), 16)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (25, 25, 7, 1, CAST(23.00 AS Decimal(10, 2)), 16)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (26, 25, 10, 1, CAST(100.00 AS Decimal(10, 2)), 16)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (27, 26, 5, 1, CAST(2999.00 AS Decimal(10, 2)), 17)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (28, 26, 7, 1, CAST(23.00 AS Decimal(10, 2)), 17)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (29, 27, 9, 2, CAST(12.00 AS Decimal(10, 2)), 18)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (30, 28, 9, 2, CAST(12.00 AS Decimal(10, 2)), 19)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (31, 29, 7, 1, CAST(23.00 AS Decimal(10, 2)), 20)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (32, 30, 10, 1, CAST(100.00 AS Decimal(10, 2)), 21)
INSERT [dbo].[order_items] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (33, 31, 10, 1, CAST(100.00 AS Decimal(10, 2)), 22)
SET IDENTITY_INSERT [dbo].[order_items] OFF
GO
SET IDENTITY_INSERT [dbo].[order_items_backup] ON 

INSERT [dbo].[order_items_backup] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (1, 7, 10, 2, CAST(100.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items_backup] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (2, 7, 7, 1, CAST(23.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items_backup] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (3, 8, 4, 2, CAST(230.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items_backup] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (4, 9, 4, 1, CAST(230.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items_backup] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (5, 9, 7, 2, CAST(23.00 AS Decimal(10, 2)), NULL)
INSERT [dbo].[order_items_backup] ([order_item_id], [transaction_id], [item_id], [quantity], [price], [order_id]) VALUES (6, 9, 5, 1, CAST(2999.00 AS Decimal(10, 2)), NULL)
SET IDENTITY_INSERT [dbo].[order_items_backup] OFF
GO
SET IDENTITY_INSERT [dbo].[orders] ON 

INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (1, 1, CAST(N'2025-03-26T14:33:12.190' AS DateTime), 10, NULL, NULL, NULL, CAST(12.00 AS Decimal(10, 2)), N'declined', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (2, 1, CAST(N'2025-03-26T14:37:36.347' AS DateTime), 11, NULL, NULL, NULL, CAST(12.00 AS Decimal(10, 2)), N'delivering', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (3, 6, CAST(N'2025-03-26T15:38:26.440' AS DateTime), 12, NULL, NULL, NULL, CAST(23.00 AS Decimal(10, 2)), N'pending', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (4, 1, CAST(N'2025-03-26T15:47:45.487' AS DateTime), 13, NULL, NULL, NULL, CAST(23.00 AS Decimal(10, 2)), N'ready', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (5, 3, CAST(N'2025-03-26T16:02:38.357' AS DateTime), 14, NULL, NULL, NULL, CAST(2999.00 AS Decimal(10, 2)), N'processing', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (6, 3, CAST(N'2025-03-26T16:21:12.993' AS DateTime), 15, NULL, NULL, NULL, CAST(23.00 AS Decimal(10, 2)), N'processing', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (7, 3, CAST(N'2025-03-26T16:28:54.417' AS DateTime), 16, NULL, NULL, NULL, CAST(2999.00 AS Decimal(10, 2)), N'processing', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (8, 3, CAST(N'2025-03-26T16:46:11.940' AS DateTime), 17, NULL, NULL, NULL, CAST(23.00 AS Decimal(10, 2)), N'processing', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (9, 3, CAST(N'2025-03-26T16:51:55.057' AS DateTime), 18, NULL, NULL, NULL, CAST(23.00 AS Decimal(10, 2)), N'delivering', N'Jayson', NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (10, 3, CAST(N'2025-03-26T17:00:27.893' AS DateTime), 19, NULL, NULL, NULL, CAST(12.00 AS Decimal(10, 2)), N'delivering', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (11, 3, CAST(N'2025-03-26T17:04:20.867' AS DateTime), 20, NULL, NULL, NULL, CAST(2999.00 AS Decimal(10, 2)), N'processing', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (12, 3, CAST(N'2025-03-30T02:39:32.253' AS DateTime), 21, NULL, NULL, NULL, CAST(462.00 AS Decimal(10, 2)), N'processing', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (13, 3, CAST(N'2025-03-30T02:47:17.853' AS DateTime), 22, NULL, NULL, NULL, CAST(12.00 AS Decimal(10, 2)), N'processing', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (14, 3, CAST(N'2025-03-30T02:53:53.683' AS DateTime), 23, NULL, NULL, NULL, CAST(3229.00 AS Decimal(10, 2)), N'delivering', NULL, NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (15, 3, CAST(N'2025-03-30T02:59:49.183' AS DateTime), 24, NULL, NULL, NULL, CAST(100.00 AS Decimal(10, 2)), N'delivering', N'Jayson', NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (16, 3, CAST(N'2025-03-30T04:12:45.963' AS DateTime), 25, NULL, NULL, NULL, CAST(353.00 AS Decimal(10, 2)), N'delivering', N'Daryl', N'GrabFood', NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (17, 3, CAST(N'2025-03-30T04:19:47.833' AS DateTime), 26, NULL, NULL, NULL, CAST(3022.00 AS Decimal(10, 2)), N'delivering', N'1', N'   ', N'3', N'4')
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (18, 3, CAST(N'2025-03-31T13:06:20.773' AS DateTime), 27, NULL, NULL, NULL, CAST(24.00 AS Decimal(10, 2)), N'delivering', N'aaaa', N'FoodPanda', N'awaw', N'awdwababa')
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (19, 3, CAST(N'2025-03-31T13:32:54.023' AS DateTime), 28, NULL, NULL, NULL, CAST(24.00 AS Decimal(10, 2)), N'delivering', N'Dha', N'GrabFood', N'AAAAAAAAAAAAAAAAAAAAAAAAAa', N'BBBBBBBBBBBBBBBBBB')
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (20, 3, CAST(N'2025-03-31T14:40:28.210' AS DateTime), 29, NULL, NULL, NULL, CAST(23.00 AS Decimal(10, 2)), N'delivering', N'Jayson', NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (21, 3, CAST(N'2025-03-31T14:46:51.677' AS DateTime), 30, NULL, NULL, NULL, CAST(100.00 AS Decimal(10, 2)), N'delivering', N'Jayson', NULL, NULL, NULL)
INSERT [dbo].[orders] ([order_id], [user_id], [order_date], [transaction_id], [subtotal], [shipping_fee], [tax], [total_amount], [status], [driver_name], [delivery_service], [tracking_link], [delivery_notes]) VALUES (22, 3, CAST(N'2025-03-31T16:44:56.943' AS DateTime), 31, NULL, NULL, NULL, CAST(100.00 AS Decimal(10, 2)), N'delivering', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[orders] OFF
GO
SET IDENTITY_INSERT [dbo].[promotions] ON 

INSERT [dbo].[promotions] ([promotion_id], [name], [value], [value_type], [start_date], [valid_until], [date_created], [description], [image]) VALUES (1, N'dfsafdsa', N'10', N'1', N'3/31/2025', N'3/31/2025', N'Mar 31 2025  5:53PM', N'sdasdsad', NULL)
INSERT [dbo].[promotions] ([promotion_id], [name], [value], [value_type], [start_date], [valid_until], [date_created], [description], [image]) VALUES (3, N'Adobong Sitaw', N'100', N'1', N'3/19/2025', N'4/14/2025', N'Apr  3 2025  2:40PM', NULL, NULL)
SET IDENTITY_INSERT [dbo].[promotions] OFF
GO
SET IDENTITY_INSERT [dbo].[transactions] ON 

INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (2, N'cash', NULL, NULL, NULL, NULL, 2, CAST(200.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T11:57:52.437' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (3, N'cash', NULL, NULL, NULL, NULL, 2, CAST(223.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T11:58:21.483' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (4, N'cash', NULL, NULL, NULL, NULL, 2, CAST(223.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T11:58:54.053' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (5, N'cash', NULL, NULL, NULL, NULL, 1, CAST(99.99 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T12:02:37.403' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (6, N'cash', NULL, NULL, NULL, NULL, 2, CAST(223.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T13:19:47.313' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (7, N'cash', NULL, NULL, NULL, NULL, 2, CAST(223.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T13:22:20.650' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (8, N'cash', NULL, NULL, NULL, NULL, 2, CAST(460.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T13:29:33.103' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (9, N'gcash', NULL, NULL, NULL, NULL, 1, CAST(3275.00 AS Decimal(10, 2)), N'Pending', N'57658798974', N'Eloissa Mae Santos', N'09310960852', CAST(N'2025-03-26T14:06:24.870' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (10, N'cash', NULL, NULL, NULL, NULL, 1, CAST(12.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T14:33:12.183' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (11, N'cash', NULL, NULL, NULL, NULL, 1, CAST(12.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T14:37:36.343' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (12, N'cash', NULL, NULL, NULL, NULL, 6, CAST(23.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T15:38:26.423' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (13, N'cash', NULL, NULL, NULL, NULL, 1, CAST(23.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T15:47:45.487' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (14, N'cash', NULL, NULL, NULL, NULL, 3, CAST(2999.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T16:02:38.350' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (15, N'cash', NULL, NULL, NULL, NULL, 3, CAST(23.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T16:21:12.977' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (16, N'cash', NULL, NULL, NULL, NULL, 3, CAST(2999.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T16:28:54.413' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (17, N'cash', NULL, NULL, NULL, NULL, 3, CAST(23.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T16:46:11.927' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (18, N'cash', NULL, NULL, NULL, NULL, 3, CAST(23.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T16:51:55.043' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (19, N'cash', NULL, NULL, NULL, NULL, 3, CAST(12.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T17:00:27.263' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (20, N'cash', NULL, NULL, NULL, NULL, 3, CAST(2999.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-26T17:04:20.847' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (21, N'cash', NULL, NULL, NULL, NULL, 3, CAST(462.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-30T02:39:32.247' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (22, N'cash', NULL, NULL, NULL, NULL, 3, CAST(12.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-30T02:47:17.850' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (23, N'cash', NULL, NULL, NULL, NULL, 3, CAST(3229.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-30T02:53:53.673' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (24, N'cash', NULL, NULL, NULL, NULL, 3, CAST(100.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-30T02:59:49.180' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (25, N'cash', NULL, NULL, NULL, NULL, 3, CAST(353.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-30T04:12:45.947' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (26, N'cash', NULL, NULL, NULL, NULL, 3, CAST(3022.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-30T04:19:47.827' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (27, N'cash', NULL, NULL, NULL, NULL, 3, CAST(24.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-31T13:06:20.763' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (28, N'cash', NULL, NULL, NULL, NULL, 3, CAST(24.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-31T13:32:54.013' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (29, N'cash', NULL, NULL, NULL, NULL, 3, CAST(23.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-31T14:40:28.203' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (30, N'cash', NULL, NULL, NULL, NULL, 3, CAST(100.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-31T14:46:51.490' AS DateTime))
INSERT [dbo].[transactions] ([transaction_id], [payment_method], [subtotal], [total], [discount], [driver], [user_id], [total_amount], [status], [reference_number], [sender_name], [sender_number], [transaction_date]) VALUES (31, N'cash', NULL, NULL, NULL, NULL, 3, CAST(100.00 AS Decimal(10, 2)), N'Pending', NULL, NULL, NULL, CAST(N'2025-03-31T16:44:56.940' AS DateTime))
SET IDENTITY_INSERT [dbo].[transactions] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 

INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [email], [address], [user_type]) VALUES (1, N'Eloissa', N'123', N'Eloissa', N'09310960852', N'eloissamaesantos@gmail.com', N'Quezon City', N'1')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [email], [address], [user_type]) VALUES (2, N'Orlan', N'12345', N'Orlan', N'098767585687', N'Orlan@gmail.com', N'Navotas City', N'1')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [email], [address], [user_type]) VALUES (3, N'customer', N'customer', NULL, NULL, NULL, NULL, N'3')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [email], [address], [user_type]) VALUES (4, N'JC', N'12345', N'James Cyrus', N'0976854568', N'jc@gmail.com', N'Malabon City', N'3')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [email], [address], [user_type]) VALUES (5, N'Eli', N'eli', N'Eli', NULL, NULL, NULL, N'3')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [email], [address], [user_type]) VALUES (6, N'staff', N'staff', N'staff', NULL, NULL, NULL, N'2')
INSERT [dbo].[users] ([user_id], [username], [password], [display_name], [contact], [email], [address], [user_type]) VALUES (7, N'admin', N'admin', N'Admin', N'09677854789', NULL, N'Sa puso mo', N'1')
SET IDENTITY_INSERT [dbo].[users] OFF
GO
/****** Object:  Index [IX_cart_user_id]    Script Date: 4/4/2025 2:40:35 AM ******/
CREATE NONCLUSTERED INDEX [IX_cart_user_id] ON [dbo].[cart]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_order_items_order_id]    Script Date: 4/4/2025 2:40:35 AM ******/
CREATE NONCLUSTERED INDEX [IX_order_items_order_id] ON [dbo].[order_items]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_order_items_transaction_id]    Script Date: 4/4/2025 2:40:35 AM ******/
CREATE NONCLUSTERED INDEX [IX_order_items_transaction_id] ON [dbo].[order_items]
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_orders_user_id]    Script Date: 4/4/2025 2:40:35 AM ******/
CREATE NONCLUSTERED INDEX [IX_orders_user_id] ON [dbo].[orders]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_transactions_user_id]    Script Date: 4/4/2025 2:40:35 AM ******/
CREATE NONCLUSTERED INDEX [IX_transactions_user_id] ON [dbo].[transactions]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cart] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[cart] ADD  DEFAULT ((0)) FOR [is_deal]
GO
ALTER TABLE [dbo].[customer_addresses] ADD  DEFAULT ((0)) FOR [is_default]
GO
ALTER TABLE [dbo].[customer_addresses] ADD  DEFAULT (getdate()) FOR [date_added]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT ((1)) FOR [discount_type]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT ((1)) FOR [applicable_to]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT (getdate()) FOR [start_date]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT (dateadd(month,(1),getdate())) FOR [end_date]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[discounts] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[menu_categories] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[menu_types] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[order_items] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__order_da__35BCFE0A]  DEFAULT (getdate()) FOR [order_date]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__total_am__36B12243]  DEFAULT ((0)) FOR [total_amount]
GO
ALTER TABLE [dbo].[orders] ADD  CONSTRAINT [DF__orders__status__37A5467C]  DEFAULT ('pending') FOR [status]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT ((1)) FOR [user_id]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT ((0)) FOR [total_amount]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT ('Pending') FOR [status]
GO
ALTER TABLE [dbo].[transactions] ADD  DEFAULT (getdate()) FOR [transaction_date]
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD FOREIGN KEY([item_id])
REFERENCES [dbo].[menu] ([item_id])
GO
ALTER TABLE [dbo].[cart]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[customer_addresses]  WITH CHECK ADD  CONSTRAINT [FK_customer_addresses_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[customer_addresses] CHECK CONSTRAINT [FK_customer_addresses_users]
GO
ALTER TABLE [dbo].[menu]  WITH CHECK ADD  CONSTRAINT [FK_menu_menu_categories] FOREIGN KEY([category_id])
REFERENCES [dbo].[menu_categories] ([category_id])
GO
ALTER TABLE [dbo].[menu] CHECK CONSTRAINT [FK_menu_menu_categories]
GO
ALTER TABLE [dbo].[menu]  WITH CHECK ADD  CONSTRAINT [FK_menu_menu_types] FOREIGN KEY([type_id])
REFERENCES [dbo].[menu_types] ([type_id])
GO
ALTER TABLE [dbo].[menu] CHECK CONSTRAINT [FK_menu_menu_types]
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD  CONSTRAINT [FK_order_items_menu] FOREIGN KEY([item_id])
REFERENCES [dbo].[menu] ([item_id])
GO
ALTER TABLE [dbo].[order_items] CHECK CONSTRAINT [FK_order_items_menu]
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD  CONSTRAINT [FK_order_items_orders] FOREIGN KEY([order_id])
REFERENCES [dbo].[orders] ([order_id])
GO
ALTER TABLE [dbo].[order_items] CHECK CONSTRAINT [FK_order_items_orders]
GO
ALTER TABLE [dbo].[order_items]  WITH CHECK ADD  CONSTRAINT [FK_order_items_transactions] FOREIGN KEY([transaction_id])
REFERENCES [dbo].[transactions] ([transaction_id])
GO
ALTER TABLE [dbo].[order_items] CHECK CONSTRAINT [FK_order_items_transactions]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_transactions] FOREIGN KEY([transaction_id])
REFERENCES [dbo].[transactions] ([transaction_id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_transactions]
GO
ALTER TABLE [dbo].[orders]  WITH CHECK ADD  CONSTRAINT [FK_orders_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[orders] CHECK CONSTRAINT [FK_orders_users]
GO
ALTER TABLE [dbo].[transactions]  WITH CHECK ADD  CONSTRAINT [FK_transactions_users] FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[transactions] CHECK CONSTRAINT [FK_transactions_users]
GO
USE [master]
GO
ALTER DATABASE [hapag_database] SET  READ_WRITE 
GO

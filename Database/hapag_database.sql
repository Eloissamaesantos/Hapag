USE [master]
GO
/****** Object:  Database [hapag_database]    Script Date: 4/3/2025 5:34:16 PM ******/
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
/****** Object:  Table [dbo].[cart]    Script Date: 4/3/2025 5:34:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cart](
	[cart_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[cart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[deals]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[deals_item]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[discounts]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[menu]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[menu_categories]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[menu_types]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[order_items]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[order_items_backup]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[orders]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[orders_backup]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[promotions]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[transactions]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Table [dbo].[users]    Script Date: 4/3/2025 5:34:17 PM ******/
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
/****** Object:  Index [IX_cart_user_id]    Script Date: 4/3/2025 5:34:17 PM ******/
CREATE NONCLUSTERED INDEX [IX_cart_user_id] ON [dbo].[cart]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_order_items_order_id]    Script Date: 4/3/2025 5:34:17 PM ******/
CREATE NONCLUSTERED INDEX [IX_order_items_order_id] ON [dbo].[order_items]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_order_items_transaction_id]    Script Date: 4/3/2025 5:34:17 PM ******/
CREATE NONCLUSTERED INDEX [IX_order_items_transaction_id] ON [dbo].[order_items]
(
	[transaction_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_orders_user_id]    Script Date: 4/3/2025 5:34:17 PM ******/
CREATE NONCLUSTERED INDEX [IX_orders_user_id] ON [dbo].[orders]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_transactions_user_id]    Script Date: 4/3/2025 5:34:17 PM ******/
CREATE NONCLUSTERED INDEX [IX_transactions_user_id] ON [dbo].[transactions]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cart] ADD  DEFAULT ((1)) FOR [quantity]
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

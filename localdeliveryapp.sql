-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 08, 2024 at 06:14 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `localdeliveryapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `app_settings`
--

CREATE TABLE `app_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `site_name` varchar(255) DEFAULT NULL,
  `site_email` varchar(255) DEFAULT NULL,
  `site_description` longtext DEFAULT NULL,
  `site_copyright` varchar(255) DEFAULT NULL,
  `facebook_url` varchar(255) DEFAULT NULL,
  `twitter_url` varchar(255) DEFAULT NULL,
  `linkedin_url` varchar(255) DEFAULT NULL,
  `instagram_url` varchar(255) DEFAULT NULL,
  `support_number` varchar(255) DEFAULT NULL,
  `support_email` varchar(255) DEFAULT NULL,
  `notification_settings` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`notification_settings`)),
  `auto_assign` tinyint(4) DEFAULT 0,
  `distance_unit` varchar(255) DEFAULT NULL COMMENT 'km, mile',
  `distance` double DEFAULT 0,
  `otp_verify_on_pickup_delivery` tinyint(4) DEFAULT 1,
  `currency` varchar(255) DEFAULT NULL,
  `currency_code` varchar(255) DEFAULT NULL,
  `currency_position` varchar(255) DEFAULT NULL,
  `is_vehicle_in_order` tinyint(4) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `app_settings`
--

INSERT INTO `app_settings` (`id`, `site_name`, `site_email`, `site_description`, `site_copyright`, `facebook_url`, `twitter_url`, `linkedin_url`, `instagram_url`, `support_number`, `support_email`, `notification_settings`, `auto_assign`, `distance_unit`, `distance`, `otp_verify_on_pickup_delivery`, `currency`, `currency_code`, `currency_position`, `is_vehicle_in_order`, `created_at`, `updated_at`) VALUES
(1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '{\"active\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"cancelled\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"completed\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"courier_arrived\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"courier_assigned\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"courier_departed\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"courier_picked_up\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"courier_transfer\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"create\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"delayed\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"failed\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"},\"payment_status_message\":{\"IS_ONESIGNAL_NOTIFICATION\":\"1\",\"IS_FIREBASE_NOTIFICATION\":\"1\"}}', 0, NULL, 0, 1, '₦', 'NGN', 'left', 0, '2023-09-10 20:12:06', '2023-09-10 20:12:06');

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `country_id` bigint(20) UNSIGNED DEFAULT NULL,
  `address` text DEFAULT NULL,
  `fixed_charges` double DEFAULT 0,
  `cancel_charges` double DEFAULT 0,
  `min_distance` double DEFAULT 0,
  `min_weight` double DEFAULT 0,
  `per_distance_charges` double DEFAULT 0,
  `per_weight_charges` double DEFAULT 0,
  `status` tinyint(4) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `commission_type` varchar(255) DEFAULT NULL COMMENT 'fixed, percentage',
  `admin_commission` double DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cities`
--

INSERT INTO `cities` (`id`, `name`, `country_id`, `address`, `fixed_charges`, `cancel_charges`, `min_distance`, `min_weight`, `per_distance_charges`, `per_weight_charges`, `status`, `created_at`, `updated_at`, `deleted_at`, `commission_type`, `admin_commission`) VALUES
(1, 'Lagos', 1, NULL, 30, 30, 1, 0.1, 30, 30, 1, '2023-09-10 09:57:34', '2023-09-10 20:02:38', NULL, 'percentage', 10);

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `distance_type` varchar(255) DEFAULT NULL,
  `weight_type` varchar(255) DEFAULT NULL,
  `links` longtext DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `name`, `code`, `distance_type`, `weight_type`, `links`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Nigeria', 'NG', 'km', 'kg', NULL, 1, '2023-09-10 09:56:29', '2023-09-10 20:01:57', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `delivery_man_documents`
--

CREATE TABLE `delivery_man_documents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `delivery_man_id` bigint(20) UNSIGNED DEFAULT NULL,
  `document_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_verified` tinyint(4) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `is_required` tinyint(4) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `extra_charges`
--

CREATE TABLE `extra_charges` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `charges_type` varchar(255) NOT NULL COMMENT 'fixed, percentage',
  `charges` double DEFAULT 0,
  `country_id` bigint(20) UNSIGNED DEFAULT NULL,
  `city_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '0-inactive , 1 - active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `extra_charges`
--

INSERT INTO `extra_charges` (`id`, `title`, `charges_type`, `charges`, `country_id`, `city_id`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'GST', 'percentage', 12, 1, 1, 1, '2023-09-10 10:03:40', '2023-09-10 10:03:40', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `media`
--

CREATE TABLE `media` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) DEFAULT NULL,
  `collection_name` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `mime_type` varchar(255) DEFAULT NULL,
  `disk` varchar(255) NOT NULL,
  `conversions_disk` varchar(255) DEFAULT NULL,
  `size` bigint(20) UNSIGNED NOT NULL,
  `manipulations` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`manipulations`)),
  `custom_properties` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`custom_properties`)),
  `generated_conversions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`generated_conversions`)),
  `responsive_images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`responsive_images`)),
  `order_column` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `media`
--

INSERT INTO `media` (`id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type`, `disk`, `conversions_disk`, `size`, `manipulations`, `custom_properties`, `generated_conversions`, `responsive_images`, `order_column`, `created_at`, `updated_at`) VALUES
(2, 'App\\Models\\User', 1, 'c9db7c8b-d519-4756-b8cc-f171599c5e05', 'profile_image', '2533570b-d128-4835-b4dd-2a7b713f1590', '2533570b-d128-4835-b4dd-2a7b713f1590', 'image/png', 'public', 'public', 3995, '[]', '[]', '[]', '[]', 1, '2023-08-16 10:07:09', '2023-08-16 10:07:09'),
(3, 'App\\Models\\Vehicle', 1, 'd0ee5751-5263-4587-b766-58b382eb0e28', 'vehicle_image', '2b2f7300-9f00-4098-825e-f1f875f1239c', '2b2f7300-9f00-4098-825e-f1f875f1239c', 'image/png', 'public', 'public', 36804, '[]', '[]', '[]', '[]', 2, '2023-09-10 09:59:50', '2023-09-10 09:59:50'),
(5, 'App\\Models\\User', 2, 'c0809f46-6e8f-416c-bc6b-b7bff37b8344', 'profile_image', '1000010824', '1000010824.jpg', 'image/jpeg', 'public', 'public', 160856, '[]', '[]', '[]', '[]', 3, '2023-09-13 11:00:16', '2023-09-13 11:00:16');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2014_10_12_200000_add_two_factor_columns_to_users_table', 1),
(4, '2019_08_19_000000_create_failed_jobs_table', 1),
(5, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(6, '2022_01_08_103820_create_sessions_table', 1),
(7, '2022_01_10_051714_create_countries_table', 1),
(8, '2022_01_10_070509_create_cities_table', 1),
(9, '2022_01_10_101903_create_extra_charges_table', 1),
(10, '2022_01_10_112023_create_app_settings_table', 1),
(11, '2022_01_11_090450_create_media_table', 1),
(12, '2022_01_13_074756_create_orders_table', 1),
(13, '2022_01_13_095310_create_static_data_table', 1),
(14, '2022_01_15_084527_create_order_histories_table', 1),
(15, '2022_01_18_100915_create_payment_gateways_table', 1),
(16, '2022_01_19_060358_create_payments_table', 1),
(17, '2022_01_24_104630_create_notifications_table', 1),
(18, '2022_04_14_084202_create_documents_table', 1),
(19, '2022_04_14_084351_create_delivery_man_documents_table', 1),
(20, '2022_05_11_080007_add_total_parcel_orders_table', 1),
(21, '2022_05_30_063501_add_fcm_token_to_users_table', 1),
(22, '2022_05_31_101332_add_auto_assign_to_orders', 1),
(23, '2022_06_02_065520_add_distance_to_app_settings', 1),
(24, '2022_06_27_131039_add_otp_verify_on_pickup_delivery', 1),
(25, '2022_12_05_111707_alter_cities_table', 1),
(26, '2022_12_05_140929_create_wallets_table', 1),
(27, '2022_12_05_140954_create_wallet_histories_table', 1),
(28, '2022_12_05_141107_create_user_bank_accounts_table', 1),
(29, '2022_12_06_061753_alter_payments_table', 1),
(30, '2022_12_10_054128_create_withdraw_requests_table', 1),
(31, '2023_01_30_121805_create_vehicles_table', 1),
(32, '2023_01_30_131633_add_is_vehicle_in_order_in_app_settings_table', 1),
(33, '2023_01_30_132224_add_vehicle_data_in_orders_table', 1),
(34, '2023_05_05_111042_create_settings_table', 1),
(35, '2023_05_19_100843_add_otp_verify_at_in_users_table', 1),
(36, '2023_10_07_105004_create_parcel_size_modals_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `type` varchar(255) NOT NULL,
  `notifiable_type` varchar(255) NOT NULL,
  `notifiable_id` bigint(20) UNSIGNED NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
('3e19670d-5053-40be-ac3c-d63ca62d24a7', 'App\\Notifications\\OrderNotification', 'App\\Models\\User', 2, '{\"id\":10,\"type\":\"courier_arrived\",\"subject\":\"Order #10\",\"message\":\"Delivery person has been arrived at pickup location and waiting for a client.\"}', '2023-09-14 17:34:56', '2023-09-14 08:38:21', '2023-09-14 17:34:56'),
('3e392831-3988-4cc3-a970-af0afa197647', 'App\\Notifications\\OrderNotification', 'App\\Models\\User', 6, '{\"id\":10,\"type\":\"courier_assigned\",\"subject\":\"Order #10\",\"message\":\"New Order #10 has been assigned to you.\"}', '2023-09-14 06:26:02', '2023-09-14 06:25:10', '2023-09-14 06:26:02'),
('6764653d-6841-48ff-97a7-cfff95b806eb', 'App\\Notifications\\OrderNotification', 'App\\Models\\User', 1, '{\"id\":35,\"type\":\"cancelled\",\"subject\":\"Order #35\",\"message\":\"Order has been cancelled.\"}', NULL, '2023-10-07 08:02:40', '2023-10-07 08:02:40'),
('770f4afa-f3d2-46d3-9287-6391899bf006', 'App\\Notifications\\OrderNotification', 'App\\Models\\User', 1, '{\"id\":36,\"type\":\"cancelled\",\"subject\":\"Order #36\",\"message\":\"Order has been cancelled.\"}', NULL, '2023-10-07 08:18:29', '2023-10-07 08:18:29'),
('7f44aa32-9b18-424d-b3b4-6ab21ba20b8f', 'App\\Notifications\\OrderNotification', 'App\\Models\\User', 1, '{\"id\":31,\"type\":\"cancelled\",\"subject\":\"Order #31\",\"message\":\"Order has been cancelled.\"}', NULL, '2023-10-07 07:55:33', '2023-10-07 07:55:33'),
('d13eb23c-d1e4-4f3e-a895-bc754240951d', 'App\\Notifications\\OrderNotification', 'App\\Models\\User', 1, '{\"id\":10,\"type\":\"courier_arrived\",\"subject\":\"Order #10\",\"message\":\"Delivery person has been arrived at pickup location and waiting for a client.\"}', NULL, '2023-09-14 08:38:21', '2023-09-14 08:38:21'),
('f3407cb0-a5a5-4853-b751-a94d6d632ce0', 'App\\Notifications\\OrderNotification', 'App\\Models\\User', 2, '{\"id\":10,\"type\":\"courier_assigned\",\"subject\":\"Order #10\",\"message\":\"Your Order #10 has been assigned to Ad Gjgg.\"}', '2023-09-14 17:34:56', '2023-09-14 06:25:10', '2023-09-14 17:34:56');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED DEFAULT NULL,
  `pickup_point` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`pickup_point`)),
  `delivery_point` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`delivery_point`)),
  `country_id` bigint(20) UNSIGNED DEFAULT NULL,
  `city_id` bigint(20) UNSIGNED DEFAULT NULL,
  `parcel_type` varchar(255) DEFAULT NULL,
  `total_weight` double DEFAULT 0,
  `total_distance` double DEFAULT 0,
  `date` datetime DEFAULT NULL,
  `pickup_datetime` datetime DEFAULT NULL,
  `delivery_datetime` datetime DEFAULT NULL,
  `parent_order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_id` bigint(20) UNSIGNED DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `payment_collect_from` varchar(255) DEFAULT NULL COMMENT 'on_pickup, on_delivery',
  `delivery_man_id` bigint(20) UNSIGNED DEFAULT NULL,
  `fixed_charges` double DEFAULT 0,
  `weight_charge` double DEFAULT 0,
  `distance_charge` double DEFAULT 0,
  `extra_charges` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`extra_charges`)),
  `total_amount` double DEFAULT 0,
  `pickup_confirm_by_client` tinyint(4) DEFAULT 0 COMMENT '0-not confirm , 1 - confirm',
  `pickup_confirm_by_delivery_man` tinyint(4) DEFAULT 0 COMMENT '0-not confirm , 1 - confirm',
  `total_parcel` double DEFAULT NULL,
  `vehicle_id` bigint(20) UNSIGNED DEFAULT NULL,
  `vehicle_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`vehicle_data`)),
  `auto_assign` tinyint(4) DEFAULT NULL,
  `cancelled_delivery_man_ids` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `client_id`, `pickup_point`, `delivery_point`, `country_id`, `city_id`, `parcel_type`, `total_weight`, `total_distance`, `date`, `pickup_datetime`, `delivery_datetime`, `parent_order_id`, `payment_id`, `reason`, `status`, `payment_collect_from`, `delivery_man_id`, `fixed_charges`, `weight_charge`, `distance_charge`, `extra_charges`, `total_amount`, `pickup_confirm_by_client`, `pickup_confirm_by_delivery_man`, `total_parcel`, `vehicle_id`, `vehicle_data`, `auto_assign`, `cancelled_delivery_man_ids`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 2, '{\"start_time\":\"2023-09-13 18:01:51.082478\",\"end_time\":null,\"address\":\"417, 27th Main Rd, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9187611\",\"longitude\":\"77.65180289999999\",\"description\":\"hxjxjx\",\"contact_number\":\"+91 7004920897\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"A206, Splendid Royale, 16\\/10 ITI, Layout, Hosapalaya, Hosapalaya, Muneshwara Nagar, Bengaluru, Karnataka 560068, India\",\"latitude\":\"12.9000101\",\"longitude\":\"77.6448739\",\"description\":\"hxux7z\",\"contact_number\":\"+91 1234567860\"}', 1, 1, 'Cakes', 1, 2.22, '2023-09-13 18:01:51', NULL, NULL, NULL, NULL, NULL, 'create', 'on_delivery', NULL, 30, 27, 36.6, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 104.83, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:31:51', '2023-09-13 11:31:51', NULL),
(2, 2, '{\"start_time\":\"2023-09-13 18:02:17.381378\",\"end_time\":null,\"address\":\"417, 27th Main Rd, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9187611\",\"longitude\":\"77.65180289999999\",\"description\":\"hxjxjx\",\"contact_number\":\"+91 7004920897\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"A206, Splendid Royale, 16\\/10 ITI, Layout, Hosapalaya, Hosapalaya, Muneshwara Nagar, Bengaluru, Karnataka 560068, India\",\"latitude\":\"12.9000101\",\"longitude\":\"77.6448739\",\"description\":\"hxux7z\",\"contact_number\":\"+91 1234567860\"}', 1, 1, 'Cakes', 1, 2.22, '2023-09-13 18:02:17', NULL, NULL, NULL, NULL, NULL, 'create', 'on_delivery', NULL, 30, 27, 36.6, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 104.83, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:32:18', '2023-09-13 11:32:18', NULL),
(3, 2, '{\"start_time\":\"2023-09-13 18:03:00.601967\",\"end_time\":null,\"address\":\"417, 27th Main Rd, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9187611\",\"longitude\":\"77.65180289999999\",\"description\":\"hxjxjx\",\"contact_number\":\"+91 7004920897\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"A206, Splendid Royale, 16\\/10 ITI, Layout, Hosapalaya, Hosapalaya, Muneshwara Nagar, Bengaluru, Karnataka 560068, India\",\"latitude\":\"12.9000101\",\"longitude\":\"77.6448739\",\"description\":\"hxux7z\",\"contact_number\":\"+91 1234567860\"}', 1, 1, 'Cakes', 1, 2.22, '2023-09-13 18:03:00', NULL, NULL, NULL, NULL, NULL, 'create', 'on_delivery', NULL, 30, 27, 36.6, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 104.83, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:33:01', '2023-09-13 11:33:01', NULL),
(4, 2, '{\"start_time\":\"2023-09-13 18:03:08.137014\",\"end_time\":null,\"address\":\"417, 27th Main Rd, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9187611\",\"longitude\":\"77.65180289999999\",\"description\":\"hxjxjx\",\"contact_number\":\"+91 7004920897\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"A206, Splendid Royale, 16\\/10 ITI, Layout, Hosapalaya, Hosapalaya, Muneshwara Nagar, Bengaluru, Karnataka 560068, India\",\"latitude\":\"12.9000101\",\"longitude\":\"77.6448739\",\"description\":\"hxux7z\",\"contact_number\":\"+91 1234567860\"}', 1, 1, 'Cakes', 1, 2.22, '2023-09-13 18:03:08', NULL, NULL, NULL, NULL, NULL, 'create', 'on_delivery', NULL, 30, 27, 36.6, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 104.83, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:33:08', '2023-09-13 11:33:08', NULL),
(5, 2, '{\"start_time\":\"2023-09-13 18:03:12.520870\",\"end_time\":null,\"address\":\"417, 27th Main Rd, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9187611\",\"longitude\":\"77.65180289999999\",\"description\":\"hxjxjx\",\"contact_number\":\"+91 7004920897\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"A206, Splendid Royale, 16\\/10 ITI, Layout, Hosapalaya, Hosapalaya, Muneshwara Nagar, Bengaluru, Karnataka 560068, India\",\"latitude\":\"12.9000101\",\"longitude\":\"77.6448739\",\"description\":\"hxux7z\",\"contact_number\":\"+91 1234567860\"}', 1, 1, 'Cakes', 1, 2.22, '2023-09-13 18:03:12', NULL, NULL, NULL, NULL, NULL, 'create', 'on_delivery', NULL, 30, 27, 36.6, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 104.83, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:33:13', '2023-09-13 11:33:13', NULL),
(6, 2, '{\"start_time\":\"2023-09-13 18:05:51.707525\",\"end_time\":null,\"address\":\"417, 27th Main Rd, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9187611\",\"longitude\":\"77.65180289999999\",\"description\":\"hxjxjx\",\"contact_number\":\"+91 7004920897\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"A206, Splendid Royale, 16\\/10 ITI, Layout, Hosapalaya, Hosapalaya, Muneshwara Nagar, Bengaluru, Karnataka 560068, India\",\"latitude\":\"12.9000101\",\"longitude\":\"77.6448739\",\"description\":\"hxux7z\",\"contact_number\":\"+91 1234567860\"}', 1, 1, 'Cakes', 1, 2.22, '2023-09-13 18:05:51', NULL, NULL, NULL, NULL, NULL, 'create', 'on_delivery', NULL, 30, 27, 36.6, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 104.83, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:35:52', '2023-09-13 11:35:52', NULL),
(7, 2, '{\"start_time\":\"2023-09-13 18:06:26.213611\",\"end_time\":null,\"address\":\"417, 27th Main Rd, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9187611\",\"longitude\":\"77.65180289999999\",\"description\":\"hxjxjx\",\"contact_number\":\"+91 7004920897\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"A206, Splendid Royale, 16\\/10 ITI, Layout, Hosapalaya, Hosapalaya, Muneshwara Nagar, Bengaluru, Karnataka 560068, India\",\"latitude\":\"12.9000101\",\"longitude\":\"77.6448739\",\"description\":\"hxux7z\",\"contact_number\":\"+91 1234567860\"}', 1, 1, 'Cakes', 1, 2.22, '2023-09-13 18:06:26', NULL, NULL, NULL, NULL, NULL, 'create', 'on_delivery', NULL, 30, 27, 36.6, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 104.83, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:36:26', '2023-09-13 11:36:26', NULL),
(8, 2, '{\"start_time\":\"2023-09-13 18:09:57.184505\",\"end_time\":null,\"address\":\"417, 27th Main Rd, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9187611\",\"longitude\":\"77.65180289999999\",\"description\":\"hxjxjx\",\"contact_number\":\"+91 7004920897\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"A206, Splendid Royale, 16\\/10 ITI, Layout, Hosapalaya, Hosapalaya, Muneshwara Nagar, Bengaluru, Karnataka 560068, India\",\"latitude\":\"12.9000101\",\"longitude\":\"77.6448739\",\"description\":\"hxux7z\",\"contact_number\":\"+91 1234567860\"}', 1, 1, 'Cakes', 1, 2.22, '2023-09-13 18:09:57', NULL, NULL, NULL, NULL, NULL, 'create', 'on_delivery', NULL, 30, 27, 36.6, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 104.83, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:39:57', '2023-09-13 11:39:57', NULL),
(9, 2, '{\"start_time\":\"2023-09-13 18:12:29.094447\",\"end_time\":null,\"address\":\"417, 27th Main Rd, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9187611\",\"longitude\":\"77.65180289999999\",\"description\":\"hxjxjx\",\"contact_number\":\"+91 7004920897\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"A206, Splendid Royale, 16\\/10 ITI, Layout, Hosapalaya, Hosapalaya, Muneshwara Nagar, Bengaluru, Karnataka 560068, India\",\"latitude\":\"12.9000101\",\"longitude\":\"77.6448739\",\"description\":\"hxux7z\",\"contact_number\":\"+91 1234567860\"}', 1, 1, 'Cakes', 1, 2.22, '2023-09-13 18:12:29', NULL, NULL, NULL, NULL, NULL, 'create', 'on_delivery', NULL, 30, 27, 36.6, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 104.83, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:42:30', '2023-09-13 11:42:30', NULL),
(10, 2, '{\"start_time\":\"2023-09-13 18:13:48.369076\",\"end_time\":null,\"address\":\"417, 27th Main Rd, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9187611\",\"longitude\":\"77.65180289999999\",\"description\":\"hxjxjx\",\"contact_number\":\"+91 7004920897\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"A206, Splendid Royale, 16\\/10 ITI, Layout, Hosapalaya, Hosapalaya, Muneshwara Nagar, Bengaluru, Karnataka 560068, India\",\"latitude\":\"12.9000101\",\"longitude\":\"77.6448739\",\"description\":\"hxux7z\",\"contact_number\":\"+91 1234567860\"}', 1, 1, 'Cakes', 1, 2.22, '2023-09-13 18:13:48', NULL, NULL, NULL, NULL, NULL, 'courier_arrived', 'on_delivery', 6, 30, 27, 36.6, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 104.83, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:43:48', '2023-09-14 08:38:21', NULL),
(11, 2, '{\"start_time\":\"2023-09-13 14:42:11.684404\",\"end_time\":null,\"address\":\"342 Bedfont Ln, Feltham TW14 9SA, UK\",\"latitude\":\"51.45252809999999\",\"longitude\":\"-0.4243231\",\"description\":null,\"contact_number\":\"+91 +91\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"342 Bedfont Ln, Feltham TW14 9SA, UK\",\"latitude\":\"51.45252809999999\",\"longitude\":\"-0.4243231\",\"description\":null,\"contact_number\":\"+91 +91\"}', 1, 1, 'Other', 1, 0, '2023-09-13 14:42:11', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 27, 0, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 63.84, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 12:36:58', '2023-09-13 12:42:12', NULL),
(12, 2, '{\"start_time\":\"2023-09-13 20:48:47.209634\",\"end_time\":null,\"address\":null,\"latitude\":null,\"longitude\":null,\"description\":null,\"contact_number\":\"+91\"}', '{\"start_time\":null,\"end_time\":null,\"address\":null,\"latitude\":null,\"longitude\":null,\"description\":null,\"contact_number\":\"+91\"}', 1, 1, NULL, 1, 0, '2023-09-13 20:48:47', NULL, NULL, NULL, NULL, NULL, 'draft', 'on_pickup', NULL, 30, 0, 0, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 0, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-09-13 18:48:49', '2023-09-13 18:48:49', NULL),
(13, 14, '{\"start_time\":\"2023-10-03 14:22:15.725771\",\"end_time\":null,\"address\":null,\"latitude\":null,\"longitude\":null,\"description\":null,\"contact_number\":\"+254\"}', '{\"start_time\":null,\"end_time\":null,\"address\":null,\"latitude\":null,\"longitude\":null,\"description\":null,\"contact_number\":\"+254\"}', 1, 1, NULL, 0, 0, '2023-10-03 14:22:15', NULL, NULL, NULL, NULL, NULL, 'draft', 'on_pickup', NULL, 30, 0, 0, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 0, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-03 12:22:15', '2023-10-03 12:22:15', NULL),
(14, 14, '{\"start_time\":\"2023-10-03 18:42:39.548209\",\"end_time\":null,\"address\":\"342 Bedfont Ln, Feltham TW14 9SA, UK\",\"latitude\":\"51.45252809999999\",\"longitude\":\"-0.4243231\",\"description\":\"fjsynnhb g\",\"contact_number\":\"+44 7949907675\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"342 Bedfont Ln, Feltham TW14 9SA, UK\",\"latitude\":\"51.45252809999999\",\"longitude\":\"-0.4243231\",\"description\":\"fjyik9yb bkghghh\",\"contact_number\":\"+44 7949907675\"}', 1, 1, 'Gifts', 1, 0, '2023-10-03 18:42:39', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 27, 0, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 63.84, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-03 16:42:39', '2023-10-03 16:42:39', NULL),
(15, 14, '{\"start_time\":\"2023-10-03 18:42:55.596545\",\"end_time\":null,\"address\":\"342 Bedfont Ln, Feltham TW14 9SA, UK\",\"latitude\":\"51.45252809999999\",\"longitude\":\"-0.4243231\",\"description\":\"fjsynnhb g\",\"contact_number\":\"+44 7949907675\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"342 Bedfont Ln, Feltham TW14 9SA, UK\",\"latitude\":\"51.45252809999999\",\"longitude\":\"-0.4243231\",\"description\":\"fjyik9yb bkghghh\",\"contact_number\":\"+44 7949907675\"}', 1, 1, 'Gifts', 1, 0, '2023-10-03 18:42:55', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 27, 0, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 63.84, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-03 16:42:55', '2023-10-03 16:42:55', NULL),
(16, 14, '{\"start_time\":\"2023-10-03 18:43:00.663991\",\"end_time\":null,\"address\":\"342 Bedfont Ln, Feltham TW14 9SA, UK\",\"latitude\":\"51.45252809999999\",\"longitude\":\"-0.4243231\",\"description\":\"fjsynnhb g\",\"contact_number\":\"+44 7949907675\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"342 Bedfont Ln, Feltham TW14 9SA, UK\",\"latitude\":\"51.45252809999999\",\"longitude\":\"-0.4243231\",\"description\":\"fjyik9yb bkghghh\",\"contact_number\":\"+44 7949907675\"}', 1, 1, 'Gifts', 1, 0, '2023-10-03 18:43:00', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 27, 0, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 63.84, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-03 16:43:00', '2023-10-03 16:43:00', NULL),
(17, 14, '{\"start_time\":\"2023-10-03 18:43:08.035130\",\"end_time\":null,\"address\":\"342 Bedfont Ln, Feltham TW14 9SA, UK\",\"latitude\":\"51.45252809999999\",\"longitude\":\"-0.4243231\",\"description\":\"fjsynnhb g\",\"contact_number\":\"+44 7949907675\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"342 Bedfont Ln, Feltham TW14 9SA, UK\",\"latitude\":\"51.45252809999999\",\"longitude\":\"-0.4243231\",\"description\":\"fjyik9yb bkghghh\",\"contact_number\":\"+44 7949907675\"}', 1, 1, 'Gifts', 1, 0, '2023-10-03 18:43:08', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 27, 0, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 63.84, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-03 16:43:07', '2023-10-03 16:43:07', NULL),
(18, 16, '{\"start_time\":\"2023-10-07 13:14:35.089328\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 1, 1.65, '2023-10-07 13:14:35', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 27, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 85.68, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:44:36', '2023-10-07 06:44:36', NULL),
(19, 16, '{\"start_time\":\"2023-10-07 13:14:45.240796\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 1, 1.65, '2023-10-07 13:14:45', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 27, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 85.68, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:44:46', '2023-10-07 06:44:46', NULL),
(20, 16, '{\"start_time\":\"2023-10-07 13:17:15.663362\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:17:15', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:47:16', '2023-10-07 06:47:16', NULL),
(21, 16, '{\"start_time\":\"2023-10-07 13:19:48.959831\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:19:48', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:49:50', '2023-10-07 06:49:50', NULL),
(22, 16, '{\"start_time\":\"2023-10-07 13:22:36.265539\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:22:36', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:52:37', '2023-10-07 06:52:37', NULL),
(23, 16, '{\"start_time\":\"2023-10-07 13:23:24.961509\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:23:24', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:53:25', '2023-10-07 06:53:25', NULL),
(24, 16, '{\"start_time\":\"2023-10-07 13:26:51.646405\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:26:51', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:56:52', '2023-10-07 06:56:52', NULL),
(25, 16, '{\"start_time\":\"2023-10-07 13:27:17.765645\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:27:17', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:57:18', '2023-10-07 06:57:18', NULL),
(26, 16, '{\"start_time\":\"2023-10-07 13:27:29.813922\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:27:29', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:57:30', '2023-10-07 06:57:30', NULL),
(27, 16, '{\"start_time\":\"2023-10-07 13:28:26.368976\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:28:26', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:58:27', '2023-10-07 06:58:27', NULL),
(28, 16, '{\"start_time\":\"2023-10-07 13:28:58.302813\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:28:58', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 06:58:59', '2023-10-07 06:58:59', NULL),
(29, 16, '{\"start_time\":\"2023-10-07 13:33:44.560404\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:33:44', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 07:03:47', '2023-10-07 07:03:47', NULL),
(30, 16, '{\"start_time\":\"2023-10-07 13:34:14.476952\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:34:14', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 07:04:15', '2023-10-07 07:04:15', NULL),
(31, 16, '{\"start_time\":\"2023-10-07 13:34:19.754957\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 4, 1.65, '2023-10-07 13:34:19', NULL, NULL, NULL, 1, 'Delivery time is too long', 'cancelled', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 07:04:20', '2023-10-07 07:55:33', NULL),
(32, 16, '{\"start_time\":\"2023-10-07 14:23:55.321109\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":\"fugcc\",\"contact_number\":\"+234 12375678950\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"fuhg\",\"contact_number\":\"+234 2353856285\"}', 1, 1, 'Cakes', 31, 1.65, '2023-10-07 14:23:55', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 117, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 186.48, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 07:04:31', '2023-10-07 07:53:57', NULL),
(33, 16, '{\"start_time\":\"2023-10-07 14:28:11.863266\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":null,\"contact_number\":\"+234 2825528855\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":null,\"contact_number\":\"+234 2688556985\"}', 1, 1, 'Documents', 31, 0, '2023-10-07 14:28:11', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 27, 0, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 63.84, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 07:58:12', '2023-10-07 07:58:12', NULL),
(34, 16, '{\"start_time\":\"2023-10-07 14:31:10.713235\",\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":null,\"contact_number\":\"+234 2825528855\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":null,\"contact_number\":\"+234 2688556985\"}', 1, 1, 'Documents', 31, 0, '2023-10-07 14:31:10', NULL, NULL, NULL, NULL, NULL, 'create', 'on_pickup', NULL, 30, 27, 0, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 63.84, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 08:01:11', '2023-10-07 08:01:11', NULL),
(35, 16, '{\"start_time\":\"2023-10-07 14:31:48.675438\",\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":\"cg\",\"contact_number\":\"+234 28858588\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"417, 27th Main Rd, Sector 2, 1st Sector, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.918804\",\"longitude\":\"77.651836\",\"description\":null,\"contact_number\":\"+234 668555885\"}', 1, 1, 'Electronics', 31, 1.65, '2023-10-07 14:31:48', NULL, NULL, NULL, 2, 'Change order', 'cancelled', 'on_pickup', NULL, 30, 27, 19.5, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 85.68, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 08:01:49', '2023-10-07 08:02:40', NULL),
(36, 16, '{\"start_time\":\"2023-10-07 14:34:16.101581\",\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":null,\"contact_number\":\"+234 255885558\"}', '{\"start_time\":null,\"end_time\":null,\"address\":\"1391, 25th Main Rd, BDA Layout, HSR Layout, Bengaluru, Karnataka 560102, India\",\"latitude\":\"12.9041787\",\"longitude\":\"77.64953059999999\",\"description\":null,\"contact_number\":\"+234 2558855585\"}', 1, 1, 'Documents', 3, 0, '2023-10-07 14:34:16', NULL, NULL, NULL, 3, 'Change of mind', 'cancelled', 'on_pickup', NULL, 30, 87, 0, '[{\"key\":\"fixed_charges\",\"value\":30,\"value_type\":null},{\"key\":\"min_distance\",\"value\":1,\"value_type\":null},{\"key\":\"min_weight\",\"value\":0.1000000000000000055511151231257827021181583404541015625,\"value_type\":null},{\"key\":\"per_distance_charges\",\"value\":30,\"value_type\":null},{\"key\":\"per_weight_charges\",\"value\":30,\"value_type\":null},{\"key\":\"gst\",\"value\":12,\"value_type\":\"percentage\"}]', 131.04, 0, 0, 1, NULL, NULL, NULL, NULL, '2023-10-07 08:04:17', '2023-10-07 08:18:29', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `order_histories`
--

CREATE TABLE `order_histories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `datetime` datetime DEFAULT NULL,
  `history_type` varchar(255) DEFAULT NULL,
  `history_message` varchar(255) DEFAULT NULL,
  `history_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`history_data`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_histories`
--

INSERT INTO `order_histories` (`id`, `order_id`, `datetime`, `history_type`, `history_message`, `history_data`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, '2023-09-13 12:31:51', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 11:31:51', '2023-09-13 11:31:51', NULL),
(2, 2, '2023-09-13 12:32:18', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 11:32:18', '2023-09-13 11:32:18', NULL),
(3, 3, '2023-09-13 12:33:01', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 11:33:01', '2023-09-13 11:33:01', NULL),
(4, 4, '2023-09-13 12:33:08', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 11:33:08', '2023-09-13 11:33:08', NULL),
(5, 5, '2023-09-13 12:33:13', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 11:33:13', '2023-09-13 11:33:13', NULL),
(6, 6, '2023-09-13 12:35:52', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 11:35:52', '2023-09-13 11:35:52', NULL),
(7, 7, '2023-09-13 12:36:26', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 11:36:26', '2023-09-13 11:36:26', NULL),
(8, 8, '2023-09-13 12:39:57', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 11:39:57', '2023-09-13 11:39:57', NULL),
(9, 9, '2023-09-13 12:42:30', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 11:42:30', '2023-09-13 11:42:30', NULL),
(10, 10, '2023-09-13 12:43:48', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 11:43:48', '2023-09-13 11:43:48', NULL),
(11, 11, '2023-09-13 13:36:58', 'draft', 'Draft order', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 12:36:58', '2023-09-13 12:36:58', NULL),
(12, 11, '2023-09-13 13:40:43', 'draft', 'Draft order', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 12:40:43', '2023-09-13 12:40:43', NULL),
(13, 11, '2023-09-13 13:40:45', 'draft', 'Draft order', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 12:40:45', '2023-09-13 12:40:45', NULL),
(14, 11, '2023-09-13 13:40:46', 'draft', 'Draft order', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 12:40:46', '2023-09-13 12:40:46', NULL),
(15, 11, '2023-09-13 13:40:52', 'draft', 'Draft order', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 12:40:52', '2023-09-13 12:40:52', NULL),
(16, 11, '2023-09-13 13:41:12', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 12:41:12', '2023-09-13 12:41:12', NULL),
(17, 11, '2023-09-13 13:42:06', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 12:42:06', '2023-09-13 12:42:06', NULL),
(18, 11, '2023-09-13 13:42:12', 'create', 'New order has been created.', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 12:42:12', '2023-09-13 12:42:12', NULL),
(19, 12, '2023-09-13 19:48:49', 'draft', 'Draft order', '{\"client_id\":2,\"client_name\":\"Deepesh\"}', '2023-09-13 18:48:49', '2023-09-13 18:48:49', NULL),
(20, 10, '2023-09-14 07:25:10', 'courier_assigned', 'New Order #10 has been assigned to you.', '{\"delivery_man_id\":6,\"delivery_man_name\":\"Ad Gjgg\",\"auto_assign\":null}', '2023-09-14 06:25:10', '2023-09-14 06:25:10', NULL),
(21, 10, '2023-09-14 09:38:21', 'courier_arrived', 'Delivery person has been arrived at pickup location and waiting for a client.', '{\"order_id\":\"10\"}', '2023-09-14 08:38:21', '2023-09-14 08:38:21', NULL),
(22, 13, '2023-10-03 13:22:15', 'draft', 'Draft order', '{\"client_id\":14,\"client_name\":\"Abdul Adeyemi\"}', '2023-10-03 12:22:15', '2023-10-03 12:22:15', NULL),
(23, 14, '2023-10-03 17:42:39', 'create', 'New order has been created.', '{\"client_id\":14,\"client_name\":\"Abdul Adeyemi\"}', '2023-10-03 16:42:39', '2023-10-03 16:42:39', NULL),
(24, 15, '2023-10-03 17:42:55', 'create', 'New order has been created.', '{\"client_id\":14,\"client_name\":\"Abdul Adeyemi\"}', '2023-10-03 16:42:55', '2023-10-03 16:42:55', NULL),
(25, 16, '2023-10-03 17:43:00', 'create', 'New order has been created.', '{\"client_id\":14,\"client_name\":\"Abdul Adeyemi\"}', '2023-10-03 16:43:00', '2023-10-03 16:43:00', NULL),
(26, 17, '2023-10-03 17:43:07', 'create', 'New order has been created.', '{\"client_id\":14,\"client_name\":\"Abdul Adeyemi\"}', '2023-10-03 16:43:07', '2023-10-03 16:43:07', NULL),
(27, 18, '2023-10-07 07:44:36', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 06:44:36', '2023-10-07 06:44:36', NULL),
(28, 19, '2023-10-07 07:44:46', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 06:44:46', '2023-10-07 06:44:46', NULL),
(29, 20, '2023-10-07 07:47:16', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 06:47:16', '2023-10-07 06:47:16', NULL),
(30, 21, '2023-10-07 07:49:50', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 06:49:50', '2023-10-07 06:49:50', NULL),
(31, 22, '2023-10-07 07:52:37', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 06:52:37', '2023-10-07 06:52:37', NULL),
(32, 23, '2023-10-07 07:53:25', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 06:53:25', '2023-10-07 06:53:25', NULL),
(33, 28, '2023-10-07 07:58:59', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 06:58:59', '2023-10-07 06:58:59', NULL),
(34, 32, '2023-10-07 08:14:10', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:14:10', '2023-10-07 07:14:10', NULL),
(35, 32, '2023-10-07 08:15:59', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:15:59', '2023-10-07 07:15:59', NULL),
(36, 32, '2023-10-07 08:16:33', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:16:33', '2023-10-07 07:16:33', NULL),
(37, 32, '2023-10-07 08:21:58', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:21:58', '2023-10-07 07:21:58', NULL),
(38, 32, '2023-10-07 08:25:37', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:25:37', '2023-10-07 07:25:37', NULL),
(39, 32, '2023-10-07 08:27:50', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:27:50', '2023-10-07 07:27:50', NULL),
(40, 32, '2023-10-07 08:28:54', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:28:54', '2023-10-07 07:28:54', NULL),
(41, 32, '2023-10-07 08:29:10', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:29:10', '2023-10-07 07:29:10', NULL),
(42, 32, '2023-10-07 08:30:04', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:30:04', '2023-10-07 07:30:04', NULL),
(43, 32, '2023-10-07 08:30:16', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:30:16', '2023-10-07 07:30:16', NULL),
(44, 32, '2023-10-07 08:30:34', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:30:34', '2023-10-07 07:30:34', NULL),
(45, 32, '2023-10-07 08:30:45', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:30:45', '2023-10-07 07:30:45', NULL),
(46, 32, '2023-10-07 08:30:48', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:30:48', '2023-10-07 07:30:48', NULL),
(47, 32, '2023-10-07 08:31:41', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:31:41', '2023-10-07 07:31:41', NULL),
(48, 32, '2023-10-07 08:32:28', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:32:28', '2023-10-07 07:32:28', NULL),
(49, 32, '2023-10-07 08:32:46', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:32:46', '2023-10-07 07:32:46', NULL),
(50, 32, '2023-10-07 08:53:57', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:53:57', '2023-10-07 07:53:57', NULL),
(51, 31, '2023-10-07 08:55:33', 'cancelled', 'Order has been cancelled.', '{\"reason\":\"Delivery time is too long\",\"status\":\"cancelled\"}', '2023-10-07 07:55:33', '2023-10-07 07:55:33', NULL),
(52, 33, '2023-10-07 08:58:12', 'create', 'New order has been created.', '{\"client_id\":16,\"client_name\":\"Deepesh\"}', '2023-10-07 07:58:12', '2023-10-07 07:58:12', NULL),
(53, 35, '2023-10-07 09:02:40', 'cancelled', 'Order has been cancelled.', '{\"reason\":\"Change order\",\"status\":\"cancelled\"}', '2023-10-07 08:02:40', '2023-10-07 08:02:40', NULL),
(54, 36, '2023-10-07 09:18:29', 'cancelled', 'Order has been cancelled.', '{\"reason\":\"Change of mind\",\"status\":\"cancelled\"}', '2023-10-07 08:18:29', '2023-10-07 08:18:29', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `parcel_size_modals`
--

CREATE TABLE `parcel_size_modals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `rate` double(8,2) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `parcel_size_modals`
--

INSERT INTO `parcel_size_modals` (`id`, `name`, `rate`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Extra Small', 10.00, 1, NULL, NULL),
(2, 'Small', 20.00, 1, NULL, NULL),
(3, 'Medium', 30.00, 1, NULL, NULL),
(4, 'Large', 40.00, 1, NULL, NULL),
(5, 'Extra Large', 50.00, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `datetime` datetime DEFAULT NULL,
  `total_amount` double DEFAULT 0,
  `payment_type` varchar(255) NOT NULL,
  `txn_id` varchar(255) DEFAULT NULL,
  `payment_status` varchar(255) DEFAULT NULL COMMENT 'pending, paid, failed',
  `transaction_detail` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`transaction_detail`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `cancel_charges` double DEFAULT 0,
  `admin_commission` double DEFAULT 0,
  `delivery_man_commission` double DEFAULT 0,
  `received_by` varchar(255) DEFAULT NULL,
  `delivery_man_fee` double DEFAULT 0,
  `delivery_man_tip` double DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `client_id`, `order_id`, `datetime`, `total_amount`, `payment_type`, `txn_id`, `payment_status`, `transaction_detail`, `created_at`, `updated_at`, `deleted_at`, `cancel_charges`, `admin_commission`, `delivery_man_commission`, `received_by`, `delivery_man_fee`, `delivery_man_tip`) VALUES
(1, 16, 31, '2023-10-07 08:55:33', 186.48, 'cash', NULL, 'paid', NULL, '2023-10-07 07:55:33', '2023-10-07 07:55:33', NULL, 30, 30, 0, 'delivery_man', 0, 0),
(2, 16, 35, '2023-10-07 09:02:40', 85.68, 'cash', NULL, 'paid', NULL, '2023-10-07 08:02:40', '2023-10-07 08:02:40', NULL, 30, 30, 0, 'delivery_man', 0, 0),
(3, 16, 36, '2023-10-07 09:18:29', 131.04, 'cash', NULL, 'paid', NULL, '2023-10-07 08:18:29', '2023-10-07 08:18:29', NULL, 30, 30, 0, 'delivery_man', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `payment_gateways`
--

CREATE TABLE `payment_gateways` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1 COMMENT '0- InActive, 1- Active',
  `is_test` tinyint(4) DEFAULT 1 COMMENT '0-  No, 1- Yes',
  `test_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`test_value`)),
  `live_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`live_value`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '65d208e38f31c44cf8b3ce6b539239c243da4ead59f1ba6cb058aa8c9dc3bcbd', '[\"*\"]', '2023-08-16 07:06:45', '2023-08-16 02:33:24', '2023-08-16 07:06:45'),
(2, 'App\\Models\\User', 1, 'auth_token', '2f1b8df66307c039d4ba9e3bea1cba9384d5bde95184efcb60299fc15f89b81d', '[\"*\"]', '2023-10-02 04:54:44', '2023-08-16 07:13:14', '2023-10-02 04:54:44'),
(3, 'App\\Models\\User', 1, 'auth_token', '7092284e68d825cf36fe79d8628bce82e181c8a453fe498a86b126a125699c15', '[\"*\"]', '2023-09-15 06:33:39', '2023-09-10 09:55:31', '2023-09-15 06:33:39'),
(4, 'App\\Models\\User', 1, 'auth_token', '3b0ea635b8b7a36aa9cb28a74e756b8566503eba194974adaa97768699537773', '[\"*\"]', '2023-09-10 22:18:22', '2023-09-10 20:01:30', '2023-09-10 22:18:22'),
(5, 'App\\Models\\User', 1, 'auth_token', '8828d2766a5e3bca346b61a21de679f57fe3a4ddca38ca2228af0f618c8662f5', '[\"*\"]', '2023-10-03 17:35:50', '2023-09-10 22:19:11', '2023-10-03 17:35:50'),
(6, 'App\\Models\\User', 2, 'auth_token', '778618db7cc73e704e9f473fc9a6a521563284c065127b379af6a58f1bd3f25d', '[\"*\"]', NULL, '2023-09-13 09:44:01', '2023-09-13 09:44:01'),
(7, 'App\\Models\\User', 2, 'auth_token', '6c0b86f6f37b6cf55b3af0984dcdf6091b7e0fd0b2f89c1016c864815982e91e', '[\"*\"]', '2023-09-13 09:45:16', '2023-09-13 09:44:05', '2023-09-13 09:45:16'),
(8, 'App\\Models\\User', 2, 'auth_token', '0579d1c25425afd78af726366a764aebd50861d3a6efe4f62b68d3c92b7a6d08', '[\"*\"]', '2023-09-13 10:53:02', '2023-09-13 10:01:29', '2023-09-13 10:53:02'),
(9, 'App\\Models\\User', 2, 'auth_token', '0654d7da98311ea9e75c73c6a7b5ad38156143929f7725a3b4d0a8dd265c96ee', '[\"*\"]', '2023-09-13 10:57:43', '2023-09-13 10:53:13', '2023-09-13 10:57:43'),
(10, 'App\\Models\\User', 2, 'auth_token', '8376fe3d2c5a2bfcf0dc8f6281b85f5d1730dbad2f4e11d64412c96bb13adc93', '[\"*\"]', '2023-09-13 11:08:49', '2023-09-13 10:57:54', '2023-09-13 11:08:49'),
(11, 'App\\Models\\User', 2, 'auth_token', 'b61c5d984895067981d5cb1f2b7057f4e43333950234fa6ee343353d426d4101', '[\"*\"]', '2023-09-13 11:45:10', '2023-09-13 11:30:33', '2023-09-13 11:45:10'),
(12, 'App\\Models\\User', 3, 'auth_token', '66ef66616528c8aad104fc8f3fb02fdbab6deed7cd0f76670d56d27ce95a6d10', '[\"*\"]', NULL, '2023-09-13 11:46:04', '2023-09-13 11:46:04'),
(13, 'App\\Models\\User', 3, 'auth_token', '98da877eb39469fae9e70977ab62667bc0f8e0e9ff73bf757f218ede52b43765', '[\"*\"]', NULL, '2023-09-13 11:47:04', '2023-09-13 11:47:04'),
(14, 'App\\Models\\User', 3, 'auth_token', '4723537bb46165592d3377d7a60b104965d0fafefaf1715c5bdf8a144eba8bc0', '[\"*\"]', '2023-09-13 11:47:27', '2023-09-13 11:47:23', '2023-09-13 11:47:27'),
(15, 'App\\Models\\User', 4, 'auth_token', '85b07d66758b598c3cc7bb511416ea21dbfb27f31de285543fe8f7a5831de83f', '[\"*\"]', NULL, '2023-09-13 12:23:12', '2023-09-13 12:23:12'),
(16, 'App\\Models\\User', 4, 'auth_token', '252eb414913615dcdbcb9e3e743e194a172f0cef5bba6e08198c88f44f16e38b', '[\"*\"]', '2023-09-13 12:26:14', '2023-09-13 12:23:14', '2023-09-13 12:26:14'),
(17, 'App\\Models\\User', 2, 'auth_token', 'afb08d70193404168aa87f7f0ea0b389507de99c4b6fa37a4fca205e07cd2553', '[\"*\"]', '2023-09-13 18:33:01', '2023-09-13 12:32:45', '2023-09-13 18:33:01'),
(18, 'App\\Models\\User', 5, 'auth_token', 'a0f691d4318db7e507238eabdd8d19d17e23934b135c417e64f613e347943175', '[\"*\"]', NULL, '2023-09-13 13:01:05', '2023-09-13 13:01:05'),
(19, 'App\\Models\\User', 5, 'auth_token', '2489fabaf3d44dfb89e01f973e15fa9191690f7ee76c258828571141b8e6b48e', '[\"*\"]', '2023-09-13 13:21:51', '2023-09-13 13:01:09', '2023-09-13 13:21:51'),
(20, 'App\\Models\\User', 2, 'auth_token', 'a8ccfc5cadb46917cc22d06eac2d183c0e30bae3e065edbd07d49d232b3aa905', '[\"*\"]', '2023-09-13 13:30:55', '2023-09-13 13:23:17', '2023-09-13 13:30:55'),
(21, 'App\\Models\\User', 2, 'auth_token', 'e6a43619ba39a5dd7286f1deca7a24a0ceaae32f0c07ee135d99952314169c87', '[\"*\"]', '2023-10-06 15:28:42', '2023-09-13 18:09:11', '2023-10-06 15:28:42'),
(22, 'App\\Models\\User', 6, 'auth_token', 'a56120e24865cc29778107ebe870f192507f05eec86416c734479409338f7dca', '[\"*\"]', NULL, '2023-09-13 18:36:31', '2023-09-13 18:36:31'),
(23, 'App\\Models\\User', 2, 'auth_token', 'b5a248969b0ed0f63cc5400719f45659808dc301bb2a833aa30e83eab64f7c76', '[\"*\"]', '2023-09-14 06:08:37', '2023-09-13 18:36:47', '2023-09-14 06:08:37'),
(24, 'App\\Models\\User', 1, 'auth_token', '034aea5bb5b46e3258be55e948de12c22cade5672edf6590c96a404731ae6900', '[\"*\"]', NULL, '2023-09-14 06:07:16', '2023-09-14 06:07:16'),
(25, 'App\\Models\\User', 1, 'auth_token', 'eb376fba554ca024f703b383b730dd9feecc75eed013072f999d84f156914049', '[\"*\"]', '2023-09-14 07:02:27', '2023-09-14 06:07:16', '2023-09-14 07:02:27'),
(26, 'App\\Models\\User', 7, 'auth_token', 'b4e0e765516e6d95d3804fb205edff8c40ba0c7b0aa3403b0de8b0d8474ecbbe', '[\"*\"]', NULL, '2023-09-14 06:12:35', '2023-09-14 06:12:35'),
(27, 'App\\Models\\User', 7, 'auth_token', '8aa6c17dd0e1f3190a57ff77fb3ea1edcf8296087e68e82d1d53c9c01c936eac', '[\"*\"]', '2023-09-14 06:14:07', '2023-09-14 06:12:58', '2023-09-14 06:14:07'),
(28, 'App\\Models\\User', 7, 'auth_token', 'a06bfc719db2ef1d52dbc71e92139d97de98c9ee25ca470937817cfa16e7343a', '[\"*\"]', '2023-09-14 06:14:13', '2023-09-14 06:14:12', '2023-09-14 06:14:13'),
(29, 'App\\Models\\User', 6, 'auth_token', 'fa74c801c9b1061930aa634c32d29b13a35a97ed8b35f2bed0a729775854010f', '[\"*\"]', '2023-09-14 19:36:14', '2023-09-14 06:21:28', '2023-09-14 19:36:14'),
(30, 'App\\Models\\User', 8, 'auth_token', '98fb143a5801b8ed6dd724bb3d1e8a2d98eb0316ed8acc28919ac4719890a30c', '[\"*\"]', NULL, '2023-09-14 10:48:41', '2023-09-14 10:48:41'),
(31, 'App\\Models\\User', 8, 'auth_token', 'bd3725502f4b9554b687987b5d53d767dc0ddba7511b59d26cc1a67785c7faab', '[\"*\"]', '2023-09-14 22:07:35', '2023-09-14 10:48:43', '2023-09-14 22:07:35'),
(32, 'App\\Models\\User', 8, 'auth_token', '228fdfb039d78cbf9e33df062dade78d56008ae0bcfb2ca437b968421c5cb43b', '[\"*\"]', '2023-09-26 15:45:21', '2023-09-14 22:10:28', '2023-09-26 15:45:21'),
(33, 'App\\Models\\User', 6, 'auth_token', '60ea1eaaf75df6b47472c66c09e29135fbb5610709a06d84b63c55d9d05ad782', '[\"*\"]', '2023-09-15 14:00:35', '2023-09-15 13:19:55', '2023-09-15 14:00:35'),
(34, 'App\\Models\\User', 6, 'auth_token', '3b078efcce6b13dae7f7cece523e5ad5cb74d74e6b9ec33e8a21ae6764193137', '[\"*\"]', '2023-09-26 15:49:07', '2023-09-22 14:41:38', '2023-09-26 15:49:07'),
(35, 'App\\Models\\User', 8, 'auth_token', 'c52dac59afba412f2890326ecc5b8de46377b0f4e377c53ff424738bb2cdc772', '[\"*\"]', '2023-09-26 16:36:23', '2023-09-26 15:47:07', '2023-09-26 16:36:23'),
(36, 'App\\Models\\User', 9, 'auth_token', 'adc5f6a2274f1d24282ee0f0b424ba63226abca46bcf585400fcf86640407b1e', '[\"*\"]', NULL, '2023-09-29 05:35:48', '2023-09-29 05:35:48'),
(37, 'App\\Models\\User', 9, 'auth_token', 'e0e18912a8882fe0ee0fd8754ee39778b2a33d28440c77c964468c26788077cf', '[\"*\"]', '2023-09-29 05:36:58', '2023-09-29 05:35:53', '2023-09-29 05:36:58'),
(38, 'App\\Models\\User', 10, 'auth_token', 'f8abb7d4777920560227866fbb32c06ea07de146d6cee13800f7864cf21951b0', '[\"*\"]', NULL, '2023-09-29 05:38:04', '2023-09-29 05:38:04'),
(39, 'App\\Models\\User', 10, 'auth_token', '54354db5ef0f4eb838605ad0f89a83a2eb2ff2f28fdd0f5c442919d9220925de', '[\"*\"]', '2023-09-29 05:38:40', '2023-09-29 05:38:08', '2023-09-29 05:38:40'),
(40, 'App\\Models\\User', 11, 'auth_token', '1dc4ca2109c6b39dedfe73f9ef326726b4f540cf0a1cc9a9418181cf7881f870', '[\"*\"]', NULL, '2023-09-29 05:40:48', '2023-09-29 05:40:48'),
(41, 'App\\Models\\User', 11, 'auth_token', 'd88853d85f8dfe1bd1c0a56d1e795525aed645b490588ab305d8bc1b73d782cc', '[\"*\"]', NULL, '2023-09-29 05:41:28', '2023-09-29 05:41:28'),
(42, 'App\\Models\\User', 12, 'auth_token', '4f17535aa7a127fd798705c5268458480819a1c02ed0ddd20805c5da86df5255', '[\"*\"]', NULL, '2023-09-29 05:42:32', '2023-09-29 05:42:32'),
(43, 'App\\Models\\User', 12, 'auth_token', '6184417f7ed3b994803cd15137b9548a2d02eced674e59ba34fdff6f3df12340', '[\"*\"]', '2023-09-29 05:44:00', '2023-09-29 05:42:35', '2023-09-29 05:44:00'),
(44, 'App\\Models\\User', 12, 'auth_token', '62d7711aa866242dfdff630aad17a8b621b2fa9baf6ce3e1db8667fba8b5f11e', '[\"*\"]', '2023-09-29 06:19:20', '2023-09-29 05:55:57', '2023-09-29 06:19:20'),
(45, 'App\\Models\\User', 13, 'auth_token', '50d0c4d0c7214f75d731e137cfb47d4bdbad58685d00c67f109119d9feb54b0c', '[\"*\"]', NULL, '2023-09-29 06:20:01', '2023-09-29 06:20:01'),
(46, 'App\\Models\\User', 13, 'auth_token', '014ee511074d11950c509516829b735e65d4cea8ae43789f9180ff68da406522', '[\"*\"]', '2023-09-29 09:52:44', '2023-09-29 06:20:04', '2023-09-29 09:52:44'),
(47, 'App\\Models\\User', 13, 'auth_token', 'fab58ec5e63ad0440463f1c725ac6075aa2a676ae5b592db5b930306517b57d9', '[\"*\"]', '2023-09-29 10:00:20', '2023-09-29 09:52:50', '2023-09-29 10:00:20'),
(48, 'App\\Models\\User', 13, 'auth_token', 'd0b9f066b13ae2bdb9fe5ddcbba0584f8525352db03927459eb36a3397f1f6cb', '[\"*\"]', '2023-09-29 10:01:11', '2023-09-29 10:00:25', '2023-09-29 10:01:11'),
(49, 'App\\Models\\User', 13, 'auth_token', '23bfe46943cc9e8f742b029554de074620f03dbe6379cd894bd60c1cad08aa9c', '[\"*\"]', '2023-09-29 10:04:06', '2023-09-29 10:02:52', '2023-09-29 10:04:06'),
(50, 'App\\Models\\User', 13, 'auth_token', '7b5d888fc5aec784812164761caa901700ae480764c2df7de5f97d0832d21032', '[\"*\"]', '2023-09-29 10:04:47', '2023-09-29 10:04:10', '2023-09-29 10:04:47'),
(51, 'App\\Models\\User', 13, 'auth_token', '49c4f3d313c0c56a6a0599eaa207cd566929cf939fc686ac086f378b12425ac3', '[\"*\"]', '2023-09-29 10:11:11', '2023-09-29 10:04:57', '2023-09-29 10:11:11'),
(52, 'App\\Models\\User', 13, 'auth_token', '9d8a206d8e15e30e6b53525dc4075ed8a85af770d71d85c829574e408ef967f9', '[\"*\"]', '2023-09-29 10:12:39', '2023-09-29 10:11:15', '2023-09-29 10:12:39'),
(53, 'App\\Models\\User', 13, 'auth_token', '3004ba4d9acd4ebfdbcc81b71cde2711da3105980f4cd9249124534cbf080b43', '[\"*\"]', '2023-09-29 10:16:52', '2023-09-29 10:15:01', '2023-09-29 10:16:52'),
(54, 'App\\Models\\User', 13, 'auth_token', '2d4544c5c910340a9a2d43099f378f6446731c8cdb0dd85121b4be6a791907ac', '[\"*\"]', '2023-09-29 10:18:55', '2023-09-29 10:18:52', '2023-09-29 10:18:55'),
(55, 'App\\Models\\User', 13, 'auth_token', '736386ff257cbda04d1f38300d56f84cb1f615450ef8586b271b4f32cb0fe89c', '[\"*\"]', '2023-09-29 10:19:48', '2023-09-29 10:19:46', '2023-09-29 10:19:48'),
(56, 'App\\Models\\User', 13, 'auth_token', '8e98f6a4925a7d38d319127d7ea2e781cb11b175dfe01009eb752ac3c013098d', '[\"*\"]', '2023-09-29 10:30:50', '2023-09-29 10:30:47', '2023-09-29 10:30:50'),
(57, 'App\\Models\\User', 13, 'auth_token', '08726abfb03f94cb3a137ec5fa83a50d03fa63c9e2741ed15493f1872487445f', '[\"*\"]', '2023-10-02 04:36:08', '2023-09-29 11:10:24', '2023-10-02 04:36:08'),
(58, 'App\\Models\\User', 14, 'auth_token', '16dfc3832d09129a6119af31f0f18b8bccef73821dafbd349c8bfebde3ad900d', '[\"*\"]', NULL, '2023-09-29 20:13:58', '2023-09-29 20:13:58'),
(59, 'App\\Models\\User', 14, 'auth_token', '8e6ee2b30be60d61a0cadc313f56ac7ca183204898ce578e428c1fe6f08c2d3a', '[\"*\"]', '2023-09-29 20:14:59', '2023-09-29 20:14:32', '2023-09-29 20:14:59'),
(60, 'App\\Models\\User', 14, 'auth_token', '3d95ab678415057454899a28c0698240154e2aa5eb5eba3e5a8d9ad2692114af', '[\"*\"]', '2023-09-29 20:18:26', '2023-09-29 20:15:03', '2023-09-29 20:18:26'),
(61, 'App\\Models\\User', 14, 'auth_token', '8f75b101bb39f5285fa140d0d2d4ca5e06ee75a12d87d3ffcec84fa07f5f434f', '[\"*\"]', '2023-09-29 20:18:50', '2023-09-29 20:18:50', '2023-09-29 20:18:50'),
(62, 'App\\Models\\User', 14, 'auth_token', 'd59d0c4c44550b6fef1442430bc9dcd7bb47288f95689d656030cbce694a0910', '[\"*\"]', '2023-10-06 16:10:26', '2023-09-29 20:19:29', '2023-10-06 16:10:26'),
(63, 'App\\Models\\User', 13, 'auth_token', '5d709e07431970479af6953fa0325fa65b290ccc141f43099eacf098fc954af6', '[\"*\"]', '2023-10-02 04:38:01', '2023-10-02 04:37:18', '2023-10-02 04:38:01'),
(64, 'App\\Models\\User', 13, 'auth_token', '55d0268ccdb08a266af945983140dcebedadd44a266a51cb6b6eae63df6dbce0', '[\"*\"]', NULL, '2023-10-02 04:38:01', '2023-10-02 04:38:01'),
(65, 'App\\Models\\User', 13, 'auth_token', '2b085fa35e89282f34715db40c6401539576baf7010d7f838488c595584fd738', '[\"*\"]', '2023-10-02 04:50:32', '2023-10-02 04:38:02', '2023-10-02 04:50:32'),
(66, 'App\\Models\\User', 1, 'auth_token', 'ca1d9db7d7f0d6302b514b6d59b5fee1c1d34858e510c2fa1907ae7062d36f08', '[\"*\"]', '2023-10-02 04:57:30', '2023-10-02 04:55:07', '2023-10-02 04:57:30'),
(67, 'App\\Models\\User', 2, 'auth_token', '8c2c6dfe9c70d4433bb64dce0b4412a4b5354ba9acfbf11cb2c4a789bfe14bf6', '[\"*\"]', '2023-10-02 04:57:49', '2023-10-02 04:57:43', '2023-10-02 04:57:49'),
(68, 'App\\Models\\User', 3, 'auth_token', '1b414eb120c312cb8a3ebaf9489505b836dddbcaa247eec8f4b7ab155731aa3b', '[\"*\"]', '2023-10-02 04:58:48', '2023-10-02 04:58:43', '2023-10-02 04:58:48'),
(69, 'App\\Models\\User', 15, 'auth_token', 'baddb07c908f1ea6545141c09ce45b9efa509dce5ca79a7fb55ab7b7b5e43536', '[\"*\"]', NULL, '2023-10-07 06:10:26', '2023-10-07 06:10:26'),
(70, 'App\\Models\\User', 15, 'auth_token', '875bb81189a9d3771743b36caab1807b9a77a35ef7de85f86f3565f57b56980c', '[\"*\"]', NULL, '2023-10-07 06:10:34', '2023-10-07 06:10:34'),
(71, 'App\\Models\\User', 16, 'auth_token', '644b3b5df280bacc5c67f262826d90ed48caea36d44926773cff1e3bb12b42bb', '[\"*\"]', NULL, '2023-10-07 06:12:16', '2023-10-07 06:12:16'),
(72, 'App\\Models\\User', 16, 'auth_token', '48b824dc8d0df73e2f26ff94549250ab80f2d8c73856027409750c4fdba48830', '[\"*\"]', '2023-10-07 08:18:42', '2023-10-07 06:12:19', '2023-10-07 08:18:42'),
(73, 'App\\Models\\User', 16, 'auth_token', '056442903b9e80040cfce45c9edcb5c3df2fb61d2af90527c449e8b70504dd37', '[\"*\"]', '2023-10-07 09:42:18', '2023-10-07 09:39:16', '2023-10-07 09:42:18');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` text NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('6cwc9qYSJjp0GGGamqJuL93uD649EIrbjGXvxPMH', NULL, '165.227.145.172', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZkhvOWZXS2lMZFpraWdUOERoemZRS3Q2RUMwQk5VMlliQWlMdHFaaSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjk6Imh0dHBzOi8vYmFja2VuZC5nb2dvcmlkZXJzLm5nIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1696241613),
('9wUbxkJZYGgBqbRCJ8zG0kHhLxKLev4zxAYLK2Bg', NULL, '165.227.145.172', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibG8zakU2ZUtTYWxzUE1sYkZVY2ZiZ0hlWHVQYjZrUXpHSWpaNVRtTSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjg6Imh0dHA6Ly9iYWNrZW5kLmdvZ29yaWRlcnMubmciO31zOjY6Il9mbGFzaCI7YToyOntzOjM6Im9sZCI7YTowOnt9czozOiJuZXciO2E6MDp7fX19', 1696241613),
('CMBa0PsnsaFJdp3NaEBKGZqAe822FpYbsjkBcSoj', NULL, '127.0.0.1', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoicVREcm9Rb2R6UkYzRE5sUkhESjBtaGNlakwzVXlEOHpuRFpYRW5IbCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1696675755),
('MmbN5PbzQoTn53EFlc8GEMN7z62iI0Fqbn4Z2HV9', NULL, '3.250.234.150', 'Mozilla/5.0 (compatible; NetcraftSurveyAgent/1.0; +info@netcraft.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVzNyUk1yRXFQZHkzZFRtNmd2cFFCOEFOanc5cWxYVzIzVjJYZUJZdyI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MzM6Imh0dHBzOi8vd3d3LmJhY2tlbmQuZ29nb3JpZGVycy5uZyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1696522254),
('rZgmKJsXiXJ6qYJpIi097ot8pBqJIfKadAAsNH2P', NULL, '34.245.231.191', 'Mozilla/5.0 (compatible; NetcraftSurveyAgent/1.0; +info@netcraft.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWmpwaWtMUnRSNk1jaHdhSmthTDNmeTY2Z3BNTDE2WmZSOE92NnpJQiI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjk6Imh0dHBzOi8vYmFja2VuZC5nb2dvcmlkZXJzLm5nIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1696516771);

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `key` varchar(255) DEFAULT NULL,
  `value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `type`, `key`, `value`) VALUES
(1, 'order_invoice', 'company_name', 'GOGO Riders'),
(2, 'order_invoice', 'company_contact_number', '+234 809 066 8144'),
(3, 'order_invoice', 'company_address', 'Block 235 flat 2 jakande housing Estate oke-afa isolo lagos');

-- --------------------------------------------------------

--
-- Table structure for table `static_data`
--

CREATE TABLE `static_data` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `static_data`
--

INSERT INTO `static_data` (`id`, `type`, `label`, `value`, `created_at`, `updated_at`) VALUES
(1, 'parcel_type', 'Cakes', 'cakes', '2023-09-10 10:04:00', '2023-09-10 10:04:32'),
(2, 'parcel_type', 'Documents', 'documents', '2023-09-10 10:04:12', '2023-09-10 10:04:12'),
(3, 'parcel_type', 'Flowers', 'flowers', '2023-09-10 10:04:21', '2023-09-10 10:04:21'),
(4, 'parcel_type', 'Foods', 'foods', '2023-09-10 10:04:27', '2023-09-10 10:04:27'),
(5, 'parcel_type', 'Gifts', 'gifts', '2023-09-10 10:04:39', '2023-09-10 10:04:39'),
(6, 'parcel_type', 'Electronics', 'electronics', '2023-09-10 10:04:55', '2023-09-10 10:04:55'),
(7, 'parcel_type', 'Other', 'other', '2023-09-10 10:05:07', '2023-09-10 10:05:07');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `two_factor_secret` text DEFAULT NULL,
  `two_factor_recovery_codes` text DEFAULT NULL,
  `address` text DEFAULT NULL,
  `contact_number` varchar(255) DEFAULT NULL,
  `user_type` varchar(255) DEFAULT NULL,
  `country_id` bigint(20) UNSIGNED DEFAULT NULL,
  `city_id` bigint(20) UNSIGNED DEFAULT NULL,
  `player_id` varchar(255) DEFAULT NULL,
  `latitude` varchar(255) DEFAULT NULL,
  `longitude` varchar(255) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `last_notification_seen` timestamp NULL DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `uid` varchar(255) DEFAULT NULL,
  `fcm_token` text DEFAULT NULL,
  `current_team_id` bigint(20) UNSIGNED DEFAULT NULL,
  `profile_photo_path` varchar(2048) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `otp_verify_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `username`, `email_verified_at`, `password`, `two_factor_secret`, `two_factor_recovery_codes`, `address`, `contact_number`, `user_type`, `country_id`, `city_id`, `player_id`, `latitude`, `longitude`, `remember_token`, `last_notification_seen`, `status`, `uid`, `fcm_token`, `current_team_id`, `profile_photo_path`, `created_at`, `updated_at`, `deleted_at`, `otp_verify_at`) VALUES
(1, 'Admin', 'admin@admin.com', 'admin', NULL, '$2y$10$Xs1thuO7saWNy1qQjmGv2O9XcS4GWwN03v6mrlFSz1WYoPwLJ90tK', NULL, NULL, NULL, '+91 9876543210', 'admin', NULL, NULL, NULL, NULL, NULL, 'dlSUAa9gOswacYpzBHCu93FBiSEyp1E4NfIqXsmgapLc4oQ1U7nkIp4odSCL', '2023-09-14 09:58:05', 1, NULL, NULL, NULL, NULL, '2023-08-12 01:08:37', '2023-09-14 09:58:05', NULL, NULL),
(2, 'Admin', 'admin1@admin.com', 'admin1', NULL, '$2y$10$Xs1thuO7saWNy1qQjmGv2O9XcS4GWwN03v6mrlFSz1WYoPwLJ90tK', NULL, NULL, NULL, '+91 7004920897', 'admin', 1, 1, NULL, NULL, NULL, NULL, '2023-09-15 05:13:16', 1, '03tPhstxi7PvnLB7aL37U21zXk82', NULL, NULL, NULL, '2023-09-13 09:44:01', '2023-09-15 05:13:16', NULL, '2023-09-13 09:44:27'),
(3, 'Admin', 'admin2@admin.com', 'admin2', NULL, '$2y$10$Xs1thuO7saWNy1qQjmGv2O9XcS4GWwN03v6mrlFSz1WYoPwLJ90tK', NULL, NULL, NULL, '+91 1234567890', 'admin', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, '2023-09-13 11:46:04', '2023-09-13 11:47:27', NULL, NULL),
(4, 'Abdul Adeyemi', 'abdule@gmail.com', 'bbgnfb', NULL, '$2y$10$UxZa.hgL1tCAcac3d27zwu0rNWMqEGhuklt9VcC.UuMmaOfNkvVRW', NULL, NULL, NULL, '+44 7949907675', 'client', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, '03tPhstxi7PvnLB7aL37U21zXk82', NULL, NULL, NULL, '2023-09-13 12:23:12', '2023-09-13 12:23:23', NULL, NULL),
(5, 'Nofisat Omotola', 'nosimade7@gmail.com', 'Monof94', NULL, '$2y$10$eSNfdb7qlq3w.WMvPOJHNu4mBq/L.A3mf0WYrAtARAog.x1J9vXnK', NULL, NULL, NULL, '+234 09122301053', 'client', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 'wfxDT7nFisenogZMd58BHZNQ6Mp1', NULL, NULL, NULL, '2023-09-13 13:01:05', '2023-09-13 13:01:57', NULL, NULL),
(6, 'Ad Gjgg', 'Abb@gmail.com', 'ydhg', NULL, '$2y$10$nsSXNxbeleRxIyJGjg5s.OiEV/5Nbf5BPBLfMeilK0W0kKGIzkrJe', NULL, NULL, NULL, '+44 7419707975', 'delivery_man', 1, 1, NULL, '51.4692461', '-0.361392', NULL, '2023-09-14 06:26:20', 1, 'VIgNbMu9LvWKgcmR8osz4HSZA4o1', NULL, NULL, NULL, '2023-09-13 18:36:31', '2023-09-15 14:00:33', NULL, '2023-09-14 07:24:26'),
(8, 'Account@royalherbal.co.uk', 'account@royalherbal.co.uk', 'hhh', NULL, '$2y$10$VfNpIzanCn9gAZIIdZS.n.kKCZacnHR306sY3VBByc.A.lmuwD10S', NULL, NULL, NULL, '+44 7448346706', 'client', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 'RQk42sTYMYUAk6r55Ft95e5BnnD3', NULL, NULL, NULL, '2023-09-14 10:48:41', '2023-09-29 20:18:41', '2023-09-29 20:18:41', '2023-09-14 11:50:10'),
(10, 'Duhdh', 'dede@gmail.com', '+91 5555555555', NULL, '$2y$10$5szLCY1fyzslv9exOm6xrubzdv.esbpBDnaLuhH3j9DUeonjw.JqG', NULL, NULL, NULL, '+91 5858568569', 'client', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 'FVWYhb5w2pa9cP8v9bFto68RYF53', NULL, NULL, NULL, '2023-09-29 05:38:04', '2023-09-29 05:38:25', NULL, NULL),
(11, 'Rest', 'test@gmail.com', '+91 5858585858', NULL, '$2y$10$QotCSo8ZosHH4659EPfIfuz.nqafAxJCCYDofXXk9HxTR1/3fVW1G', NULL, NULL, NULL, '+91 5858585858', 'delivery_man', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, '2023-09-29 05:40:48', '2023-09-29 05:40:48', NULL, NULL),
(12, 'Test User', 'asdf@gmail.com', '+91 2580258025', NULL, '$2y$10$Ig2coFAGGxAwM2NWV.mpD.d2sl.2a/NFtOgLWVqJDJ8fRQy0lORPW', NULL, NULL, NULL, '+91 2580258025', 'client', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 'RxS2HTX8fIcazfcocucm0mmPt8i1', NULL, NULL, NULL, '2023-09-29 05:42:32', '2023-09-29 05:42:41', NULL, NULL),
(13, 'Dggg', 'dedede@gmail.com', '+254 9098987898', NULL, '$2y$10$0rANczAaSlI8Tr5u1Pu1L.8XhlDOEVZC4dX2LGRoa1otVyEv9/Yi6', NULL, NULL, NULL, '+254 9098987898', 'client', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 'ITl0BsKBYwXp1cncdwsp9Lv4qZA2', NULL, NULL, NULL, '2023-09-29 06:20:01', '2023-09-29 11:10:20', NULL, NULL),
(14, 'Abdul Adeyemi', 'abd@gmail.com', '+44 7448346706', NULL, '$2y$10$NKlBDcf64T8gdBk/awDfkekKbe6ZNbm4nSQw/I5vgcXRDgNLUEefe', NULL, NULL, NULL, '+44 7448346706', 'client', 1, 1, NULL, NULL, NULL, NULL, '2023-09-29 20:20:44', 1, NULL, NULL, NULL, NULL, '2023-09-29 20:13:58', '2023-09-29 20:20:44', NULL, '2023-09-29 21:20:05'),
(16, 'Deepesh', 'deepeshinfo22@gmail.com', '+234 7004920897', NULL, '$2y$10$B7qE8gj6VJi9Dl3pDxafHurHmMItP9yE/LIyMIY3o2..PSsqlrM7y', NULL, NULL, NULL, '+234 7004920897', 'client', 1, 1, NULL, NULL, NULL, NULL, NULL, 1, 'ZNccSnUSTfQZ20VgkTm8RiWXOMM2', NULL, NULL, NULL, '2023-10-07 06:12:16', '2023-10-07 06:12:25', NULL, '2023-09-29 21:20:05');

-- --------------------------------------------------------

--
-- Table structure for table `user_bank_accounts`
--

CREATE TABLE `user_bank_accounts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `bank_code` varchar(255) DEFAULT NULL,
  `account_holder_name` varchar(255) DEFAULT NULL,
  `account_number` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL COMMENT 'all,city_wise',
  `size` varchar(255) DEFAULT NULL,
  `city_ids` text DEFAULT NULL,
  `capacity` varchar(255) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`id`, `title`, `type`, `size`, `city_ids`, `capacity`, `status`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Bike', 'all', '2', '[ \"1\"]', '2', 1, 'Bike', '2023-09-10 09:59:50', '2023-09-10 09:59:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `wallets`
--

CREATE TABLE `wallets` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `total_amount` double DEFAULT 0,
  `online_received` double DEFAULT 0,
  `collected_cash` double DEFAULT 0,
  `manual_received` double DEFAULT 0,
  `total_withdrawn` double DEFAULT 0,
  `currency` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wallets`
--

INSERT INTO `wallets` (`id`, `user_id`, `total_amount`, `online_received`, `collected_cash`, `manual_received`, `total_withdrawn`, `currency`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 16, 940, 1000, 0, 0, 0, NULL, '2023-10-07 07:55:33', '2023-10-07 08:18:29', NULL),
(2, 1, 90, 0, 0, 0, 0, NULL, '2023-10-07 07:55:33', '2023-10-07 08:18:29', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `wallet_histories`
--

CREATE TABLE `wallet_histories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL COMMENT 'credit,debit',
  `transaction_type` varchar(255) DEFAULT NULL COMMENT 'topup,withdraw,order_fee,admin_commision,correction',
  `currency` varchar(255) DEFAULT NULL,
  `amount` double DEFAULT 0,
  `balance` double DEFAULT 0,
  `datetime` datetime DEFAULT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `description` text DEFAULT NULL,
  `data` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wallet_histories`
--

INSERT INTO `wallet_histories` (`id`, `user_id`, `type`, `transaction_type`, `currency`, `amount`, `balance`, `datetime`, `order_id`, `description`, `data`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 16, 'debit', 'order_cancel_charge', 'ngn', 30, -30, '2023-10-07 08:55:33', 31, NULL, '{\"payment_id\":1,\"cancel_charges\":30,\"order_history\":0}', '2023-10-07 07:55:33', '2023-10-07 07:55:33', NULL),
(2, 1, 'credit', 'commission', 'ngn', 30, 30, '2023-10-07 08:55:33', 31, NULL, '{\"payment_id\":1,\"order_history\":0,\"admin_commission\":30}', '2023-10-07 07:55:33', '2023-10-07 07:55:33', NULL),
(3, 16, 'debit', 'order_cancel_charge', 'ngn', 30, 970, '2023-10-07 09:02:40', 35, NULL, '{\"payment_id\":2,\"cancel_charges\":30,\"order_history\":0}', '2023-10-07 08:02:40', '2023-10-07 08:02:40', NULL),
(4, 1, 'credit', 'commission', 'ngn', 30, 60, '2023-10-07 09:02:40', 35, NULL, '{\"payment_id\":2,\"order_history\":0,\"admin_commission\":30}', '2023-10-07 08:02:40', '2023-10-07 08:02:40', NULL),
(5, 16, 'debit', 'order_cancel_charge', 'ngn', 30, 940, '2023-10-07 09:18:29', 36, NULL, '{\"payment_id\":3,\"cancel_charges\":30,\"order_history\":0}', '2023-10-07 08:18:29', '2023-10-07 08:18:29', NULL),
(6, 1, 'credit', 'commission', 'ngn', 30, 90, '2023-10-07 09:18:29', 36, NULL, '{\"payment_id\":3,\"order_history\":0,\"admin_commission\":30}', '2023-10-07 08:18:29', '2023-10-07 08:18:29', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `withdraw_requests`
--

CREATE TABLE `withdraw_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `amount` double DEFAULT 0,
  `currency` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT 'requested' COMMENT 'requested,approved,decline',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `app_settings`
--
ALTER TABLE `app_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `delivery_man_documents`
--
ALTER TABLE `delivery_man_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `delivery_man_documents_document_id_foreign` (`document_id`),
  ADD KEY `delivery_man_documents_delivery_man_id_foreign` (`delivery_man_id`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `extra_charges`
--
ALTER TABLE `extra_charges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `media_uuid_unique` (`uuid`),
  ADD KEY `media_model_type_model_id_index` (`model_type`,`model_id`),
  ADD KEY `media_order_column_index` (`order_column`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_client_id_foreign` (`client_id`);

--
-- Indexes for table `order_histories`
--
ALTER TABLE `order_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_histories_order_id_foreign` (`order_id`);

--
-- Indexes for table `parcel_size_modals`
--
ALTER TABLE `parcel_size_modals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `payments_client_id_foreign` (`client_id`),
  ADD KEY `payments_order_id_foreign` (`order_id`);

--
-- Indexes for table `payment_gateways`
--
ALTER TABLE `payment_gateways`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `static_data`
--
ALTER TABLE `static_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD UNIQUE KEY `users_username_unique` (`username`);

--
-- Indexes for table `user_bank_accounts`
--
ALTER TABLE `user_bank_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_bank_accounts_user_id_foreign` (`user_id`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `wallets`
--
ALTER TABLE `wallets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wallets_user_id_foreign` (`user_id`);

--
-- Indexes for table `wallet_histories`
--
ALTER TABLE `wallet_histories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wallet_histories_user_id_foreign` (`user_id`),
  ADD KEY `wallet_histories_order_id_foreign` (`order_id`);

--
-- Indexes for table `withdraw_requests`
--
ALTER TABLE `withdraw_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `withdraw_requests_user_id_foreign` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `app_settings`
--
ALTER TABLE `app_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cities`
--
ALTER TABLE `cities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `delivery_man_documents`
--
ALTER TABLE `delivery_man_documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `documents`
--
ALTER TABLE `documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `extra_charges`
--
ALTER TABLE `extra_charges`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `media`
--
ALTER TABLE `media`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `order_histories`
--
ALTER TABLE `order_histories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `parcel_size_modals`
--
ALTER TABLE `parcel_size_modals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payment_gateways`
--
ALTER TABLE `payment_gateways`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `static_data`
--
ALTER TABLE `static_data`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `user_bank_accounts`
--
ALTER TABLE `user_bank_accounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `wallets`
--
ALTER TABLE `wallets`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `wallet_histories`
--
ALTER TABLE `wallet_histories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `withdraw_requests`
--
ALTER TABLE `withdraw_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `delivery_man_documents`
--
ALTER TABLE `delivery_man_documents`
  ADD CONSTRAINT `delivery_man_documents_delivery_man_id_foreign` FOREIGN KEY (`delivery_man_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `delivery_man_documents_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_histories`
--
ALTER TABLE `order_histories`
  ADD CONSTRAINT `order_histories_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_bank_accounts`
--
ALTER TABLE `user_bank_accounts`
  ADD CONSTRAINT `user_bank_accounts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wallets`
--
ALTER TABLE `wallets`
  ADD CONSTRAINT `wallets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `wallet_histories`
--
ALTER TABLE `wallet_histories`
  ADD CONSTRAINT `wallet_histories_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wallet_histories_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `withdraw_requests`
--
ALTER TABLE `withdraw_requests`
  ADD CONSTRAINT `withdraw_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

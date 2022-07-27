-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: db
-- Время создания: Июл 27 2022 г., 14:55
-- Версия сервера: 10.7.3-MariaDB-1:10.7.3+maria~focal
-- Версия PHP: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `bras`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`%` PROCEDURE `doWhile` ()   BEGIN
DECLARE i INT DEFAULT 1; 
WHILE (i <= 1000) DO
    INSERT INTO `users` (`user`, `service`, `password`, `ip_static`, `ul_shape`, `dl_shape`, `interface`, `rx_bytes`, `tx_bytes`, `rx_bps`, `tx_bps`, `lastCreatedSession`, `lastClosedSession`, `lastIp`, `lastMac`, `active`, `nat`, `kickFromSession`) VALUES (i, '*', '123456', '*', '2048', '2048', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1', '1', '0'); 
    SET i = i+1;
END WHILE;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `history_auth`
--

CREATE TABLE `history_auth` (
  `id` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `time` datetime NOT NULL DEFAULT current_timestamp(),
  `type` text NOT NULL,
  `ip` text NOT NULL,
  `mac` text NOT NULL,
  `interface` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `traffic`
--

CREATE TABLE `traffic` (
  `id` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `rx_bytes` bigint(20) NOT NULL,
  `tx_bytes` bigint(20) NOT NULL,
  `time` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `user` varchar(255) NOT NULL,
  `service` text NOT NULL DEFAULT '*',
  `password` int(11) NOT NULL,
  `ip_static` text NOT NULL DEFAULT '*',
  `ul_shape` int(11) NOT NULL,
  `dl_shape` int(11) NOT NULL,
  `interface` varchar(255) DEFAULT NULL,
  `rx_bytes` bigint(20) DEFAULT NULL,
  `tx_bytes` bigint(20) DEFAULT NULL,
  `rx_bps` bigint(20) DEFAULT NULL,
  `tx_bps` bigint(20) DEFAULT NULL,
  `lastCreatedSession` datetime DEFAULT NULL,
  `lastClosedSession` datetime DEFAULT NULL,
  `lastIp` text DEFAULT NULL,
  `lastMac` text DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `nat` tinyint(1) NOT NULL DEFAULT 1,
  `kickFromSession` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `history_auth`
--
ALTER TABLE `history_auth`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user` (`user`);

--
-- Индексы таблицы `traffic`
--
ALTER TABLE `traffic`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user` (`user`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`user`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `history_auth`
--
ALTER TABLE `history_auth`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `traffic`
--
ALTER TABLE `traffic`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `history_auth`
--
ALTER TABLE `history_auth`
  ADD CONSTRAINT `history_auth_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`user`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `traffic`
--
ALTER TABLE `traffic`
  ADD CONSTRAINT `traffic_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`user`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

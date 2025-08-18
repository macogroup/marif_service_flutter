-- phpMyAdmin SQL Dump
-- version 5.1.2
-- https://www.phpmyadmin.net/
--
-- Хост: localhost:3306
-- Время создания: Авг 18 2025 г., 04:56
-- Версия сервера: 5.7.24
-- Версия PHP: 8.3.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `app_anime`
--

-- --------------------------------------------------------

--
-- Структура таблицы `charact`
--

CREATE TABLE `charact` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `age` int(11) NOT NULL,
  `description` text NOT NULL,
  `avatar_url` varchar(2000) NOT NULL,
  `cost` int(11) NOT NULL,
  `likes_count` int(11) NOT NULL,
  `tag` json NOT NULL,
  `recom` enum('male','female','unisex') NOT NULL,
  `backstory` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `charact`
--

INSERT INTO `charact` (`id`, `name`, `age`, `description`, `avatar_url`, `cost`, `likes_count`, `tag`, `recom`, `backstory`) VALUES
(1, 'kito', 3, 'string', 'https://sdmntpritalynorth.oaiusercontent.com/files/00000000-ff78-6246-a4fe-9c8c66054a76/raw?se=2025-08-18T01%3A39%3A05Z&sp=r&sv=2024-08-04&sr=b&scid=c80c01e0-73fa-5e49-9ac4-6101d1275918&skoid=9ccea605-1409-4478-82eb-9c83b25dc1b0&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-08-17T22%3A48%3A49Z&ske=2025-08-18T22%3A48%3A49Z&sks=b&skv=2024-08-04&sig=SYfeqeaQvYufRLPMkEijmsR5xW/mOD6ygSFPFhHoMTw%3D', 38, 23, '\"[\\\"kiro\\\"]\"', 'male', 'string'),
(2, 'kito', 3, 'string', 'https://sdmntpritalynorth.oaiusercontent.com/files/00000000-ff78-6246-a4fe-9c8c66054a76/raw?se=2025-08-18T01%3A39%3A05Z&sp=r&sv=2024-08-04&sr=b&scid=c80c01e0-73fa-5e49-9ac4-6101d1275918&skoid=9ccea605-1409-4478-82eb-9c83b25dc1b0&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-08-17T22%3A48%3A49Z&ske=2025-08-18T22%3A48%3A49Z&sks=b&skv=2024-08-04&sig=SYfeqeaQvYufRLPMkEijmsR5xW/mOD6ygSFPFhHoMTw%3D', 38, 23, '\"[\\\"kiro\\\"]\"', 'male', 'string'),
(3, 'kito', 3, 'string', 'https://sdmntpritalynorth.oaiusercontent.com/files/00000000-ff78-6246-a4fe-9c8c66054a76/raw?se=2025-08-18T01%3A39%3A05Z&sp=r&sv=2024-08-04&sr=b&scid=c80c01e0-73fa-5e49-9ac4-6101d1275918&skoid=9ccea605-1409-4478-82eb-9c83b25dc1b0&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-08-17T22%3A48%3A49Z&ske=2025-08-18T22%3A48%3A49Z&sks=b&skv=2024-08-04&sig=SYfeqeaQvYufRLPMkEijmsR5xW/mOD6ygSFPFhHoMTw%3D', 38, 23, '\"[\\\"kiro\\\"]\"', 'male', 'string'),
(4, 'kito', 3, 'string', 'https://sdmntpritalynorth.oaiusercontent.com/files/00000000-ff78-6246-a4fe-9c8c66054a76/raw?se=2025-08-18T01%3A39%3A05Z&sp=r&sv=2024-08-04&sr=b&scid=c80c01e0-73fa-5e49-9ac4-6101d1275918&skoid=9ccea605-1409-4478-82eb-9c83b25dc1b0&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-08-17T22%3A48%3A49Z&ske=2025-08-18T22%3A48%3A49Z&sks=b&skv=2024-08-04&sig=SYfeqeaQvYufRLPMkEijmsR5xW/mOD6ygSFPFhHoMTw%3D', 38, 23, '\"[\\\"\\\\u043a\\\\u0430\\\\u0432\\\\u0430\\\\u0439\\\\u043d\\\\u044b\\\\u0439\\\", \\\"\\\\u0448\\\\u043a\\\\u043e\\\\u043b\\\\u044c\\\\u043d\\\\u0438\\\\u0446\\\\u0430\\\", \\\"\\\\u043c\\\\u0430\\\\u0433\\\\u0438\\\\u044f\\\"]\"', 'male', 'string'),
(5, 'kito', 3, 'string', 'https://sdmntpritalynorth.oaiusercontent.com/files/00000000-ff78-6246-a4fe-9c8c66054a76/raw?se=2025-08-18T01%3A39%3A05Z&sp=r&sv=2024-08-04&sr=b&scid=c80c01e0-73fa-5e49-9ac4-6101d1275918&skoid=9ccea605-1409-4478-82eb-9c83b25dc1b0&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-08-17T22%3A48%3A49Z&ske=2025-08-18T22%3A48%3A49Z&sks=b&skv=2024-08-04&sig=SYfeqeaQvYufRLPMkEijmsR5xW/mOD6ygSFPFhHoMTw%3D', 38, 23, '\"[\\\"\\\\u043a\\\\u0430\\\\u0432\\\\u0430\\\\u0439\\\\u043d\\\\u044b\\\\u0439\\\", \\\"\\\\u0448\\\\u043a\\\\u043e\\\\u043b\\\\u044c\\\\u043d\\\\u0438\\\\u0446\\\\u0430\\\", \\\"\\\\u043c\\\\u0430\\\\u0433\\\\u0438\\\\u044f\\\"]\"', 'male', 'string'),
(6, 'gdffnj', 17, 'string', 'https://sdmntpritalynorth.oaiusercontent.com/files/00000000-ff78-6246-a4fe-9c8c66054a76/raw?se=2025-08-18T01%3A39%3A05Z&sp=r&sv=2024-08-04&sr=b&scid=c80c01e0-73fa-5e49-9ac4-6101d1275918&skoid=9ccea605-1409-4478-82eb-9c83b25dc1b0&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-08-17T22%3A48%3A49Z&ske=2025-08-18T22%3A48%3A49Z&sks=b&skv=2024-08-04&sig=SYfeqeaQvYufRLPMkEijmsR5xW/mOD6ygSFPFhHoMTw%3D', 30, 12, '\"[\\\"cute\\\"]\"', 'female', 'string');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `login` varchar(50) NOT NULL,
  `sex` enum('male','female') NOT NULL,
  `pass` varchar(255) NOT NULL,
  `coins` int(50) NOT NULL DEFAULT '50',
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `charact`
--
ALTER TABLE `charact`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `login` (`login`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `charact`
--
ALTER TABLE `charact`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

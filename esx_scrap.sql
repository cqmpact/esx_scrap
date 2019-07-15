SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


CREATE TABLE `esx_scrap` (
  `id` int(11) NOT NULL,
  `vehicle` varchar(64) NOT NULL,
  `multiplier` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


INSERT INTO `esx_scrap` (`id`, `vehicle`, `multiplier`) VALUES
(1, 'SULTANRS', 5),
(2, 'PANTO', 1),
(3, 'F620', 3),
(4, 'LANDSTAL', 2),
(5, 'Z190', 4);


ALTER TABLE `esx_scrap`
  ADD PRIMARY KEY (`id`);

--
ALTER TABLE `esx_scrap`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
COMMIT;

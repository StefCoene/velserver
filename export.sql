--
-- Database: `velbus`
--
CREATE DATABASE IF NOT EXISTS `velbus` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `velbus`;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `raw` varchar(50) NOT NULL,
  `address` varchar(2) NOT NULL,
  `prio` varchar(8) NOT NULL,
  `type` varchar(2) NOT NULL,
  `rtr_size` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `modules`
--

CREATE TABLE `modules` (
  `address` varchar(2) NOT NULL,
  `name` varchar(16) NOT NULL,
  `type` varchar(16) NOT NULL,
  `status` varchar(16) NOT NULL,
  `date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `modules_channel_info`
--

CREATE TABLE `modules_channel_info` (
  `address` varchar(2) NOT NULL,
  `channel` varchar(40) NOT NULL,
  `data` varchar(40) NOT NULL,
  `value` varchar(120) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `modules_info`
--

CREATE TABLE `modules_info` (
  `address` varchar(2) NOT NULL,
  `data` varchar(40) NOT NULL,
  `value` varchar(120) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`address`);

--
-- Indexes for table `modules_channel_info`
--
ALTER TABLE `modules_channel_info`
  ADD UNIQUE KEY `address` (`address`,`channel`,`data`) USING BTREE;

--
-- Indexes for table `modules_info`
--
ALTER TABLE `modules_info`
  ADD UNIQUE KEY `address` (`address`,`data`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

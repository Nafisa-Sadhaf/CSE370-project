-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 05, 2026 at 08:33 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `capital_advisory`
--

-- --------------------------------------------------------

--
-- Table structure for table `advisor`
--

CREATE TABLE `advisor` (
  `AdvisorID` int(11) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Specialization` varchar(100) DEFAULT NULL,
  `ExperienceYears` int(11) DEFAULT NULL,
  `JoinDate` varchar(20) DEFAULT NULL,
  `Username` varchar(50) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `advisor`
--

INSERT INTO `advisor` (`AdvisorID`, `Name`, `Email`, `Specialization`, `ExperienceYears`, `JoinDate`, `Username`, `Password`) VALUES
(1, 'Md. Abdur Rahman', 'rahman@capitalbd.com', 'Wealth Management', 8, '2019-03-10', 'rahman', 'pass123'),
(2, 'Farida Sultana', 'sultana@capitalbd.com', 'Retirement Planning', 5, '2021-06-01', 'sultana', 'pass123'),
(3, 'Kamal Hossain', 'hossain@capitalbd.com', 'Tax & Investment', 6, '2020-09-15', 'hossain', 'pass123');

-- --------------------------------------------------------

--
-- Table structure for table `advisor_performance`
--

CREATE TABLE `advisor_performance` (
  `PerformanceID` int(11) NOT NULL,
  `AdvisorID` int(11) DEFAULT NULL,
  `TotalClients` int(11) DEFAULT NULL,
  `AvgPortfolioGrowth` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `advisor_performance`
--

INSERT INTO `advisor_performance` (`PerformanceID`, `AdvisorID`, `TotalClients`, `AvgPortfolioGrowth`) VALUES
(1, 1, 38, 14.2),
(2, 2, 55, 11.6),
(3, 3, 27, 16.8);

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `AppointmentID` int(11) NOT NULL,
  `ClientID` int(11) DEFAULT NULL,
  `AdvisorID` int(11) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Topic` varchar(200) DEFAULT NULL,
  `Notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`AppointmentID`, `ClientID`, `AdvisorID`, `Date`, `Topic`, `Notes`) VALUES
(1, 1, 1, '2026-05-02 10:00:00', 'Annual Portfolio Review', 'Reviewed Grameenphone stock performance - up 24% YTD. Discussed rolling Sanchayapatra on maturity date.'),
(2, 1, 1, '2026-02-14 14:00:00', 'Hajj Fund Planning', 'Discussed increasing monthly contribution to Tk 15,000 to meet Hajj Fund deadline. Client agreed.'),
(3, 2, 2, '2026-04-15 11:00:00', 'Retirement & Housing Plan', 'Reviewed flat purchase goal. Recommended DPS (Deposit Pension Scheme) to accelerate savings for Chittagong flat.'),
(4, 3, 1, '2026-03-20 09:30:00', 'Car Purchase Goal Session', 'Client targeting a Toyota Allion. Set monthly savings target of Tk 40,000. Reviewed Dutch-Bangla Bank portfolio.'),
(5, 4, 3, '2026-04-28 15:00:00', 'Education Fund & Tax Planning', 'Discussed investing in Islami Bank Mudaraba Fund for Shariah-compliant growth. Reviewed tax exemption on Sanchayapatra.'),
(6, 5, 2, '2026-04-10 13:00:00', 'Marriage Fund Final Review', 'Rakib is 95% to goal. Discussed liquidating Beximco shares after marriage to fund honeymoon expenses.');

-- --------------------------------------------------------

--
-- Table structure for table `client`
--

CREATE TABLE `client` (
  `ClientID` int(11) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Phone` varchar(20) DEFAULT NULL,
  `Address` varchar(200) DEFAULT NULL,
  `HomeCity` varchar(100) DEFAULT NULL,
  `Username` varchar(50) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `AdvisorID` int(11) DEFAULT NULL,
  `Status` varchar(20) DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`ClientID`, `Name`, `Email`, `Phone`, `Address`, `HomeCity`, `Username`, `Password`, `AdvisorID`, `Status`) VALUES
(1, 'Md. Rahim Uddin', 'rahim.uddin@gmail.com', '+880 1711-234567', 'House 12, Road 5, Dhanmondi, Dhaka', 'Dhaka', 'rahim', 'pass123', 1, 'active'),
(2, 'Nusrat Jahan', 'nusrat.jahan@gmail.com', '+880 1812-345678', 'Flat 3B, Agrabad, Chittagong', 'Chittagong', 'nusrat', 'pass123', 2, 'active'),
(3, 'Tanvir Ahmed', 'tanvir.ahmed@gmail.com', '+880 1913-456789', 'House 7, Mirpur-10, Dhaka', 'Dhaka', 'tanvir', 'pass123', 1, 'pending'),
(4, 'Mithila Akter', 'mithila.akter@gmail.com', '+880 1615-567890', 'Flat 2A, Zindabazar, Sylhet', 'Sylhet', 'mithila', 'pass123', 3, 'active'),
(5, 'Rakib Hasan', 'rakib.hasan@gmail.com', '+880 1716-678901', 'House 9, Shaheb Bazar, Rajshahi', 'Rajshahi', 'rakib', 'pass123', 2, 'active');

-- --------------------------------------------------------

--
-- Table structure for table `financial_goal`
--

CREATE TABLE `financial_goal` (
  `GoalID` int(11) NOT NULL,
  `ClientID` int(11) DEFAULT NULL,
  `GoalName` varchar(100) DEFAULT NULL,
  `TargetAmount` float DEFAULT NULL,
  `CurrentAmount` float DEFAULT NULL,
  `Deadline` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `financial_goal`
--

INSERT INTO `financial_goal` (`GoalID`, `ClientID`, `GoalName`, `TargetAmount`, `CurrentAmount`, `Deadline`) VALUES
(1, 1, 'Retirement Savings', 2000000, 1650000, '2030-12-31'),
(2, 1, 'Hajj Fund', 300000, 178000, '2026-05-25'),
(3, 2, 'Flat Purchase (Chittagong)', 3500000, 1400000, '2028-06-01'),
(4, 3, 'Car Purchase', 800000, 465000, '2026-09-01'),
(5, 4, 'Children Education Fund', 1500000, 870000, '2027-12-01'),
(6, 5, 'Marriage Fund', 500000, 275000, '2026-08-01');

-- --------------------------------------------------------

--
-- Table structure for table `fraud_flag`
--

CREATE TABLE `fraud_flag` (
  `FraudID` int(11) NOT NULL,
  `ClientID` int(11) DEFAULT NULL,
  `Reason` varchar(255) DEFAULT NULL,
  `Status` varchar(50) DEFAULT NULL,
  `Date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fraud_flag`
--

INSERT INTO `fraud_flag` (`FraudID`, `ClientID`, `Reason`, `Status`, `Date`) VALUES
(1, 1, 'Suspicious Location: Transaction from Mumbai.', 'Pending', '2026-04-26 22:00:00'),
(2, 2, 'Suspicious Location: Transaction from Singapore.', 'Pending', '2026-04-27 03:30:00'),
(3, 3, 'RED ZONE: 2 transactions in 2 mins.', 'Red Zone', '2026-04-28 08:01:00'),
(4, 2, 'Threshold Alert: Less than 30% balance remaining.', 'Pending', '2026-04-15 16:00:00'),
(5, 5, 'Suspicious Location: Transaction from dhaka.', 'Pending', '2026-05-05 12:38:51'),
(6, 5, 'Threshold Alert: Less than 30% balance remaining.', 'Pending', '2026-05-05 22:26:20'),
(7, 5, 'Threshold Alert: Less than 30% balance remaining.', 'Pending', '2026-05-05 23:07:51'),
(8, 5, 'Threshold Alert: Less than 30% balance remaining.', 'Pending', '2026-05-05 23:18:27'),
(9, 5, 'Threshold Alert: Less than 30% balance remaining.', 'Pending', '2026-05-05 23:20:05');

-- --------------------------------------------------------

--
-- Table structure for table `investment`
--

CREATE TABLE `investment` (
  `InvestmentID` int(11) NOT NULL,
  `PortfolioID` int(11) DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `InvestedAt` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `investment`
--

INSERT INTO `investment` (`InvestmentID`, `PortfolioID`, `Amount`, `InvestedAt`) VALUES
(1, 1, 64000, '2023-02-10 10:00:00'),
(2, 2, 500000, '2022-07-01 11:00:00'),
(3, 3, 16500, '2023-04-15 09:30:00'),
(4, 4, 33000, '2022-11-20 14:00:00'),
(5, 5, 34000, '2023-06-05 10:30:00'),
(6, 6, 8750, '2023-01-18 09:00:00'),
(7, 7, 300000, '2021-09-01 11:00:00'),
(8, 8, 85000, '2022-08-12 13:00:00'),
(9, 9, 14000, '2023-10-03 15:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `portfolio`
--

CREATE TABLE `portfolio` (
  `PortfolioID` int(11) NOT NULL,
  `ClientID` int(11) DEFAULT NULL,
  `AssetName` varchar(100) DEFAULT NULL,
  `AssetType` varchar(50) DEFAULT NULL,
  `Quantity` float DEFAULT NULL,
  `PurchasePrice` float DEFAULT NULL,
  `CurrentValue` float DEFAULT NULL,
  `PurchaseDate` varchar(20) DEFAULT NULL,
  `TotalValue` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `portfolio`
--

INSERT INTO `portfolio` (`PortfolioID`, `ClientID`, `AssetName`, `AssetType`, `Quantity`, `PurchasePrice`, `CurrentValue`, `PurchaseDate`, `TotalValue`) VALUES
(1, 1, 'Grameenphone Ltd.', 'Stock', 200, 320, 398.5, '2023-02-10', 79700),
(2, 1, 'Bangladesh Sanchayapatra', 'Bond', 5, 100000, 100000, '2022-07-01', 500000),
(3, 2, 'BRAC Bank Ltd.', 'Stock', 300, 55, 72.3, '2023-04-15', 21690),
(4, 2, 'Square Pharmaceuticals', 'Stock', 150, 220, 265, '2022-11-20', 39750),
(5, 3, 'Dutch-Bangla Bank Ltd.', 'Stock', 400, 85, 91.5, '2023-06-05', 36600),
(6, 4, 'Islami Bank Bangladesh', 'Stock', 250, 35, 42, '2023-01-18', 10500),
(7, 4, '5-Year Sanchayapatra', 'Bond', 3, 100000, 100000, '2021-09-01', 300000),
(8, 5, 'Walton Hi-Tech Industries', 'Stock', 100, 850, 940, '2022-08-12', 94000),
(9, 5, 'Beximco Pharmaceuticals', 'Stock', 500, 28, 35.5, '2023-10-03', 17750);

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `TransactionID` int(11) NOT NULL,
  `ClientID` int(11) DEFAULT NULL,
  `Amount` float DEFAULT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `TransactionType` varchar(50) DEFAULT NULL,
  `Status` varchar(50) DEFAULT 'Completed',
  `CreatedAt` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`TransactionID`, `ClientID`, `Amount`, `Location`, `TransactionType`, `Status`, `CreatedAt`) VALUES
(1, 1, 50000, 'Dhaka', 'Deposit', 'Completed', '2026-04-25 14:30:00'),
(2, 1, 15000, 'Dhaka', 'Withdraw', 'Completed', '2026-04-10 09:15:00'),
(3, 2, 30000, 'Chittagong', 'Deposit', 'Completed', '2026-04-20 11:00:00'),
(4, 3, 20000, 'Dhaka', 'Deposit', 'Completed', '2026-04-18 13:45:00'),
(5, 4, 10000, 'Sylhet', 'Deposit', 'Completed', '2026-04-22 10:30:00'),
(6, 5, 45000, 'Rajshahi', 'Deposit', 'Completed', '2026-04-15 15:00:00'),
(7, 1, 80000, 'Mumbai', 'Transfer', 'Completed', '2026-04-26 22:00:00'),
(8, 2, 150000, 'Singapore', 'Transfer', 'Completed', '2026-04-27 03:30:00'),
(9, 3, 5000, 'Dhaka', 'Withdraw', 'Completed', '2026-04-28 08:00:00'),
(10, 3, 5000, 'Dhaka', 'Withdraw', 'Completed', '2026-04-28 08:01:00'),
(11, 5, 500, 'dhaka', 'Deposit', 'Completed', '2026-05-05 12:38:51'),
(12, 5, 10000, 'Rajshahi', 'Buy', 'Completed', '2026-05-05 22:25:24'),
(13, 5, 1000000000, 'Rajshahi', 'Withdraw', 'Completed', '2026-05-05 22:26:20'),
(14, 5, 100000, 'Rajshahi', 'Withdraw', 'Completed', '2026-05-05 23:07:51'),
(15, 5, 100000, 'dhaka', 'Buy', 'Completed', '2026-05-05 23:18:27'),
(16, 5, 100000, 'dhaka', 'Deposit', 'Completed', '2026-05-05 23:20:05');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `advisor`
--
ALTER TABLE `advisor`
  ADD PRIMARY KEY (`AdvisorID`),
  ADD UNIQUE KEY `Username` (`Username`);

--
-- Indexes for table `advisor_performance`
--
ALTER TABLE `advisor_performance`
  ADD PRIMARY KEY (`PerformanceID`),
  ADD KEY `AdvisorID` (`AdvisorID`);

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`AppointmentID`),
  ADD KEY `AdvisorID` (`AdvisorID`);

--
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`ClientID`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD KEY `AdvisorID` (`AdvisorID`);

--
-- Indexes for table `financial_goal`
--
ALTER TABLE `financial_goal`
  ADD PRIMARY KEY (`GoalID`),
  ADD KEY `ClientID` (`ClientID`);

--
-- Indexes for table `fraud_flag`
--
ALTER TABLE `fraud_flag`
  ADD PRIMARY KEY (`FraudID`),
  ADD KEY `ClientID` (`ClientID`);

--
-- Indexes for table `investment`
--
ALTER TABLE `investment`
  ADD PRIMARY KEY (`InvestmentID`),
  ADD KEY `PortfolioID` (`PortfolioID`);

--
-- Indexes for table `portfolio`
--
ALTER TABLE `portfolio`
  ADD PRIMARY KEY (`PortfolioID`),
  ADD KEY `ClientID` (`ClientID`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`TransactionID`),
  ADD KEY `ClientID` (`ClientID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `advisor`
--
ALTER TABLE `advisor`
  MODIFY `AdvisorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `advisor_performance`
--
ALTER TABLE `advisor_performance`
  MODIFY `PerformanceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `AppointmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `ClientID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `financial_goal`
--
ALTER TABLE `financial_goal`
  MODIFY `GoalID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `fraud_flag`
--
ALTER TABLE `fraud_flag`
  MODIFY `FraudID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `investment`
--
ALTER TABLE `investment`
  MODIFY `InvestmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `portfolio`
--
ALTER TABLE `portfolio`
  MODIFY `PortfolioID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `TransactionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `advisor_performance`
--
ALTER TABLE `advisor_performance`
  ADD CONSTRAINT `advisor_performance_ibfk_1` FOREIGN KEY (`AdvisorID`) REFERENCES `advisor` (`AdvisorID`);

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`AdvisorID`) REFERENCES `advisor` (`AdvisorID`);

--
-- Constraints for table `client`
--
ALTER TABLE `client`
  ADD CONSTRAINT `client_ibfk_1` FOREIGN KEY (`AdvisorID`) REFERENCES `advisor` (`AdvisorID`);

--
-- Constraints for table `financial_goal`
--
ALTER TABLE `financial_goal`
  ADD CONSTRAINT `financial_goal_ibfk_1` FOREIGN KEY (`ClientID`) REFERENCES `client` (`ClientID`);

--
-- Constraints for table `fraud_flag`
--
ALTER TABLE `fraud_flag`
  ADD CONSTRAINT `fraud_flag_ibfk_1` FOREIGN KEY (`ClientID`) REFERENCES `client` (`ClientID`);

--
-- Constraints for table `investment`
--
ALTER TABLE `investment`
  ADD CONSTRAINT `investment_ibfk_1` FOREIGN KEY (`PortfolioID`) REFERENCES `portfolio` (`PortfolioID`);

--
-- Constraints for table `portfolio`
--
ALTER TABLE `portfolio`
  ADD CONSTRAINT `portfolio_ibfk_1` FOREIGN KEY (`ClientID`) REFERENCES `client` (`ClientID`);

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`ClientID`) REFERENCES `client` (`ClientID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

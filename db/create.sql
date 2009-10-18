DROP TABLE data_points;
CREATE TABLE data_points (
  id int unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
  timestamp datetime NOT NULL,
  timescale int unsigned,
  slug varchar(255),
  type varchar(100),
  level enum('info', 'warn', 'error', 'fatal'),
  message text,
  measurement decimal(10,2),
  created_at datetime,
  updated_at datetime
);

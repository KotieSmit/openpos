openPOS
=======
Another fork of the Open Source Point of Sale. Many forks have been created, but none has been updated. 
This project aims to create a modern look and integrate features from other commercial POS applications.


MySQL User Creation
-------------------------
CREATE USER 'openpos'@'localhost' IDENTIFIED BY  'openpos';
GRANT USAGE ON * . * TO  'openpos'@'localhost' IDENTIFIED BY  'openpos' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;
CREATE DATABASE IF NOT EXISTS  `openpos` ;
GRANT ALL PRIVILEGES ON  `openpos` . * TO  'openpos'@'localhost';


How to Install
-------------------------
1. Create/locate a new mysql database to install open source point of sale into
2. Execute the file database/database.sql to create the tables needed
3. unzip and upload Open Source Point of Sale files to web server
4. Copy application/config/database.php.tmpl to application/config/database.php
5. Modify application/config/database.php to connect to your database
6. Go to your point of sale install via the browser
7. LOGIN using
username: admin 
password:pointofsale
8. Enjoy
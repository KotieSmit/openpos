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



Nginx Vhost setup that works for me:

server {
	root /var/www/openpos/;
	index index.html index.htm index.php;

	access_log /var/log/nginx/openpos.access.log;
        error_log /var/log/nginx/openpos.error.log;

	# Make site accessible from http://localhost/
        server_name openpos.kotie.dev;
	location /doc/ {
		alias 		/usr/share/doc;
		autoindex 	on;
		allow 		127.0.0.1;
                allow 		192.168.0.207;
		deny 		all;
	}
 	location / {
                # Check if a file or directory index file exists, else route it to index.php.
                try_files $uri $uri/ /index.php;
	}

    location ~* \.php$ {
	fastcgi_buffer_size 	128k;
	fastcgi_buffers 	4 256k;
	fastcgi_busy_buffers_size 256k;
    	fastcgi_pass    	unix:/var/lib/php5/php5-fpm.sock;
        fastcgi_index  		index.php;
        include        		fastcgi_params;
        fastcgi_read_timeout 	86400;
        fastcgi_send_timeout 	86400;
        fastcgi_param  		SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param  		HTTPS $https;
	}

	location ~ \.php$ {
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_index index.php;
		include fastcgi_params;
	}
}


Add the following to your /etc/nginx/nginx.conf  http block
        #proxy  settings
        proxy_buffer_size   128k;
        proxy_buffers   4 256k;
        proxy_busy_buffers_size   256k;

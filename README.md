# Laravel

1. Launch EC2 Instance
Go to the AWS EC2 dashboard and launch a new instance:

AMI: Amazon Linux 2023

Instance Type: As per the requirement

Allow inbound rules for SSH (22), HTTP (80), and HTTPS (443) in security group

Connect to your instance:
  ssh -i /path/to/your-key.pem ec2-user@your-ec2-public-ip

2. Install Required Packages
  sudo yum update -y

# Apache Web Server
sudo yum install -y httpd

# PHP and required extensions
sudo dnf install -y php php-cli php-common php-mbstring php-xml php-bcmath php-pdo php-mysqlnd php-fpm php-opcache unzip curl git

# Start Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Node.js and NPM (for frontend assets)
sudo dnf module enable nodejs:18 -y
sudo dnf install -y nodejs

# Install Composer (PHP dependency manager)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer

3. Clone Laravel App from Private Repo
You can use SSH key or Personal Access Token to access your private repo:

Option A: Use SSH (Recommended)
Generate key:
ssh-keygen -t ed25519 -C "ec2"
Copy key and add to GitHub (in SSH and GPG keys):
cat ~/.ssh/id_ed25519.pub
Test GitHub access:
ssh -T git@github.com
Option B: Use Personal Access Token (alternative)
git clone https://<username>:<token>@github.com/<username>/<repo>.git

4. Move Laravel App to Web Directory
cd /var/www
sudo git clone git@github.com:your-username/your-laravel-repo.git laravel-app
cd laravel-app

5. Configure Laravel Environment
Copy .env file:
cp .env.example .env
Generate application key:
php artisan key:generate
Edit .env with DB and other environment details:
nano .env

6. Install Composer Dependencies
composer install --no-dev --optimize-autoloader

7. Install and Compile NPM Assets (if applicable)
If your Laravel app uses Mix, Vite, or other frontend tooling:
npm install
npm run build   # or npm run prod

8. Set Folder Permissions
sudo chown -R apache:apache /var/www/laravel-app
sudo chmod -R 775 /var/www/laravel-app/storage
sudo chmod -R 775 /var/www/laravel-app/bootstrap/cache

9. Set Up Apache for Laravel
Edit Apache config:
sudo nano /etc/httpd/conf.d/laravel.conf
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
Restart Apache:
sudo systemctl restart httpd

10. Test Laravel Application
Open your browser:
http://<your-ec2-public-ip>/
You should see your Laravel app’s homepage.
Optional: Configure Database (MySQL/RDS)
If your .env is using MySQL and you haven’t set it up yet:

Install MySQL locally or connect to AWS RDS

Update .env:
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=your_db
DB_USERNAME=root
DB_PASSWORD=your_password
Run Laravel migrations:
php artisan migrate 
-------------------------------------------------------------------------------------------------------

1. Move Laravel Project to Apache Web Directory
Apache serves files from /var/www/html, but Laravel should be served from the /public folder. Let's move it properly:
sudo mv ~/Laravel-Payvance /var/www/laravel
cd /var/www/laravel
2. Install PHP Dependencies with Composer
Make sure you're in the Laravel directory:
cd /var/www/laravel
composer install --no-dev --optimize-autoloader
If composer is not found, make sure you installed it and it’s in your path. You can test with composer -V.

3. Configure the .env File
cp .env.example .env
nano .env
Edit values like database, app name, URL, etc.

Example:
APP_NAME=Laravel
APP_ENV=production
APP_KEY=
APP_URL=http://your-ec2-ip

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=your_db
DB_USERNAME=your_user
DB_PASSWORD=your_password

4. Generate Laravel App Key
php artisan key:generate

5. Set Correct Permissions
Laravel needs proper permissions for storage and bootstrap/cache:
sudo chown -R apache:apache /var/www/laravel
sudo chmod -R 775 storage
sudo chmod -R 775 bootstrap/cache

6. Configure Apache to Serve Laravel App
Create an Apache config file:
sudo nano /etc/httpd/conf.d/laravel.conf
Paste this:
<VirtualHost *:80>
    DocumentRoot /var/www/laravel/public
    <Directory /var/www/laravel/public>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
Enable .htaccess support:
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
Restart Apache:
sudo systemctl restart httpd

7. Compile Frontend Assets
If your project uses Vite or Laravel Mix (check vite.config.js or webpack.mix.js), run:
npm install
npm run build

8. Access Your App
Now open your browser and go to:
http://<your-ec2-public-ip>/
You should see your Laravel app running. 

9. Run Migrations (If Needed)
If your .env is connected to a working database:

php artisan migrate --force

Fix in Steps
1. Do You Have MySQL Installed on This EC2 Instance?
sudo dnf install -y mariadb105-server
sudo systemctl enable mariadb
sudo systemctl start mariadb
2. Secure MySQL and Create Laravel Database
sudo mysql_secure_installation
Then log into MySQL:
sudo mysql -u root -p
And create a database and user for Laravel:
CREATE DATABASE laravel_db;
CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'strong_password';
GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
3.Update Laravel .env File
Open .env and update:
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=strong_password
Then clear Laravel config cache:
php artisan config:clear
php artisan config:cache
4. Run Laravel Migrations
Only run if you’re ready to build the DB schema:
php artisan migrate --force
Test Again
Visit your EC2 IP in the browser:
http://your-IP
--------------------------------------------------------

Step 1: Launched EC2 Instance
Created an Amazon EC2 instance using Amazon Linux 2023 AMI.

Chose t2.micro instance (or other) and set up:

Key Pair for SSH access

Security Group allowing:

SSH (port 22) — for terminal access

HTTP (port 80) — for web server access

(Optional) HTTPS (port 443) — for SSL later

Step 2: Connected to the EC2 Instance via SSH
Used the following command from local machine:
ssh -i /path/to/your-key.pem ec2-user@<EC2-Public-IP>

Step 3: Installed Required Software
Installed all necessary packages for running Laravel:
sudo yum update -y
sudo yum install -y httpd git curl unzip php php-cli php-common php-mbstring php-xml php-bcmath php-pdo php-mysqlnd php-fpm php-opcache
Installed Node.js and NPM:
sudo dnf module enable nodejs:18 -y
sudo dnf install -y nodejs
Installed Composer:
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --install-dir=/usr/local/bin --filename=composer

Step 4: Cloned Laravel Project from Private GitHub Repo
Cloned the Laravel project Laravel-Payvance:
git clone git@github.com:your-username/your-private-repo.git Laravel-Payvance

Step 5: Moved Laravel Code to Apache Directory
Moved project to web root:
sudo mv Laravel-Payvance /var/www/laravel
cd /var/www/laravel

Step 6: Installed Laravel Dependencies
Installed PHP dependencies with Composer:
composer install --no-dev --optimize-autoloader
Installed frontend dependencies:
npm install
npm run build

Step 7: Set Environment Configuration
Copied and edited .env:
cp .env.example .env
nano .env
Set values like:
APP_NAME=Laravel
APP_ENV=production
APP_KEY=
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=StrongPass123!
Generated application key:
php artisan key:generate

Step 8: Set File and Directory Permissions
  Laravel needs writable directories:
  sudo chown -R apache:apache /var/www/laravel
  sudo chmod -R 775 storage
  sudo chmod -R 775 bootstrap/cache

Step 9: Configured Apache Virtual Host for Laravel
  Created config file:
  sudo nano /etc/httpd/conf.d/laravel.conf
  Added:
  <VirtualHost *:80>
      DocumentRoot /var/www/laravel/public
      <Directory /var/www/laravel/public>
          AllowOverride All
          Require all granted
      </Directory>
  </VirtualHost>
  Enabled .htaccess:
  sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
  Restarted Apache:
  sudo systemctl restart httpd

Step 10: Installed and Configured MariaDB (MySQL)
Installed MariaDB:
sudo dnf install -y mariadb105-server
sudo systemctl enable mariadb
sudo systemctl start mariadb
Secured MariaDB:
  sudo mysql_secure_installation
Created Laravel DB and user:

CREATE DATABASE laravel_db;
CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'StrongPass123!';
GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'localhost';
FLUSH PRIVILEGES;

Step 11: Ran Laravel Migrations
php artisan migrate --force

Step 12: Laravel App Live in Browser
Visited:
http://<your-ec2-public-ip>

# wordpress_fix_permissions_debian10
A Shell Script to fix permissions of all Files and Directories in a WordPress installation based on official recommendations.

So, the 5 Steps this Script does:
1. Set new Owner on all Files and (Sub)Directories ( user:group )
2. Set Permissions: 755 to Directories and 644 to Files
3. wp-config.php : Preventing world access for "wp-config.php", leaving it accesible to WordPress (660)
4. Allow WordPress to manage the "wp-content" (Directories to 755 & Files to 664)
5. Privatize "wp-content" (Set 755)

## 

## Usage
Make the Script executable
sudo chmod +x fix_wordPress_permissions

Run
./fix_wordPress_permissions

The Script will ask for:
1. Absolute Path to our WordPress installation (our typical public_html)
2. Desired "owner:user" ("www-data" by default, typing y or leaving it blank)

That was all!  


## Extra Tip
Maybe you need to add something like this to your "/etc/apache2/apache2.conf"

  <Directory /home/mydomain/public_html/>
      Options Indexes FollowSymLinks
      AllowOverride None
      Require all granted
  </Directory>

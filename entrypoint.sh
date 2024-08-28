#!/bin/bash
# Install the Drupal site with SCS Manager

# Define the path to the settings.php file
SETTINGS_FILE="/opt/drupal/web/sites/default/settings.php"

# Check if Drupal is already installed
if [ -f "$SETTINGS_FILE" ]; then
  echo "Drupal is already installed."
else
  echo "Installing Drupal..."

  # Install the site
  drush si \
    --db-url="${DB_DRIVER}://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:3306/${DB_NAME}" \
    --site-name="${SITE_NAME}" \
    --account-name="${DRUPAL_USER}" \
    --account-pass="${DRUPAL_PASSWORD}"

  # Install development modules
  composer require drupal/devel
  drush en devel -y

  # Set permissions
  chown -R www-data:www-data /opt/drupal
  chmod -R 775 /opt/drupal
fi

# Keep the container running
/usr/sbin/apache2ctl -D FOREGROUND
; This version of the .make will build a local copy of the distribution
; using the versions of modules and patches listed.
; Modules and libraries will be in sites/all
; This is used to test the packaging BEFORE committing
; drush make --no-core civicrm_starterkit.make

core = 7.51
api = 2

; Drupal Core
projects[drupal][version] = "7.80"

; ====== CIVICRM RELATED =========

libraries[civicrm][download][type] = get
libraries[civicrm][download][url] = "https://download.civicrm.org/civicrm-5.40.1-drupal.tar.gz"
libraries[civicrm][destination] = modules
libraries[civicrm][directory_name] = civicrm

;PANTHEON RELATED PATCHES
; Settings for Pantheon (d.o/node/2082713 originally)
libraries[civicrm][patch][pantheonsettings] = ./patches/pantheon-settings-starterkit-55.patch

; Set session for cron.
; Matches settings in CiviCRM core for extern/*.
libraries[civicrm][patch][cron] = ./patches/cron.patch

; IPN: Separate Paypal Pro and Standard into separate calls [deprecated]
libraries[civicrm][patch][ipn] = ./patches/ipn.patch
libraries[civicrm][patch][ipnstd] = ./patches/ipnStd.patch

; === Installer ===

; Necessary if CiviCRM in profiles/*/modules/civicrm
; Define the path to the civicrm.settings.php file because CiviCRM is not in the expected location.
; Required for anything not doing a full bootstrap.
; https://www.drupal.org/node/1844558
libraries[civicrm][patch][1844558] = ./patches/settings_location-for-profiles.patch

; [OPTIONAL] SMTP patch for PHP 5.6+
; https://civicrm.stackexchange.com/questions/16628/outgoing-mail-settings-civismtp-php-5-6-x-problem
libraries[civicrm][patch][smtpverify] = ./patches/smtp-disable-peer-verification.patch

; === Modules ===

projects[captcha][subdir] = "contrib"
projects[recaptcha][subdir] = "contrib"
projects[civicrm_clear_all_caches][subdir] = "contrib"
projects[civicrm_cron][subdir] = "contrib"
projects[ctools][subdir] = "contrib"
projects[features][subdir] = "contrib"
projects[libraries][subdir] = "contrib"
projects[module_filter][subdir] = "contrib"
projects[options_element][subdir] = "contrib"
projects[views][subdir] = "contrib"
projects[webform][subdir] = "contrib"
projects[webform_civicrm][subdir] = "contrib"
projects[wysiwyg][subdir] = "contrib"

; === Libraries ===

libraries[ckeditor][download][type] = get
libraries[ckeditor][download][url] = "http://download.cksource.com/CKEditor/CKEditor/CKEditor%204.9.2/ckeditor_4.9.2_standard.tar.gz"
libraries[ckeditor][destination] = libraries
libraries[ckeditor][directory_name] = ckeditor

libraries[tinymce][download][type] = get
libraries[tinymce][download][url] = "http://download.ephox.com/tinymce/community/tinymce_4.5.7.zip"
libraries[tinymce][destination] = libraries
libraries[tinymce][directory_name] = tinymce

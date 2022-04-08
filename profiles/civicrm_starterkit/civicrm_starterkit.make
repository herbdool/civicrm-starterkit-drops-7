; This version of the .make will build a local copy of the distribution
; using the versions of modules and patches listed.
; Modules and libraries will be in sites/all
; This is used to test the packaging BEFORE committing
; drush make --no-core civicrm_starterkit.make

; @todo add to commit notes:
; upgrade extensions (sometimes core extensions are also included):
; terminus drush site:env cvapi Extension.upgrade

core = 7.89
api = 2

; Drupal Core
projects[drupal][version] = "7.89"

; ====== CIVICRM RELATED =========

libraries[civicrm][download][type] = get
libraries[civicrm][download][url] = "https://download.civicrm.org/civicrm-5.47.4-drupal.tar.gz"
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
projects[civicrm_clear_all_caches][download][type] = get
projects[civicrm_clear_all_caches][download][url] = "https://ftp.drupal.org/files/projects/civicrm_clear_all_caches-7.x-1.0-beta2.zip"
projects[civicrm_cron][subdir] = "contrib"
projects[civicrm_cron][download][type] = get
projects[civicrm_cron][download][url] = "https://ftp.drupal.org/files/projects/civicrm_cron-7.x-2.0-beta2.zip"
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
libraries[ckeditor][download][url] = "https://download.cksource.com/CKEditor/CKEditor/CKEditor%204.18.0/ckeditor_4.18.0_standard.zip"
libraries[ckeditor][destination] = libraries
libraries[ckeditor][directory_name] = ckeditor

libraries[tinymce][download][type] = get
libraries[tinymce][download][url] = "http://download.ephox.com/tinymce/community/tinymce_4.5.7.zip"
libraries[tinymce][destination] = libraries
libraries[tinymce][directory_name] = tinymce

#Changelog

## June 1, 2022

Security upgrade: CiviCRM 5.47.4 to CiviCRM 5.49.4.

## July 5, 2018

Fixed a minor error with the install profile.

Updated Webform CiviCRM.

## June 13, 2018

### Update to CiviCRM 5.2.1

CiviCRM is now set to 5.2.1 and includes database changes. There are no major issues with the upgrade.

## May 19, 2018.

### Removed Drupal modules from profile.

To streamline the profile and because it's easier to let people choose for themselves the modules they want to use, these modules have been removed from the profile:
backup_migrate-7.x-3.4, fontyourface-7.x-2.8, imce-7.x-1.11, imce_wysiwyg-7.x-1.0.

If you are using any of them you'll need to move them to your `sites/all/modules` directory.

**WARNING**: you should rebuild the class registry to avoid PHP fatal errors and also clear the cache. Using terminus is the best approach: 

`terminus drush site-name.env rr`
`terminus drush site-name.environment cc all`

See also https://www.drupal.org/project/registry_rebuild if you prefer not to use terminus.

### Updated CKEditor

Updated CKEditor to the latest security release 4.9.2 that will work with Drupal 7's WYSIWYG.

## April 24, 2018

### Update to CiviCRM 5.0.1

Made some updates to the settings that are optional, including getting smarter about setting the base url, use the tokens to most of the paths and directories, and setting the CiviCRM environment (dev, staging, live) based on Pantheon's environment. For all environments but live, CiviCRM will now prevent scheduled tasks and mailings from running.

New sites will inherit these new settings from the settings template. Otherwise you can apply them manually by looking at default.civicrm.settings.php.

## March 2, 2018

### Update to CiviCRM templates compiling.

We have removed the patch to optionally store compiled templates in Redis. This approach is no longer recommended. Instead, based on Pantheon's recommendations, you should store compiled templates in the `/tmp` folder. You will need to update your `civicrm.settings.php` file to assign `CIVICRM_TEMPLATE_COMPILEDIR` to the `/tmp` directory. Compare your live settings file to `sites/default/default.civicrm.settings.php`. Specifically `CIVICRM_TEMPLATE_COMPILEDIR` should look like this:

```
if (isset($pantheon_conf)) {
    define('CIVICRM_TEMPLATE_COMPILEDIR', '/srv/bindings/' . $pantheon_conf['pantheon_binding'] . '/tmp/civicrm/templates_c/');
  }
```

The technical reason for the change. Storing templates in Redis seemed to help with performance because it avoided writing generated PHP files to a network file system. However, storing in Redis meant we couldn't take advantage of "opcache" by PHP since the PHP wasn't written to files. Pantheon recommends writing generated PHP files to the local machine in something like the temp directory. This is a good recommendation for any setup that needs to support multiple webservers. [Read more](https://lab.civicrm.org/dev/cloud-native/issues/1#note_3120)

## September, 2017

### Upgrading to CiviCRM 4.7.

If you require support in upgrading from CiviCRM 4.6 to 4.7 please contact us at [CiviCRM Starterkit](http://civicrmstarterkit.org/contact).

You will see the update in the Pantheon dashboard. Make sure to make a backup of your database if you don't already have a regular backup schedule.

Testing the upgrade is super important. We recommend testing it on the dev environment with a clone of the live database, or if you have access to Multidev, then a fresh environment and branch so that you don't bottleneck other code updates while you're testing this major upgrade.

**Required changes for 4.7**

There are a number of changes to the settings file so we've included a template at `sites/default/default.civicrm.settings.php` with instructions on what to copy over if you've got an existing site. New sites will still have a settings file automatically created.

Steps for upgrading:

1. Disable each extension at `civicrm/admin/extensions?reset=1`.
2. Disable all CiviCRM integration modules (`admin/modules`), that is, modules that list CiviCRM as a dependency. The exception being Civitheme and CiviCRM itself.
3. Backup the database, files and code using Pantheon's backup tool first.
4. Merge the updates visible in Pantheon's admin interface.
5. Rename `civicrm.settings.php` to `old.civicrm.settings.php` and rename `default.civicrm.settings.php` to `civicrm.settings.php`.
6. In `civicrm.settings.php` replace each instance of a variable with double percentage signs. For instance, replace `%%siteKey%%` with `CIVICRM_SITE_KEY` and replace `%%baseURL%%` with `CIVICRM_UF_BASEURL`, by copying it over from the old.civicrm.settings.php file. Note that most of the settings are set to be generated automatically so there is just a minimal number of variables to edit manually to have a functioning site in Pantheon. The one exception is if you would also like to be able to work on the site on your own computer which requires you to add paths for each `else` statement: `if (isset($pantheon_conf)) {} else {` EDIT HERE `}`.
7. Commit your new `civicrm.settings.php` file and ftp or git push it to Pantheon.
8. Upgrade the database. Two options: go to `http://<your_drupal_home>/civicrm/upgrade?reset=1` or use `terminus drush site.env civicrm-upgrade-db` where "env" is dev, test, live or the name of the Multidev.
9. If you've got extensions switch to SFTP mode and go to `civicrm/admin/extensions?reset=1` to check and download any extension updates.
10. If there are extension database updates, make another backup of the database and click the update link in the Extension dashboard.
11. Commit any extension code updates and switch back to git mode.
12. Enable extensions and CiviCRM integration modules.
13. Verify Drupal role-based permissions which were added in recent releases. You can review and update these at `admin/people/permissions`.
14. If you were using Views integration prior to this upgrade, you will need to go to `admin/structure/views/settings/advanced` and press "Clear Views cache" for Views to capture changes in the CiviCRM Views integration code.
15. Clear CiviCRM caches by clicking "Cleanup Caches" at `civicrm/admin/setting/updateConfigBackend?reset=1`
16. Rebuild CiviCRM templates by first enabling debugging at `civicrm/admin/setting/debug?reset=1` and then pasting `&directoryCleanup=1` to the end of the URL so it looks like `civicrm/admin/setting/debug?reset=1&directoryCleanup=1` and hitting Enter. Once that's done loading disable debugging again if on live.

When you are ready to deploy the upgrade to live, put the live site into maintenance mode. You then have two options: one, you can copy the live database to dev or test and rerun the upgrade and then copy the database to live. Or two, rerun the relevant steps above on live (backup the database and files; disable extensions and CiviCRM integration modules; push the code update to live and run the database upgrade).

It is also useful to consult the [guide on upgrading CiviCRM on Drupal 7](https://wiki.civicrm.org/confluence/display/CRMDOC/Upgrading+CiviCRM+for+Drupal+7). On Pantheon the above steps overrule some of the steps in the latter guide but it is still useful to reference.

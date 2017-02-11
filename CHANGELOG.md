# Changelog

## 2017-02-11 Release 1.1.0

This is the last release with Puppet3 support!

* Fix wrong requirements in metadata.json
* Sync metadata.json license to be same as LICENSE
* Set min version_requirement for Puppet + deps

##2015-12-04 Release 1.0.2
###Summary

####Bugfixes
- fixed issue install dotnet 4.5.2


##2015-03-23 Release 1.0.1
###Summary

- puppet-community release


##2014-10-16 Release 1.0.0
###Summary

####Features

- updating documentation to meet standard
- refactored the tests
- added support for 4.5.1 and 4.5.2
- added param package_dir that allows you do download to a directory other than C:\Windows\Temp
- adding support for downloading from the web using opentable/download_file when not specifying the package_dir

####Bugfixes

- fixing bug in operatingsystemversion checks
- fixing error when running with strict_variables
- updating powershell dependency from joshcopper to puppetlabs

##2013-05-01 Release 0.0.2
###Summary

####Features

- refactored into define type to allow for side-by-side install of 3.5 and 4.x

####Bugfixes

- fixed warning about string escaping on puppet 3.x

##2013-04-25 Release 0.0.1
###Summary

  Initial release. Intalls 3.5, 4.0 and 4.5

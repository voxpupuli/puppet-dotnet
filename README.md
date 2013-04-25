Puppet module for installing and managing [Microsoft .NET framework]().

This module is also available on the [Puppet Forge](https://forge.puppetlabs.com/liamjbennett/dotnet)

[![Build
Status](https://secure.travis-ci.org/liamjbennett/puppet-dotnet.png)](http://travis-ci.org/liamjbennett/puppet-dotnet)
[![Dependency
Status](https://gemnasium.com/liamjbennett/puppet-dotnet.png)](http://gemnasium.com/liamjbennett/puppet-dotnet)

## Configuration ##
The dotnet class has some defaults that can be overridden using hiera:

**```version```** - The version of the .NET framework to be managed [3.5|4|4.5]   
**```ensure```**  - The state of the framework on the machine [present|absent]   
**```windows_deployment_root```** - A defined network location with which the binaries are stored.   

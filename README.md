Puppet module for installing and managing [Microsoft .NET framework]().

This module is also available on the [Puppet Forge](https://forge.puppetlabs.com/liamjbennett/dotnet)

[![Build
Status](https://secure.travis-ci.org/liamjbennett/puppet-dotnet.png)](http://travis-ci.org/liamjbennett/puppet-dotnet)
[![Dependency
Status](https://gemnasium.com/liamjbennett/puppet-dotnet.png)](http://gemnasium.com/liamjbennett/puppet-dotnet)

## Configuration ##
The dotnet class has some defaults that can be overridden, for instance if you wanted a specific version of .NET

	class { 'dotnet': version => '3.5' }

It is also important to note that you must specifify the ```deployment_root``` which is a network share where the binaries are stored. This can either be set as a parameter or in your hiera configuration.

## Requirements ##

Tested against puppet versions 2.7.x and 3.x.x

These modules will also get installed as a dependency for this module:

puppetlabs/stdlib
joshcooper/powershell
liamjbennett/win_facts

Please see the ModuleFile for further details.


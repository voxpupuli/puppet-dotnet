# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   MIT

# == Define: dotnet
#
# Module to install the Microsoft .NET framework on windows
#
# === Requirements/Dependencies
#
# Currently reequires the puppetlabs/stdlib module on the Puppet Forge in
# order to validate much of the the provided configuration.
#
# === Parameters
#
# [*ensure*]
# Control the state of the .NET installation
#
# [*version*]
# The version of .NET to be managed
#
# [*package_dir*]
# If installing .NET from a directory or a mounted network location then this is that directory
#
# === Examples
#
#  Installing .NET 4.5
#
#    dotnet { 'dotnet45':
#      version => '4.5',
#    }
#
define dotnet(
  $ensure  = 'present',
  $version = '',
  $package_dir = ''
) {

  validate_re($ensure,['^(present|absent)$'])
  validate_re($version,['^(3.5|4\.0|4\.5(\.\d)?)$'])

  include dotnet::params

  case $version {
    '3.5': {
      case $::operatingsystemversion {
        /^Windows.Server.(2008|2012).?(R2)?.*/: { $type = 'feature' }
        /^Windows (XP|Vista|7|8|8.1).*/: { $type = 'package' }
        default: { err("dotnet ${version} is not support on this version of windows") }
      }
    }
    '4.0': {
      case $::operatingsystemversion {
        /^Windows.(Server)?.?(2003|2008|2012|XP|Vista|7|8.*).?(R2)?.*/: { $type = 'package' }
        default: { err("dotnet ${version} is not support on this version of windows") }
      }
    }
    /4\.5(\.\d)?/: {
      case $::operatingsystemversion {
        /^Windows.(Server)?.?(2008|2012|Vista|7|8.*).?(R2)?.*/: { $type = 'package' }
        default: { err("dotnet ${version} is not support on this version of windows") }
      }
    }
    default: {
      err("dotnet does not have a version: ${version}")
    }
  }

  if $type == 'feature' {
    dotnet::install::feature { "dotnet-feature-${version}":
      ensure  => $ensure,
      version => $version
    }
  } elsif $type == 'package' {
    dotnet::install::package { "dotnet-package-${version}":
      ensure     => $ensure,
      version    => $version,
      package_dir => $package_dir
    }
  } else {

  }
}

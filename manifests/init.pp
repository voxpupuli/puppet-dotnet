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
  Enum['3.5', '4.0', '4.5.1', '4.5.2']
  $version,

  Enum['present', 'absent']
  $ensure = 'present',

  Variant[String, Undef]
  $package_dir = undef,
) {

  include dotnet::params

  if $::os['family'] != 'windows' {
    fail("dotnet ${version} is not supported on ${::os['family']}")
  }

  $windows_version = $::os['release']['full']

  case $version {
    '3.5': {
      case $windows_version {
        /^2008/, /^2012/:  { $type = 'feature' }
        /^2003/, 'XP', 'Vista', '7', '8', '8.1': { $type = 'package' }
        default: { $type = 'err' }
      }
    }
    '4.0': {
      case $windows_version {
        /^2012/, '8', '8.1': { $type = 'builtin' }
        /^2003/, /^2008/, 'XP', 'Vista', '7': { $type = 'package' }
        default: { $type = 'err' }
      }
    }
    '4.5': {
      case $windows_version {
        /^2012/, '8', '8.1': { $type = 'builtin' }
        /^2003/, /^2008/, 'XP', 'Vista', '7': { $type = 'package' }
        default: { $type = 'err' }
      }
    }
    '4.5.1': {
      case $windows_version {
        '2012 R2', '8.1': { $type = 'builtin' }
        /^2003/, /^2008/, '2012', 'XP', 'Vista', '7', '8': { $type = 'package' }
        default: { $type = 'err' }
      }
    }
    '4.5.2': {
      case $windows_version {
        /^2003/, /^2008/, /^2012/, 'XP', 'Vista', '7', '8', '8.1': { $type = 'package' }
        default: { $type = 'err' }
      }
    }
    default: { $type = 'err' }
  }

  if $type == 'feature' {
    dotnet::install::feature { "dotnet-feature-${version}":
      ensure  => $ensure,
      version => $version,
    }
  } elsif $type == 'package' {
    dotnet::install::package { "dotnet-package-${version}":
      ensure      => $ensure,
      version     => $version,
      package_dir => $package_dir,
    }
  } elsif $type == 'builtin' {
    # This .NET version is built into the OS. No configuration required.
  } else {
    fail("dotnet ${version} is not supported on windows ${windows_version}")
  }

}

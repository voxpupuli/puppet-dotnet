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
  Enum['3.5', '4.0', '4.5', '4.5.1', '4.5.2']
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
        /^2012/: {
          $type    = 'feature'
          $feature = 'NET-Framework-Features'
        }
        '2008 R2': {
          $type    = 'feature'
          $feature = 'AS-NET-Framework'
        }
        '7', '8', '8.1':                { $type = 'dism'    }
        /^2003/, '2008', 'XP', 'Vista': { $type = 'package' }
        default:                        { $type = 'err'     }
      }
    }
    '4.0': {
      case $windows_version {
        /^2012/, '8', '8.1':                  { $type = 'builtin' }
        /^2003/, /^2008/, 'XP', 'Vista', '7': { $type = 'package' }
        default:                              { $type = 'err'     }
      }
    }
    '4.5': {
      case $windows_version {
        /^2012/, '8', '8.1':                  { $type = 'builtin' }
        /^2003/, /^2008/, 'XP', 'Vista', '7': { $type = 'package' }
        default:                              { $type = 'err'     }
      }
    }
    '4.5.1': {
      case $windows_version {
        '2012 R2', '8.1':                                  { $type = 'builtin' }
        /^2003/, /^2008/, '2012', 'XP', 'Vista', '7', '8': { $type = 'package' }
        default:                                           { $type = 'err'     }
      }
    }
    '4.5.2': {
      case $windows_version {
        /^2003/, /^2008/, /^2012/, 'XP', 'Vista', '7', '8', '8.1': { $type = 'package' }
        default:                                                   { $type = 'err'     }
      }
    }
    default: { $type = 'err' }
  }

  case $type {
    'feature': {
      dotnet::install::feature { "dotnet-feature-${version}":
        ensure  => $ensure,
        version => $version,
        feature => $feature,
        source  => $package_dir,
      }
    }
    'dism': {
      dotnet::install::dism { "dotnet-dism-${version}":
        ensure  => $ensure,
        version => $version,
      }
    }
    'package': {
      dotnet::install::package { "dotnet-package-${version}":
        ensure      => $ensure,
        version     => $version,
        package_dir => $package_dir,
      }
    }
    'builtin': {
      # This .NET version is built into the OS. No configuration required.
    }
    default: {
      fail("dotnet ${version} is not supported on windows ${windows_version}")
    }
  }

}

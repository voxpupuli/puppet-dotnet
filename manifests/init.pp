# @summary Module to install the Microsoft .NET framework on Windows.
# @param version The version of .NET to be managed.
# @param ensure Control the state of the .NET installation.
# @param package_dir If installing .NET from a directory or a mounted network location then this is that directory.
# @example Installing .NET 4.5
#  dotnet { 'dotnet45':
#    version => '4.5',
#  }
define dotnet (
  Pattern[/^(3.5|4\.0|4\.5(\.\d)?)$/] $version,
  Enum['present', 'absent'] $ensure = 'present',
  $package_dir                      = ''
) {
  include dotnet::params

  case $version {
    '3.5': {
      case $::operatingsystemversion {
        /^Windows.Server.(2008|2012).?(R2)?.*/: { $type = 'feature' }
        /^Windows (XP|Vista|7|8|8.1).*/: { $type = 'package' }
        default: { $type = 'err' err("dotnet ${version} is not support on this version of windows") }
      }
    }
    '4.0': {
      case $::operatingsystemversion {
        /^Windows.(Server)?.?(2003|2008|2012|XP|Vista|7|8.*).?(R2)?.*/: { $type = 'package' }
        default: { $type = 'err' err("dotnet ${version} is not support on this version of windows") }
      }
    }
    /4\.5(\.\d)?/: {
      case $::operatingsystemversion {
        /^Windows.(Server)?.?(2008|2012|Vista|7|8.*).?(R2)?.*/: { $type = 'package' }
        default: { $type = 'err' err("dotnet ${version} is not support on this version of windows") }
      }
    }
    default: {
      $type = 'err'
      err("dotnet does not have a version: ${version}")
    }
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
  } else {}
}

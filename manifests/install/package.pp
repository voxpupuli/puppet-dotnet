#
define dotnet::install::package(
  $ensure      = 'present',
  $version     = '',
  $package_dir = ''
) {

  include dotnet::params

  $url       = $dotnet::params::version[$version]['url']
  $exe       = $dotnet::params::version[$version]['exe']
  $package   = $dotnet::params::version[$version]['package']
  $conflicts = $dotnet::params::version[$version]['conflicts']

  if "x${package_dir}x" == 'xx' {
    $source_file = "C:/Windows/Temp/${exe}"
    remote_file { $source_file:
      ensure => $ensure,
      source => $url,
    }
  } else {
    $source_file = "${package_dir}/${exe}"
  }

  package { $package:
    ensure            => $ensure,
    source            => $source_file,
    install_options   => ['/q', '/norestart'],
    uninstall_options => ['/x', '/q', '/norestart'],
  }

  if $ensure == 'present' {
    # Some versions of .NET are in-place upgrades of others. Installation of
    # .NET 4.5, for example, will replace the 4.0 package. In order to disallow
    # Puppet from continuously trying to install .NET 4.0 in the event dotnet
    # resources for both 4.0 and 4.5 have been added to the catalog, create a
    # package=absent resource for each conflicting version. This will cause the
    # conflict to be caught when a catalog is compiled for the node.
    $conflicts.each |$conflict| {
      package { $dotnet::params::version[$conflict]['package']:
        ensure            => absent,
        before            => Package[$package],
        uninstall_options => ['/x', '/q', '/norestart'],
      }
    }
  }

}

#
define dotnet::install::package(
  $ensure      = 'present',
  $version     = '',
  $package_dir = ''
) {

  include dotnet::params

  $url     = $dotnet::params::version[$version]['url']
  $exe     = $dotnet::params::version[$version]['exe']
  $package = $dotnet::params::version[$version]['package']

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

}

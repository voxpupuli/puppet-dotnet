#
define dotnet::install::package(
  $ensure = 'present',
  $version = '',
  $package_dir = ''
) {

  include ::dotnet::params

  $url = $dotnet::params::version[$version]['url']
  $exe = $dotnet::params::version[$version]['exe']
  $key = $dotnet::params::version[$version]['key']


  if "x${package_dir}x" == 'xx' {
    $source_dir = 'C:\Windows\Temp'
    if $ensure == 'present' {
      download_file { "download-dotnet-${version}" :
        url                   => $url,
        destination_directory => $source_dir,
      }
    } else {
      file { "C:/Windows/Temp/${exe}":
        ensure => 'absent',
      }
    }
  } else {
    $source_dir = $package_dir
  }

  $installed = "if (Test-Path \'${key}\') { exit 0 } else { exit 1 }"
  if $ensure == 'present' {
    exec { "install-dotnet-${version}":
      command   => "& ${source_dir}\\${exe} /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => $installed,
      require   => Download_file["download-dotnet-${version}"],
    }
  } else {
    exec { "uninstall-dotnet-${version}":
      command   => "& ${source_dir}\\${exe} /x /q /norestart",
      provider  => powershell,
      logoutput => true,
      onlyif    => $installed,
    }
  }

}

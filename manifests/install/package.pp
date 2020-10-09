# @summary Installs dotnet from a downloaded package.
# @param ensure Control the state of the .NET installation.
# @param version The version of .NET to be managed.
# @param package_dir If installing .NET from a directory or a mounted network location then this is that directory.
define dotnet::install::package (
  $ensure = 'present',
  $version = '',
  $package_dir = ''
) {
  include dotnet::params

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

  if $ensure == 'present' {
    exec { "install-dotnet-${version}":
      command   => "& ${source_dir}\\${exe} /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-Item -LiteralPath \'${key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }",
    }
  } else {
    exec { "uninstall-dotnet-${version}":
      command   => "& ${source_dir}\\${exe} /x /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-Item -LiteralPath \'${key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }",
    }
  }
}

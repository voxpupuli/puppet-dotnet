define dotnet::install::package(
  $ensure = 'present',
  $version = '',
  $source_dir = ''
) {

  include dotnet::params

  $exe = $dotnet::params::version[$version]['exe']
  $key = $dotnet::params::version[$version]['key']


  if "x${source_dir}x" == 'xx' {
    #TODO: add support for downloading the file
  } else {

    if $ensure == 'present' {
      exec { "install-dotnet-${version}":
        command   => "& ${source_dir}\\${exe} /q /norestart",
        provider  => powershell,
        logoutput => true,
        unless    => "if ((Get-Item -LiteralPath \'${key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }"
      }
    } else {
      exec { "uninstall-dotnet-${version}":
        command   => "& ${source_dir}\\${exe} /x /q /norestart",
        provider  => powershell,
        logoutput => true,
        unless    => "if ((Get-Item -LiteralPath \'${key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }"
      }
    }

  }

}

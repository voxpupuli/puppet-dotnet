define dotnet::install::package(
  $ensure = 'present',
  $version = '',
  $package_dir = '',
  $url = '',
  $exe = '',
  $key = ''
) {

  include dotnet::params

  if("x${url}x" == 'xx'){
    $url = $dotnet::params::version[$version]['url']
  }
  if("x${exe}x" == 'xx'){
    $exe = $dotnet::params::version[$version]['exe']
  }
  if("x${key}x" == 'xx'){
    $key = $dotnet::params::version[$version]['key']
  }

  if "x${package_dir}x" == 'xx' {
    $source_dir = "C:\\Windows\\Temp"
    if $ensure == 'present' {
      download_file { "download-dotnet-${version}" :
        url                   => $url,
        destination_directory => $source_dir,
        before                => Exec["configure-dotnet-${version}-${ensure}"],
      }
    } else {
      file { "C:/Windows/Temp/${exe}":
        ensure => absent,
      }
    }
  } else {
    $source_dir = $package_dir
  }

  if $ensure == 'present' {
    exec { "configure-dotnet-${version}-${ensure}":
      command   => "& ${source_dir}\\${exe} /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-Item -LiteralPath \'${key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }",

    }
  } else {
    exec { "configure-dotnet-${version}-${ensure}":
      command   => "& ${source_dir}\\${exe} /x /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-Item -LiteralPath \'${key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }",

    }
  }

}

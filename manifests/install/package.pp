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
    $package_url = $dotnet::params::version[$version]['url']
  } else {
    $package_url = $url
  }
  if("x${exe}x" == 'xx'){
    $package_exe = $dotnet::params::version[$version]['exe']
  } else {
    $package_exe = $exe
  }
  if("x${key}x" == 'xx'){
    $package_key = $dotnet::params::version[$version]['key']
  } else {
    $package_key = $key
  }

  if "x${package_dir}x" == 'xx' {
    $source_dir = "C:\\Windows\\Temp"
    if $ensure == 'present' {
      download_file { "download-dotnet-${version}" :
        url                   => $package_url,
        destination_directory => $source_dir,
        before                => Exec["configure-dotnet-${version}-${ensure}"],
      }
    } else {
      file { "C:/Windows/Temp/${package_exe}":
        ensure => absent,
      }
    }
  } else {
    $source_dir = $package_dir
  }

  if $ensure == 'present' {
    exec { "configure-dotnet-${version}-${ensure}":
      command   => "& ${source_dir}\\${package_exe} /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-Item -LiteralPath \'${package_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }",

    }
  } else {
    exec { "configure-dotnet-${version}-${ensure}":
      command   => "& ${source_dir}\\${package_exe} /x /q /norestart",
      provider  => powershell,
      logoutput => true,
      unless    => "if ((Get-Item -LiteralPath \'${package_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }",

    }
  }

}

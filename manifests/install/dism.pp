#
define dotnet::install::dism (
  $ensure  = 'present',
  $version = '',
) {

  if $ensure == 'present' {
    exec { "install-dotnet-dism-${version}":
      command   => 'DISM /Online /Enable-Feature /FeatureName:NetFx3 /NoRestart',
      creates   => "C:/Windows/Microsoft.NET/Framework/v${version}",
      provider  => powershell,
      logoutput => true,
    }
  } else {
    exec { "uninstall-dotnet-dism-${version}":
      command   => 'DISM /Online /Disable-Feature /FeatureName:NetFx3 /NoRestart',
      onlyif    => "If (-Not(Test-Path C:/Windows/Microsoft.NET/Framework/v${version})) { Exit 1 }",
      provider  => powershell,
      logoutput => true,
    }
  }

}

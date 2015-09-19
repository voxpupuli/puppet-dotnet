#
define dotnet::install::feature(
  $version,
  $ensure  = 'present',
  $feature = 'AS-NET-Framework',
  $source  = undef,
) {

  $source_flag = $source ? {
    undef   => '',
    default => "-source ${source}",
  }

  if $ensure == 'present' {
    exec { "install-dotnet-feature-${version}":
      command   => "Import-Module ServerManager; Add-WindowsFeature ${feature} ${source_flag}",
      provider  => powershell,
      logoutput => true,
      creates   => "C:/Windows/Microsoft.NET/Framework/v${version}",
    }
  } else {
    exec { "uninstall-dotnet-feature-${version}":
      command   => "Import-Module ServerManager; Remove-WindowsFeature ${feature}",
      provider  => powershell,
      logoutput => true,
      onlyif    => "If (-Not(Test-Path C:/Windows/Microsoft.NET/Framework/v${version})) { Exit 1 }",
    }
  }

}

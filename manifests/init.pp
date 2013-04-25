# Class dotnet
#
# This class installs the Microsoft .NET framework on windows
#
class dotnet(
  $deployment_root = 'UNSET',
  $version = 'UNSET',
  $ensure  = 'UNSET',
) {
  
  include dotnet::params
  
  $fixed_deployment_root = $deployment_root ? {
      'UNSET' => $dotnet::params::deployment_root,
      default => $deployment_root
  }
  
  $fixed_version = $version ? {
      'UNSET' => $dotnet::params::version,
      default => $version
  }
  
  $fixed_ensure = $ensure ? {
      'UNSET' => $dotnet::params::ensure,
      default => $ensure
  }

  if $fixed_ensure == 'present' {
    case $fixed_version {
      '3.5': {
        case $::operatingsystemversion {
          'Windows Server 2008','Windows Server 2008 R2','Windows Server 2012': {
            exec { 'install-feature-3.5':
              command   => "${dotnet::params::ps_command} Import-Module ServerManager; Add-WindowsFeature as-net-framework",
              provider  => windows,
              logoutput => true,
              unless    => "${dotnet::params::ps_command} Test-Path C:\Windows\Microsoft.NET\Framework\v3.5",
            }
          }
          'Windows XP','Windows Vista','Windows 7','Windows 8': {
            exec { 'install-dotnet-35':
              command   => "& ${fixed_deployment_root}\\dotNet\\dotNetFx35setup.exe /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::t_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }"
            }
          }
          default: {
            err('dotnet 3.5 is not support on this version of windows')
          }
        }  
      }
      '4': {
        case $::operatingsystemversion {
          'Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows XP','Windows Vista','Windows 7','Windows 8': {
            exec { 'install-dotnet-4':
              command   => "& ${fixed_deployment_root}\\dotNet\\dotNetFx40_Full_x86_x64.exe /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::f_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }"
            }
          }
          default: {
            err('dotnet 4 is not supported on this version of windows')
          }
        }
      }
      '4.5': {
        case $::operatingsystemversion {
          'Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows Vista','Windows 7','Windows 8': {
            exec { 'install-dotnet-45':
              command   => "& ${fixed_deployment_root}\\dotNet\\dotnetfx45_full_x86_x64.exe /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::ff_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 0 }"
            }
          }
          default: {
            err('dotnet 4.5 is not supported on this version of windows')
          }
        }
      }
      default: {
        err("dotnet does not have a version: ${fixed_version}")
      }
    }
  }
  elsif $fixed_ensure == 'absent' {
    case $fixed_version {
      '3.5': {
        case $::operatingsystemversion {
          'Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012': {
            exec { 'uninstall-feature-3.5':
              command   => "${dotnet::params::ps_command} Import-Module ServerManager; Remove-WindowsFeature as-net-framework",
              provider  => windows,
              logoutput => true,
              onlyif    => "${dotnet::params::ps_command} Test-Path C:\Windows\Microsoft.NET\Framework\v3.5",
            }
          }
          'Windows XP','Windows Vista','Windows 7','Windows 8': {
            exec { 'uninstall-dotnet-35':
              command   => "& ${fixed_deployment_root}\\dotNet\\dotNetFx35setup.exe /x /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::t_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }"
            }                 
          }
          default: {
            err('dotnet 3.5 is not supported on this version of windows')
          }
        }  
      }
      '4': {
        case $::operatingsystemversion {
          'Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows XP','Windows Vista','Windows 7','Windows 8': {
            exec { 'uninstall-dotnet-4':
              command   => "& ${fixed_deployment_root}\\dotNet\\dotNetFx40_Full_x86_x64.exe /x /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::f_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }"
            }
          }
          default: {
            err('dotnet 4 is not supported on this version of windows')
          }
        }
      }
      '4.5': {
        case $::operatingsystemversion {
          'Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows Vista','Windows 7','Windows 8': {
            exec { 'uninstall-dotnet-45':
              command   => "& ${fixed_deployment_root}\\dotNet\\dotnetfx45_full_x86_x64.exe /x /q /norestart",
              provider  => powershell,
              logoutput => true,
              unless    => "if ((Get-Item -LiteralPath \'${dotnet::params::ff_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }"
            }
          }
          default: {
            err('dotnet 4.5 is not supported on this version of windows')
          }
        }
      }
    }
  }
  else {
    err("do not understand ensure: ${fixed_ensure}")
  }
}   
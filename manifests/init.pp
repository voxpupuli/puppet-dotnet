# Class dotnet
#
# This class installs the Microsoft .NET framework on windows
#
# Parameters:
#   [*ensure*]          - Control the existence of the framework    
#   [*deployment_root*] - The network location to go and find the package
#   [*version*]         - The version of the framework to install
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#   class { 'dotnet': 
#     version => "4.5"
#   }
class dotnet(
  $ensure = 'present',
  $deployment_root = hiera('windows_deployment_root'), 
  $version = hiera('dotnet_version'),
) {
    
  case $version {
      '3.5': {
        
      }
      '4': {
          
      }
      '4.5': {
        $dotnet_reg_key = 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\{1AD147D0-BE0E-3D6C-AC11-64F6DC4163F1}'
      }
      default: {
        notify { "dotnet does not have a version: ${version}": }
      }
  }
    
  if $ensure == 'present' {
    case $version {
      '3.5': {
        case $::operatingsystemversion {
          'Windows Server 2008 R2': {
            exec { 'install-3.5':
              command   => 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -executionpolicy remotesigned -Command Import-Module ServerManager; Add-WindowsFeature as-net-framework',
              provider  => windows,
              logoutput => true,
              unless    => 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -executionpolicy remotesigned -Command Test-Path C:\Windows\Microsoft.NET\Framework\v3.5',
            }
          }
          default: {
            #TODO install the exe
          }
        }  
      }
      '4': {
        exec { 'install-dotnet-4':
          command   => "& ${deployment_root}\\dotNet\\dotNetFx40_Full_x86_x64.exe /q /norestart",
          provider  => powershell,
          logoutput => true,
          unless    => "if (Get-Item -LiteralPath \'\\${dotnet_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }"
        } 
      }
      '4.5': {
        exec { 'install-dotnet-45':
          command   => "& ${deployment_root}\\dotNet\\dotnetfx45_full_x86_x64.exe /q /norestart",
          provider  => powershell,
          logoutput => true,
          unless    => "if (Get-Item -LiteralPath \'\\${dotnet_reg_key}\' -ErrorAction SilentlyContinue).GetValue(\'DisplayVersion\')) { exit 1 }"
        }
      }
      default: {
        notify { "dotnet does not have a version: ${version}": }
      }
    }
  }
  elsif $ensure == 'absent' {
	  #TODO remove
  }
  else {
    notify { "do not understand ensure: ${ensure}": }
  }
}   
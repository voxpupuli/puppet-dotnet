# Author::    Liam Bennett (mailto:liamjbennett@gmail.com)
# Copyright:: Copyright (c) 2014 Liam Bennett
# License::   MIT

# == Class dotnet::params
#
# This class is meant to be called from `dotnet`
# It sets variables according to platform
#
class dotnet::params {

  $version = {
    '3.5' => {
      'exe' => 'dotNetFx35setup.exe',
      'key' => 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{CE2CDD62-0124-36CA-84D3-9F4DCF5C5BD9}'
    },
    '4.0' => {
      'exe' => 'dotNetFx40_Full_x86_x64.exe',
      'key' => 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8E34682C-8118-31F1-BC4C-98CD9675E1C2}'
    },
    '4.5' => {
      'exe' => 'dotnetfx45_full_x86_x64.exe',
      'key' => 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1AD147D0-BE0E-3D6C-AC11-64F6DC4163F1}'
    }
  }
}

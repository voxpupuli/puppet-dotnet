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
      'url' => 'http://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe',
      'exe' => 'dotNetFx35setup.exe',
      'key' => 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{CE2CDD62-0124-36CA-84D3-9F4DCF5C5BD9}'
    },
    '4.0' => {
      'url' => 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
      'exe' => 'dotNetFx40_Full_x86_x64.exe',
      'key' => 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{8E34682C-8118-31F1-BC4C-98CD9675E1C2}'
    },
    '4.5' => {
      'url' => 'http://download.microsoft.com/download/b/a/4/ba4a7e71-2906-4b2d-a0e1-80cf16844f5f/dotnetfx45_full_x86_x64.exe',
      'exe' => 'dotnetfx45_full_x86_x64.exe',
      'key' => 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{1AD147D0-BE0E-3D6C-AC11-64F6DC4163F1}'
    }
  }
}

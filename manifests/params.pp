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
      'url'       => 'http://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe',
      'exe'       => 'dotNetFx35setup.exe',
      'conflicts' => [ ],
      'package'   => 'Microsoft .NET Framework 3.5',
    },
    '4.0' => {
      'url'       => 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe',
      'exe'       => 'dotNetFx40_Full_x86_x64.exe',
      'conflicts' => ['4.5', '4.5.1', '4.5.2'],
      'package'   => [
        'Microsoft .NET Framework 4 Extended',
        'Microsoft .NET Framework 4 Client Profile',
      ],
    },
    '4.5'         => {
      'url'       => 'http://download.microsoft.com/download/b/a/4/ba4a7e71-2906-4b2d-a0e1-80cf16844f5f/dotnetfx45_full_x86_x64.exe',
      'exe'       => 'dotnetfx45_full_x86_x64.exe',
      'conflicts' => ['4.0', '4.5.1', '4.5.2'],
      'package'   => 'Microsoft .NET Framework 4.5',
    },
    '4.5.1' => {
      'url'       => 'http://download.microsoft.com/download/1/6/7/167F0D79-9317-48AE-AEDB-17120579F8E2/NDP451-KB2858728-x86-x64-AllOS-ENU.exe',
      'exe'       => 'NDP451-KB2858728-x86-x64-AllOS-ENU.exe',
      'conflicts' => ['4.0', '4.5', '4.5.2'],
      'package'   => 'Microsoft .NET Framework 4.5.1',
    },
    '4.5.2' => {
      'url'       => 'http://download.microsoft.com/download/E/2/1/E21644B5-2DF2-47C2-91BD-63C560427900/NDP452-KB2901907-x86-x64-AllOS-ENU.exe',
      'exe'       => 'NDP452-KB2901907-x86-x64-AllOS-ENU.exe',
      'conflicts' => ['4.0', '4.5', '4.5.1'],
      'package'   => 'Microsoft .NET Framework 4.5.2',
    },
  }

}

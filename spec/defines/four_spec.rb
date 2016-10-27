require 'spec_helper'
# rubocop:disable RSpec/InstanceVariable
describe 'dotnet', type: :define do
  before do
    @hklm = 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall'

    @four_url = 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe'
    @four_prog = 'dotNetFx40_Full_x86_x64.exe'
    @four_reg = '{8E34682C-8118-31F1-BC4C-98CD9675E1C2}'
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012', 'Windows XP', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context "with ensure => present, version => 4.0, os => #{os}, network package" do
      let(:title) { 'dotnet4' }
      let(:params) do
        {
          ensure: 'present',
          version: '4.0',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_exec('install-dotnet-4.0').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@four_prog} /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
        )
      end
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012', 'Windows XP', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context "with ensure => present, version => 4.0, os => #{os}, download package" do
      let(:title) { 'dotnet4' }
      let(:params) do
        {
          ensure: 'present',
          version: '4.0'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_download_file('download-dotnet-4.0').with(
          'url'                   => @four_url,
          'destination_directory' => 'C:\\Windows\\Temp'
        )
      end

      it do
        is_expected.to contain_exec('install-dotnet-4.0').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@four_prog} /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
        )
      end
    end
  end

  ['unknown'].each do |os|
    context "with ensure => present, version => 4.0, os => #{os}" do
      let(:title) { 'dotnet4' }
      let(:params) do
        {
          ensure: 'present',
          version: '4.0',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it { is_expected.to_not contain_exec('install-dotnet-4.0') }
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012', 'Windows XP', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context "with ensure => absent, version => 4.0, os => #{os}" do
      let(:title) { 'dotnet4' }
      let(:params) do
        {
          ensure: 'absent',
          version: '4.0',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_exec('uninstall-dotnet-4.0').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@four_prog} /x /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
        )
      end
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012', 'Windows XP', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context "with ensure => absent, version => 4.0, os => #{os}, download package" do
      let(:title) { 'dotnet4' }
      let(:params) do
        {
          ensure: 'absent',
          version: '4.0'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_file("C:/Windows/Temp/#{@four_prog}").with(
          'ensure' => 'absent'
        )
      end

      it do
        is_expected.to contain_exec('uninstall-dotnet-4.0').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@four_prog} /x /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
        )
      end
    end
  end

  ['unknown'].each do |os|
    context "with ensure => absent, version => 4.0, os => #{os}" do
      let(:title) { 'dotnet4' }
      let(:params) do
        {
          ensure: 'absent',
          version: '4.0',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it { is_expected.to_not contain_exec('uninstall-dotnet-4.0') }
    end
  end
end

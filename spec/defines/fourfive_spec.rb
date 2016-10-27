require 'spec_helper'
# rubocop:disable RSpec/InstanceVariable
describe 'dotnet', type: :define do
  before do
    @hklm = 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall'

    @four_five_url = 'http://download.microsoft.com/download/b/a/4/ba4a7e71-2906-4b2d-a0e1-80cf16844f5f/dotnetfx45_full_x86_x64.exe'
    @four_five_prog = 'dotnetfx45_full_x86_x64.exe'
    @four_five_reg = '{1AD147D0-BE0E-3D6C-AC11-64F6DC4163F1}'
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context "with ensure => present, version => 4.5, os => #{os}, network package" do
      let(:title) { 'dotnet45' }
      let(:params) do
        {
          ensure: 'present',
          version: '4.5',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_exec('install-dotnet-4.5').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@four_five_prog} /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_five_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
        )
      end
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context "with ensure => present, version => 4.5, os => #{os}, download package" do
      let(:title) { 'dotnet45' }
      let(:params) do
        {
          ensure: 'present',
          version: '4.5'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_download_file('download-dotnet-4.5').with(
          'url'                   => @four_five_url,
          'destination_directory' => 'C:\\Windows\\Temp'
        )
      end

      it do
        is_expected.to contain_exec('install-dotnet-4.5').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@four_five_prog} /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_five_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
        )
      end
    end
  end

  ['unknown', 'Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    context "with ensure => present, version => 4.5, os => #{os}" do
      let(:title) { 'dotnet45' }
      let(:params) do
        {
          ensure: 'present',
          version: '4.5',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it { is_expected.to_not contain_exec('install-dotnet-4.5') }
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context 'with ensure => absent, version => 4.5' do
      let(:title) { 'dotnet45' }
      let(:params) do
        {
          ensure: 'absent',
          version: '4.5',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_exec('uninstall-dotnet-4.5').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@four_five_prog} /x /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_five_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
        )
      end
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012', 'Windows Vista', 'Windows 7', 'Windows 8'].each do |os|
    context 'with ensure => absent, version => 4.5, download package' do
      let(:title) { 'dotnet45' }
      let(:params) do
        {
          ensure: 'absent',
          version: '4.5'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it do
        is_expected.to contain_file("C:/Windows/Temp/#{@four_five_prog}").with(
          'ensure' => 'absent'
        )
      end

      it do
        is_expected.to contain_exec('uninstall-dotnet-4.5').with(
          'provider'  => 'powershell',
          'logoutput' => 'true',
          'command'   => "& C:\\Windows\\Temp\\#{@four_five_prog} /x /q /norestart",
          'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_five_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
        )
      end
    end
  end

  ['unknown', 'Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    context "with ensure => absent, version => 4.5, os => #{os}" do
      let(:title) { 'dotnet45' }
      let(:params) do
        {
          ensure: 'absent',
          version: '4.5',
          package_dir: 'C:\\Windows\\Temp'
        }
      end
      let(:facts) do
        {
          operatingsystemversion: os
        }
      end

      it { is_expected.to_not contain_exec('uninstall-dotnet-4.5') }
    end
  end
end

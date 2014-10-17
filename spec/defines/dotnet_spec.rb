require 'spec_helper'

describe 'dotnet', :type => :define do

  before {
    @hklm = 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall'

    @three_url = 'http://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe'
    @three_prog = 'dotNetFx35setup.exe'
    @three_reg = '{CE2CDD62-0124-36CA-84D3-9F4DCF5C5BD9}'

    @four_url = 'http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe'
    @four_prog = 'dotNetFx40_Full_x86_x64.exe'
    @four_reg = '{8E34682C-8118-31F1-BC4C-98CD9675E1C2}'

    @four_five_url = 'http://download.microsoft.com/download/b/a/4/ba4a7e71-2906-4b2d-a0e1-80cf16844f5f/dotnetfx45_full_x86_x64.exe'
    @four_five_prog = 'dotnetfx45_full_x86_x64.exe'
    @four_five_reg = '{1AD147D0-BE0E-3D6C-AC11-64F6DC4163F1}'

    @deployment_root = 'C:\\Windows\\Temp'
  }

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}, server feature" do
      let :title do 'dotnet35' end
      let :params do
        { :ensure => 'present', :version => '3.5'}
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_exec('install-feature-3.5').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "Import-Module ServerManager; Add-WindowsFeature as-net-framework",
        'unless'    => "Test-Path C:\\Windows\\Microsoft.NET\\Framework\\v3.5"
      )}
    end
  end

  ['unknown','Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}, server feature" do
      let :title do 'dotnet35' end
      let :params do
        { :ensure => 'present', :version => '3.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should_not contain_exec('install-feature-3.5') }
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012'].each do |os|
    context "with ensure => absent, version => 3.5, os => #{os}, server feature" do
      let :title do 'dotnet35' end
      let :params do
        { :ensure => 'absent', :version => '3.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_exec('uninstall-feature-3.5').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "Import-Module ServerManager; Remove-WindowsFeature as-net-framework",
        'onlyif'    => "Test-Path C:\\Windows\\Microsoft.NET\\Framework\\v3.5"
      )}
    end
  end

  ['Windows XP', 'Windows Vista', 'Windows 7','Windows 8'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}, network package" do
      let :title do 'dotnet35' end
      let :params do
        { :ensure => 'present', :version => '3.5', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_exec('install-dotnet-3.5').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@three_prog} /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@three_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
      )}
    end
  end

  ['Windows XP', 'Windows Vista', 'Windows 7','Windows 8'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}, download package" do
      let :title do 'dotnet35' end
      let :params do
        { :ensure => 'present', :version => '3.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_download_file('download-dotnet-3.5').with(
        'url'                   => @three_url,
        'destination_directory' => 'C:\\Windows\\Temp'
      ) }

      it { should contain_exec('install-dotnet-3.5').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@three_prog} /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@three_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
      )}
    end
  end

  ['unknown'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}" do
      let :title do 'dotnet35' end
      let :params do
        { :ensure => 'present', :version => '3.5', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should_not contain_exec('install-dotnet-35')}
    end
  end

  ['Windows XP', 'Windows Vista', 'Windows 7','Windows 8'].each do |os|
    context "with ensure => absent, version => 3.5, os => #{os}" do
      let :title do 'dotnet35' end
      let :params do
        { :ensure => 'absent', :version => '3.5', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_exec('uninstall-dotnet-3.5').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@three_prog} /x /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@three_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
      )}
    end
  end

  ['Windows XP', 'Windows Vista', 'Windows 7','Windows 8'].each do |os|
    context "with ensure => absent, version => 3.5, os => #{os}, download package" do
      let :title do 'dotnet35' end
      let :params do
        { :ensure => 'absent', :version => '3.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_file("C:/Windows/Temp/#{@three_prog}").with(
        'ensure' => 'absent'
      )}

      it { should contain_exec('uninstall-dotnet-3.5').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@three_prog} /x /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@three_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
      )}
    end
  end

  ['unknown'].each do |os|
    context "with ensure => absent, version => 3.5, os => #{os}" do
      let :title do 'dotnet35' end
      let :params do
        { :ensure => 'absent', :version => '3.5', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should_not contain_exec('uninstall-dotnet-3.5')}
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows XP','Windows Vista','Windows 7','Windows 8'].each do |os|
    context "with ensure => present, version => 4.0, os => #{os}, network package" do
      let :title do 'dotnet4' end
      let :params do
        { :ensure => 'present', :version => '4.0', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_exec('install-dotnet-4.0').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@four_prog} /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
      )}

    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows XP','Windows Vista','Windows 7','Windows 8'].each do |os|
    context "with ensure => present, version => 4.0, os => #{os}, download package" do
      let :title do 'dotnet4' end
      let :params do
        { :ensure => 'present', :version => '4.0' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_download_file('download-dotnet-4.0').with(
        'url'                   => @four_url,
        'destination_directory' => 'C:\\Windows\\Temp'
      ) }

      it { should contain_exec('install-dotnet-4.0').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@four_prog} /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
      )}

    end
  end

  ['unknown'].each do |os|
    context "with ensure => present, version => 4.0, os => #{os}" do
      let :title do 'dotnet4' end
      let :params do
        { :ensure => 'present', :version => '4.0', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should_not contain_exec('install-dotnet-4.0') }
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows XP','Windows Vista','Windows 7','Windows 8'].each do |os|
    context "with ensure => absent, version => 4.0, os => #{os}" do
      let :title do 'dotnet4' end
      let :params do
        { :ensure => 'absent', :version => '4.0', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_exec('uninstall-dotnet-4.0').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@four_prog} /x /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
      )}
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows XP','Windows Vista','Windows 7','Windows 8'].each do |os|
    context "with ensure => absent, version => 4.0, os => #{os}, download package" do
      let :title do 'dotnet4' end
      let :params do
        { :ensure => 'absent', :version => '4.0', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_file("C:/Windows/Temp/#{@four_prog}").with(
        'ensure' => 'absent'
      )}

      it { should contain_exec('uninstall-dotnet-4.0').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@four_prog} /x /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
      )}
    end
  end

  ['unknown'].each do |os|
    context "with ensure => absent, version => 4.0, os => #{os}" do
      let :title do 'dotnet4' end
      let :params do
        { :ensure => 'absent', :version => '4.0', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should_not contain_exec('uninstall-dotnet-4.0') }
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows Vista','Windows 7','Windows 8'].each do |os|
    context "with ensure => present, version => 4.5, os => #{os}, network package" do
      let :title do 'dotnet45' end
      let :params do
        { :ensure => 'present', :version => '4.5', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_exec('install-dotnet-4.5').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@four_five_prog} /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_five_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
      )}
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows Vista','Windows 7','Windows 8'].each do |os|
    context "with ensure => present, version => 4.5, os => #{os}, download package" do
      let :title do 'dotnet45' end
      let :params do
        { :ensure => 'present', :version => '4.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_download_file('download-dotnet-4.5').with(
        'url'                   => @four_five_url,
        'destination_directory' => 'C:\\Windows\\Temp'
      ) }

      it { should contain_exec('install-dotnet-4.5').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@four_five_prog} /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_five_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
      )}
    end
  end

  ['unknown','Windows Server 2003','Windows Server 2003 R2'].each do |os|
    context "with ensure => present, version => 4.5, os => #{os}" do
      let :title do 'dotnet45' end
      let :params do
        { :ensure => 'present', :version => '4.5', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should_not contain_exec('install-dotnet-4.5') }
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows Vista','Windows 7','Windows 8'].each do |os|
    context 'with ensure => absent, version => 4.5' do
      let :title do 'dotnet45' end
      let :params do
        { :ensure => 'absent', :version => '4.5', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_exec('uninstall-dotnet-4.5').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@four_five_prog} /x /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_five_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
      )}
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows Vista','Windows 7','Windows 8'].each do |os|
    context 'with ensure => absent, version => 4.5, download package' do
      let :title do 'dotnet45' end
      let :params do
        { :ensure => 'absent', :version => '4.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should contain_file("C:/Windows/Temp/#{@four_five_prog}").with(
        'ensure' => 'absent'
      )}

      it { should contain_exec('uninstall-dotnet-4.5').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& C:\\Windows\\Temp\\#{@four_five_prog} /x /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_five_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
      )}
    end
  end

  ['unknown','Windows Server 2003','Windows Server 2003 R2'].each do |os|
    context "with ensure => absent, version => 4.5, os => #{os}" do
      let :title do 'dotnet45' end
      let :params do
        { :ensure => 'absent', :version => '4.5', :package_dir => "C:\\Windows\\Temp" }
      end
      let :facts do
        { :operatingsystemversion => os }
      end

      it { should_not contain_exec('uninstall-dotnet-4.5') }
    end
  end

  ['Windows Server 2012','Windows Server 2008 R2','Windows Server 2008', 'Windows Server 2003','Windows Server 2003 R2','Windows 8','Windows 7','Windows Vista','Windows XP'].each do |os|
    context "with invalid custom param: os => #{os}, version => fubar" do
      let :facts do
        { :operatingsystemversion => os }
      end
      let :title do 'fubar' end
      let :params do
        { :version => 'fubar' }
      end

      it do
        expect {
          should contain_exec('install-dotnet-3.5')
        }.to raise_error(Puppet::Error)
      end
    end
  end

  ['Windows Server 2012','Windows Server 2008 R2','Windows Server 2008', 'Windows Server 2003','Windows Server 2003 R2','Windows 8','Windows 7','Windows Vista','Windows XP'].each do |os|
    context "with invalid custom param: os => #{os}, ensure => fubar" do
      let :facts do
        { :operatingsystemversion => os }
      end
      let :title do 'fubar' end
      let :params do
        { :version => '3.5', :ensure => 'fubar' }
      end

      it do
        expect {
          should contain_exec('install-dotnet-3.5')
        }.to raise_error(Puppet::Error)
      end
    end
  end
end

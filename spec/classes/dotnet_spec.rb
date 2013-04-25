require 'spec_helper'

describe 'dotnet', :type => :class do
  
  before { 
    @powershell_command = 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -executionpolicy remotesigned -Command'
    @hklm = 'HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall'
    
    @three_prog = 'dotNetFx35setup.exe'
    @three_reg = '{CE2CDD62-0124-36CA-84D3-9F4DCF5C5BD9}'
   
    @four_prog = 'dotNetFx40_Full_x86_x64.exe'
    @four_reg = '{8E34682C-8118-31F1-BC4C-98CD9675E1C2}'
  
    @four_five_prog = 'dotnetfx45_full_x86_x64.exe'
    @four_five_reg = '{1AD147D0-BE0E-3D6C-AC11-64F6DC4163F1}' 
  }
  
  let :hiera_data do
    { :windows_deployment_root => '\\test-server\packages' }
  end
  
  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}, server feature" do    
      let :params do
        { :ensure => 'present', :version => '3.5'}
      end      
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should contain_exec('install-feature-3.5').with(
        'provider'  => 'windows',
        'logoutput' => 'true',
        'command'   => "#{@powershell_command} Import-Module ServerManager; Add-WindowsFeature as-net-framework",
        'unless'    => "#{@powershell_command} Test-Path C:\\Windows\\Microsoft.NET\\Framework\\v3.5"
      )}
    end
  end
   
  ['unknown','Windows Server 2003', 'Windows Server 2003 R2'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}, server feature" do
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
      let :params do
        { :ensure => 'absent', :version => '3.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should contain_exec('uninstall-feature-3.5').with(
        'provider'  => 'windows',
        'logoutput' => 'true',
        'command'   => "#{@powershell_command} Import-Module ServerManager; Remove-WindowsFeature as-net-framework",
        'onlyif'    => "#{@powershell_command} Test-Path C:\\Windows\\Microsoft.NET\\Framework\\v3.5"
      )}
    end
  end

  ['Windows XP', 'Windows Vista', 'Windows 7','Windows 8'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}" do
      let :params do
        { :ensure => 'present', :version => '3.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should contain_exec('install-dotnet-35').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& \\test-server\\packages\\dotNet\\#{@three_prog} /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@three_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
      )}
    end
  end
 
  ['unknown'].each do |os|
    context "with ensure => present, version => 3.5, os => #{os}" do
      let :params do
        { :ensure => 'present', :version => '3.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should_not contain_exec('install-dotnet-35')}
    end
  end 
 
  ['Windows XP', 'Windows Vista', 'Windows 7','Windows 8'].each do |os|
    context "with ensure => absent, version => 3.5, os => #{os}" do
      let :params do
        { :ensure => 'absent', :version => '3.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should contain_exec('uninstall-dotnet-35').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& \\test-server\\packages\\dotNet\\#{@three_prog} /x /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@three_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
      )}
    end
  end

  ['unknown'].each do |os|
    context "with ensure => absent, version => 3.5, os => #{os}" do
      let :params do
        { :ensure => 'absent', :version => '3.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should_not contain_exec('uninstall-dotnet-35')}
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows XP','Windows Vista','Windows 7','Windows 8'].each do |os|
    context "with ensure => present, version => 4, os => #{os}" do
      let :params do
        { :ensure => 'present', :version => '4' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should contain_exec('install-dotnet-4').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& \\test-server\\packages\\dotNet\\#{@four_prog} /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
      )}
      
    end
  end
 
  ['unknown'].each do |os|
    context "with ensure => present, version => 4, os => #{os}" do
      let :params do
        { :ensure => 'present', :version => '4' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should_not contain_exec('install-dotnet-4') }
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows XP','Windows Vista','Windows 7','Windows 8'].each do |os|
    context "with ensure => absent, version => 4, os => #{os}" do
      let :params do
        { :ensure => 'absent', :version => '4' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should contain_exec('uninstall-dotnet-4').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& \\test-server\\packages\\dotNet\\#{@four_prog} /x /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
      )}      
    end
  end

  ['unknown'].each do |os|
    context "with ensure => absent, version => 4, os => #{os}" do
      let :params do
        { :ensure => 'absent', :version => '4' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should_not contain_exec('uninstall-dotnet-4') }
    end
  end

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows Vista','Windows 7','Windows 8'].each do |os|
    context "with ensure => present, version => 4.5, os => #{os}" do
      let :params do
        { :ensure => 'present', :version => '4.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should contain_exec('install-dotnet-45').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& \\test-server\\packages\\dotNet\\#{@four_five_prog} /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_five_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 0 }"
      )}
    end
  end

  ['unknown','Windows Server 2003','Windows Server 2003 R2'].each do |os|
    context "with ensure => present, version => 4.5, os => #{os}" do
      let :params do
        { :ensure => 'present', :version => '4.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should_not contain_exec('install-dotnet-45') }
    end
  end 

  ['Windows Server 2008', 'Windows Server 2008 R2', 'Windows Server 2012','Windows Vista','Windows 7','Windows 8'].each do |os|
    context 'with ensure => absent, version => 4.5' do
      let :params do
        { :ensure => 'absent', :version => '4.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
    
      it { should contain_exec('uninstall-dotnet-45').with(
        'provider'  => 'powershell',
        'logoutput' => 'true',
        'command'   => "& \\test-server\\packages\\dotNet\\#{@four_five_prog} /x /q /norestart",
        'unless'    => "if ((Get-Item -LiteralPath '#{@hklm}\\#{@four_five_reg}' -ErrorAction SilentlyContinue).GetValue('DisplayVersion')) { exit 1 }"
      )}
    end
  end

  ['unknown','Windows Server 2003','Windows Server 2003 R2'].each do |os|
    context "with ensure => absent, version => 4.5, os => #{os}" do
      let :params do
        { :ensure => 'absent', :version => '4.5' }
      end
      let :facts do
        { :operatingsystemversion => os }
      end
      
      it { should_not contain_exec('uninstall-dotnet-45') }
    end
  end
end
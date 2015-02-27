require 'spec_helper'

describe 'dotnet', :type => :define do

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
          should contain_exec('configure-dotnet-3.5-present')
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
          should contain_exec('configure-dotnet-3.5-present')
        }.to raise_error(Puppet::Error)
      end
    end
  end
end

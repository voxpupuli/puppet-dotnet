require 'spec_helper'

describe 'dotnet', :type => :define do
  ['2012', '2008 R2', '2008', '2003', '2003 R2', '8', '7', 'Vista', 'XP'].each do |release|
    context "with invalid custom param: os.release.full => #{release}, version => fubar" do
      let(:title) { 'fubar' }
      let :params do
        { :version => 'fubar' }
      end
      let :facts do
        { :os => { 'family' => 'windows', 'release' => { 'full' => release } } }
      end

      it do
        expect { is_expected.to compile }.to raise_error(/parameter/)
      end
    end
  end

  ['Windows Server 2012', 'Windows Server 2008 R2', 'Windows Server 2008', 'Windows Server 2003', 'Windows Server 2003 R2', 'Windows 8', 'Windows 7', 'Windows Vista', 'Windows XP'].each do |os|
    context "with invalid custom param: os => #{os}, ensure => fubar" do
      let :facts do
        { :operatingsystemversion => os }
      end
      let(:title) { 'fubar' }
      let :params do
        { :version => '3.5', :ensure => 'fubar' }
      end

      it do
        expect { should contain_exec('install-dotnet-3.5') }.to raise_error(Puppet::Error)
      end
    end
  end

  ['unknown'].each do |release|
    context "with ensure => present, version => 4.5, os.release.full => #{release}" do
      let(:title) { 'fubar' }
      let :params do
        { :version => '4.5.1', :ensure => 'present' }
      end
      let :facts do
        { :os => { 'family' => 'windows', 'release' => { 'full' => release } } }
      end

      it do
        expect { is_expected.to compile }.to raise_error(/is not supported on windows #{release}/)
      end
    end
  end
end

require 'spec_helper'

describe 'dotnet', type: :define do
  ['Windows Server 2012', 'Windows Server 2008 R2', 'Windows Server 2008', 'Windows Server 2003', 'Windows Server 2003 R2', 'Windows 8', 'Windows 7', 'Windows Vista', 'Windows XP'].each do |os|
    context "with invalid custom param: os => #{os}, version => fubar" do
      let(:title) { 'fubar' }
      let(:params) do
        { version: 'fubar' }
      end
      let(:facts) do
        { operatingsystemversion: os }
      end

      it do
        expect do
          is_expected.to contain_exec('install-dotnet-3.5')
        end.to raise_error(Puppet::Error)
      end
    end
  end

  ['Windows Server 2012', 'Windows Server 2008 R2', 'Windows Server 2008', 'Windows Server 2003', 'Windows Server 2003 R2', 'Windows 8', 'Windows 7', 'Windows Vista', 'Windows XP'].each do |os|
    context "with invalid custom param: os => #{os}, ensure => fubar" do
      let(:title) { 'fubar' }
      let(:params) do
        { version: '3.5', ensure: 'fubar' }
      end
      let(:facts) do
        { operatingsystemversion: os }
      end

      it do
        expect do
          is_expected.to contain_exec('install-dotnet-3.5')
        end.to raise_error(Puppet::Error)
      end
    end
  end
end

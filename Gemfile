source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 3.4.0'
  gem "puppet-lint"
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "puppet-syntax"
  gem "puppetlabs_spec_helper", "0.4.1"
  gem "hiera-puppet-helper"
  gem "beaker"
  gem "beaker-rspec"
	gem "rspec", "2.99.0"

  if ENV['PUPPET_VERSION'] =~ /2\.7/
    gem "hiera"
    gem "hiera-puppet"
  end

end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "vagrant-wrapper"
  gem "puppet-blacksmith"
  gem "guard-rake"
end

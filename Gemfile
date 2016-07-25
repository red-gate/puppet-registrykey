source 'https://rubygems.org'

gem 'puppet-lint'

gem 'test-kitchen', '~> 1.8.0'
# A 'special' version of kitchen-puppet with added support for windows
gem 'kitchen-puppet', :github  => 'red-gate/kitchen-puppet', :ref  => 'windows_support'
gem 'kitchen-vagrant', '~> 0.20.0'

# needed by the vagrant-winrm vagrant plugin which is needed by kitchen-vagrant in order to be able to use winrm
gem 'winrm-fs', '~> 0.4'
gem 'winrm-elevated', '~> 0.4'

# We use serverspec to test the state of our servers
gem 'serverspec', '~> 2.31.1'
# use our fork of specinfra which has a fix for a winrm warning.
# TODO: get that fix back into the main gem...
gem 'specinfra', :github => 'red-gate/specinfra'

# We use rake as our build engine
gem 'rake', '~> 11.1.2'
# This gem tells us how long each rake task takes.
gem 'rake-performance'

# We use r10k to download our puppet modules.
# We do use our own fork which contains a fix/workaround for SSL validation on windows.
gem 'r10k', :github => 'red-gate/r10k', :branch => '2.0.x'

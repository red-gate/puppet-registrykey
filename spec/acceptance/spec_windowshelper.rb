require 'serverspec'
require 'winrm'

set :backend, :winrm
set :os, :family => 'windows'

endpoint = "http://#{ENV['KITCHEN_HOSTNAME']}:#{ENV['KITCHEN_PORT']}/wsman"
username = ENV['KITCHEN_USERNAME']
password = 'vagrant' #sadly, no KITCHEN_PASSWORD variable at the time of writing.

Specinfra.configuration.winrm = ::WinRM::WinRMWebService.new(endpoint, :ssl, :user => username, :pass => password, :basic_auth_only => true).create_executor

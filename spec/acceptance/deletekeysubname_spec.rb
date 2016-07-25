# Encoding: utf-8
require_relative 'spec_windowshelper'

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\MyCompany\MyKey') do
  it { should exist }
  it { should_not have_property('SubName') }
end

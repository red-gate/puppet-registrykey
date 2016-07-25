# Encoding: utf-8
require_relative 'spec_windowshelper'

describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\MyCompany\MyKey') do
  it { should exist }
  it { should have_property_value('SubName', :type_string, "data") }
end

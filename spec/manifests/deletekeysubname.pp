registrykey { 'set MyCompany\MyKey':
  ensure  => 'absent',
  key     => 'HKLM:\SOFTWARE\Wow6432Node\MyCompany\MyKey',
  subName => 'SubName',
}

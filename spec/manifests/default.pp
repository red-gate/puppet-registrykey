
registrykey { 'set MyCompany\MyKey':
  key     => 'HKLM:\SOFTWARE\Wow6432Node\MyCompany\MyKey',
  subName => 'SubName',
  data    => 'data',
}
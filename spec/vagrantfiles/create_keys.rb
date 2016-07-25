Vagrant.configure(2) do |config|
  # Create registry keys so that we can test deleting them actually works
  config.vm.provision "shell", inline: <<-SHELL
    New-Item "HKLM:\\SOFTWARE\\Wow6432Node\\MyCompany\\MyKey" -Type Directory -Force
    New-ItemProperty -Path "HKLM:\\SOFTWARE\\Wow6432Node\\MyCompany\\MyKey" -Name "SubName" -PropertyType "String" -Value "data"
  SHELL
end

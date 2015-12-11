# A simple resource to set a registry key
# Requires powershell
define registrykey ($key, $subName, $data, $type='string') {
  # ensure windows os
  if $::operatingsystem != 'windows'{
    fail("Unsupported OS ${::operatingsystem}")
  }

  if !member(['string', 'expandstring', 'binary', 'dword', 'multistring', 'qword', 'unknown'], $type) {
    fail("Unsupported Type ${type}")
  }

  # Recursively create key if it doesn't exist
  exec { "newregkey_${key}_${subName}":
    command  => "New-Item \"${key}\" -Type Directory -Force",
    onlyif   => "if( Test-Path \"${key}\" ) { exit 1 }",
    provider => powershell,
  }
  ->
  # Create value if it doesn't exist
  exec { "newregval_${key}_${subName}":
    command  => "New-ItemProperty -Path \"${key}\" -Name \"${subName}\" -PropertyType \"${type}\" -Value \"${data}\"",
    onlyif   => "if( (Get-ItemProperty \"${key}\" -Name \"${subName}\" -ea 0) -ne \$null ) { exit 1 }",
    provider => powershell,
  }
  ->
  # Set value
  exec { "setregval_${key}_${subName}":
    command  => "Set-ItemProperty -Path \"${key}\" -Name \"${subName}\" -Value \"${data}\"  -Type \"${type}\"",
    unless   => "if( (Get-ItemProperty \"${key}\" -Name \"${subName}\").\"${subName}\" -ne \"${data}\" ) { exit 1 }",
    provider => powershell,
  }
}

# A simple resource to set a registry key
# Requires powershell
define registrykey ($key, $ensure='present', $subName = undef, $data = undef, $type='string') {
  # ensure windows os
  if $::operatingsystem != 'windows'{
    fail("Unsupported OS ${::operatingsystem}")
  }

  if !member(['string', 'expandstring', 'binary', 'dword', 'multistring', 'qword', 'unknown'], $type) {
    fail("Unsupported Type ${type}")
  }

  if !member(['present', 'absent'], $ensure) {
    fail("Unsupported value for ensure. (${ensure}). Valid values are 'present', 'absent'")
  }

  if $ensure == 'present' {
    # Recursively create key if it doesn't exist
    exec { "newregkey_${key}_${subName}":
      command  => "New-Item \"${key}\" -Type Directory -Force",
      onlyif   => "if( Test-Path \"${key}\" ) { exit 1 }",
      provider => powershell,
    }

    if $subName != undef {

      if $data == undef {
        fail('If $subName is set, $data should also be set')
      }

      # Create value if it doesn't exist
      exec { "newregval_${key}_${subName}":
        command  => "New-ItemProperty -Path \"${key}\" -Name \"${subName}\" -PropertyType \"${type}\" -Value \"${data}\"",
        onlyif   => "if( (Get-ItemProperty \"${key}\" -Name \"${subName}\" -ea 0) -ne \$null ) { exit 1 }",
        provider => powershell,
        require  => Exec["newregkey_${key}_${subName}"],
      }
      
      if $type == 'multistring' {
        exec { "setregval_${key}_${subName}_${data}": # Include $data in the title here so we can have >1 of them
          command  => "Set-ItemProperty -Path \"${key}\" -Name \"${subName}\" -Value ((Get-ItemProperty \"${key}\" -Name \"${subName}\").\"${subName}\" += \"${data}\") -Type \"${type}\"",
          onlyif   => "if( (Get-ItemProperty \"${key}\" -Name \"${subName}\").\"${subName}\" -contains \"${data}\" ) { exit 1 }",
          provider => powershell,
          require => Exec["newregval_${key}_${subName}"]
        }
      } else {
        exec { "setregval_${key}_${subName}":
          command  => "Set-ItemProperty -Path \"${key}\" -Name \"${subName}\" -Value \"${data}\"  -Type \"${type}\"",
          unless   => "if( (Get-ItemProperty \"${key}\" -Name \"${subName}\").\"${subName}\" -ne \"${data}\" ) { exit 1 }",
          provider => powershell,
          require => Exec["newregval_${key}_${subName}"]
        }
      }

    }
  } else {
    # absent. Delete the key unless it's a multistring and we have a value, in which case we should remove that value only (TODO)
    if $subName != undef {
      if ($type == 'multistring' and $value != undef) {
        fail("ensure => absent not implemented for registrykey of type multistring with specified value")
      } else {
        # Delete the subkey
        exec { "delregval_${key}_${subName}":
          command  => "Remove-ItemProperty -Path \"${key}\" -Name \"${subName}\" -Force",
          onlyif   => "if( (Get-ItemProperty \"${key}\" -Name \"${subName}\" -ea 0) -eq \$null ) { exit 1 }",
          provider => powershell,
        }
      }
    } else {
      # delete the parent key
      exec { "delregval_${key}":
        command  => "Remove-Item -Path \"${key}\" -Force -Recurse",
        onlyif   => "if( (Get-Item \"${key}\" -ea 0) -eq \$null ) { exit 1 }",
        provider => powershell,
      }
    }
  }

}

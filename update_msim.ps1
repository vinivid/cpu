$folders = @('arithmetic', 'control_unit', 'memory')

foreach ($folder in $folders) {
    Copy-Item -Path ".\$folder\*" -Destination ".\msim" -Recurse
    Copy-Item -Path ".\$folder\*" -Destination ".\msimfiles" -Recurse
}

Copy-Item -Path ".\cpu.vhd" -Destination ".\msim" -Recurse
Copy-Item -Path ".\cpu.vhd" -Destination ".\msimfiles" -Recurse

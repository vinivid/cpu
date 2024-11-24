$folders = @('arithmetic', 'control_unit', 'memory')

foreach ($folder in $folders) {
    Copy-Item -Path ".\$folder\*" -Destination ".\cpu_fpga" -Recurse
}

Copy-Item -Path ".\cpu_fpga\*" -Destination ".\cpu_qrt" -Recurse 
# PowerShell script
# You will need to have run this in powershell at least once prior:
# Set-ExecutionPolicy RemoteSigned

write-output "==============================================================="
get-date -displayHint datetime

# This is only for v4.1, get the last v4_1_* build directory to copy from
# Force the get-children results to come back as an array in case there is just one result
$buildList = @(get-childitem -name "\\osp1\build\v4_1_*" | Where-Object {$_ -match "v\d+_\d+_\d+_\d+"} | sort-object)
$lastBuildDir = $buildList[$buildList.Count - 1]
write-output "$lastBuildDir"

exit

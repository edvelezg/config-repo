# PowerShell script
# 2013-10-04 - Richard Hash
#
# Written to update files from the latest build (that I don't normally build), into these dev areas:
#    C:\dev\Prod.OpenSpirit.Dev
#
# You will need to have run this in powershell at least once prior:
# Set-ExecutionPolicy RemoteSigned

$ospDevDir = "C:\dev\Prod.OpenSpirit.v4.1"

write-output "==============================================================="
get-date -displayHint datetime

# This is only for v4.1, get the last v4_1_* build directory to copy from
# Force the get-children results to come back as an array in case there is just one result
$buildList = @(get-childitem -name "\\osp1\build\v4_1_*" | Where-Object {$_ -match "v\d+_\d+_\d+_\d+"} | sort-object)
$lastBuildDir = $buildList[$buildList.Count - 1]
write-output "LastBuildDir=$lastBuildDir"

# ------------------------------------------------
function copyFiles ([array] $srcdest) {
   foreach ($item in $srcdest) {
      $src = $item[0]
      $dest = $item[1]
      write-output "INFO: Copying from '$src' to '$dest'"
   
      if (-not (test-path -path $dest)) {
         # need to create the $dest directory
         write-output "INFO: Needed to create the destination directory '$dest'"
         new-item -path $dest -type directory | out-null
      }
   
      copy-item -force -recurse $src -destination $dest
   }
}
# ------------------------------------------------
$sourceDir = "\\osp1\build\$lastBuildDir"

# Destination must be directory, not file
$files = @(("$sourceDir\lib\Windows_*\",       "$ospDevDir\lib\"),
           ("$sourceDir\lib\*.dll",            "$ospDevDir\lib\"),
           ("$sourceDir\lib\NET\*",            "$ospDevDir\lib\NET\"),
           ("$sourceDir\lib\*.exe",            "$ospDevDir\lib\"),
           ("$sourceDir\plugins\ArcSDECarto\*.dll",     "$ospDevDir\plugins\ArcSDECarto\"),
           ("$sourceDir\plugins\ArcSDECarto\Windows_*", "$ospDevDir\plugins\ArcSDECarto\"),
           ("$sourceDir\plugins\ArcSDECarto\NET",       "$ospDevDir\plugins\ArcSDECarto\"),
           ("$sourceDir\plugins\corba\Windows_*",       "$ospDevDir\plugins\corba\"),
           ("$sourceDir\plugins\corba\NET",             "$ospDevDir\plugins\corba\"),
           ("$sourceDir\plugins\framework\Windows_*",   "$ospDevDir\plugins\framework\"),
           ("$sourceDir\plugins\framework\NET",         "$ospDevDir\plugins\framework\"),
           ("$sourceDir\plugins\geometry\NET",          "$ospDevDir\plugins\geometry\"),
           ("$sourceDir\providers\NET\OpenSpirit\Plugin\Corba\Mico\Gen\*",   "$ospDevDir\providers\NET\OpenSpirit\Plugin\Corba\Mico\Gen\"))

copyFiles $files

exit

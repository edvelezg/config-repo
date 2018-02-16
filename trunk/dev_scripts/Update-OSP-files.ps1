# PowerShell script
# 2010-04-29 - Richard Hash
#
# Written to update files from the latest build (that I don't normally build), into these dev areas:
#    C:\RGH\dev\OpenSpirit-v4.0
#    C:\RGH\dev\OpenSpiritProject-v4.0

$ospDevDir = "C:\dev\OpenSpirit-v4.0"
$ospProjectDevDir = "C:\dev\OpenSpiritProject-v4.0"

write-output "==============================================================="
get-date -displayHint datetime

# This is only for v4.0, get the last v4_0_* build directory to copy from
$buildList = get-childitem -name "\\netapp01a\build\v4_0_*" | sort-object
$lastBuildDir = $buildList[$buildList.Count - 1]

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
$sourceDir = "\\netapp01a\build\$lastBuildDir"

# Destination must be directory, not file
$files = @(("$sourceDir\classes\orb.jar",                                            "$ospDevDir\classes\"),
           ("$sourceDir\classes\ospcom.jar",                                         "$ospDevDir\classes\"),
           ("$sourceDir\classes\osporg.jar",                                         "$ospDevDir\classes\"),
           ("$sourceDir\classes\ospStart.jar",                                       "$ospDevDir\classes\"),
           ("$sourceDir\lib\Windows_*\",                                             "$ospDevDir\lib\"),
           ("$sourceDir\lib\*.dll",                                                  "$ospDevDir\lib\"),
           ("$sourceDir\lib\NET\*",                                                  "$ospDevDir\lib\NET\"),
           ("$sourceDir\lib\*.exe",                                                  "$ospDevDir\lib\"),
           ("$sourceDir\plugins\ArcSDECarto\*.dll",                                  "$ospDevDir\plugins\ArcSDECarto\"),
           ("$sourceDir\plugins\ArcSDECarto\Windows_*",                              "$ospDevDir\plugins\ArcSDECarto\"),
           ("$sourceDir\plugins\ArcSDECarto\NET",                                    "$ospDevDir\plugins\ArcSDECarto\"),
           ("$sourceDir\plugins\corba\Windows_*",                                    "$ospDevDir\plugins\corba\"),
           ("$sourceDir\plugins\corba\NET",                                          "$ospDevDir\plugins\corba\"),
           ("$sourceDir\plugins\framework\Windows_*",                                "$ospDevDir\plugins\framework\"),
           ("$sourceDir\plugins\framework\NET",                                      "$ospDevDir\plugins\framework\"),
           ("$sourceDir\plugins\geometry\NET",                                       "$ospDevDir\plugins\geometry\"),
           ("$sourceDir\plugins\migration\*.dll",                                    "$ospDevDir\plugins\migration\"),
           ("$sourceDir\plugins\migration\NET",                                      "$ospDevDir\plugins\migration\"),
           ("$sourceDir\providers\NET\OpenSpirit\Plugin\Corba\Mico\Gen\*",           "$ospDevDir\providers\NET\OpenSpirit\Plugin\Corba\Mico\Gen\"),
           ("$sourceDir\providers\Java\com\openspirit\plugin\corba\gen\*",           "$ospDevDir\providers\Java\com\openspirit\plugin\corba\gen\"),
           ("$sourceDir\providers\Java\com\openspirit\plugin\data\corba\gen\*",      "$ospDevDir\providers\Java\com\openspirit\plugin\data\corba\gen\"))

copyFiles $files

write-output "==============================================================="

# Destination must be directory, not file
$files = @(("$sourceDir\lib\OpenSpirit*.jar", "$ospProjectDevDir\lib\"),
           ("$sourceDir\lib\JniTable*.jar",   "$ospProjectDevDir\lib\"),
           ("$sourceDir\plugins\corba\*.jar", "$ospProjectDevDir\lib\"))

copyFiles $files

exit

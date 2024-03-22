#  Get 
[xml]$configFile = Get-Content "config.xml"
$printerName = $configFile.configuration.printer
$hotFolderPath = $configFile.configuration.hotfolder

Write-Host $printerName
Write-Host $hotFolderPath
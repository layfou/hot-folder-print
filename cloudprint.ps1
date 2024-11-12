# Set the path to the hot folder
$hotFolderPath = "$env:USERPROFILE\OneDrive\brother-hl1110"

# Set the printer name to use for printing
$printerName = "Brother HL-1110 series"

# Create a file system watcher to monitor the hot folder
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $hotFolderPath
$watcher.Filter = "*.pdf"
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

# Define the event handler for new file creation
$onCreated = Register-ObjectEvent -InputObject $watcher -EventName Created -SourceIdentifier FileCreated -Action {
    $path = $Event.SourceEventArgs.FullPath
    $pdfName = $Event.SourceEventArgs.Name
    Write-Host "==> $pdfName"
    
    # Print the PDF file
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "C:\Program Files (x86)\Foxit Software\Foxit PDF Reader\FoxitPDFReader.exe"  # Replace with the path to your PDF reader executable
    $psi.Arguments = "-p `"$path`" -scaletofit `"$printerName`""
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    
    $process = [System.Diagnostics.Process]::Start($psi)
    $process.WaitForExit()
}

# Wait for user input to stop the script
Write-Host "Monitoring hot folder: $hotFolderPath"
Write-Host "Press Ctrl+C to stop..."
Write-Host "======================="

Start-Sleep -Seconds 30
Start-process "C:\Users\Apple\AppData\Local\Microsoft\OneDrive\OneDrive.exe"

# Keep the script running indefinitely
while ($true) {
    Start-Sleep -Seconds 2
}

# Clean up and unregister the event handler
Unregister-Event -SourceIdentifier FileCreated
$watcher.Dispose()

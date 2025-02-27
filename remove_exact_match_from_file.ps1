$excluded_servers = (Get-Content -Path "C:\Users\user\Desktop\test\exclude.txt" | ? {$_.trim() -ne "" }).Trim()  ## Get contents of file with whitespace removed

$excluded_servers | foreach {
    $excluded_server_name = "\b$_\b"  ## \b is needed to get an exact match
    Set-Content -Path "C:\Users\user\Desktop\test\prod.txt" -Value (Get-Content -Path "C:\Users\user\Desktop\test\prod.txt" | Select-String -Pattern $excluded_server_name -NotMatch)  ## remove match from file
    Set-Content -Path "C:\Users\user\Desktop\test\nonprod.txt" -Value (Get-Content -Path "C:\Users\user\Desktop\test\nonprod.txt" | Select-String -Pattern $excluded_server_name -NotMatch)  ## remove match from file
}

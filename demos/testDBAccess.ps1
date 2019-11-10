using module .\DBAccess.psm1

try {
    $h = New-Object -TypeName SQLDBAccess

    [string]$DBname = "APP_Framework_Nuva"
    [string]$ServerName = "MANPRO"
    
    [SQLDBAccess]::new($ServerName,$DBname)
    $sql = "select * from entornos"
    $result = $h.ExecuteQuery($sql)
    $result  
}
catch {
        Write-Host $_
		# Write-Host $_.GetType()
		# Write-Host $_.Exception
		# Write-Host $_.Exception.StackTrace
		throw
}




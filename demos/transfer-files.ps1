function Move-Files {
   param(
   [Parameter(Mandatory)]
   [string]$Path,
  
   [Parameter(Mandatory)]
   [string]$DestinationPath
   )
   try {

    # if ($Path.Length -eq 0 -or $DestinationPath.Length -eq 0 )
    #   {
    #       write-host 'Usage: args[0] = $Path args[1] = $DestinationPath'
    #       throw 'Usage: args[0] = $Path args[1] = $DestinationPath'
    #   }

   ## Zip up the folder
   #$zipFile = Compress-Archive -Path $Path -DestinationPath "$Path\($(New-Guid).Guid).zip" -CompressionLevel Optimal -PassThru

  #  $compress = @{
  #   Path= $Path
  #   CompressionLevel = "Optimal"
  #   DestinationPath = "$Path\($(New-Guid).Guid).zip"
  #   }

   $zipFile = "$Path\($(New-Guid).Guid).zip"

   Compress-Archive -Path $Path -DestinationPath $zipFile -CompressionLevel Optimal #-PassThru
      

   ## Create the before hash
   $beforeHash = (Get-FileHash -Path $zipFile).Hash
  
   ## Transfer to a temp folder
   $destComputer = $DestinationPath.Split('\')[2]
   $remoteZipFilePath = "\\$destComputer\c$\Temp"
   Start-BitsTransfer -Source $zipFile -Destination $remoteZipFilePath
  
   ## Create a PowerShell remoting session
   $destComputer = $DestinationPath.Split('\')[2]
   $session = New-PSSession -ComputerName $destComputer
  
   ## Compare the before and after hashes
   ## Assuming we're using the c$ admin share
   $localFolderPath = $DestinationPath
   $localZipFilePath =  $remoteZipFilePath.Split('\')[3] 
  #  $localZipFilePath = $remoteZipFilePath.Replace("\\$destComputer\c$\",'C:\')
  #  $afterHash = Invoke-Command -Session $session -ScriptBlock { (Get-FileHash -Path "$using:localFolderPath\$localZipFilePath").Hash }
   
   $afterHash = Invoke-Command -Session $session -ScriptBlock { (Get-FileHash -Path Join-Path -Path $localFolderPath -ChildPath $localZipFilePath).Hash }
   
  #  if ($beforeHash -ne $afterHash) {
  #   throw 'File modified in transit!'
  #  }
  
   ## Decompress the zip file
   Invoke-Command -Session $session -ScriptBlock { Expand-Archive -Path "$using:localFolderPath\$localZipFilePath" -DestinationPath $using:localFolderPath }
   
   write-host "Files transfer success!!"

   } 
   catch [System.Net.WebException],[System.IO.IOException] {
    $PSCmdlet.ThrowTerminatingError($_)
     write-host $_
   }
   catch {
    write-host $_
    $PSCmdlet.ThrowTerminatingError($_)
   } finally {
    ## Cleanup
    Invoke-Command -Session $session -ScriptBlock { Remove-Item "$using:localFolderPath\$localZipFilePath" -ErrorAction Ignore }
    Remove-Item -Path $zipFile.FullName -ErrorAction Ignore
    Remove-PSSession -Session $session -ErrorAction Ignore


    }
  }
 
  write-host $args[0]
  write-host $args[1]
  

  Move-Files $args[0] $args[1] 

#   #This snippet code is use by acces to SQL DB configuration
#   $SQLCommand = New-Object System.Data.SqlClient.SqlCommand
# $sql = "select COD_Entorno, CntIngresos ,FechaLastIngreso from Entornos "

# if ($args[0].length -gt 0) {
#     $sql += " where Cod_Entorno = '" + $args[0] + "'"
# }

# $SQLServer = "MANPRO"
# $DB = "APP_Framework_Nuva"
# $SQLConnection = Connect($SQLServer,$DB)

# $SQLDataset = ExecuteQuery($sql)

# $SqlAdapter.fill($SQLDataset) | out-null

# $tablevalue = @()
# $tablevalue = "COD_Entorno" + "," + "CntIngresos"
# foreach ($data in $SQLDataset.tables[0])
# {
# $tablevalue = $data[0] + "," + $data[1]
# $tablevalue
# } 
# $SQLConnection.close()
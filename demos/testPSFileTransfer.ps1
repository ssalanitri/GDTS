Impoort-Module -Name PSTransferFile

$TargetSession = New-PSSession -ComputerName arbue-vs-if001

Send-File -SourceFilePath E:\Desarrollo\VBNET\IF_DFP_Despachos\IF_DFP_Despachos\bin\x86\Release -DestinationFolderPath -
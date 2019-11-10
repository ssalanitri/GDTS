
class SQLDBAccess {
    [string]$DBName
    [string]$ServerName
    [string]$SQLQuery

    SQLDBAccess([string]$ServerName, 
                [string]$DBName)
                {
                    $this.DBName = $DBName
                    $this.ServerName = $ServerName
                }

    [System.Data.SQLClient.SQLConnection]Connect(
        [string]$ServerName,
        [string]$DBName
    )
    {
        try {
           
            $SQLConnection = New-Object System.Data.SQLClient.SQLConnection
            $SQLConnection.ConnectionString ="server=$ServerName;database=$DBName;Integrated Security=True;"
            $SQLConnection.Open()

            return $SQLConnection
        }
        catch
        {
            write-host("Failed to connect SQL Server:" + $ServerName) 
            throw 
        }
    }

       [System.Data.DataSet]ExecuteQuery([string]$SQL)
       {
           try {
            $SQLCommand = New-Object System.Data.SqlClient.SqlCommand
            $SQLCommand.CommandText = "select QueryName,CollectionName from [dbo].[Collections_G] as G inner join [dbo].[Collection_Rules] as R
             on G.CollectionID = R.CollectionID where G.CollectionName = 'softwareinstallation'"
            $SQLCommand.Connection = Connect($this.ServerName,$this.DBName)
            
            $SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
            $SqlAdapter.SelectCommand = $SQLCommand                 
            $SQLDataset = New-Object System.Data.DataSet
            $SqlAdapter.fill($SQLDataset) | out-null
    
            return $SQLDataset
           }
           catch {
            write-host("Failed to execute SQL query:" + $SQL) 
            throw 
           }
        
       } 
     
    }
}
    

$SQLCommand = New-Object System.Data.SqlClient.SqlCommand
$sql = "select COD_Entorno, CntIngresos ,FechaLastIngreso from Entornos "

if ($args[0].length -gt 0) {
    $sql += " where Cod_Entorno = '" + $args[0] + "'"
}

$SQLServer = "MANPRO"
$DB = "APP_Framework_Nuva"
$SQLConnection = Connect($SQLServer,$DB)

$SQLDataset = ExecuteQuery($sql)

$SqlAdapter.fill($SQLDataset) | out-null

$tablevalue = @()
$tablevalue = "COD_Entorno" + "," + "CntIngresos"
foreach ($data in $SQLDataset.tables[0])
{
$tablevalue = $data[0] + "," + $data[1]
$tablevalue
} 
$SQLConnection.close()
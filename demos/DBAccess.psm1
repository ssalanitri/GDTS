

#Custom class to use perform access operations to SQL Server Data base.
#Author: Salanitri Sergio 
#Create date: 2019-10-26
 
class SQLDBAccess {
    [string]$DBName
    [string]$ServerName
    [string]$SQLQuery

    #Default constructor
    SQLDBAccess(){}

    #Custom constructor
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
            throw 
        }
    }

       [System.Data.DataSet]ExecuteQuery([string]$SQL)
       {
           try {
            $SQLCommand = New-Object System.Data.SqlClient.SqlCommand
            $SQLCommand.CommandText = $SQL
            $SQLCommand.Connection = $this.Connect($this.ServerName,$this.DB)
            
            $SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
            $SqlAdapter.SelectCommand = $SQLCommand                 
            $SQLDataset = New-Object System.Data.DataSet
            $SqlAdapter.fill($SQLDataset) | out-null
    
            return $SQLDataset
           }
           catch {
            throw 
             
           }
        
       } 
     
}

    


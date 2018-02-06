$password = ConvertTo-SecureString 'P@$$w0rd' -AsPlainText -Force
Import-Csv .\userImport.csv | foreach-object {
Set-ADAccountpassword -Identity $_.Username -NewPassword $password -Reset }
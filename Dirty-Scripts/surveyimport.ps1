<#
.SYNOPSIS
Downloads URL files to Local disk. 
.DESCRIPTION
Download files from a list of URL's and store them locally. URL -> File relationships stored in CSV.
#>

$csvList= "projects.csv"   #Location of CSV file
$logFile= "import.log" 	#Location of Log File

$fromAddress= "import@yourdomain.com" 	
$toAddress= "youremail@yourdomain.com"		
$serverAddress= "mail-server.domain"	
$messageSubject= "Import Result"
$messageBody= "Results of Daily Import`n`n"  #Start the message body here so we can append the string below.

Import-Csv $csvList | Foreach-Object {   #Read the CSV file and then loop for each row.
	Try
	{
        $project= $_.Project  #Grab Project Name
		$file = $_.File += "$project.csv"		#Grab File name
		$messageBody += "$project download to $file"  #Add the current Project -> file to the body.
		Invoke-WebRequest $_.URL -OutFile $_.File	#Powerhsell equivalent of curl. Download URL to File. 
		$messageBody += " Success`n`n"	#If above action completes then add Success to report.
	} 
	Catch
	{
		$Time=Get-Date
		$ErrorMessage = $_.Exception.Message #Grab the error message when download fails
		$messageBody += " Failure. $ErrorMessage`n"		#Add the error information to Report.
		"$Time - $ErrorMessage" | out-file $logFile -append		#Log the error with timestamp
	}
}
#Write-Host $messageBody  #For debugging
Send-MailMessage -From $fromAddress -To $toAddress -Subject $messageSubject -SmtpServer $serverAddress -Body $messageBody  #Email compiled report
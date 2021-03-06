#$compIp = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"').IPAddress
$compIp = (Get-WmiObject -Class Win32_ComputerSystem -Property Name).Name
$logFileName = "log-" + [String](Get-Date -format yyyyMMdd) + ".log" 
#$paths = "c:\apiLogs\test.log", "c:\apiLogs2\test.log"

Try {
$paths = ("c:\apiLogs\" + $logFileName), ("c:\apiLogs2\" + $logFileName) 
    foreach ($path in $paths) {
    $readLog = Get-Content -path $path -ErrorAction Stop
    $message = $message + ("`n") + $path
     
        foreach ($read in $readLog) {
        if ($read -like "what find in log files") {
            try {    
            $total = [int](([System.DateTime]::Now - [datetime]$read.Substring(0,19)).TotalMinutes) 
            if ($total -ge 15) {
                $message = $message + ("`n") + $read 
                $totalErrors = $totalErrors + 1
               write-host "added"
               }
            } 
            catch {}
        }
        }


    }
        if ($totalErrors -gt 0) {
        SendEMail -body $message
        }
        $message = ""
        $totalErrors = 0
        write-host "send"
}

catch { write-host "Something wrong!"}



Function SendEMail {

Param(
[Parameter(`
    mandatory=$true)]
[String]$body
)
    

$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$Username = "username@gmail.com"
$Password = "password"
$to = "user2@domain"
#$cc = "user2@domain.com"
$subject = "Error!!!    " + $compIp
#$body = "Insert body text here"
#$attachment = "C:\test.txt"

$message = New-Object System.Net.Mail.MailMessage
$message.subject = $subject
$message.body = $body
$message.to.add($to)
#$message.cc.add($cc)
$message.from = $username
#$message.attachments.add($attachment)

$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);
$smtp.EnableSSL = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);
$smtp.send($message)

}
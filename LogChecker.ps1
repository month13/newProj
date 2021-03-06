$compIp = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"').IPAddress
$paths = "c:\apiLogs\test.log", "c:\apiLogs2\test.log"

foreach ($path in $paths) {
$readLog = Get-Content -path $path
$message = $message + ("`n") + $path
 
    foreach ($read in $readLog) {
    if ($read -like "*CreateRealAccount*") {
        try {    
        $total = [int](([System.DateTime]::Now - [datetime]$read.Substring(0,19)).TotalMinutes)
        if ($total -ge 15) {
            $message = $message + ("`n") + $read 
           write-host "added"
           }
        } 
        catch {}
    }
    }

    SendEMail -body $message
    $message = ""
    write-host "send"
}




Function SendEMail {

Param(
[Parameter(`
    mandatory=$true)]
[String]$body
)
    

$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$Username = "user2@gmail.com"
$Password = "password"
$to = "user2@domain"
#$cc = "user2@domain.com"
$subject = "Error!!!" + $compIp
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
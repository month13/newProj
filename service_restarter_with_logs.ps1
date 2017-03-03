try {
restart-service WAS  -PassThru -force -ErrorAction Stop
restart-service W3SVC -PassThru -ErrorAction Stop
write-host "Done!"
"$(Get-Date -uformat ‘%D %T’) IIS-Server was restarted" | Out-File C:\test\IIS_restart_log.log -append
}
catch{
"$(Get-Date -uformat ‘%D %T’) IIS-Server restart error!!!" | Out-File C:\test\IIS_restart_log.log -append
}

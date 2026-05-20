using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Runtime.InteropServices;
using System.Runtime.Serialization.Json;
using SharpShell.Attributes;
using SharpShell.SharpThumbnailHandler;

namespace PoseThumbnailProvider;

[ComVisible(true)]
[Guid("8328811d-cd39-4b96-abab-6e156b5cdcaa")]
[COMServerAssociation(AssociationType.ClassOfExtension, ".pose")]
public class PoseThumbnailProvider : SharpThumbnailHandler
{
    private const string SoftwarePosethumbnailprovider = @"SOFTWARE\PoseThumbnailProvider";

    private static readonly string LogPath = Path.Combine(
        Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
        "PoseThumbnailProvider", "thumb.log");

    private static bool IsLoggingEnabled()
    {
        try
        {
            using var key = Microsoft.Win32.Registry.LocalMachine.OpenSubKey(SoftwarePosethumbnailprovider);
            return key?.GetValue("Logging") is 1;
        }
        catch
        {
            return false;
        }
    }

    protected override void Log(string message)
    {
        if (!IsLoggingEnabled()) return;
        try
        {
            var dir = Path.GetDirectoryName(LogPath);
            if (!Directory.Exists(dir))
                Directory.CreateDirectory(dir!);

            var content = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss.fff}] {message}{Environment.NewLine}";
            Debug.WriteLine(content);
            File.AppendAllText(LogPath, content);
        }
        catch
        {
            /* never throw from a shell extension */
        }
    }

    protected override Bitmap GetThumbnailImage(uint width)
    {
        Log($"GetThumbnailImage called, width={width}");
        try
        {
            var serializer = new DataContractJsonSerializer(typeof(PoseFile));
            var pose = (PoseFile)serializer.ReadObject(SelectedItemStream);

            if (pose == null || string.IsNullOrWhiteSpace(pose.Base64Image))
            {
                Log("Base64Image missing or empty");
                return null!;
            }

            Log($"Decoding base64, length={pose.Base64Image.Length}");

            var bytes = Convert.FromBase64String(pose.Base64Image);

            using var ms = new MemoryStream(bytes);
            var bmp = new Bitmap(ms);
            Log($"Bitmap created: {bmp.Width}x{bmp.Height}");
            return bmp;
        }
        catch (Exception ex)
        {
            /* never throw from a shell extension */
            Log($"EXCEPTION: {ex.GetType().Name}: {ex.Message}{Environment.NewLine}{ex.StackTrace}");
            return null!;
        }
    }
}
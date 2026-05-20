using System.Runtime.Serialization;

namespace PoseThumbnailProvider;

[DataContract]
internal class PoseFile
{
    [DataMember(Name = "Base64Image")]
    public string Base64Image { get; set; }
}
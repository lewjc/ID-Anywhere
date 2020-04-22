using MongoDB.Bson.Serialization.Attributes;
using DataLayer.Mongo.WorkModels;
using MongoDB.Bson;

namespace DataLayer.Mongo
{
  public class WorkDocument
  {
    [BsonId]
    public ObjectId ID { get; set; }

    public PassportData PassportData { get; set; }

    public LicenseData LicenseData { get; set; }

    public bool BackLicenseUploaded { get; set; }

    public string UserId { get; set; }

    public string AppID { get; set; }

    public bool Ready { get; set; }
  }
}

using System;

namespace DataLayer.Mongo.WorkModels
{
  public class LicenseData
  {
    public string FirstName { get; set; }
    public string LastName { get; set; }

    public string Number { get; set; }

    public DateTime DateOfBirth { get; set; }

    public DateTime Expiry { get; set; }
  }
}

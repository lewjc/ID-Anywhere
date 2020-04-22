using System;


namespace DataLayer.Mongo.WorkModels
{
  public class PassportData
  {
    public string FirstName { get; set; }
    public string LastName { get; set; }

    public string Number { get; set; }
    public string MRZ { get; set; }

    public DateTime DateOfBirth { get; set; }

    public DateTime Expiry { get; set; }
  }
}

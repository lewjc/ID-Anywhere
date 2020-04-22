using System;
using System.Collections.Generic;
using System.Text;

namespace DataModels
{
  public class JobDM : BaseDM
  {
    public string UserId { get; set; }

    public string ClaimedFirstName { get; set; }

    public string ClaimedLastName { get; set; }

    public string FirstNamePassport { get; set; }

    public string FirstNameLicense { get; set; }

    public string LastNameLicense { get; set; }

    public string LastNamePassport { get; set; }

    public string PassportNumber { get; set; }

    public string LicenseNumber { get; set; }

    public DateTime PassportDateOfBirth { get; set; }

    public DateTime LicenseDateOfBirth { get; set; }

    public DateTime LicenseExpiry { get; set; }

    public  DateTime PassportExpiry { get; set; }

    public string MRZ { get; set; }

    public DateTime Created { get; set; }

    public bool Valid { get; set; }

    public string AppId { get; set; }
  }
}

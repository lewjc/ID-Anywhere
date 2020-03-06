using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WebApp.Models
{
  public class JobViewModel
  {
    public int ID { get; set; }
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

    public DateTime PassportExpiry { get; set; }

    public string MRZ { get; set; }

    public DateTime Created { get; set; }

    public bool Valid { get; set; }

    public string AppId { get; set; }

    public string LicenseFrontUrl { get; set; }
    public string LicenseBackUrl { get; set; }
    public string PassportUrl { get; set; }
  }
}

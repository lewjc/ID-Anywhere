using System;
using System.Collections.Generic;
using System.Text;

namespace ServiceModels
{
  public class PassportSM
  {
    public string Number { get; set; }

    public string FirstName { get; set; }

    public string LastName { get; set; }

    public DateTime DateOfBirth { get; set; }

    public DateTime Expiry { get; set; }

    public string MRZ { get; set; }
  }
}

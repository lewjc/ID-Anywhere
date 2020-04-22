using System;
using System.Collections.Generic;
using System.Text;

namespace ServiceModels
{
  public class CodeVerificationSM
  {
    public string Code { get; set; }

    public int MinimumAgeRequired { get; set; }
  }
}

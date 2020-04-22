using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace ViewModels
{
  public class CodeVerificationVM
  {
    [Required]
    public string  Code { get; set; }

    [Required]
    public int MinimumAgeRequired { get; set; }
  }
}

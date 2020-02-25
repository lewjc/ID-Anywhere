using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace ViewModels
{
  public class PassportVM
  {
    [Required]
    public string Number { get; set; }

    [Required]
    public string FirstName { get; set; }

    [Required]
    public string LastName { get; set; }

    [Required]
    public DateTime DateOfBirth { get; set; }
    
    [Required]
    public DateTime Expiry { get; set; }

    [Required]
    public string MRZ { get; set; }
  }
}

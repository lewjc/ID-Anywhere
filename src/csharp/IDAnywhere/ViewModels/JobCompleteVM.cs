using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace ViewModels
{
  public class JobCompleteVM
  {
    [Required]
    public bool Verified { get; set; }
    [Required]
    public string Message { get; set; }
    [Required]
    public string UserId { get; set; }
  }
}

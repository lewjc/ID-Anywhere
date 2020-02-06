using System;
using System.ComponentModel.DataAnnotations;

namespace ViewModels
{
  public class SignUpVM
  {
    [Required]
    public string FirstName { get; set; }

    [Required]
    public string LastName { get; set; }

    [Required]
    [DataType(DataType.EmailAddress)]
    public string Email { get; set; }

    [Required]
    public string Password { get; set; }

    [Required]
    public string AppID { get; set; }
  }
}

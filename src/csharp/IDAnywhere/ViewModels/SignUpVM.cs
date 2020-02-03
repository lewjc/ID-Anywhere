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

    /// <summary>
    /// Should always be a string of a hash. NEVER PLAIN TEXT
    /// </summary>
    [Required]
    public string Password { get; set; }
  }
}

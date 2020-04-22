using System;

namespace ServiceModels
{
  public class SignUpSM
  {
    public string FirstName { get; set; }

    public string LastName { get; set; }

    public string Email { get; set; }

    /// <summary>
    /// Should always be a string of a hash. NEVER PLAIN TEXT
    /// </summary>
    public string Password { get; set; }

    public string AppID { get; set; }
  }
}

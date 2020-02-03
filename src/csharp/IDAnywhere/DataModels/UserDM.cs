using Dependency.Enums;
using System;

namespace DataModels
{
  public class UserDM : BaseDM
  {
    public string FirstName { get; set; }

    public string LastName { get; set; }

    public string Password { get; set; }

    public string Email { get; set; }

    public long? PassportNumber { get; set; }

    public string LicenseNumber { get; set; }

    public DateTime Created { get; set; } = DateTime.Now;

    public DateTime LastUpdate { get; set; } = DateTime.Now;

    public UserStatus Status { get; set; }

    public bool Locked { get; set; } = false;

  }
}

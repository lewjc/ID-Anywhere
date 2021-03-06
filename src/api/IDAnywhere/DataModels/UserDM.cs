﻿using Dependency.Enums;
using System;
using System.ComponentModel.DataAnnotations.Schema;

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

    public string AppID { get; set; }

    public DateTime? DateOfBirth { get; set; }

    [ForeignKey("Role")]
    public int RoleID{ get; set; }

    public RoleDM Role { get; set; }

  }
}

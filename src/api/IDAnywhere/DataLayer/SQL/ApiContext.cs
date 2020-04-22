using DataModels;
using JetBrains.Annotations;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Text;

namespace DataLayer.SQL
{
  public class ApiContext : DbContext
  {

    public DbSet<UserDM> Users { get; set; }

    public DbSet<JobDM> Jobs { get; set; }

    public DbSet<RoleDM> Roles { get; set; }

    public ApiContext(DbContextOptions<ApiContext> options) : base(options)
    {

    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
      modelBuilder.Entity<UserDM>().Property(u => u.Status).HasConversion<string>();
      modelBuilder.Entity<UserDM>().ToTable("User");
      modelBuilder.Entity<JobDM>().ToTable("Jobs");
      modelBuilder.Entity<RoleDM>().ToTable("Roles");

      base.OnModelCreating(modelBuilder);
    }
  }
}

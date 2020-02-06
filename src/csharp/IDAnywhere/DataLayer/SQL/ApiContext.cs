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

    public ApiContext(DbContextOptions<ApiContext> options) : base(options)
    {

    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
      modelBuilder.Entity<UserDM>().Property(u => u.Status).HasConversion<string>();

      modelBuilder.Entity<UserDM>().ToTable("User");


      base.OnModelCreating(modelBuilder);
    }
  }
}

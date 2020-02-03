using DataLayer.SQL;
using DataModels;
using Microsoft.EntityFrameworkCore;
using Serilog;
using ServiceLayer.Interfaces;
using ServiceModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ServiceLayer.Implementations
{
  public class SignupService : BaseService<SignupService>, ISignupService
  {

    public SignupService(ApiContext db, ILogger logger) : base(db, logger)
    {
    }

    public async Task<ServiceResult> ExecuteSignup(SignUpSM sm)
    {

      var userDataModel = new UserDM()
      {
        FirstName = sm.FirstName,
        LastName = sm.LastName,
        Email = sm.Email,
        Password = sm.Password
      };

      try
      {
        var t = await Db.Users.AddAsync(userDataModel);
        await Db.SaveChangesAsync();
      }
      catch (DbUpdateException e)
      {
        ServiceResult.Errors.Add("Error creating user, please try again later.");
        Logger.Error(e, e.Message);
      }

      // Here we need to create a user data model, and pass that into the database.
      return ServiceResult;
    }
  }
}

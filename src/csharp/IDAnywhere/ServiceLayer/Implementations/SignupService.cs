using AutoMapper;
using DataLayer.SQL;
using DataModels;
using Microsoft.EntityFrameworkCore;
using Serilog;
using ServiceLayer.Interfaces;
using ServiceModels;
using System.Threading.Tasks;

namespace ServiceLayer.Implementations
{
  public class SignupService : BaseService<SignupService>, ISignupService
  {

    public SignupService(ApiContext db, ILogger logger, IMapper mapper) : base(db, logger, mapper)
    {
    }

    public async Task<ServiceResult> ExecuteSignup(SignUpSM sm)
    {

      var userDataModel = mapper.Map<UserDM>(sm);
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

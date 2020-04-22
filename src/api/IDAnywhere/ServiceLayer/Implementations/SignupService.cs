using AutoMapper;
using DataLayer.SQL;
using DataModels;
using Microsoft.EntityFrameworkCore;
using Serilog;
using ServiceLayer.Interfaces;
using ServiceModels;
using System.Linq;
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
      bool emailExists = await Db.Users.AnyAsync(u => u.Email.ToLower().Equals(sm.Email.ToLower()));
      bool appIdInUse = await Db.Users.AnyAsync(u => u.AppID.Equals(sm.AppID));
      if (!emailExists && !appIdInUse)
      {
        var userDataModel = mapper.Map<UserDM>(sm);
        await Db.Users.AddAsync(userDataModel);
        await Db.SaveChangesAsync();
      }
      else if (emailExists)
      {
        ServiceResult.Errors.Add("Email already in use.");
      }
      else if (appIdInUse)
      {
        ServiceResult.Errors.Add("Application ID already registered.");
      }

      return ServiceResult;
    }
  }
}

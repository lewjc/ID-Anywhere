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
      var user = await Db.Users.FirstOrDefaultAsync(u => u.Email.ToLower().Equals(sm.Email.ToLower())); 
      if(user == null)
      {
        var userDataModel = mapper.Map<UserDM>(sm);
        await Db.Users.AddAsync(userDataModel);
        await Db.SaveChangesAsync();
      } else
      {
        ServiceResult.Errors.Add("User already exists");
      }
      return ServiceResult;
    }
  }
}

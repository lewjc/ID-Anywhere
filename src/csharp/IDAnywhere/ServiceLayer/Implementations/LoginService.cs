using AutoMapper;
using DataLayer.SQL;
using DataModels;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Serilog;
using ServiceLayer.Interfaces;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;

namespace ServiceLayer.Implementations
{
  public class LoginService : BaseService<LoginService>, ILoginService
  {
    private readonly IConfiguration _configuration;

    public LoginService(ApiContext db, ILogger logger, IMapper mapper, IConfiguration configuration) : base(db, logger, mapper)
    {

    }

    public ServiceResult AttemptLogin(string email, string password)
    {
      var user = Db.Users.FirstOrDefault(x =>
        x.Email.Equals(email, StringComparison.CurrentCultureIgnoreCase) &&
        x.Password.Equals(password));

      if (user == null)
      {
        ServiceResult.Errors.Add("User does not exist");
      }
      else if (user.Locked)
      {
        ServiceResult.Errors.Add("This account is locked. Please unlock through the web portal.");
      }
      else
      {
        string token = GenerateJwt(user);
        ServiceResult.Values.Add("token", token);
      }

      return ServiceResult;
    }

    private string GenerateJwt(UserDM user)
    {
      // User exists and is not locked; let us generate a token and login.
      var tokenHandler = new JwtSecurityTokenHandler();
      var key = Encoding.ASCII.GetBytes(_configuration.GetValue<string>("AppSettings:Secret"));

      var tokenDescriptor = new SecurityTokenDescriptor
      {
        Subject = new ClaimsIdentity(new Claim[]
        {
            new Claim(ClaimTypes.Name, user.ID.ToString())
        }),
        Expires = DateTime.UtcNow.AddHours(1),
        SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.RsaSha256Signature)
      };
      var token = tokenHandler.CreateToken(tokenDescriptor);
      return tokenHandler.WriteToken(token);
    }
  }
}

﻿using AutoMapper;
using DataLayer.SQL;
using DataModels;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using Serilog;
using ServiceLayer.Interfaces;
using ServiceModels;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace ServiceLayer.Implementations
{
  public class LoginService : BaseService<LoginService>, ILoginService
  {
    private IConfiguration configuration;

    public LoginService(ApiContext db, ILogger logger, IMapper mapper, IConfiguration configuration) : base(db, logger, mapper)
    {
      this.configuration = configuration;
    }

    public async Task<ServiceResult> AttemptLogin(LoginSM sm)
    {
      var user = await Db.Users.FirstOrDefaultAsync(x =>
        x.Email.Equals(sm.Email, StringComparison.OrdinalIgnoreCase) &&
        x.Password.Equals(sm.Password, StringComparison.OrdinalIgnoreCase));

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
      var key = Encoding.ASCII.GetBytes(configuration.GetValue<string>("AppSettings:Secret"));

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

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WebApp.Models;
using WebApp.Results;

namespace WebApp.Services
{
  public interface ILoginService
  {
    Task<LoginResult> AttemptLogin(LoginViewModel loginViewModel);
  }
}

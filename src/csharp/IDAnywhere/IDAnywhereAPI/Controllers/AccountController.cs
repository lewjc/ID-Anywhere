using System.Threading.Tasks;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ServiceLayer;
using ServiceLayer.Interfaces;
using ServiceModels;
using ViewModels;

namespace IDAnywhereAPI.Controllers
{
  [Route("api/[controller]/[action]")]
  [Authorize]
  [ApiController]
  public class AccountController : ControllerBase
  {
    private readonly ISignupService signupService;
    private readonly ILoginService loginService;
    private readonly IMapper mapper;

    public AccountController(ISignupService signupService, ILoginService loginService, IMapper mapper)
    {
      this.signupService = signupService;
      this.loginService = loginService;
      this.mapper = mapper;
    }

    [HttpPost]
    [AllowAnonymous]
    public async Task<ActionResult> SignUp(SignUpVM vm)
    {
      if (ModelState.IsValid)
      {
        ServiceResult result = await signupService.ExecuteSignup(mapper.Map<SignUpSM>(vm));

        if (result.Valid)
        {
          return new JsonResult("Success")
          {
            StatusCode = 200
          };
        }

        return new JsonResult(
          new
          {
            result.Errors
          })
        {
          StatusCode = 400
        };
      }

      return new StatusCodeResult(400);
    }

    [HttpPost]
    [AllowAnonymous]
    public async Task<ActionResult> Login(LoginVM vm)
    {
      if (ModelState.IsValid)
      {
        ServiceResult result = await loginService.AttemptLogin(mapper.Map<LoginSM>(vm));

        if (result.Valid)
        {
          // We return the service result values as there is a token present to be passed to the user, to use for all future authentication requests.
          return new JsonResult(result.Values);
        }

        return new JsonResult(new { result.Errors })
        {
          StatusCode = 400
        };
      }

      return new StatusCodeResult(400);
    }

    [HttpGet]
    [AllowAnonymous]
    public string Heartbeat()
    {
      return "Online";
    }
  }
}

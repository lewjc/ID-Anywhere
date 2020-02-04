using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
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
    private readonly IMapper mapper;

    public AccountController(ISignupService signupService, IMapper mapper)
    {
      this.signupService = signupService;
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

        return new JsonResult(result.Errors)
        {
          StatusCode = 400
        };
      }

      return new StatusCodeResult(500);
    }


    [HttpPost]
    [AllowAnonymous]
    public async Task<ActionResult> Login(LoginVM vm)
    {
      if (ModelState.IsValid)
      {

      }
      return new StatusCodeResult(500);
    }

    // GET: api/Account/5
    [HttpGet("{id}", Name = "Get")]
    public string Get(int id)
    {
      return "value";
    }

    // POST: api/Account
    [HttpPost]
    public void Post([FromBody] string value)
    {
    }

    // PUT: api/Account/5
    [HttpPut("{id}")]
    public void Put(int id, [FromBody] string value)
    {
    }

    // DELETE: api/ApiWithActions/5
    [HttpDelete("{id}")]
    public void Delete(int id)
    {
    }
  }
}

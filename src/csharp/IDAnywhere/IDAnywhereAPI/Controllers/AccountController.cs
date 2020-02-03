using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ServiceLayer;
using ServiceLayer.Interfaces;
using ServiceModels;
using ViewModels;

namespace IDAnywhereAPI.Controllers
{
  [Route("api/[controller]/[action]")]
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
    public async Task<JsonResult> SignUp(SignUpVM vm)
    {
      if (ModelState.IsValid)
      {
        ServiceResult result = await signupService.ExecuteSignup(mapper.Map<SignUpSM>(vm));

        if (result.Valid)
        {
          var json = new JsonResult("Success")
          {
            StatusCode = 200
          };
          return json;
        }
      }

      return null;
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

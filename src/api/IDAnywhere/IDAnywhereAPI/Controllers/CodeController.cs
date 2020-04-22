using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ServiceLayer.Interfaces;
using ServiceModels;
using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using ViewModels;

namespace IDAnywhereAPI.Controllers
{
  [Authorize]
  [Route("api/[controller]/[action]")]
  [ApiController]
  public class CodeController : ControllerBase
  {
    private readonly ICodeService codeService;
    private readonly IMapper mapper;

    public CodeController(ICodeService codeService, IMapper mapper)
    {
      this.codeService = codeService;
      this.mapper = mapper;
    }

    [HttpGet]
    public async Task<ActionResult> GenerateIdentityCode()
    {
      string userId = User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Name).Value;
      var code = await codeService.CreateCode(userId);

      if (code == null)
      {
        return new StatusCodeResult(500);
      }

      return Ok(new
      {
        code
      });
    }

    [HttpPost]
    public async Task<ActionResult> VerifyIdentityCode(CodeVerificationVM viewModel)
    {
      DateTimeOffset datetime = DateTimeOffset.UtcNow;
      if (ModelState.IsValid)
      {
        string userId = User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.Name).Value;        
        var sm = mapper.Map<CodeVerificationSM>(viewModel);
        var result = await codeService.ValidateCode(datetime, sm, userId);

        if (result.Valid)
        {
          return Ok();
        }
        else
        {
          return Ok(new { result.Errors });
        }
      }

      return BadRequest();
    }
  }
}
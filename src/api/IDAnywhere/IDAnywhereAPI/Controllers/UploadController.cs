using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ServiceLayer.Interfaces;
using ServiceModels;
using ViewModels;
using ViewModels.ViewModels;

namespace IDAnywhereAPI.Controllers
{
  [Route("api/[controller]/[action]")]
  [ApiController]
  [Authorize]
  public class UploadController : ControllerBase
  {
    private readonly IUploadService uploadService;
    private readonly IMapper mapper;

    public UploadController(IUploadService uploadService, IMapper mapper)
    {
      this.uploadService = uploadService;
      this.mapper = mapper;
    }

    [HttpPost]
    public async Task<ActionResult> Passport(PassportVM passportVM)
    {

      if (ModelState.IsValid)
      {
        string userId = User.Claims.Where(x => x.Type == ClaimTypes.Name).FirstOrDefault().Value;
        string appId = User.Claims.Where(x => x.Type == "AppID").FirstOrDefault().Value;
        bool uploaded = await uploadService.AddPassportDataToJob(mapper.Map<PassportSM>(passportVM), userId, appId);
        if (uploaded)
        {
          return Ok();
        }
      }
      return new StatusCodeResult(400);
    }

    [HttpPost]
    public async Task<ActionResult> LicenseFront(LicenseVM licenseVM)
    {

      if (ModelState.IsValid)
      {
        string userId = User.Claims.Where(x => x.Type == ClaimTypes.Name).FirstOrDefault().Value;
        string appId = User.Claims.Where(x => x.Type == "AppID").FirstOrDefault().Value;
        bool uploaded = await uploadService.AddLicenseDataToJob(mapper.Map<LicenseSM>(licenseVM), userId, appId);
        if (uploaded)
        {
          return Ok();
        }
      }
      return new StatusCodeResult(400);
    }

    [HttpPost]
    public async Task<ActionResult> LicenseBack()
    {
      string userId = User.Claims.Where(x => x.Type == ClaimTypes.Name).FirstOrDefault().Value;
      string appId = User.Claims.Where(x => x.Type == "AppID").FirstOrDefault().Value;
      bool uploaded = await uploadService.MarkBackLicenseUploaded(userId, appId);
      if (uploaded)
      {
        return Ok();
      }
      return new StatusCodeResult(400);
    }
  }
}
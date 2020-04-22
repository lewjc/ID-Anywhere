using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using ServiceLayer.Interfaces;
using ServiceModels;
using ViewModels;

namespace IDAnywhereAPI.Controllers
{
  [Route("api/[controller]/[action]")]
  [ApiController]
  [Authorize]
  public class JobController : ControllerBase
  {
    private readonly IFinalJobPreperationService finalJobPreperationService;
    private readonly IMapper mapper;

    public JobController(IFinalJobPreperationService finalJobPreperationService, IMapper mapper)
    {
      this.finalJobPreperationService = finalJobPreperationService;
      this.mapper = mapper;
    }

    [HttpGet]
    public ActionResult GetJobs(int pageSize, int pageNumber)
    {
      List<JobSM> jobs = finalJobPreperationService.GetJobs(pageSize, pageNumber);

      if (jobs == null)
      {
        return new StatusCodeResult(StatusCodes.Status500InternalServerError);
      }

      return new JsonResult(jobs);
    }

    [HttpGet]
    public ActionResult GetJob(int Id)
    {
      JobSM job = finalJobPreperationService.GetJob(Id);

      if (job == null)
      {
        return new StatusCodeResult(StatusCodes.Status500InternalServerError);
      }

      return new JsonResult(job);
    }

    [HttpPut]
    public async Task<ActionResult> UpdateJob(FinalJobVM model)
    {
      if (ModelState.IsValid)
      {
        var job = mapper.Map<FinalJobSM>(model);
        bool updated = await finalJobPreperationService.UpdateJob(job);

        if (updated)
        {
          if (job.LicenseDateOfBirth.Date != job.PassportDateOfBirth.Date)
          {
            return BadRequest();
          }

          await finalJobPreperationService.FinaliseUserFromJob(job.UserId, job.LicenseNumber, long.Parse(job.PassportNumber), job.LicenseDateOfBirth);
          return Ok();
        }
      }

      return BadRequest();
    }
  }
}
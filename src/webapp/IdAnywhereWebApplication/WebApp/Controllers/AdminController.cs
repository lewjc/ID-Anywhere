using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApp.Models;
using WebApp.Services;

namespace WebApp.Controllers
{
  [Authorize]
  public class AdminController : Controller
  {
    private readonly IJobService jobService;

    public AdminController(IJobService jobService)
    {
      this.jobService = jobService;
    }

    // GET: Admin
    [HttpGet]
    public async Task<ActionResult> Jobs(int pageNumber = 1, int pageSize = 15)
    {
      var bearer = HttpContext.Session.GetString("JWToken");
      var vm = new JobsViewModel()
      {
        JobsList = await jobService.LoadJobs(pageNumber, pageSize, bearer)
      };

      return View(vm);
    }

    [HttpGet]
    public async Task<ActionResult> ProcessJob(int id)
    {
      // Get the job based on the ID, then fill in the view for it.
      var bearer = HttpContext.Session.GetString("JWToken");
      var job = await jobService.GetJob(id, bearer);
      return View(job);
    }


    // POST: Admin/Create
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<ActionResult> ProcessJob(JobViewModel vm, IFormCollection collection)
    {
      string acceptedString = "accepted";
      try
      {
        // TODO: Add insert logic here, Create a processed job view model.
        var acceptPassport = collection["acceptPassport"].FirstOrDefault() == acceptedString ? true : false;
        var acceptLicenseBack = collection["acceptLicenseBack"].FirstOrDefault() == acceptedString ? true : false;
        var acceptLicenseFront = collection["acceptLicenseFront"].FirstOrDefault() == acceptedString ? true : false;          
        var bearer = HttpContext.Session.GetString("JWToken");

        if (acceptPassport && acceptLicenseBack && acceptLicenseFront)
        {
          vm.Valid = true;
          bool updated = await jobService.UpdateJob(vm, bearer);

          if (updated)
          {

          } else
          {

          }
        } else
        {
          if (!acceptPassport)
          {
            // Notify user that the passport is not okay
            // Create an action.
          }

          if (!acceptLicenseBack)
          {
            // Notify the user that the back of the license is not okay.
            // Create an action.
          }

          if (!acceptLicenseFront)
          {
            // Notify the user that the front of the license is not okay.
            // Create an action.
          }
        }

        return Ok();
      }
      catch
      {
        return View();
      }
    }

    [HttpGet]
    public ActionResult CreateAdmin()
    {
      return View(new CreateAdminVM());
    }

    [HttpPost]
    public async Task<ActionResult> CreateAdmin(CreateAdminVM vm) 
    {
      if (ModelState.IsValid)
      {
        return Ok();
      }

      return BadRequest();
    }
  }
}
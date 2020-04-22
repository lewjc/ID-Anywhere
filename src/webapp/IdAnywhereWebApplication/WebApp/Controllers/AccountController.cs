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
  public class AccountController : Controller
  {
    private readonly ILoginService loginService;

    public AccountController(ILoginService loginService)
    {
      this.loginService = loginService;
    }

    // GET: Account
    [HttpGet]
    public ActionResult Login()
    {
      return View(new LoginViewModel());
    }

    [HttpPost]
    public async Task<ActionResult> Login(LoginViewModel vm)
    {
      // Send the email and password. 
      if (ModelState.IsValid)
      {
        var result = await loginService.AttemptLogin(vm);

        if (result != null && result.IsValid)
        {
          // Set token in session
          HttpContext.Session.SetString("JWToken", result.Token);
          return RedirectToAction("Jobs", "Admin");          
        }

        return BadRequest(result.Errors);
      } else
      {
        return Ok();
      }
    }
  }
}
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Logging;
using Microsoft.IdentityModel.Tokens;
using WebApp.Services;

namespace WebApp
{
  public class Startup
  {
    public Startup(IConfiguration configuration)
    {
      Configuration = configuration;
    }

    public IConfiguration Configuration { get; }

    // This method gets called by the runtime. Use this method to add services to the container.
    public void ConfigureServices(IServiceCollection services)
    {
      services.AddHttpClient();

      string secret = Configuration.GetValue<string>("AppSettings:Secret");
      byte[] secret_b = Encoding.ASCII.GetBytes(secret);

      services.AddAuthentication(x =>
      {
        x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
      })
     .AddJwtBearer(x =>
     {
       x.RequireHttpsMetadata = false;
       x.SaveToken = true;
       x.TokenValidationParameters = new TokenValidationParameters
       {
         ValidateIssuerSigningKey = true,
         IssuerSigningKey = new SymmetricSecurityKey(secret_b),
         ValidateIssuer = false,
         ValidateAudience = false
       };

     });
      services.AddSession();
      services.AddScoped<ILoginService, LoginService>();
      services.AddScoped<IJobService, JobService>();

      services.Configure<RequestLocalizationOptions>(options =>
      {
        options.DefaultRequestCulture = new Microsoft.AspNetCore.Localization.RequestCulture("en-GB");
        options.SupportedCultures = new List<CultureInfo> { new CultureInfo("en-US"), new CultureInfo("en-GB") };
      });

      services.AddControllersWithViews();
    }

    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
      IdentityModelEventSource.ShowPII = true;
      if (env.IsDevelopment())
      {
        app.UseDeveloperExceptionPage();
      }
      else
      {
        app.UseExceptionHandler("/Home/Error");
        app.UseHsts();
      }

      app.UseStatusCodePages(async context =>
      {
        var request = context.HttpContext.Request;
        var response = context.HttpContext.Response;

        if(response.StatusCode == (int)HttpStatusCode.Unauthorized)
        {
          response.Redirect("/account/login");
        }
      });

      app.UseSession();
      //Add JWToken to all incoming HTTP Request Header
      app.Use(async (context, next) =>
      {
        var JWToken = context.Session.GetString("JWToken");
        if (!string.IsNullOrEmpty(JWToken))
        {
          context.Request.Headers.Add("Authorization", "Bearer " + JWToken);
        }
        await next();
      });

      app.UseCors(x =>
      {

        x.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
      });

      app.UseRequestLocalization();
      app.UseHttpsRedirection();
      app.UseStaticFiles();
      app.UseRouting();

      app.UseAuthentication();
      app.UseAuthorization();

      app.UseEndpoints(endpoints =>
      {
        endpoints.MapControllerRoute(
                  name: "default",
                  pattern: "{controller=Home}/{action=Index}/{id?}");
      });
    }
  }
}

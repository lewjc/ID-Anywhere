using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using DataLayer.Mongo;
using DataLayer.SQL;
using IDAnywhereAPI.MappingProfiles;
using IDAnywhereAPI.ServiceExtensions;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Serilog;
using ServiceLayer;
using ServiceLayer.Implementations;
using ServiceLayer.Interfaces;

namespace IDAnywhereAPI
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
      services.AddCors();
      services.AddControllers();
      services.Configure<ApiBehaviorOptions>(options =>
      {
        options.SuppressModelStateInvalidFilter = true;
      });

      string secret = Configuration.GetValue<string>("AppSettings:Secret");
      byte[] secret_b = Encoding.ASCII.GetBytes(secret);

      services.AddDbContext<ApiContext>(options =>
      {
        options.UseSqlServer(Configuration.GetConnectionString("DefaultConnection"));
      });

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

      // Adding profile here may be redundant as automapper may auto search for profiles through reflection at startup? 
      services.AddAutoMapper(options =>
      {
        options.AddProfile<ViewModelMappingProfile>();
      }, typeof(Startup));

      services.AddSerilogServices();
      services.Configure<RouteOptions>(x =>
      {
        x.LowercaseUrls = true;
      });
      services.AddScoped<ISignupService, SignupService>();
      services.AddScoped<ILoginService, LoginService>();
      services.AddScoped<IUploadService, UploadService>();
      services.AddScoped<IMongoWorkQueue, MongoWorkQueue>();
    }

    // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
    public void Configure(IApplicationBuilder app, IWebHostEnvironment env, ILogger logger)
    {
      if (env.IsDevelopment())
      {
        app.UseDeveloperExceptionPage();
      }

      app.ConfigureExceptions(logger);

      app.UseCors(x =>
      {

        x.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
      });

      app.UseHttpsRedirection();

      app.UseRouting();
      app.UseAuthentication();
      app.UseAuthorization();

      app.UseEndpoints(endpoints =>
      {
        endpoints.MapControllers();
      });
    }
  }
}

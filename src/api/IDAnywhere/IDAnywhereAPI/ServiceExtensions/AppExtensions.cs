using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Http;

using Serilog;
using System.Net;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using IDAnywhereAPI.Errors;

namespace IDAnywhereAPI.ServiceExtensions
{
  public static class AppExtensions
  {

    public static void ConfigureExceptions(this IApplicationBuilder app, ILogger logger)
    {
      app.UseExceptionHandler(handler =>
      {
        handler.Run(async context =>
        {
          context.Response.StatusCode = 500;
          context.Response.ContentType = "application/json";

          var contextFeature = context.Features.Get<IExceptionHandlerFeature>();
          if (contextFeature != null)
          {
            logger.Error($"Oops, Something went wrong: {contextFeature.Error}");

            await context.Response.WriteAsync(new ErrorDetails()
            {
              StatusCode = context.Response.StatusCode,
              Message = "Internal Server Error. Try again later"
            }.ToString());
          }
        });
      });
    }
  }
}

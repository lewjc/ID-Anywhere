using System;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using DataLayer.SQL;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Serilog;

namespace IDAnywhereAPI
{
  public class Program
  {
    public static void Main(string[] args)
    {
      var host = CreateHostBuilder(args).Build();

      CreateDatabaseIfNotExists(host);
      host.Run();
    }

    private static void CreateDatabaseIfNotExists(IHost host)
    {
      using var scope = host.Services.CreateScope();
      var services = scope.ServiceProvider;

      try
      {
        var context = services.GetRequiredService<ApiContext>();
        context.Database.EnsureCreated();
      }
      catch (Exception ex)
      {
        var logger = services.GetRequiredService<ILogger>();
        logger.Error(ex, "An error occurred creating the DB.");
      }
    }

    public static IHostBuilder CreateHostBuilder(string[] args)
    {
      return Host.CreateDefaultBuilder(args)
       .ConfigureWebHostDefaults(webBuilder =>
       {
         webBuilder.ConfigureKestrel(serverOptions =>
         {
           serverOptions.Listen(IPAddress.Any, 8000,
             listenOptions =>
             {
               listenOptions.UseHttps(StoreName.My, "lewiscummins.dev",
                 allowInvalid: false, StoreLocation.LocalMachine);
             });
         })
         .UseStartup<Startup>();
       });
    }
  }
}

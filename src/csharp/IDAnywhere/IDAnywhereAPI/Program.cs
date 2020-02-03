using System.Net;
using System.Security.Cryptography.X509Certificates;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Serilog;
using Serilog.Extensions.Logging;

namespace IDAnywhereAPI
{
  public class Program
  {
    public static void Main(string[] args)
    {
      CreateHostBuilder(args).Build().Run();
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

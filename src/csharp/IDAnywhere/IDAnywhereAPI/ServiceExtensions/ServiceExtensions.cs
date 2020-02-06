using Microsoft.Extensions.DependencyInjection;
using Serilog;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IDAnywhereAPI.ServiceExtensions
{
  internal static class ServiceExtensions
  {
    public static IServiceCollection AddSerilogServices(this IServiceCollection services)
    {
      Log.Logger = new LoggerConfiguration()
          .Enrich.FromLogContext()
          .WriteTo.File("./Logs/log-.txt", rollingInterval: RollingInterval.Day)
          .CreateLogger();

      AppDomain.CurrentDomain.ProcessExit += (s, e) => Log.CloseAndFlush();
      return services.AddSingleton(Log.Logger);
    }
  }
}

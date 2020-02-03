using DataLayer.SQL;
using Serilog;
using System;
using System.Collections.Generic;
using System.Text;

namespace ServiceLayer
{
  public class BaseService<T>
  {
    protected ServiceResult ServiceResult { get; set; }

    protected ApiContext Db { get; private set; }

    protected ILogger Logger { get; private set; }

    public BaseService(ApiContext db, ILogger logger)
    {
      Db = db;
      Logger = logger.ForContext<T>();
    }
  }
}

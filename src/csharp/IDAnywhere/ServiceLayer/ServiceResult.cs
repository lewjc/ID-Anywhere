using System;
using System.Collections.Generic;
using System.Text;

namespace ServiceLayer
{
  public class ServiceResult
  {

    public Dictionary<string, object> Values { get; set; }

    public List<string> Errors { get; set; }

    public bool Valid 
    {
      get
      {
        return Errors != null && Errors.Count == 0;
      }
    }
  }
}

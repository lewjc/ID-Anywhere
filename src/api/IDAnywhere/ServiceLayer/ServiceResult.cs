using System;
using System.Collections.Generic;
using System.Text;

namespace ServiceLayer
{
  public class ServiceResult
  {
    public Dictionary<string, string> Values { get; set; } = new Dictionary<string, string>();

    public List<string> Errors { get; set; } = new List<string>();

    public bool Valid 
    {
      get
      {
        return Errors != null && Errors.Count == 0;
      }
    }
  }
}

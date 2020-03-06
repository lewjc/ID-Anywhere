using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace WebApp.Results
{
  public class LoginResult
  {
    [JsonPropertyName("firstname")]
    public string FirstName { get; set; }

    [JsonPropertyName("token")]
    public string Token { get; set; }

    [JsonPropertyName("status")]
    public string Status { get; set; }
    public bool IsValid { get { return Errors.Count == 0; } }
    public List<string> Errors { get; set; } = new List<string>();
  }
}

using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace ServiceLayer.CodeVault
{
  public class CodeBuilder
  {
    private readonly Dictionary<string, string> builder;

    public CodeBuilder()
    {
      builder = new Dictionary<string, string>();
    }

    public CodeBuilder AddAppId(string appId)
    {
      builder["1"] = appId;
      return this;
    }

    public CodeBuilder AddPassportNumber(string passportNumber)
    {
      builder["2"] = passportNumber;
      return this;
    }

    public CodeBuilder AddLicenseNumber(string licenseNumber)
    {
      builder["3"] = licenseNumber;
      return this;
    }

    public CodeBuilder AddGUID(string guid)
    {
      builder["4"] = guid;
      return this;
    }

    public string Build()
    {
      if(builder.Keys.Count != 4)
      {
        throw new Exception("Not all data fileds required have been added to the CodeBuilder.");
      }
      string code = builder["1"] + "." + builder["2"] + "." + builder["3"] + "." + builder["4"];
      using var hasher = new SHA256Managed();
      var codeBytes = Encoding.UTF8.GetBytes(code);
      var password = hasher.ComputeHash(codeBytes);
      return BitConverter.ToString(password).Replace("-", string.Empty).ToLower();
    }
  }
}

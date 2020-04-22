using AutoMapper;
using DataLayer.SQL;
using Serilog;
using ServiceLayer.CodeVault;
using ServiceLayer.Interfaces;
using ServiceModels;
using System;
using System.Threading.Tasks;

namespace ServiceLayer.Implementations
{
  public class CodeService : BaseService<CodeService>, ICodeService
  {
    private readonly ICodeVault codeVault;

    public CodeService(ICodeVault codeVault, ApiContext db, ILogger logger, IMapper mapper) : base(db, logger, mapper)
    {
      this.codeVault = codeVault;
    }

    public async Task<string> CreateCode(string userId)
    {
      var guid = Guid.NewGuid().ToString();
      var user = await Db.Users.FindAsync(int.Parse(userId));
      var passportNumber = user.PassportNumber;
      var licenseNumber = user.LicenseNumber;
      var appId = user.AppID;
      CodeBuilder builder = new CodeBuilder();
      var hashedCode = builder
        .AddAppId(appId)
        .AddGUID(guid)
        .AddLicenseNumber(licenseNumber)
        .AddPassportNumber(passportNumber.ToString())
        .Build();
      codeVault.AddHashCodeToVault(hashedCode);
      return hashedCode;
    }

    public async Task<ServiceResult> ValidateCode(DateTimeOffset timeOfRequest, CodeVerificationSM sm, string userId)
    {
      if (codeVault.ValidateHash(sm.Code, timeOfRequest.ToUnixTimeSeconds()))
      {
        // Check date of birth.
        var user = await Db.Users.FindAsync(int.Parse(userId));
        if (user.DateOfBirth.Value < DateTime.Today.AddYears(-sm.MinimumAgeRequired))
        {
          return ServiceResult;
        }
        else
        {
          ServiceResult.Errors.Add("User is not old enough");
          return ServiceResult;
        }
      }
      ServiceResult.Errors.Add("Code provided is invalid.");
      return ServiceResult;
    }
  }
}

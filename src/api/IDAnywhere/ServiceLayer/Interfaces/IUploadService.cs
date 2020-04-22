using ServiceModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ServiceLayer.Interfaces
{
  public interface IUploadService
  {
    Task<bool> AddPassportDataToJob(PassportSM passportSM, string userId, string appId);

    Task<bool> AddLicenseDataToJob(LicenseSM licenseSM, string userId, string appId);

    Task<bool> MarkBackLicenseUploaded(string userId, string appId);
  }
}

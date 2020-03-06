using ServiceModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ServiceLayer.Interfaces
{
  public interface ICodeService
  {
    Task<string> CreateCode(string userId);
    Task<ServiceResult> ValidateCode(DateTimeOffset timeOfRequest, CodeVerificationSM sm, string userId);
  }
}

using ServiceModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ServiceLayer.Interfaces
{
  public interface ISignupService
  {
    Task<ServiceResult> ExecuteSignup(SignUpSM sm);
  }
}

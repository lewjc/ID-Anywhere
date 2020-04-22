using ServiceModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ServiceLayer.Interfaces
{
  public interface IFinalJobPreperationService
  {
    Task<ServiceResult> CreateFinalJob(string userId);
    List<JobSM> GetJobs(int amount, int skip);
    JobSM GetJob(int ID);
    Task<bool> UpdateJob(FinalJobSM job);
    Task<bool> FinaliseUserFromJob(int userId, string licenseNumber, long passportNumber, DateTime dateOfBirth);
  }
}

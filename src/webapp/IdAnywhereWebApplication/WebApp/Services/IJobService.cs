using System.Collections.Generic;
using System.Threading.Tasks;
using WebApp.Models;

namespace WebApp.Services
{
  public interface IJobService
  {
    Task<List<JobViewModel>> LoadJobs(int page, int size, string bearer);

    Task<JobViewModel> GetJob(int Id, string bearerToken);

    Task<bool> UpdateJob(JobViewModel model, string bearerToken);
  }
}
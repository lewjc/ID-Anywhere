using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using DataLayer.Mongo;
using DataLayer.SQL;
using DataModels;
using Dependency.Enums;
using Serilog;
using ServiceLayer.Interfaces;
using ServiceModels;

namespace ServiceLayer.Implementations
{
  public class FinalJobPreperationService : BaseService<FinalJobPreperationService>, IFinalJobPreperationService
  {
    private readonly IMongoWorkQueue workQueue;

    public FinalJobPreperationService(ApiContext db, ILogger logger, IMapper mapper, IMongoWorkQueue workQueue) : base(db, logger, mapper)
    {
      this.workQueue = workQueue;
    }

    public async Task<ServiceResult> CreateFinalJob(string userId)
    {
      // Okay, get the user from the database and also get the mongo work document.
      // Create a job in a new database table called FinalJob. When this is created, we can then push it to the database. Then, the mvc can request a list of jobs. Each with information about the Job. 
      // The way to handle the images.. we can get download links for each of them for 10 minutes..pass that in the 
      // Job JSON then display this in the MVC?

      try
      {
        WorkDocument document = await workQueue.FindByUserId(userId);
        var user = Db.Users.Find(int.Parse(userId)); ;
        user.Status = Dependency.Enums.UserStatus.Pending;

        JobDM dm = new JobDM()
        {
          UserId = userId,
          ClaimedFirstName = user.FirstName,
          ClaimedLastName = user.LastName,
          FirstNameLicense = document.LicenseData.FirstName,
          LastNameLicense = document.LicenseData.LastName,
          LicenseNumber = document.LicenseData.Number,
          LicenseDateOfBirth = document.LicenseData.DateOfBirth,
          LicenseExpiry = document.LicenseData.Expiry,
          FirstNamePassport = document.PassportData.FirstName,
          LastNamePassport = document.PassportData.LastName,
          PassportNumber = document.PassportData.Number,
          PassportExpiry = document.PassportData.Expiry,
          MRZ = document.PassportData.MRZ,
          PassportDateOfBirth = document.PassportData.DateOfBirth,
          AppId = user.AppID,
          Created = DateTime.Now
        };

        Db.Jobs.Add(dm);
        await Db.SaveChangesAsync();
      }
      catch (Exception e)
      {
        Logger.Error(e.ToString());
        ServiceResult.Errors.Add("Error creating the final job.");
      }

      return ServiceResult;
    }

    public List<JobSM> GetJobs(int pageSize, int pageNumber)
    {
      var jobs = Db.Jobs.Where(x => !x.Valid).OrderByDescending(k => k.Created).Skip(pageNumber == 1 ? 0 : pageNumber * pageSize).Take(pageSize).ToList();
      return mapper.Map<List<JobDM>, List<JobSM>>(jobs);
    }

    public JobSM GetJob(int ID)
    {
      return mapper.Map<JobSM>(Db.Jobs.Find(ID));
    }

    public async Task<bool> UpdateJob(FinalJobSM job)
    {
      var entity = Db.Jobs  .Find(job.ID);
      entity = mapper.Map(job, entity);
      Db.Jobs.Update(entity);
      return await Db.SaveChangesAsync() == 1;
    }

    public async Task<bool> FinaliseUserFromJob(int userId, string licenseNumber, long passportNumber, DateTime dateOfBirth)
    {
      try
      {
        var user = await Db.Users.FindAsync(userId);
        user.Status = UserStatus.Verified;
        user.LicenseNumber = licenseNumber;
        user.PassportNumber = passportNumber;
        user.DateOfBirth = dateOfBirth;

        // TODO: Delete the images.
         

        return await Db.SaveChangesAsync() == 1;
      }
      catch (Exception e)
      {
        Logger.Error(e.ToString());
        return false;
      }
    }
  }
}

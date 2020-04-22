using DataLayer.Mongo;
using DataLayer.Mongo.WorkModels;
using Serilog;
using ServiceLayer.Interfaces;
using ServiceModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace ServiceLayer
{
  public class UploadService : IUploadService
  {

    private readonly IMongoWorkQueue _workQueue;

    private readonly ILogger _logger;

    public UploadService(IMongoWorkQueue workQueue, ILogger logger)
    {
      _workQueue = workQueue;
      _logger = logger;
    }

    public async Task<bool> AddPassportDataToJob(PassportSM passportSM, string userId, string appId)
    {
      var currentDocument = await _workQueue.FindByUserId(userId);
      if (currentDocument == null)
      {

        // This is the first thing that a user has uploaded. Create a new work task for them.      
        var document = new WorkDocument()
        {
          UserId = userId,
          PassportData = CreatePassportData(passportSM),
          AppID = appId
        };

        bool didCreate = await _workQueue.CreateWorkDocumentAsync(document);

        if (!didCreate)
        {
          _logger.Error("Failed to create new work document using passport data.");
          return false;
        }

        CheckUploadJobComplete(document);
        // All good, work document created.
        return true;
      }
      else
      {
        currentDocument.PassportData = CreatePassportData(passportSM);
        bool didCreate = await _workQueue.UpdateWorkDocumentAsync(currentDocument);

        if (!didCreate)
        {
          _logger.Error("Failed to create new work document using passport data.");
          return false;
        }

        // All good, work document created.
        CheckUploadJobComplete(currentDocument);
        return true;
      }
    }

    public async Task<bool> AddLicenseDataToJob(LicenseSM licenseSM, string userId, string appId)
    {
      var currentDocument = await _workQueue.FindByUserId(userId);
      if (currentDocument == null)
      {

        // This is the first thing that a user has uploaded. Create a new work task for them.      
        var document = new WorkDocument()
        {
          UserId = userId,
          LicenseData = CreateLicenseData(licenseSM),
          AppID = appId
        };

        bool didCreate = await _workQueue.CreateWorkDocumentAsync(document);

        if (!didCreate)
        {
          _logger.Error("Failed to create new work document using license data.");
          return false;
        }

        CheckUploadJobComplete(document);

        // All good, work document created.
        return true;
      }
      else
      {
        currentDocument.LicenseData = CreateLicenseData(licenseSM);
        bool didCreate = await _workQueue.UpdateWorkDocumentAsync(currentDocument);

        if (!didCreate)
        {
          _logger.Error("Failed to create new work document using license data.");
          return false;
        }

        // All good, work document updated.
        CheckUploadJobComplete(currentDocument);
        return true;
      }
    }

    public async Task<bool> MarkBackLicenseUploaded(string userId, string appId)
    {
      var currentDocument = await _workQueue.FindByUserId(userId);
      if (currentDocument == null)
      {

        // This is the first thing that a user has uploaded. Create a new work task for them.      
        var document = new WorkDocument()
        {
          UserId = userId,
          BackLicenseUploaded = true,
          AppID = appId
        };

        bool didCreate = await _workQueue.CreateWorkDocumentAsync(document);

        if (!didCreate)
        {
          _logger.Error("Failed to create new work document.");
          return false;
        }

        CheckUploadJobComplete(document);

        // All good, work document created.
        return true;
      }
      else
      {
        currentDocument.BackLicenseUploaded = true;
        bool didCreate = await _workQueue.UpdateWorkDocumentAsync(currentDocument);

        if (!didCreate)
        {
          _logger.Error("Failed to create new work document using license data.");
          return false;
        }

        // All good, work document updated.
        CheckUploadJobComplete(currentDocument);
        return true;
      }
    }


    private PassportData CreatePassportData(PassportSM passportSM)
    {
      return new PassportData()
      {
        FirstName = passportSM.FirstName,
        LastName = passportSM.LastName,
        MRZ = passportSM.MRZ,
        Number = passportSM.Number,
        DateOfBirth = passportSM.DateOfBirth,
        Expiry = passportSM.Expiry
      };
    }

    private LicenseData CreateLicenseData(LicenseSM licenseSM)
    {
      return new LicenseData()
      {
        FirstName = licenseSM.FirstName,
        LastName = licenseSM.LastName,
        Number = licenseSM.Number,
        DateOfBirth = licenseSM.DateOfBirth,
        Expiry = licenseSM.Expiry
      };
    }

    private async void CheckUploadJobComplete(WorkDocument document)
    {

      if (document.LicenseData != null && document.PassportData != null && document.BackLicenseUploaded)
      {
        document.Ready = true;
        bool didCreate = await _workQueue.UpdateWorkDocumentAsync(document);
      }
    }
  }
}

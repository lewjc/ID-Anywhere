using MongoDB.Bson;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace DataLayer.Mongo
{
  public interface IMongoWorkQueue
  {
    Task<bool> CreateWorkDocumentAsync(WorkDocument document);

    Task<bool> UpdateWorkDocumentAsync(WorkDocument document);

    Task<WorkDocument> FindByUserId(string userGUID);
  }
}

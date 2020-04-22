using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Text;
using Serilog;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;

namespace DataLayer.Mongo
{
  public class MongoWorkQueue : IMongoWorkQueue
  {
    private readonly MongoClient _client;
    private readonly IMongoDatabase _idAnywhere;
    private readonly IMongoCollection<WorkDocument> _workQueue;
    private readonly ILogger _logger;

    public MongoWorkQueue(IConfiguration configuration, ILogger logger)
    {
      _logger = logger.ForContext<MongoWorkQueue>();
      try
      {
        var host = configuration["MongoWorkQueueSettings:Host"];
        var port = configuration["MongoWorkQueueSettings:Port"];
        var db = configuration["MongoWorkQueueSettings:Db"];
        var collection = configuration["MongoWorkQueueSettings:Collection"];
        var url = new MongoUrl($"mongodb://{host}:{port}");
        _client = new MongoClient(url);
        _idAnywhere = _client.GetDatabase(db);
        _workQueue = _idAnywhere.GetCollection<WorkDocument>(collection);
      }
      catch (Exception e)
      {

      }
    }

    public async Task<bool> CreateWorkDocumentAsync(WorkDocument document)
    {
      var filter = new FilterDefinitionBuilder<WorkDocument>().Eq(x => x.ID, document.ID);
      var docExists = (await FindByUserId(document.UserId)) != null;

      if (docExists)
      {
        // User already has a work job that needs to be appended too.
        return false;
      }

      await _workQueue.InsertOneAsync(document);

      return true;
    }

    public async Task<bool> UpdateWorkDocumentAsync(WorkDocument document)
    {
      // Find the same document and update it.
      var filter = new FilterDefinitionBuilder<WorkDocument>().Eq(x => x.UserId, document.UserId);
      var replaceResult = await _workQueue.ReplaceOneAsync(filter, document);
      return replaceResult.IsAcknowledged;
    }


    public async Task<WorkDocument> FindByUserId(string userGUID)
    {
      var filter = new FilterDefinitionBuilder<WorkDocument>().Eq(x => x.UserId, userGUID);
      var subject = (await _workQueue.FindAsync(filter)).FirstOrDefault();
      return subject;
    }
  }
}


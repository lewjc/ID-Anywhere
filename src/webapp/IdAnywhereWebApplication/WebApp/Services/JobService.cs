using Firebase.Auth;
using Firebase.Storage;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using WebApp.Models;

namespace WebApp.Services
{
  public class JobService : IJobService
  {
    private readonly IHttpClientFactory clientFactory;
    private readonly IConfiguration configuration;

    public JobService(IHttpClientFactory clientFactory, IConfiguration configuration)
    {
      this.clientFactory = clientFactory;
      this.configuration = configuration;
    }

    public async Task<List<JobViewModel>> LoadJobs(int page, int size, string bearerToken)
    {
      var request = new HttpRequestMessage(HttpMethod.Get,
      $"{configuration["Api:Url"]}job/getjobs?pageSize={size}&pageNumber={page}");
      request.Headers.Add("Accept", "application/json");
      request.Headers.Add("Authorization", $"bearer {bearerToken}");

      using var client = clientFactory.CreateClient();
      HttpResponseMessage response = null;
      try
      {
        response = await client.SendAsync(request);
      }
      catch (Exception e)
      {
        Console.Write(e);
      }

      if (response.IsSuccessStatusCode)
      {
        var responseStream = await response.Content.ReadAsStringAsync();
        var result = JsonConvert.DeserializeObject
            <List<JobViewModel>>(responseStream);

        return result;
      }
      return null;
    }

    public async Task<JobViewModel> GetJob(int Id, string bearerToken)
    {
      var request = new HttpRequestMessage(HttpMethod.Get,
      $"{configuration["Api:Url"]}job/getJob?Id={Id}");
      request.Headers.Add("Accept", "application/json");
      request.Headers.Add("Authorization", $"bearer {bearerToken}");

      using var client = clientFactory.CreateClient();
      HttpResponseMessage response = null;
      try
      {
        response = await client.SendAsync(request);
      }
      catch (Exception e)
      {
        Console.Write(e);
      }

      if (response.IsSuccessStatusCode)
      {
        var responseStream = await response.Content.ReadAsStringAsync();
        var result = JsonConvert.DeserializeObject
            <JobViewModel>(responseStream);

        await GetJobImageUrls(result);
        return result;
      }

      return null;
    }

    public async Task<bool> UpdateJob(JobViewModel model, string bearerToken)
    {
      var request = new HttpRequestMessage(HttpMethod.Put,
      $"{configuration["Api:Url"]}job/updateJob?Id={model.ID}");
      request.Headers.Add("Accept", "application/json");
      request.Headers.Add("Authorization", $"bearer {bearerToken}");
      StringContent content = new StringContent(System.Text.Json.JsonSerializer.Serialize(model), Encoding.UTF8, "application/json");
      request.Content = content;
      using var client = clientFactory.CreateClient();
      HttpResponseMessage response = null;
      try
      {
        response = await client.SendAsync(request);
      }
      catch (Exception e)
      {
        Console.Write(e);
      }

      if (response.IsSuccessStatusCode)
      {
        return true;
      }

      return false;
    }

    private async Task GetJobImageUrls(JobViewModel vm)
    {
      using FirebaseAuthProvider authProvider = new FirebaseAuthProvider(new FirebaseConfig(configuration["AppSettings:Firebase:ApiKey"]));
      string email = configuration["AppSettings:Firebase:Email"];
      string password = configuration["AppSettings:Firebase:Password"];
      var auth = await authProvider.SignInWithEmailAndPasswordAsync(email, password);

      var storage = new FirebaseStorage("dissertation-498be.appspot.com", new FirebaseStorageOptions() { AuthTokenAsyncFactory = () => Task.FromResult(auth.FirebaseToken) });

      var licenseBackTask = storage.Child("userinf").Child(vm.AppId).Child("license_back").GetDownloadUrlAsync();
      var licenseFrontTask = storage.Child("userinf").Child(vm.AppId).Child("license_front").GetDownloadUrlAsync();
      var passportTask = storage.Child("userinf").Child(vm.AppId).Child("passport").GetDownloadUrlAsync();

      await Task.WhenAll(new Task[] { licenseBackTask, licenseFrontTask, passportTask });

      vm.PassportUrl = passportTask.Result;
      vm.LicenseBackUrl = licenseBackTask.Result;
      vm.LicenseFrontUrl = licenseFrontTask.Result;
    }
  }
}

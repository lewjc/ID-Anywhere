using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using WebApp.Models;
using WebApp.Results;

namespace WebApp.Services
{
  public class LoginService : ILoginService
  {
    private readonly IHttpClientFactory clientFactory;
    private readonly IConfiguration configuration;

    public LoginService(IHttpClientFactory clientFactory, IConfiguration configuration)
    {
      this.clientFactory = clientFactory;
      this.configuration = configuration;
    }

    public async Task<LoginResult> AttemptLogin(LoginViewModel model)
    {
      var request = new HttpRequestMessage(HttpMethod.Post,
          $"{configuration["Api:Url"]}account/login");
      request.Headers.Add("Accept", "application/json");
      StringContent content = new StringContent(JsonSerializer.Serialize(model), Encoding.UTF8, "application/json");
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
        using var responseStream = await response.Content.ReadAsStreamAsync();
        var result = await JsonSerializer.DeserializeAsync
            <LoginResult>(responseStream);

        return result;
      }
      else
      {
        if ((int)response.StatusCode == 400)
        {
          var result = new LoginResult();
          using var responseStream = await response.Content.ReadAsStreamAsync();
          result.Errors = await JsonSerializer.DeserializeAsync
            <List<string>>(responseStream);
          return result;
        }
        return null;
      }
    }
  }
}

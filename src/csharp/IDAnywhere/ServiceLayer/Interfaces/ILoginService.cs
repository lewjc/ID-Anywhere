namespace ServiceLayer.Interfaces
{
  public interface ILoginService
  {
    ServiceResult AttemptLogin(string email, string password); 
  }
}

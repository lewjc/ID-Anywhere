using ServiceModels;
using System.Threading.Tasks;

namespace ServiceLayer.Interfaces
{
  public interface ILoginService
  {
    Task<ServiceResult> AttemptLogin(LoginSM sm); 
  }
}

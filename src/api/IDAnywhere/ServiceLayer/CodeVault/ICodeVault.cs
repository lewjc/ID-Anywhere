using System;
using System.Collections.Generic;
using System.Text;

namespace ServiceLayer.CodeVault
{
  public interface ICodeVault
  {
    bool ValidateHash(string hash, long currentTime);    
    bool AddHashCodeToVault(string hash);   
  }
}

using Microsoft.Extensions.Caching.Memory;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Text;

namespace ServiceLayer.CodeVault
{
  public class CodeVault : ICodeVault
  {
    private readonly MemoryCache codeCache;

    private readonly object codeLock = new object();

    public CodeVault()
    {
      codeCache = new MemoryCache(new MemoryCacheOptions()
      {
        ExpirationScanFrequency = TimeSpan.FromSeconds(60),
      });
    }

    public CodeVault(MemoryCacheOptions options)
    {
      codeCache = new MemoryCache(options);
    }

    public bool AddHashCodeToVault(string hash)
    {
      lock (codeLock)
      {
        codeCache.Set(hash, DateTimeOffset.UtcNow.AddSeconds(15).ToUnixTimeSeconds(), DateTimeOffset.UtcNow.AddSeconds(60));
        return true;
      }
    }

    public bool ValidateHash(string hash, long currentTime)
    {
      long? timestamp = 0;
      lock (codeLock)
      {
        timestamp = codeCache.Get(hash) as long?;
      }

      if (timestamp == null || timestamp == 0)
      {
        // Could not find code
        return false;
      }

      if (currentTime - timestamp < 0)
      {
        // Code is expired.
        return false;
      }

      return true;
    }
  }
}

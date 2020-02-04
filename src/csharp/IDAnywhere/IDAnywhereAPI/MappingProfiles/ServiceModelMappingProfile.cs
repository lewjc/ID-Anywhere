using AutoMapper;
using DataModels;
using ServiceModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace IDAnywhereAPI.MappingProfiles
{
  public class ServiceModelMappingProfile : Profile
  {
    public ServiceModelMappingProfile()
    {
      CreateMap<SignUpSM, UserDM>();
    }
  }
}

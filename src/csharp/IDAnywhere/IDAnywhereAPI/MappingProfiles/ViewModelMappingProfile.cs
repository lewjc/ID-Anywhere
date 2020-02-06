using AutoMapper;
using ServiceModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ViewModels;

namespace IDAnywhereAPI.MappingProfiles
{
  public class ViewModelMappingProfile : Profile
  {
    public ViewModelMappingProfile()
    {
      CreateMap<SignUpVM, SignUpSM>();
      CreateMap<LoginVM, LoginSM>();
    }
  }
}

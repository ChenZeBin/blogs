//
//  BMacro.h
//  AFNetWorkingStudy
//
//  Created by ChenZeBin on 2020/3/27.
//  Copyright © 2020 ChenZeBin. All rights reserved.
//

#ifndef BMacro_h
#define BMacro_h

#ifndef __Require_Quiet
    #define __Require_Quiet(assertion, exceptionLabel)                            \
      do                                                                          \
      {                                                                           \
          if ( __builtin_expect(!(assertion), 0) )                                \
          {                                                                       \
              goto exceptionLabel;                                                \
          }                                                                       \
      } while ( 0 )
#endif

#ifndef __nRequire_Quiet
    #define __nRequire_Quiet(assertion, exceptionLabel)  __Require_Quiet(!(assertion), exceptionLabel)
#endif

#endif /* BMacro_h */

##############################################################################
# CMakeLists.txt file for multiple projects in subfolders
# Location: Root folder of the project
# \author Qingsong Wu (mailto:qqsongzi@gmail.com)
#
# \date April 8th, 2013
##############################################################################

CMAKE_MINIMUM_REQUIRED(VERSION 3.1)

SET(proj_name darknet)
PROJECT(${proj_name} C)

INCLUDE_DIRECTORIES("include")

IF(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
  SET(CUDA_TOOLKIT_ROOT_DIR "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v8.0/")
ELSE()
  SET(CUDA_TOOLKIT_ROOT_DIR "/usr/local/cuda")
ENDIF()
FIND_PACKAGE(CUDA REQUIRED)
ADD_DEFINITIONS(-DGPU -DCUDNN)
# Pass options to NVCC
IF(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
  SET(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -O3 -gencode arch=compute_61,code=sm_61 -Xcompiler ${RT})
ELSE()
  SET(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -O3 -gencode arch=compute_61,code=sm_61)
ENDIF()

FILE(GLOB cu_srcs "src/*.cu")
SOURCE_GROUP("cuda" FILES ${cu_srcs})
cuda_compile(cu_objs ${cu_srcs})
SOURCE_GROUP("cuda\\obj" FILES ${cu_objs})
SET(cuda_objs_and_srcs ${cu_objs} ${cu_srcs})

FIND_PACKAGE(OpenCV REQUIRED)
ADD_DEFINITIONS(-DOPENCV)

FILE(GLOB hdrs "include/*.h" "src/*.h")
FILE(GLOB srcs "src/*.c")
FOREACH(f ${srcs})
  IF(${f} MATCHES "demo.c$")
    LIST(REMOVE_ITEM srcs ${f})
  ENDIF()
ENDFOREACH()
SOURCE_GROUP("Header Files" FILES ${hdrs})
SOURCE_GROUP("Source Files" FILES ${srcs})

ADD_LIBRARY(${proj_name} STATIC ${srcs} ${hdrs} ${cuda_objs_and_srcs})

SET_TARGET_PROPERTIES(${proj_name} PROPERTIES OUTPUT_NAME ${proj_name})
SET_TARGET_PROPERTIES(${proj_name} PROPERTIES DEBUG_POSTFIX d)
SET_TARGET_PROPERTIES(${proj_name} PROPERTIES CLEAN_DIRECT_OUTPUT 1)

TARGET_LINK_LIBRARIES(${proj_name} ${OpenCV_LIBS} cuda cudart cudnn curand cublas)

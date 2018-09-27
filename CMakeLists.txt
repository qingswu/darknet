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
  SET(CUDA_TOOLKIT_ROOT_DIR "C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v9.1/")
ELSE()
  SET(CUDA_TOOLKIT_ROOT_DIR "/usr/local/cuda")
ENDIF()
FIND_PACKAGE(CUDA QUIET)
IF(CUDA_FOUND)
  INCLUDE_DIRECTORIES(${CUDA_TOOLKIT_ROOT_DIR}/include)
  ADD_DEFINITIONS(-DGPU -DCUDNN)

  # Pass options to NVCC
  IF(${CMAKE_SYSTEM_NAME} STREQUAL Windows)
    SET(CUDA_NVCC_FLAGS_DEBUG   ${CUDA_NVCC_FLAGS_DEBUG};   -O3 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_61,code=sm_61 -Xcompiler "/MDd")
	  SET(CUDA_NVCC_FLAGS_RELEASE ${CUDA_NVCC_FLAGS_RELEASE}; -O3 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_61,code=sm_61 -Xcompiler "/MD")
  ELSE()
    SET(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS}; -O3 -gencode arch=compute_52,code=sm_52 -gencode arch=compute_61,code=sm_61)
  ENDIF()
  LINK_DIRECTORIES(${CUDA_TOOLKIT_ROOT_DIR}/lib/x64)

  FILE(GLOB cu_srcs "src/*.cu")
  SOURCE_GROUP("cuda" FILES ${cu_srcs})
  cuda_compile(cu_objs ${cu_srcs})
  SOURCE_GROUP("cuda\\obj" FILES ${cu_objs})
  SET(cuda_objs_and_srcs ${cu_objs} ${cu_srcs})
ENDIF()

FILE(GLOB hdrs "include/darknet.h"
	src/activations.h
	src/activation_layer.h
	src/avgpool_layer.h
	src/batchnorm_layer.h
	src/blas.h
	src/box.h
	src/classifier.h
	src/col2im.h
	src/connected_layer.h
	src/convolutional_layer.h
	src/cost_layer.h
	src/crnn_layer.h
	src/crop_layer.h
	src/cuda.h
	src/data.h
	src/deconvolutional_layer.h
	src/demo.h
	src/detection_layer.h
	src/dropout_layer.h
	src/gemm.h
	src/gru_layer.h
	src/im2col.h
	src/image.h
	src/iseg_layer.h
	src/l2norm_layer.h
	src/layer.h
	src/list.h
	src/local_layer.h
	src/logistic_layer.h
	src/lstm_layer.h
	src/matrix.h
	src/maxpool_layer.h
	src/network.h
	src/normalization_layer.h
	src/option_list.h
	src/parser.h
	src/region_layer.h
	src/reorg_layer.h
	src/rnn_layer.h
	src/route_layer.h
	src/shortcut_layer.h
	src/softmax_layer.h
	src/stb_image.h
	src/stb_image_write.h
	src/tree.h
	src/upsample_layer.h
	src/utils.h
	src/yolo_layer.h
  )
FILE(GLOB srcs 
src/activations.c
src/activation_layer.c
src/avgpool_layer.c
src/batchnorm_layer.c
src/blas.c
src/box.c
src/col2im.c
# src/compare.c
src/connected_layer.c
src/convolutional_layer.c
src/cost_layer.c
src/crnn_layer.c
src/crop_layer.c
src/cuda.c
src/data.c
src/deconvolutional_layer.c
# src/demo.c
src/detection_layer.c
src/dropout_layer.c
src/gemm.c
src/gru_layer.c
src/im2col.c
src/image.c
src/iseg_layer.c
src/l2norm_layer.c
src/layer.c
src/list.c
src/local_layer.c
src/logistic_layer.c
src/lstm_layer.c
src/matrix.c
src/maxpool_layer.c
src/network.c
src/normalization_layer.c
src/option_list.c
src/parser.c
src/region_layer.c
src/reorg_layer.c
src/rnn_layer.c
src/route_layer.c
src/shortcut_layer.c
src/softmax_layer.c
src/tree.c
src/upsample_layer.c
src/utils.c
src/yolo_layer.c
)

SOURCE_GROUP("Header Files" FILES ${hdrs})
SOURCE_GROUP("Source Files" FILES ${srcs})

ADD_LIBRARY(${proj_name} STATIC ${srcs} ${hdrs} ${cuda_objs_and_srcs})

SET_TARGET_PROPERTIES(${proj_name} PROPERTIES OUTPUT_NAME ${proj_name})
SET_TARGET_PROPERTIES(${proj_name} PROPERTIES DEBUG_POSTFIX d)
SET_TARGET_PROPERTIES(${proj_name} PROPERTIES CLEAN_DIRECT_OUTPUT 1)

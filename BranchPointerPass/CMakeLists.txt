set(LT_LLVM_INSTALL_DIR "" CACHE PATH "LLVM installation directory")

list(APPEND CMAKE_PREFIX_PATH "${LT_LLVM_INSTALL_DIR}/lib/cmake/llvm/")

if(UNIX AND NOT APPLE)
    set(LLVM_DIR /usr/lib/llvm-17)
    list(APPEND CMAKE_PREFIX_PATH /usr/lib/llvm-17/lib/cmake/llvm/)
    include(~/tmpdir/vcpkg/scripts/buildsystems/vcpkg.cmake)
endif()
find_package(LLVM CONFIG)
if("${LLVM_VERSION_MAJOR}" VERSION_LESS 16)
  message(FATAL_ERROR "Found LLVM ${LLVM_VERSION_MAJOR}, but need LLVM 16 or above")
endif()

# include_directories(SYSTEM ${LLVM_INCLUDE_DIRS} /usr/local/include)
include_directories(SYSTEM ${LLVM_INCLUDE_DIRS})

set(CMAKE_CXX_STANDARD 17 CACHE STRING "")

if(NOT LLVM_ENABLE_RTTI)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
endif()

# Find the nlohmann_json package
# find_package(nlohmann_json 3.2.0 REQUIRED)
# if on linux
find_package(nlohmann_json CONFIG REQUIRED)
    # target_link_libraries(main PRIVATE nlohmann_json::nlohmann_json)

add_library(BranchPointerPass MODULE
    BranchPointerPass.cpp
)

target_compile_features(BranchPointerPass PRIVATE cxx_range_for cxx_auto_type)

target_link_libraries(BranchPointerPass LLVM nlohmann_json::nlohmann_json)

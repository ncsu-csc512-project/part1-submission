cmake_minimum_required(VERSION 3.10)

project(BranchPointerProfiler)

find_package(LLVM REQUIRED CONFIG)

add_subdirectory(BranchPointerPass)

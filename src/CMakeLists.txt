cmake_minimum_required(VERSION 3.8)
project(cpp_webapi_poc)

set(CMAKE_CXX_STANDARD 17)

find_package(Boost COMPONENTS system filesystem REQUIRED)
find_package(Threads)

include_directories(${Boost_INCLUDE_DIRS})

add_executable(cpp_webapi_poc main.cpp)

target_link_libraries(cpp_webapi_poc ${Boost_LIBRARIES} Threads::Threads)


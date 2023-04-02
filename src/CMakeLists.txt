cmake_minimum_required(VERSION 3.8)
project(cpp_webapi_poc)

set(CMAKE_CXX_STANDARD 17)
set(THREADS_PREFER_PTHREAD_FLAG ON)

add_executable(cpp_webapi_poc main.cpp)

find_package(Boost COMPONENTS system filesystem REQUIRED)
find_package(Threads REQUIRED)
find_package(mongocxx REQUIRED)
find_package(bsoncxx REQUIRED)

target_link_libraries(${PROJECT_NAME} ${Boost_LIBRARIES} Threads::Threads mongo::bsoncxx_shared mongo::mongocxx_shared)

target_include_directories(${PROJECT_NAME} PRIVATE ${Boost_INCLUDE_DIRS} ${LIBMONGOCXX_INCLUDE_DIR} ${LIBBSONCXX_INCLUDE_DIR})




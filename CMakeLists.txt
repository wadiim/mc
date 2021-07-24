cmake_minimum_required(VERSION 3.12)

project(mc CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")
set(SFML_COMPONENTS graphics)

add_executable(mc main.cpp)

if(WIN32)
	set(SFML_STATIC_LIBRARIES TRUE)
endif(WIN32)

if(MSVC)
	list(APPEND SFML_COMPONENTS main)
endif(MSVC)

set(SFML_LIBRARIES ${SFML_COMPONENTS})
list(TRANSFORM SFML_LIBRARIES PREPEND "sfml-")

find_package(GMP REQUIRED)
find_package(MPFR 3.0.0 REQUIRED)
find_package(SFML 2.5 COMPONENTS ${SFML_COMPONENTS} REQUIRED)

include_directories(${GMP_INCLUDE_DIRS})
include_directories(${MPFR_INCLUDE_DIRS})
include_directories(${CMAKE_SOURCE_DIR}/mpreal)

target_link_libraries(mc
	${SFML_LIBRARIES}
	${GMP_LIBRARIES}
	${MPFR_LIBRARIES}
	)

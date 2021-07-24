#
# FindGMP
# --------
#
# Find GMP include dirs and libraries
#
# This module reads hint about search locations from variable:
#
#  GMP_ROOT - Preferred installation prefix
#
# This script creates the following variables:
#
#  GMP_FOUND         - Boolean that indicates if the package was found
#  GMP_INCLUDE_DIRS  - Paths to the necessary header files
#  GMP_LIBRARIES     - Package libraries
#  GMP_VERSION       - GMP version
#

# Find headers
find_path(GMP_INCLUDE_DIR
	NAMES gmp.h
	HINTS $ENV{GMP_ROOT} ${GMP_ROOT}
	PATHS /usr/local /usr /opt/local
	PATH_SUFFIXES
		include
		dll/Win32/Debug/
		dll/Win32/Release/
		dll/x64/Debug/
		dll/x64/Release/
	)

#message(${GMP_INCLUDE_DIR})

if(WIN32)
	set(CMAKE_FIND_LIBRARY_PREFIXES "lib" "")
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".dll" ".dll.a" ".a" ".lib")
endif(WIN32)

# Find libraries
find_library(GMP_LIBRARY
	NAMES gmp
	HINTS $ENV{GMP_ROOT} ${GMP_ROOT}
	PATHS /usr/local /usr /opt/local
	PATH_SUFFIXES
		lib
		dll/Win32/Debug/
		dll/Win32/Release/
		dll/x64/Debug/
		dll/x64/Release/
	)

#message(${GMP_LIBRARY})

# Set GMP_FIND_VERSION to 1.0.0 if no minimum version is specified
if(NOT GMP_FIND_VERSION)
	if(NOT GMP_FIND_VERSION_MAJOR)
		set(GMP_FIND_VERSION_MAJOR 1)
	endif()
	if(NOT GMP_FIND_VERSION_MINOR)
		set(GMP_FIND_VERSION_MINOR 0)
	endif()
	if(NOT GMP_FIND_VERSION_PATCH)
		set(GMP_FIND_VERSION_PATCH 0)
	endif()
	string(CONCAT GMP_FIND_VERSION
		"${GMP_FIND_VERSION_MAJOR}"
		".${GMP_FIND_VERSION_MINOR}"
		".${GMP_FIND_VERSION_PATCH}")
endif()

if(GMP_INCLUDE_DIR)
	# Query GMP_VERSION
	file(READ "${GMP_INCLUDE_DIR}/gmp.h" _gmp_header)
	string(REGEX MATCH "define[ \t_]+GNU_MP_VERSION[ \t]+([0-9]+)"
		_gmp_major_version_match "${_gmp_header}")
	set(GMP_MAJOR_VERSION "${CMAKE_MATCH_1}")
	string(REGEX MATCH "define[ \t_]+GNU_MP_VERSION_MINOR[ \t]+([0-9]+)"
		_gmp_minor_version_match "${_gmp_header}")
	set(GMP_MINOR_VERSION "${CMAKE_MATCH_1}")
	string(REGEX MATCH
		"define[ \t_]+GNU_MP_VERSION_PATCHLEVEL[ \t]+([0-9]+)"
		_gmp_patchlevel_version_match "${_gmp_header}")
	set(GMP_PATCHLEVEL_VERSION "${CMAKE_MATCH_1}")

	set(GMP_VERSION
		${GMP_MAJOR_VERSION}.${GMP_MINOR_VERSION}.${GMP_PATCHLEVEL_VERSION})

	if(${GMP_VERSION} VERSION_LESS ${GMP_FIND_VERSION})
		set(GMP_VERSION_OK FALSE)
		message(STATUS "GMP version ${GMP_VERSION} "
			"found in ${GMP_INCLUDES}, "
			"but at least version ${GMP_FIND_VERSION} "
			"is required")
	else()
		set(GMP_VERSION_OK TRUE)
	endif()
endif(GMP_INCLUDE_DIR)

# Set GMP_FOUND honoring the QUIET and REQUIRED arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
	GMP
	DEFAULT_MSG
	GMP_LIBRARY GMP_INCLUDE_DIR GMP_VERSION_OK
	)

# Output variables
if(GMP_FOUND)
	set(GMP_INCLUDE_DIRS ${GMP_INCLUDE_DIR})
	set(GMP_LIBRARIES ${GMP_LIBRARY})
endif(GMP_FOUND)

# Replece all occurrenses of Win32, x64, Debug and Release by $(Platform) and
# $(Configuration) in GMP_INCLUDE_DIRS and GMP_LIBRARIES variables
if(MSVC)
	if(GMP_FOUND)
		string(REGEX REPLACE "Win32" "$(Platform)"
			GMP_INCLUDE_DIRS ${GMP_INCLUDE_DIRS})
		string(REGEX REPLACE "x64" "$(Platform)"
			GMP_INCLUDE_DIRS ${GMP_INCLUDE_DIRS})
		string(REGEX REPLACE "Debug" "$(Configuration)"
			GMP_INCLUDE_DIRS ${GMP_INCLUDE_DIRS})
		string(REGEX REPLACE "Release" "$(Configuration)"
			GMP_INCLUDE_DIRS ${GMP_INCLUDE_DIRS})

		string(REGEX REPLACE "Win32" "$(Platform)"
			GMP_LIBRARIES ${GMP_LIBRARIES})
		string(REGEX REPLACE "x64" "$(Platform)"
			GMP_LIBRARIES ${GMP_LIBRARIES})
		string(REGEX REPLACE "Debug" "$(Configuration)"
			GMP_LIBRARIES ${GMP_LIBRARIES})
		string(REGEX REPLACE "Release" "$(Configuration)"
			GMP_LIBRARIES ${GMP_LIBRARIES})
	endif(GMP_FOUND)
endif(MSVC)

# Advanced options for not cluttering the cmake UIs:
mark_as_advanced(GMP_INCLUDE_DIR GMP_LIBRARY)

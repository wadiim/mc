#
# FindMPFR
# --------
#
# Find MPFR include dirs and libraries
#
# This module reads hint about search locations from variable:
#
#  MPFR_ROOT - Preferred installation prefix
#
# This script creates the following variables:
#
#  MPFR_FOUND         - Boolean that indicates if the package was found
#  MPFR_INCLUDE_DIRS  - Paths to the necessary header files
#  MPFR_LIBRARIES     - Package libraries
#  MPFR_VERSION       - MPFR version
#

# Find headers
find_path(MPFR_INCLUDE_DIR
	NAMES mpfr.h
	HINTS $ENV{MPFR_ROOT} ${MPFR_ROOT}
	PATHS /usr/local /usr /opt/local
	PATH_SUFFIXES
		include
		dll/Win32/Debug/
		dll/Win32/Release/
		dll/x64/Debug/
		dll/x64/Release/
	)

if(WIN32)
	set(CMAKE_FIND_LIBRARY_PREFIXES "lib" "")
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".dll" ".dll.a" ".a" ".lib")
endif(WIN32)

# Find libraries
find_library(MPFR_LIBRARY
	NAMES mpfr
	HINTS $ENV{MPFR_ROOT} ${MPFR_ROOT}
	PATHS /usr/local /usr /opt/local
	PATH_SUFFIXES
		lib
		dll/Win32/Debug/
		dll/Win32/Release/
		dll/x64/Debug/
		dll/x64/Release/
	)

# Set MPFR_FIND_VERSION to 1.0.0 if no minimum version is specified
if(NOT MPFR_FIND_VERSION)
	if(NOT MPFR_FIND_VERSION_MAJOR)
		set(MPFR_FIND_VERSION_MAJOR 1)
	endif()
	if(NOT MPFR_FIND_VERSION_MINOR)
		set(MPFR_FIND_VERSION_MINOR 0)
	endif()
	if(NOT MPFR_FIND_VERSION_PATCH)
		set(MPFR_FIND_VERSION_PATCH 0)
	endif()
	string(CONCAT MPFR_FIND_VERSION
		"${MPFR_FIND_VERSION_MAJOR}"
		".${MPFR_FIND_VERSION_MINOR}"
		".${MPFR_FIND_VERSION_PATCH}")
endif()

if(MPFR_INCLUDE_DIR)
	# Query MPFR_VERSION
	file(READ "${MPFR_INCLUDE_DIR}/mpfr.h" _mpfr_header)
	string(REGEX MATCH "define[ \t]+MPFR_VERSION_MAJOR[ \t]+([0-9]+)"
		_mpfr_major_version_match "${_mpfr_header}")
	set(MPFR_MAJOR_VERSION "${CMAKE_MATCH_1}")
	string(REGEX MATCH "define[ \t]+MPFR_VERSION_MINOR[ \t]+([0-9]+)"
		_mpfr_minor_version_match "${_mpfr_header}")
	set(MPFR_MINOR_VERSION "${CMAKE_MATCH_1}")
	string(REGEX MATCH "define[ \t]+MPFR_VERSION_PATCHLEVEL[ \t]+([0-9]+)"
		_mpfr_patchlevel_version_match "${_mpfr_header}")
	set(MPFR_PATCHLEVEL_VERSION "${CMAKE_MATCH_1}")

	set(MPFR_VERSION
		${MPFR_MAJOR_VERSION}.${MPFR_MINOR_VERSION}.${MPFR_PATCHLEVEL_VERSION})

	if(${MPFR_VERSION} VERSION_LESS ${MPFR_FIND_VERSION})
		set(MPFR_VERSION_OK FALSE)
		message(STATUS "MPFR version ${MPFR_VERSION} "
			"found in ${MPFR_INCLUDES}, "
			"but at least version ${MPFR_FIND_VERSION} "
			"is required")
	else()
		set(MPFR_VERSION_OK TRUE)
	endif()
endif(MPFR_INCLUDE_DIR)

# Set MPFR_FOUND honoring the QUIET and REQUIRED arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
	MPFR
	DEFAULT_MSG
	MPFR_LIBRARY MPFR_INCLUDE_DIR MPFR_VERSION_OK
	)

# Output variables
if(MPFR_FOUND)
	set(MPFR_INCLUDE_DIRS ${MPFR_INCLUDE_DIR})
	set(MPFR_LIBRARIES ${MPFR_LIBRARY})
endif(MPFR_FOUND)

# Replece all occurrenses of Win32, x64, Debug and Release by $(Platform) and
# $(Configuration) in MPFR_INCLUDE_DIRS and MPFR_LIBRARIES variables
if(MSVC)
	if(MPFR_FOUND)
		string(REGEX REPLACE "Win32" "$(Platform)"
			MPFR_INCLUDE_DIRS ${MPFR_INCLUDE_DIRS})
		string(REGEX REPLACE "x64" "$(Platform)"
			MPFR_INCLUDE_DIRS ${MPFR_INCLUDE_DIRS})
		string(REGEX REPLACE "Debug" "$(Configuration)"
			MPFR_INCLUDE_DIRS ${MPFR_INCLUDE_DIRS})
		string(REGEX REPLACE "Release" "$(Configuration)"
			MPFR_INCLUDE_DIRS ${MPFR_INCLUDE_DIRS})

		string(REGEX REPLACE "Win32" "$(Platform)"
			MPFR_LIBRARIES ${MPFR_LIBRARIES})
		string(REGEX REPLACE "x64" "$(Platform)"
			MPFR_LIBRARIES ${MPFR_LIBRARIES})
		string(REGEX REPLACE "Debug" "$(Configuration)"
			MPFR_LIBRARIES ${MPFR_LIBRARIES})
		string(REGEX REPLACE "Release" "$(Configuration)"
			MPFR_LIBRARIES ${MPFR_LIBRARIES})
	endif(MPFR_FOUND)
endif(MSVC)

# Advanced options for not cluttering the cmake UIs:
mark_as_advanced(MPFR_INCLUDE_DIR MPFR_LIBRARY)

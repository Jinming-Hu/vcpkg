set(LIB_NAME nghttp2)
set(LIB_VERSION 1.42.0)

set(LIB_FILENAME ${LIB_NAME}-${LIB_VERSION}.tar.gz)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO nghttp2/nghttp2
    REF v${LIB_VERSION}
    SHA512 717494c9aa4eda64414535752df947d62311e7aed5cc6c4936400fcb2c9fc2818923668bcabc3e1bc61154d660f6765dad120e5a113d9eee3e934d66ee63a406
    HEAD_REF master
)

if (VCPKG_LIBRARY_LINKAGE STREQUAL static)
    set(ENABLE_STATIC_LIB ON)
    set(ENABLE_SHARED_LIB OFF)
else()
    set(ENABLE_STATIC_LIB OFF)
    set(ENABLE_SHARED_LIB ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DENABLE_LIB_ONLY=ON
        -DENABLE_ASIO_LIB=OFF
        -DENABLE_STATIC_LIB=${ENABLE_STATIC_LIB}
        -DENABLE_SHARED_LIB=${ENABLE_SHARED_LIB}
)

vcpkg_install_cmake()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

vcpkg_copy_pdbs()

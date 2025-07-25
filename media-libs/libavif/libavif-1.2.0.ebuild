# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib gnome2-utils

ARGPARSE_COMMIT="ee74d1b53bd680748af14e737378de57e2a0a954"
DESCRIPTION="Library for encoding and decoding .avif files"
HOMEPAGE="https://github.com/AOMediaCodec/libavif"
SRC_URI="
	https://github.com/AOMediaCodec/libavif/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
	extras? (
		https://github.com/kmurray/libargparse/archive/${ARGPARSE_COMMIT}.tar.gz
			-> libargparse-${ARGPARSE_COMMIT}.tar.gz
	)
"

LICENSE="
	BSD-2
	extras? ( MIT )
"
# See bug #822336 re subslot
SLOT="0/16.1.1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc64 ~riscv sparc x86"
IUSE="+aom dav1d examples extras gdk-pixbuf rav1e svt-av1 libyuv test"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( aom dav1d )"

DEPEND="
	media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	media-libs/libpng:=[${MULTILIB_USEDEP}]
	aom? ( >=media-libs/libaom-3.3.0:=[${MULTILIB_USEDEP}] )
	dav1d? ( >=media-libs/dav1d-1.0.0:=[${MULTILIB_USEDEP}] )
	extras? (
		test? (
			dev-cpp/gtest
			media-gfx/imagemagick[lcms]
		)
	)
	gdk-pixbuf? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	)
	rav1e? ( >=media-video/rav1e-0.5.1:=[capi] )
	svt-av1? ( >=media-libs/svt-av1-0.9.1:= )
	libyuv? ( media-libs/libyuv:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	cmake_src_prepare

	# Bug: https://bugs.gentoo.org/951614
	if use extras; then
		mv "${WORKDIR}/libargparse-${ARGPARSE_COMMIT}" "${S}/ext/libargparse" ||
			die "mv failed"
	fi
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DAVIF_CODEC_LIBGAV1=OFF

		# Use system libraries.
		-DAVIF_CODEC_AOM=$(usex aom SYSTEM OFF)
		-DAVIF_CODEC_DAV1D=$(usex dav1d SYSTEM OFF)
		-DAVIF_ZLIBPNG=SYSTEM
		-DAVIF_JPEG=SYSTEM

		-DAVIF_BUILD_GDK_PIXBUF=$(usex gdk-pixbuf ON OFF)

		-DAVIF_ENABLE_WERROR=OFF
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DAVIF_CODEC_RAV1E=$(usex rav1e SYSTEM OFF)
			-DAVIF_CODEC_SVT=$(usex svt-av1 SYSTEM OFF)
			-DAVIF_LIBYUV=$(usex libyuv SYSTEM OFF)

			-DAVIF_BUILD_EXAMPLES=$(usex examples ON OFF)
			-DAVIF_BUILD_APPS=$(usex extras ON OFF)
			-DAVIF_BUILD_TESTS=$(usex test ON OFF)
			-DAVIF_GTEST=$(usex extras $(usex test SYSTEM OFF) OFF)
		)
	else
		mycmakeargs+=(
			-DAVIF_CODEC_RAV1E=OFF
			-DAVIF_CODEC_SVT=OFF
			-DAVIF_LIBYUV=OFF

			-DAVIF_BUILD_EXAMPLES=OFF
			-DAVIF_BUILD_APPS=OFF
			-DAVIF_BUILD_TESTS=OFF
			-DAVIF_GTEST=OFF
		)

		if ! use aom ; then
			if use rav1e || use svt-av1 ; then
				ewarn "libavif on ${MULTILIB_ABI_FLAG} will work in read-only mode."
				ewarn "Support for rav1e and/or svt-av1 is is not available on ${MULTILIB_ABI_FLAG}"
				ewarn "Enable aom flag for full support on ${MULTILIB_ABI_FLAG}"
			fi
		fi
	fi

	cmake_src_configure
}

pkg_postinst() {
	if ! use aom && ! use rav1e && ! use svt-av1 ; then
		ewarn "No AV1 encoder is set,"
		ewarn "libavif will work in read-only mode."
		ewarn "Enable aom, rav1e or svt-av1 flag if you want to save .AVIF files."
	fi

	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	use gdk-pixbuf && multilib_foreach_abi gnome2_gdk_pixbuf_update
}

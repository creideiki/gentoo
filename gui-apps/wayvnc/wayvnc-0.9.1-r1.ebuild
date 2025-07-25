# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="VNC server for wlroots based Wayland compositors"
HOMEPAGE="https://github.com/any1/wayvnc"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/any1/wayvnc.git"
else
	SRC_URI="https://github.com/any1/wayvnc/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="gbm pam test tracing"

RDEPEND="
	=dev-libs/aml-0.3*
	dev-libs/jansson:=
	dev-libs/wayland
	=gui-libs/neatvnc-0.9*[gbm?]
	media-libs/mesa[egl(+),gles2(+),gbm(+)?]
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pixman
	pam? ( sys-libs/pam )
	tracing? ( dev-debug/systemtap )
"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
"
BDEPEND="
	app-text/scdoc
	dev-util/wayland-scanner
	virtual/pkgconfig
"

RESTRICT="!test? ( test )"

src_configure() {
	local emesonargs=(
		$(meson_feature pam)
		$(meson_feature gbm screencopy-dmabuf)
		$(meson_use tracing systemtap)
		$(meson_use test tests)
	)
	meson_src_configure
}

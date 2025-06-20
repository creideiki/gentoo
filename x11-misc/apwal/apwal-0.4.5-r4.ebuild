# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A simple application launcher and combined editor"
HOMEPAGE="http://apwal.free.fr/"
SRC_URI="http://apwal.free.fr/download/${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	dev-libs/libxml2:=
	dev-libs/glib:2
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC PKG_CONFIG
}

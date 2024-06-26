# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C API library to the last.fm web service (unofficial)"
HOMEPAGE="https://liblastfm.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN/c}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

BDEPEND="virtual/pkgconfig"
DEPEND="net-misc/curl"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS README )

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}

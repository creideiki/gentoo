# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Proxy program for two connections set up by a UCSPI server and a UCSPI client"
HOMEPAGE="https://untroubled.org/ucspi-proxy/"
SRC_URI="https://untroubled.org/ucspi-proxy/archive/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/bglibs-2.04"
DEPEND="${RDEPEND}"

src_configure() {
	# bug #946204
	append-cflags -std=gnu17

	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	echo "${EPREFIX}/usr/bin" > conf-bin || die
	echo "${EPREFIX}/usr/share/man" > conf-man || die
}

src_install() {
	local -x install_prefix="${D}"
	default
}

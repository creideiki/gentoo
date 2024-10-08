# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Compute Gröbner bases of noncommutative polynomials"
SRC_URI="https://github.com/gap-packages/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="examples"

gap-pkg_enable_tests

src_prepare() {
	# The GNUmakefile is used to produce the tarball, not to build the
	# package.
	rm GNUmakefile || die
	default
}

src_install() {
	gap-pkg_src_install
	use examples && dodoc -r examples
}

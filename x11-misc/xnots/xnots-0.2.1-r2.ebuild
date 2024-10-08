# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Desktop sticky note program for the unix geek"
HOMEPAGE="https://xnots.sourceforge.net https://github.com/thePalindrome/xnots"
SRC_URI="https://downloads.sourceforge.net/xnots/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 -riscv x86"
IUSE="vim-syntax"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pango[X]
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.1-gcc6.patch
)

src_prepare() {
	default

	sed -i -e 's|LICENCE||g' Makefile || die

	append-cflags -std=gnu89
}

src_compile() {
	emake CC="$(tc-getCC)" NO_DEBUG=1
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		mandir=/usr/share/man \
		prefix=/usr \
		install

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins etc/xnots.vim
	fi
}

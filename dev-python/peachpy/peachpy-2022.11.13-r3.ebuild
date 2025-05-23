# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

EGIT_COMMIT=349e8f836142b2ed0efeb6bb99b1b715d87202e9
MY_P=PeachPy-${EGIT_COMMIT}

DESCRIPTION="Portable Efficient Assembly Code-generator in Higher-level Python"
HOMEPAGE="
	https://github.com/Maratyszcza/PeachPy/
	https://pypi.org/project/PeachPy/
"
SRC_URI="
	https://github.com/Maratyszcza/PeachPy/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/opcodes[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

DOCS=README.rst

distutils_enable_sphinx sphinx \
	dev-python/sphinx-bootstrap-theme

distutils_enable_tests pytest

src_test() {
	local EPYTEST_IGNORE=( tests/arm/test_arm.py )
	distutils-r1_src_test
}

#!/usr/bin/env bash
set -ev
pushd emp-tool
find . \( -iname '*.h' -or -iname '*.hpp' -or -iname '*.c' -or -iname '*.cpp' \) -print \
	-exec sed -i -e 's/STS_OK/RLC_OK/g' -e 's/BN_POS/RLC_POS/g' -e 's/DIG_LOG/RLC_DIG_LOG/g' \
		-e 's/SPLIT(\([[:alpha:]]*\), \([[:alpha:]]*\), \([[:alpha:]]*\), RLC_DIG_LOG)/RLC_RIP(\1, \2, \3)/g' \
		{} \;
popd

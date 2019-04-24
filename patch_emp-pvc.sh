#!/usr/bin/env bash
set -ev
pushd emp-pvc
find . \( -iname '*.h' -or -iname '*.hpp' -or -iname '*.c' -or -iname '*.cpp' \) -print \
	-exec sed -i -e 's/RELIC_EB_TABLE_MAX/RLC_EB_TABLE_MAX/g' \
		{} \;
popd

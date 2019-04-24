#!/usr/bin/env bash
set -ev

if [ $# -gt 0 ]; then
	echo 'Run in checking mode.'
	check_mode=1
else
	check_mode=0
fi

rm -rf emp-env
mkdir emp-env
export ENV_PATH=$(realpath emp-env)

rm -rf relic
git clone https://github.com/relic-toolkit/relic.git
pushd relic
git log -1 | cat
cmake -DCMAKE_INSTALL_PREFIX=$ENV_PATH \
	-DALIGN=16 -DARCH=X64 -DARITH=curve2251-sse -DCHECK=off -DFB_POLYN=251 -DFB_METHD="INTEG;INTEG;QUICK;QUICK;QUICK;QUICK;LOWER;SLIDE;QUICK" -DFB_PRECO=on -DFB_SQRTF=off -DEB_METHD="PROJC;LODAH;COMBD;INTER" -DEC_METHD="CHAR2" -DCOMP="-O3 -funroll-loops -fomit-frame-pointer -march=native -msse4.2 -mpclmul" -DTIMER=CYCLE -DWITH="MD;DV;BN;FB;EB;EC" -DWSIZE=64 \
	. 2>&1 > /dev/null
make -j > /dev/null
make install > /dev/null
popd

rm -rf emp-tool
git clone https://github.com/emp-toolkit/emp-tool.git
if [ $check_mode -eq 0 ]; then
	./patch_emp-tool.sh
fi
pushd emp-tool
git log -1 | cat
cmake -DCMAKE_INSTALL_PREFIX=$ENV_PATH \
	-DCMAKE_C_FLAGS="-I$ENV_PATH/include -Wall -Wextra" \
	-DCMAKE_CXX_STANDARD=11 \
	-DCMAKE_CXX_FLAGS="-I$ENV_PATH/include -Wall -Wextra" \
	-DTHREADING=on \
	. 2>&1 > /dev/null
make -j > /dev/null
make install > /dev/null
popd

rm -rf emp-ot
git clone https://github.com/emp-toolkit/emp-ot.git
if [ $check_mode -eq 0 ]; then
	./patch_emp-ot.sh
fi
pushd emp-ot
git log -1 | cat
cmake -DCMAKE_INSTALL_PREFIX=$ENV_PATH \
	-DCMAKE_C_FLAGS="-I$ENV_PATH/include -Wall -Wextra" \
	-DCMAKE_CXX_STANDARD=11 \
	-DCMAKE_CXX_FLAGS="-I$ENV_PATH/include -Wall -Wextra" \
	. 2>&1 > /dev/null
make -j > /dev/null
make install > /dev/null
popd

rm -rf emp-pvc
git clone https://github.com/emp-toolkit/emp-pvc.git
if [ $check_mode -eq 0 ]; then
	./patch_emp-pvc.sh
fi
pushd emp-pvc
git log -1 | cat
cmake -DCMAKE_INSTALL_PREFIX=$ENV_PATH \
	-DCMAKE_C_FLAGS="-I$ENV_PATH/include -Wall -Wextra" \
	-DCMAKE_CXX_STANDARD=11 \
	-DCMAKE_CXX_FLAGS="-I$ENV_PATH/include -Wall -Wextra" \
	.
make -j
popd

#!/usr/bin/env bash

################################################################################
## Authors: Mateus Fogaca, Eder Matheus Monteiro
##          (Advisor: Ricardo Reis)
##
## BSD 3-Clause License
##
## Copyright (c) 2019, Federal University of Rio Grande do Sul (UFRGS)
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## * Redistributions of source code must retain the above copyright notice, this
##   list of conditions and the following disclaimer.
##
## * Redistributions in binary form must reproduce the above copyright notice,
##   this list of conditions and the following disclaimer in the documentation
##   and#or other materials provided with the distribution.
##
## * Neither the name of the copyright holder nor the names of its
##   contributors may be used to endorse or promote products derived from
##   this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
## LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
## CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.
################################################################################

test_script=./run.sh

echo ""
echo "************************"
echo "* Tapcell unit tests *"
echo "************************"
echo ""

testdir=$(cd "$(dirname "$0")" && pwd -P)
binary=$testdir/../../../build/src/openroad
failed=0

echo " > Tapcell binary: $binary"
if [ ! -e $binary ] ; 
then
	echo "    - Binary not found. Exiting...\n" 
	exit 1
fi

for unit_test_path in ${testdir}/src/* ; 
do
	test_name=$(basename $unit_test_path)
	echo " > Now running $test_name..."

	if [ ! -e $unit_test_path/$test_script ] ; 
	then
		echo "    - Script \"run.sh\" not found. Skipping..." 
		continue
	fi
	
	cd $unit_test_path 
	$test_script $binary $testdir
	test_return_code=$?
	cd $test_root

	if [ $test_return_code == 0 ];
	then
		echo "     - Test returned GREEN (passed)"
	elif [ $test_return_code == 1 ];
	then
		echo "     - Test return YELLOW (passed)"
	else
		echo "     - Test returned RED (failed)"
		failed=1
	fi
done

echo ""
echo "Tapcell tests finished!"

sh $testdir/clean_all.sh $testdir

if [ $failed -gt 0 ]
then
	exit 1
fi
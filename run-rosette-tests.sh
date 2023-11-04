#!/bin/bash

# TODO(jie): add these back to tests after adding support for them
# "tests.llvm.count"
# "tests.llvm.list1"
# "tests.llvm.list1_fns"
# "tests.llvm.struct1"

tests=(
# "test.python.count_driver"
# "tests.python.list1_driver"
# "tests.python.list1_fns_driver"
# "tests.python.list_abs_sum_driver"
  "tests.llvm.uninterp_driver"
  "tests.python.uninterp_driver"
)

for test in ${tests[*]}; do
  printf "\n\nrunning %s\n" "$test"
  python -m $test
done


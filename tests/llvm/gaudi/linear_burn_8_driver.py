import time

from metalift.frontend.llvm import Driver
from metalift.ir import Int
from metalift.ir import List as mlList
from tests.llvm.gaudi.gaudi_common import (
    all_possible_selects_two_args_synth, nested_list_computation_inv0_grammar,
    nested_list_computation_inv1_grammar,
    nested_list_computation_ps_grammar_fn, nested_list_computation_target_lang,
    selection_two_args_synth)
from tests.python.utils.utils import codegen

if __name__ == "__main__":
    driver = Driver()
    linear_burn_8 = driver.analyze(
        llvm_filepath="tests/llvm/gaudi/linear_burn_8.ll",
        loops_filepath="tests/llvm/gaudi/linear_burn_8.loops",
        fn_name="linear_burn_8",
        target_lang_fn=nested_list_computation_target_lang,
        inv_grammars={
            "linear_burn_8_inv0": nested_list_computation_inv0_grammar,
            "linear_burn_8_inv1": nested_list_computation_inv1_grammar
        },
        ps_grammar=nested_list_computation_ps_grammar_fn
    )

    base = Matrix(Int, "base")
    active = Matrix(Int, "active")
    driver.add_var_objects([base, active])

    # Add preconditions
    driver.add_precondition(base.len() > 1)
    driver.add_precondition(base.len() == active.len())
    driver.add_precondition(base[0].len() == active[0].len())

    driver.fns_synths = [all_possible_selects_two_args_synth, selection_two_args_synth]
    linear_burn_8(base, active)

    start_time = time.time()
    driver.synthesize(listBound=3, noVerify=True)
    end_time = time.time()
    print(f"Synthesis took {end_time - start_time} seconds")
    print("\n\ngenerated code:" + linear_burn_8.codegen(codegen))

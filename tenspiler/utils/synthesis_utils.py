import os
from pathlib import Path

from metalift.frontend.llvm import Driver
from metalift.synthesis_common import SynthesisFailed, VerificationFailed
from tenspiler.codegen.gaudi_codegen import gaudi_codegen
from tenspiler.codegen.numpy_codegen import numpy_codegen
from tenspiler.codegen.pytorch_codegen import pytorch_codegen
from tenspiler.codegen.tensorflow_codegen import tensorflow_codegen
from tenspiler.codegen.utils import DataType

tpcc_benchmarks = {
    "normal_blend_f",
    "normal_blend_8",
    "dissolve_blend_8",
    "darken_blend_8",
    "multiply_blend_8",
    "linear_burn_8",
    "color_burn_8",
    "lighten_blend_8",
    "screen_blend_8",
    "linear_dodge_8",
    "color_dodge_8",
    "overlay_blend_8",
    "dot",
    "mag_array",
    "matrix_add_matrix",
    "mse_array",
    "mult_add_into_cpu",
    "ol_l2_cpu1",
    "ol_l2_cpu2",
    "scale_array",
    "scale_matrix",
    "sum_array",
    "translate_array",
    "matadd",
    "matscal",
    "matsub",
    "vadd",
    "vcopy",
    "vmul",
    "vneg",
    "voffset",
    "vrecip",
    "vscal",
    "vsub",
    "wvec",
    "n_real_updates",
    "sum_of_squares",
    "diveq_sca",
    "diveq",
    "len_sq",
    "len",
    "matmul_sca",
    "muleq_sca",
    "muleq",
    "negate",
    "pluseq",
    "subeq_sca",
    "subeq",
    "array_inc",
    "array_sum",
    "cube_in_place",
    "fourth_in_place",
    "sum_elts",
    "fir_small",
    "lmsfir1",
    "lmsfir2",
}


def run_synthesis_with_bound(
    *,
    driver: Driver,
    data_type: DataType,
    benchmark_name: str,
    list_bound: int,
    max_rounds: int,
    has_relaxed: bool,
):
    try:
        print(f"Trying strict grammar with list bound {list_bound}...")
        # First use strict grammar
        basename = f"{benchmark_name}_strict_listbound{list_bound}_rounds{max_rounds}"
        driver.synthesize(
            filename=basename,
            list_bound=list_bound,
            relaxed_grammar=False,
            rounds_to_guess=max_rounds,
        )
    except SynthesisFailed as e:
        print(f"Strict grammar with list bound {list_bound} failed")
        if not has_relaxed:
            print("No relaxed grammar specified")
            raise e

        # Use relaxed grammar
        print("Trying relaxed grammar...")
        basename = f"{benchmark_name}_relaxed_listbound{list_bound}_rounds{max_rounds}"
        driver.synthesize(
            filename=basename,
            list_bound=list_bound,
            relaxed_grammar=True,
            rounds_to_guess=max_rounds,
        )

    ps_fn_decl = driver.get_actual_ps_fn_decl()

    curr_file_path = Path(__file__).resolve()
    tenspiler_dir = curr_file_path.parent.parent
    generated_code_dir = tenspiler_dir / "codegen" / "generated_code" / benchmark_name
    generated_code_dir.mkdir(parents=True, exist_ok=True)

    # Write numpy code
    np_code = numpy_codegen(ps_fn_decl, driver.synthesized_fns, data_type)
    with open(generated_code_dir / f"{benchmark_name}_numpy.py", "w") as f:
        f.write(np_code)

    # Write tensorflow code
    tf_code = tensorflow_codegen(ps_fn_decl, driver.synthesized_fns, data_type)
    with open(generated_code_dir / f"{benchmark_name}_tensorflow.py", "w") as f:
        f.write(tf_code)

    # Write pytorch code
    pt_code = pytorch_codegen(ps_fn_decl, driver.synthesized_fns, data_type)
    with open(generated_code_dir / f"{benchmark_name}_pytorch.py", "w") as f:
        f.write(pt_code)

    if benchmark_name in tpcc_benchmarks:
        gaudi_base_dir = generated_code_dir / "gaudi"
        gaudi_base_dir.mkdir(parents=True, exist_ok=True)
        gaudi_hpp_glue_code, gaudi_cpp_glue_code, gaudi_kernel_code = gaudi_codegen(
            ps_fn_decl, driver.synthesized_fns, data_type
        )

        with open(gaudi_base_dir / f"{benchmark_name}_gaudi.hpp", "w") as f:
            f.write(gaudi_hpp_glue_code)
        with open(gaudi_base_dir / f"{benchmark_name}_gaudi.cpp", "w") as f:
            f.write(gaudi_cpp_glue_code)
        with open(gaudi_base_dir / f"{benchmark_name}_gaudi.c", "w") as f:
            f.write(gaudi_kernel_code)


def run_synthesis_algorithm(
    *,
    driver: Driver,
    data_type: DataType,
    benchmark_name: str,
    max_rounds: int = 2,
    has_relaxed: bool = False,
):
    list_bound_start = os.getenv("LIST_BOUND_START", 2)
    print(f"Starting synthesis at list bound {list_bound_start}")
    list_bound_start = int(list_bound_start)
    list_bound = list_bound_start
    while True:
        try:
            run_synthesis_with_bound(
                driver=driver,
                data_type=data_type,
                benchmark_name=benchmark_name,
                list_bound=list_bound,
                max_rounds=max_rounds,
                has_relaxed=has_relaxed,
            )
            return
        except VerificationFailed:
            list_bound += 1
        except Exception as e:
            raise e

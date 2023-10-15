set(CMSIS_DSP_Source_MatrixFunctions_PATH      ${cmsis-dsp_SOURCE_DIR}/Source/MatrixFunctions)

# Set some variables
if ((NOT ARMAC5) AND (NOT DISABLEFLOAT16))
    set(ArmAC5 true)
endif()

set(MatrixFunctions_SOURCES
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cholesky_f64.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_inverse_f64.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_ldlt_f64.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_mult_f64.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_solve_lower_triangular_f64.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_solve_upper_triangular_f64.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_sub_f64.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_trans_f64.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_qr_f64.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_householder_f64.c

    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_add_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cholesky_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cmplx_mult_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cmplx_trans_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_init_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_inverse_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_ldlt_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_mult_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_scale_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_solve_lower_triangular_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_solve_upper_triangular_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_sub_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_trans_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_vec_mult_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_qr_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_householder_f32.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_add_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cmplx_mult_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cmplx_trans_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_init_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_mult_fast_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_mult_opt_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_mult_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_scale_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_sub_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_trans_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_vec_mult_q31.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_add_q15.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cmplx_mult_q15.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cmplx_trans_q15.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_init_q15.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_mult_fast_q15.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_mult_q15.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_scale_q15.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_sub_q15.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_trans_q15.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_vec_mult_q15.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_mult_q7.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_vec_mult_q7.c
    ${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_trans_q7.c


    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_add_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cholesky_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cmplx_mult_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_cmplx_trans_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_init_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_inverse_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_mult_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_scale_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_solve_lower_triangular_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_solve_upper_triangular_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_sub_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_trans_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_vec_mult_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_mat_qr_f16.c>
    $<$<BOOL:${ArmAC5}>:${CMSIS_DSP_Source_MatrixFunctions_PATH}/arm_householder_f16.c>
)

set(ArmAC5)

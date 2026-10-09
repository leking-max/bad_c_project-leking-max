cmake_minimum_required(VERSION 3.16)

project(mathlib VERSION 0.4.0 LANGUAGES C)

# TODO: разобраться с типами сборок, пока хардкодим Release
set(CMAKE_BUILD_TYPE Release CACHE STRING "build type" FORCE)

add_compile_options(-Wall -Wextra)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_library(math_utils src/math_utils.c)
target_include_directories(math_utils PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/src)

add_executable(math_cli src/main.c)
target_link_libraries(math_cli PRIVATE math_utils)

enable_testing()

find_path(CMOCKA_INCLUDE_DIR cmocka.h)
find_library(CMOCKA_LIBRARY NAMES cmocka)

if(NOT CMOCKA_INCLUDE_DIR OR NOT CMOCKA_LIBRARY)
  message(FATAL_ERROR "cmocka not found. Install it: sudo apt-get install libcmocka-dev")
endif()

add_executable(test_math_utils tests/test_math_utils.c)
target_include_directories(test_math_utils PRIVATE ${CMOCKA_INCLUDE_DIR})
target_link_libraries(test_math_utils PRIVATE math_utils ${CMOCKA_LIBRARY})

# каждый тест - отдельная проверка в ctest, чтобы в CI было видно имена
function(add_unit_test target name)
  add_test(NAME ${name} COMMAND ${target} ${name})
endfunction()

add_unit_test(test_math_utils test_add_of_positive_numbers)
add_unit_test(test_math_utils test_add_of_negative_numbers)
add_unit_test(test_math_utils test_add_of_zero_is_neutral)
add_unit_test(test_math_utils test_add_is_commutative)
add_unit_test(test_math_utils test_add_near_int_max)
add_unit_test(test_math_utils test_subtract_of_positive_numbers)
add_unit_test(test_math_utils test_subtract_of_equal_numbers_is_zero)
add_unit_test(test_math_utils test_subtract_of_negative_numbers)
add_unit_test(test_math_utils test_subtract_undoes_add)
add_unit_test(test_math_utils test_is_even_of_zero)
add_unit_test(test_math_utils test_is_even_of_positive_even)
add_unit_test(test_math_utils test_is_even_of_positive_odd)
add_unit_test(test_math_utils test_is_even_of_negative_even)
add_unit_test(test_math_utils test_is_even_of_negative_odd)
add_unit_test(test_math_utils test_is_even_of_int_min)
add_unit_test(test_math_utils test_multiply_by_two_of_zero_is_zero)
add_unit_test(test_math_utils test_multiply_by_two_of_one_is_two)
add_unit_test(test_math_utils test_multiply_by_two_of_two_is_four)
add_unit_test(test_math_utils test_multiply_by_two_of_ten_is_twenty)
add_unit_test(test_math_utils test_multiply_by_two_of_negative_three)
add_unit_test(test_math_utils test_multiply_by_two_of_negative_one_stays_negative)
add_unit_test(test_math_utils test_multiply_by_two_near_int_max)
add_unit_test(test_math_utils test_multiply_by_two_near_int_min)
add_unit_test(test_math_utils test_multiply_by_two_applied_twice_doubles_again)

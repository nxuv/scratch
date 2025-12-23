#!/usr/bin/env -S tcc -run

#include "stdio.h"

#define TEST_FILE "unit_test.c"
#define TEST_HEAD "unit_test.h"
#include "unit.h"

#define FOREACH(P_WHAT) for (int i = 0; i < sizeof(P_WHAT) / sizeof(P_WHAT[0]); ++i)

int main(int argc, char **argv) {
    // printf("%lu\n", sizeof(tests) / sizeof(tests[0]));
    FOREACH(tests) {
        printf("%-30s %s\n", tests[i].name, tests[i].func() ? "PASS" : "FAIL");
    }
    return 0;
}

// - ---------------------------------------------------------------------------- -

// int tests_run = 0;

// int foo = 7;
// int bar = 4;

// static char * test_foo() {
//     mu_assert("error, foo != 7", foo == 7);
//     return 0;
// }

// static char * test_bar() {
//     mu_assert("error, bar != 5", bar == 5);
//     return 0;
// }

// static char * all_tests() {
//     mu_run_test(test_foo);
//     mu_run_test(test_bar);
//     return 0;
// }

// int main(int argc, char **argv) {
//     char *result = all_tests();
//     if (result != 0) {
//         fprintf(stderr, "%s\n", result);
//     }
//     else {
//         printf("ALL TESTS PASSED\n");
//     }
//     printf("Tests run = %d\n", tests_run);

//     return result != 0;
// }


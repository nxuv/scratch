// LINK: https://jera.com/techinfo/jtns/jtn002
// - ----------------------------- file: minunit.h ------------------------------ -
// #define mu_assert(message, test) do { if (!(test)) return message; } while (0)
// #define mu_run_test(test) do { char *message = test(); tests_run++; \
//                           if (message) return message; } while (0)
// extern int tests_run;
// - ---------------------------------------------------------------------------- -


// #define UNITTEST(NAME) void unit_##NAME() 
// #define UNITTESTS_BEGIN void(*UNITTESTS_ARRAY[])() = {
// #define UNITTESTS_END }

// UNITTESTS_BEGIN

// UNITTEST(test) {

// }

// UNITTESTS_END

#define TEST(NAME, ...) int test_##NAME()
#ifdef TEST_FILE
#include TEST_FILE
#endif // TEST_FILE
#undef TEST

typedef struct test_t {
    const char *name;
    int (*func)();
} Test;

Test tests[] = {
    #define TEST(NAME, ...) { .name = #NAME, .func = test_##NAME },
    #ifdef TEST_HEAD
    #include TEST_HEAD
    #endif // TEST_FILE
    #undef TEST
};


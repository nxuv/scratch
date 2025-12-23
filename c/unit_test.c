// #define TEST_BEGIN
// #include "unit.h"

#ifndef TEST
#define TEST(NAME, ...) int test_##NAME()
#endif

TEST(thing) {
    return 1;
}


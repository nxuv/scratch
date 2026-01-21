#pragma once
#ifndef NCPP_H
#define NCPP_H

// and you need a name too...
// - --------------------------- GOOD TO HAVE STUFFS ---------------------------- -
// #include "std/int.h"
#include <stdint.h>

#define DISCARD (void)
#define cast(T) (T)

typedef int8_t i8;
typedef int16_t i16;
typedef int32_t i32;
typedef int64_t i64;
typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;
// - ------------------------ END OF GOOD TO HAVE STUFFS ------------------------ -

// what shall thee be named i wonder?
// nostdc?
// cppc
// stdc
// std/cpp.h?
// .....?
// - -------------------------- REQUIRED FOR FUNCTION --------------------------- -
// #include "std/lib.h"
#include <stdlib.h>
// where it's pulling std::size_t from?
// std::size_t is from some of libs?
// seems you can safely comment next line out?
// #include "std/def.h"
#include <stddef.h>
// up, both of those do indeed include stddef

// required for c++
void *operator new(size_t p_size) { return malloc(p_size); }
void operator delete(void *p_ptr) noexcept { free(p_ptr); }
void operator delete(void *p_ptr, size_t p_uint) noexcept { (void) p_uint; free(p_ptr); }
extern "C" void __cxa_pure_virtual() { exit(38); } // ENOSYS
// - ----------------------------- END OF REQUIRED ------------------------------ -

#endif // NCPP_H

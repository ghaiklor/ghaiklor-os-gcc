typedef signed char int8_t;
typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short uint16_t;
typedef int int32_t;
typedef unsigned uint32_t;
typedef long long int64_t;
typedef unsigned long long uint64_t;

typedef signed char int_least8_t;
typedef unsigned char uint_least8_t;
typedef short int_least16_t;
typedef unsigned short uint_least16_t;
typedef int int_least32_t;
typedef unsigned uint_least32_t;
typedef long long int_least64_t;
typedef unsigned long long uint_least64_t;

typedef char int_fast8_t;
typedef unsigned char uint_fast8_t;
typedef short int_fast16_t;
typedef unsigned short uint_fast16_t;
typedef int int_fast32_t;
typedef unsigned int uint_fast32_t;
typedef long long int_fast64_t;
typedef unsigned long long uint_fast64_t;

typedef int intptr_t;
typedef unsigned uintptr_t;

typedef long long intmax_t;
typedef unsigned long long uintmax_t;

#define INT8_MIN (-128)
#define INT16_MIN (-32768)
#define INT32_MIN (-2147483647 - 1)
#define INT64_MIN (-9223372036854775807LL - 1)

#define INT8_MAX 127
#define INT16_MAX 32767
#define INT32_MAX 2147483647
#define INT64_MAX 9223372036854775807LL

#define UINT8_MAX 0xFF
#define UINT16_MAX 0xFFFF
#define UINT32_MAX 0xFFFFFFFF
#define UINT64_MAX 0xFFFFFFFFFFFFFFFFULL

#define INT_LEAST8_MIN INT8_MIN
#define INT_LEAST16_MIN INT16_MIN
#define INT_LEAST32_MIN INT32_MIN
#define INT_LEAST64_MIN INT64_MIN

#define INT_LEAST8_MAX INT8_MAX
#define INT_LEAST16_MAX INT16_MAX
#define INT_LEAST32_MAX INT32_MAX
#define INT_LEAST64_MAX INT64_MAX

#define UINT_LEAST8_MAX UINT8_MAX
#define UINT_LEAST16_MAX UINT16_MAX
#define UINT_LEAST32_MAX UINT32_MAX
#define UINT_LEAST64_MAX UINT64_MAX

#define INT_FAST8_MIN INT8_MIN
#define INT_FAST16_MIN INT16_MIN
#define INT_FAST32_MIN INT32_MIN
#define INT_FAST64_MIN INT64_MIN

#define INT_FAST8_MAX INT8_MAX
#define INT_FAST16_MAX INT16_MAX
#define INT_FAST32_MAX INT32_MAX
#define INT_FAST64_MAX INT64_MAX

#define UINT_FAST8_MAX UINT8_MAX
#define UINT_FAST16_MAX UINT16_MAX
#define UINT_FAST32_MAX UINT32_MAX
#define UINT_FAST64_MAX UINT64_MAX

#define INTPTR_MIN INT32_MIN
#define INTPTR_MAX INT32_MAX
#define UINTPTR_MAX UINT32_MAX

#define INTMAX_MIN INT64_MIN
#define INTMAX_MAX INT64_MAX
#define UINTMAX_MAX UINT64_MAX

#define PTRDIFF_MIN INT32_MIN
#define PTRDIFF_MAX INT32_MAX

#define SIG_ATOMIC_MIN INT32_MIN
#define SIG_ATOMIC_MAX INT32_MAX

#define SIZE_MAX UINT32_MAX

#define WCHAR_MIN 0
#define WCHAR_MAX ((wchar_t)-1)
#define WINT_MIN 0
#define WINT_MAX ((wint_t)-1)

#define INT8_C(val) ((int8_t) + (val))
#define UINT8_C(val) ((uint8_t) + (val##U))
#define INT16_C(val) ((int16_t) + (val))
#define UINT16_C(val) ((uint16_t) + (val##U))

#define INT32_C(val) val##L
#define UINT32_C(val) val##UL
#define INT64_C(val) val##LL
#define UINT64_C(val) val##ULL

#define INTMAX_C(val) INT64_C(val)
#define UINTMAX_C(val) UINT64_C(val)

#define LOW_8(address) (uint8_t)((address) & 0xFF)
#define HIGH_8(address) (uint8_t)(((address) >> 8) & 0xFF)

#define LOW_16(address) (uint16_t)((address) & 0xFFFF)
#define HIGH_16(address) (uint16_t)(((address) >> 16) & 0xFFFF)

#define LOW_32(address) (uint32_t)((address) & 0xFFFFFFFF)
#define HIGH_32(address) (uint32_t)(((address) >> 32) & 0xFFFFFFFF)

#define LOW_64(address) (uint64_t)((address) & 0xFFFFFFFFFFFFFFFF)
#define HIGH_64(address) (uint64_t)(((address) >> 64) & 0xFFFFFFFFFFFFFFFF)

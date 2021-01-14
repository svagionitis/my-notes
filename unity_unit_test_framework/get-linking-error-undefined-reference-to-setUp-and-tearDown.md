# Linking error when writing a test in Unity

If you get the following linking error in Unity

```
/usr/bin/gcc -O3 -DNDEBUG  -rdynamic CMakeFiles/test_get_api_key.dir/test_get_api_key.c.o  -o test_get_api_key  external/unity/unity-build/libunity.a
/usr/bin/ld: external/unity/unity-build/libunity.a(unity.c.o): in function `UnityDefaultTestRun':
unity.c:(.text+0x3a19): undefined reference to `setUp'
/usr/bin/ld: unity.c:(.text+0x3a39): undefined reference to `tearDown'
collect2: error: ld returned 1 exit status
make[2]: *** [lib/test/CMakeFiles/test_get_api_key.dir/build.make:85: lib/test/test_get_api_key] Error 1
make[2]: Leaving directory '/home/stavros/workspace/themoviedb.org/themoviedb/build'
make[1]: *** [CMakeFiles/Makefile2:1019: lib/test/CMakeFiles/test_get_api_key.dir/all] Error 2
make[1]: Leaving directory '/home/stavros/workspace/themoviedb.org/themoviedb/build'
make: *** [Makefile:152: all] Error 2

```

You need to define the Unity functions `setUp()` and `tearDown()` in your test file.

See the following example.

Let's say that you have the following test file `test_get_api_key.c`

```
#include "unity.h"

#include "tmdb-compiler.h"
#include "tmdb.h"

void test_Is_1(void)
{
    TEST_ASSERT_EQUAL_INT(1, tmdb_get_api_key());
}

int main(void)
{
    UNITY_BEGIN();

    RUN_TEST(test_Is_1);

    return UNITY_END();
}

```


If you try to compile it, you will get the above mentioned linking error. So in order to to fix this, you have to to define those functions like following


```
#include "unity.h"

#include "tmdb-compiler.h"
#include "tmdb.h"

void setUp(void)
{
}

void tearDown(void)
{
}

void test_Is_1(void)
{
    TEST_ASSERT_EQUAL_INT(1, tmdb_get_api_key());
}

int main(void)
{
    UNITY_BEGIN();

    RUN_TEST(test_Is_1);

    return UNITY_END();
}
```

Check the following
* https://stackoverflow.com/questions/57573905/unity-framework-unit-testing-undefined-reference-to-setup-and-teardown
* https://github.com/ThrowTheSwitch/Unity/blob/0b078cdb6e4e9689f812fc50ee8c14f35ddb59a9/src/unity.h#L23
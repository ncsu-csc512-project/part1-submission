#include <stdio.h>

void foo(int x)
{
    printf("Foo: %d\n", x);
}

void bar(int x)
{
    printf("Bar: %d\n", x);
}

int main()
{
    void (*fun_ptr)(int);
    int c;

    // Branching and function pointer assignment
    for (c = 0; c < 2; c++)
    {
        if (c % 2 == 0)
        {
            fun_ptr = &foo;
        }
        else
        {
            fun_ptr = &bar;
        }
        (*fun_ptr)(c);
    }

    return 0;
}

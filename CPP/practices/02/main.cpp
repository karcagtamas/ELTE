#include <iostream>
#include "Derived.h"

#define LOWER 100

template <int N>
constexpr int fibonacci()
{
    // Since C++17 can use if, for, while in constexpr methods
    if constexpr (N >= 2)
        return fibonacci<N - 1>() + fibonacci<N - 2>();
    else
        return N;
}

template <typename I>
constexpr auto adder(I i)
{
    return [i](auto j)
    { return i + j; };
}

constexpr int f(int x)
{
    return x;
}

int my_strlen(const char *s)
{
    const char *p = s;
    while (!(*p == 0)) // Cannot write *p = 0 because p is not modifieable (also s)
        ++p;

    return p - s;
}

int my_strlen2(char *s)
{
    char *p = s;
    while (!(0 == *p)) // Yoda condition: Cannot write 0 = *p because 0 is not assignable
        ++p;
    return p - s;
}

int main()
{
    std::cout << "Start"
              << "\n";

    const char t1[]{'H', 'e', 'l', 'l', 'o'};
    const char t2[]{"Alma"};
    std::cout << t1 << "\n";
    std::cout << t2 << "\n";

    // Constants
    const int c1 = 1;
    const int c2 = f(2);
    volatile const int c22 = f(2); // volatile - compile won't optimize -> don't work the const optimization -> not constexpr the f(2) -> run-time
    int c3 = 3;

    // Pointers
    const int *ptr1 = &c1; // A pointer what point to a constant value
    const int *ptr3 = &c3;
    int *ptr33 = &c3;
    // int *ptr11 = &c1; Does not work because c1 is const - you cant grant const, update downgrade is not possible
    ptr1 = &c2;

    const int *const ptr11 = &c1;
    // ptr11 = &c2; ptr11 pointer is constant - cannot be modified

    Derived d{};
    Derived *dPtr = &d;
    Derived **dPtrPtr = &dPtr;
    // Base **bPtrPtr = dPtrPtr; This won't work

    const Derived d1{};
    d1.getYear(); // Callable because getYear() is const
    d1.readCnt++;

    switch (1)
    {
    case c1:
        break;
    case c2:
        break;
    // case c3: break;
    default:
        break;
    }

    constexpr auto add5 = adder(5);
    int t[add5(10)]; // In that case add5 and 10 is const because of the constexpr specifiers

    /*if (std::is_constant_evaluated())
    {
    }
    else
    {
    }*/

    if constexpr (std::is_pointer_v<int>) // In compile time, it is optimized
    {
    }

    constexpr int fib12 = fibonacci<12>(); // Optimized to 144
    std::cout << fib12 << "\n";

    return 0;
}

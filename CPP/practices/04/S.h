#include <iostream>

struct S
{

    S()
    {
        a = ++cnt;
        std::cout << "S() ";
    }

    S(const S &rhs)
    {
        a = rhs.a;
        std::cout << "copyCtr ";
    }

    S(S &&rhs) noexcept // Has to be noexcept for the std::vector - because it works safe
    {
        a = rhs.a;
        std::cout << "moveCtr ";
    }

    S &operator=(const S &rhs)
    {
        a = rhs.a;
        std::cout << "copy= ";
        return *this;
    }

    S &operator=(const S &&rhs)
    {
        a = rhs.a;
        std::cout << "move= ";
        return *this;
    }

    int a;
    static int cnt;
};
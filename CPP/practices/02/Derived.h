#include "Base.h"

class Derived : public Base
{
public:
    Derived();
    Derived(int y);
    virtual void run();
    int getYear() const; // const is part of the method signature - can be ovarload with no const
    mutable int readCnt; // Can be modified when the object is const, also from const method

private:
    const int cYear = 2001; // Must be initialized from constructor or here -> also can use const init (const fn or something)
    int year;
    static int a;
    static const int b;
};
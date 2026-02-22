#include "Base.h"

class Derived : public Base
{
public:
    Derived(const Derived &rhs); // Copy constructor
    Derived(Derived &&rhs);      // Move constructor
};
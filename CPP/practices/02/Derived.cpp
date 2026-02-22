#include "Derived.h"

Derived::Derived() : cYear(2000) {}

Derived::Derived(int y) : year(y) {}

void Derived::run() {}

int Derived::getYear() const
{
    return year;
}
#include "Derived.h"
#include <utility>

Derived::Derived(const Derived &rhs) : Base(rhs) {}

Derived::Derived(Derived &&rhs) : Base(std::move(rhs)) {} // std::move() create rvalue - it is necessary during the inheritance
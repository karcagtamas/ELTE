#include <iostream>
#include <memory>
#include <variant>

template <typename T>
class Base
{
public:
    void bar() { std::cout << "Base::bar()" << std::endl; }
};

template <typename T>
class Derived : public Base<T>
{
public:
    void foo() { this->bar(); } // If not use this and there is a bar() in the external env, maybe the template want to use that
};

// Inheriting from own template type param
// Reversing the inheritance - can define the Derived class before the Mixin
// Policy/Strategy can be injected
template <class Base>
class Mixin : public Base
{
};

template <typename T>
struct CRTPBase
{
};

// We pass the child type to the parent
// We can use this to operation generating or return type sepcialization or when we want to seperate the interface and the implementation
// We define the common operators in the base class
// Then we define the specialized operators in the dervied class
struct CRTPDerived : public CRTPBase<CRTPDerived>
{
};

class Y : public std::enable_shared_from_this<Y>
{
public:
    std::shared_ptr<Y> f()
    {
        return shared_from_this();
    }
};

// Variadic templates - recursive example
template <typename T> // specialization
T sum(T v)
{
    return v;
}

template <typename T, typename... Args> // Template parameter pack
// T sum(T first, Args... args)
std::common_type<T, Args...>::type sum(T first, Args... args) // Function parameter pack
{
    return first + sum(args...); // If args only one, it will invoke the specialization
}

template <typename... T>
auto avg(T... t)
{
    return (t + ...) / sizeof...(t); // From C++17 you can define without base specialization template method (like sum)
}

// This is only a skeleton
// It generated in compile time, when it is used (create with different type versions)
template <class R, class T, class S> // <typename T>
constexpr R                          /*std::common_type<T, S>*/
max(T a, S b)
{
    if (a > b)
    {
        return a;
    }
    else
    {
        return b;
    }
}

// This is a specialization
template <class T>
constexpr T max(T a, T b)
{
    if (a > b)
        return a;
    else
        return b;
}

int main()
{
    int x = 1, y = 1;
    int m1 = max(x, y);

    double f = 1.1, g = 1.2;
    double m2 = max(f, g);

    // It will find the most matching template
    auto m3 = max<double>(g, x);

    std::cout << m1 << std::endl;
    std::cout << m2 << std::endl;
    std::cout << m3 << std::endl;

    // Liskov substitutional principle
    Base<int> b;
    Derived<int> d;

    // Two mixin not in inhertiance connection
    Mixin<Base<int>> mb;
    Mixin<Derived<int>> md;

    // Lazy instantiation. If the template type param is not correct, we only find out when we use the concret implementation

    // Typedef does not work with templates, but we can use using
    using myint = int;
    using myBase = Base<int>;

    myint a = 1;

    double sum1 = sum(1, 2, 3, 4, 5);
    std::cout << sum1 << std::endl;

    // Collect value into a tipe
    std::variant<int, double, long> v;

    // Visit variant, and handle arg
    // You can check type with std::is_name_v() and handle arg by time
    std::visit([](auto &&arg)
               { std::cout << arg; },
               v);
    return 0;
}
#include <iostream>
#include <memory>
#include <cstring>
#include <vector>
#include <utility>
#include <optional>
#include <string>
#include <variant>

template <int N>
struct Factorial
{
    enum
    {
        value = N * Factorial<N - 1>::value // You can create typo
    };
};

template <>
struct Factorial<1>
{
    enum
    {
        value = 1 // You can create typo
    };
};

template <class T, class S>
auto max(T a, S b)
{
    if (a > b)
        return a;
    else
        return b;
}

// Trait
template <typename T>
struct copy_trait
{
    static void copy(T *to, const T *from, int n)
    {
        for (int i = 0; i < n; ++i)
            to[i] = from[i];
    }
};

// Specialization
template <>
struct copy_trait<long>
{
    static void copy(long *to, const long *from, int n)
    {
        std::memcpy(to, from, n * sizeof(long));
    }
};

// Policy
template <typename T>
struct is_pod
{
    enum
    {
        value = false
    };
};

template <>
struct is_pod<long>
{
    enum
    {
        value = true
    };
};

// typedef TYPELIST_3(char, signed char, unsigned char) CharList;
// List of type for compile time

// Taditionl
enum Alert
{
    green,
    yellow
};

// Scoped and stonlgy typed enum
// No export of enumerator names into enclosing scope
// No implicit conversion to int
enum class Color
{
    red,
    blue
};

// Can be changed the base type (default int like in the traditional enum)
enum class EE : unsigned long
{
    EE1 = 1,
    EE2 = 2L
};

// User defined literals
long double operator"" _w(long double a)
{
    return a;
}

struct C
{
    int a = 1;
    static const int c = 12;
    int b = 2.13;
};

int main()
{
    const int fact5 = Factorial<5>::value; // Compile time
    std::cout << fact5 << std::endl;
    std::cout << max(1.2, 3.2) << std::endl;

    // Run-time
    // - Functions
    // - Values, literals
    // - Data structures
    // - If/else
    // - Loop
    // - Assignment
    // - May depend on input
    // - Imperative
    // - Object-oriented
    // - Generative
    // - (some) Functional

    // Compile-time
    // - Metafunctions (type)
    // - Const, enum, constexpr
    // - Typelist (type)
    // - Pattern matching
    // - Recursion
    // - Ref. Transparency
    // - Deterministic
    // - Pure Functional

    // Auto, decltype
    auto d = 1;          // type deduction
    const auto &d2 = 1;  // type deuction + modifiers
    auto &&d3 = 1;       // universal reference
    auto d4 = 1, d5 = 1; // All have to be the same type by deduction

    auto a = green;
    // Alert a1 = 1; // Error
    Alert a2 = static_cast<Alert>(1);
    int a3 = green;

    // auto b = red;
    auto b = Color::red;
    // Color b1 = 1; // Error - no implicit conversion
    // int b2 = Color::red; // Error - no conversion
    int b3 = static_cast<int>(Color::blue);

    auto ud = 1.2_w;

    // Structured bindings
    std::vector v{1, 2, 3, 4, 5};
    if (auto [s, it] = std::pair{v.size(), v.begin()}; s > 0 && s < *it)
    {
    }
    // Binds the specified names ot sub-objects or members
    // Array-like, Tuple-like, Member
    int arr[] = {1, 2};
    auto [x1, y1] = arr;  // Create a temp[2] and assign the value (by reference) to the x1 and y1 - does not work with tuple, because it is not copyable
    auto &[x2, y2] = arr; // Do not create temp. Assign the original arr values

    C obj;
    auto [x3, y3] = obj; // static does not matter - won't use them - only a and b

    // Optional
    // - Maybe implementation
    // - Replace the std::pair<T, bool> results
    // - Contains value: initialized with T or std::optional<T>
    // - Not contains value: default initialized or initialized with std::nullopt_t or initialized with std::optional<T> what does not contain value
    // - If contains value, then it is allocated as T - not a pointer based heap storage
    // - Convertible to bool: has a value or not
    // - No optional reference
    std::optional<int> o1;
    std::optional<int> o2{1};
    std::optional<int> o3{std::nullopt};

    std::cout << o1.has_value() << std::endl;
    std::cout << o2.value() << std::endl;
    std::cout << o3.value_or(-1) << std::endl;

    // Variant
    // - Type-safe union
    // - Hold one of the alternative type or no value (hard to achieve)
    // - Not allowed to allocate dynamic memory - the contained object is inside the variant
    // - Can hold the same type more than once
    // - Default initialized variant hold the first alternative (index() == 0)
    // - Not allowed to hold reference or array
    std::variant<int, std::string, double> var;
    var = 55; // Will be int

    std::cout << var.index() << std::endl;
    std::cout << std::get<int>(var) << std::endl;

    try
    {
        std::cout << std::get<double>(var) << std::endl;
    }
    catch (std::bad_variant_access e)
    {
        std::cout << "Not a double" << std::endl;
    }

    std::visit([](auto &&arg)
               { std::cout << arg << std::endl; },
               var);

    // String view
    // - Can refer a constant contiguous char-like sequence
    // - Iterator and Const Iterator
    // - It is not the owenr the string
    std::string s{"Alma"};
    std::string_view sv{s};
    std::cout << sv[2] << std::endl;

    return 0;
}

void f(const std::vector<double> &v)
{
    for (auto x : v)
    {
    }

    for (auto &x : v)
    {
        // using reference allows us to change the value
    }

    for (const auto x : {1, 2, 3, 4, 5})
    {
    }
}

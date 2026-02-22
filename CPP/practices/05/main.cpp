#include <iostream>
#include <vector>
#include <algorithm>
#include <utility>

struct PrinterFunctor
{
    void operator()(int n) const { std::cout << n << " "; }
};

int main()
{
    // Temporaries: Create when evaluating expressions
    // Guaranteed to live until the full expression is evaluated

    // Lifetime extension
    // When a (const) reference is set to a temporary, or member of a temporary the temporary will live until the reference goes out of scope
    {
        int i1{1};
        int i2{2};
        int i3{3};

        const int &ic = i1 + i2;         // Destroys at the end of the block - not extend
        static const int &isc = i2 + i3; // won't destroy at the end of the block - extend
    }

    {
        int *ip1 = new int;         // Uninitialized (expression)
        int *ip2 = new int{42};     // Initialized (expression)
        int *ap1 = new int[2];      // New array - uninitialized (expression)
        int *ap2 = new int[]{1, 2}; // New array - initialized (expression)

        int *ptr = static_cast<int *>(::operator new(sizeof(int))); // New operator
        ::operator delete(ptr);                                     // Delete operator
        delete ip1;                                                 // Delete expression
        delete[] ap1;                                               // Array delete expression

        // New expression: Allocate memory for X. Calls the constructor of X and passing parameters. Converts void* pointer to X* and returns.
        // Operator new can throw bad_alloc
        // Constructor can throw exception
        // New expression guaranties no leak if the constructor throws exception
        // Operator delete never throws exception

        // They have nothrows version

        // New and delete operators can be overloaded at 2 leve - at class level and at namespace level

        // RAII: Resource Acquisition Is Initialization
        // Keep a resource is expresses by object lifetime
        // Constructo allocates, destructor deallocates
        // Object lives when constructo has successfully finished. Destructor call only when a living object goes out of scope.
        // RAII solutions: Smart pointers, guards, ifstream, ofstream, std::containers

    } // Destroys all the elements

    std::vector v{1, 2, 3, 4, 5};
    std::for_each(v.begin(), v.end(), PrinterFunctor()); // Object functor
    std::cout << std::endl;
    std::for_each(v.begin(), v.end(), [](int n) -> void
                  { std::cout << n << " "; }); // Lambda
    std::cout << std::endl;

    int x = 1;
    int y = 1;
    auto f = [x]() -> void {};                 // Access to x by value (copy)
    auto f2 = [&x]() -> void {};               // Access to x by reference (bind)
    auto f3 = [&x, y]() -> void {};            // Can mix
    auto f4 = [=]() -> void {};                // Everything by value
    auto f5 = [&]() -> void {};                // Everything by reference
    auto f6 = [&, x]() -> void {};             // Everything by reference, except x
    auto f7 = [x = x]() -> void {};            // Capture x value into x variable
    auto f8 = [u = std::move(x)]() -> void {}; // Capture x value (rvalue) into u variable
    auto f9 = []() mutable -> void {};         // Mutable - can edit environment
    constexpr auto f10 = [](int a, int b) mutable -> int
    { a *b; }; // MCan be constexpr - optimiziation
    // In class scope, can capture this and this*
    // this is not captured by default, = also captures it, this and this* captured by value
    // Capturing can be dangerous - this can be destructed when the lamda called

    // Lamdas are mapped to functors
    // [] - captures (what they see from the env)
    // () - parameters
    // -> void - return type (optional)
    // Runtime object
    // Copy constructable but not copy assignable (deleted)
    // Can stored in std::function (or use auto)
    // Default constructor deleted

    double (*fp1)(int) = [](int n) -> double
    { return n / 2.0; }; // Convert to function pointer
    const int i = [&]
    {
        int i = 2;

        return i;
    }(); // Immediately Invoked Function Expression

    auto lamda = [](auto a, auto b)
    { return a < b; }; // Generalized lambdas
    // Works like template functions

    std::cout << "Float: " << lamda(1.5, 1.2) << std::endl;
    std::cout << "Integer: " << lamda(1, 2) << std::endl;
    std::cout << "String: " << lamda("Alma", "Korte") << std::endl;

    return 0;
}
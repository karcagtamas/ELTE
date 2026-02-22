#include <atomic>
#include <vector>
#include <list>
#include <string>
#include <map>

struct A
{
    int a;
    A() {}                      // a - default initialization
    A(int a) : a{a} /*a(a)*/ {} // value initialization
};

struct B : public A
{
    B() = default;     // Not user-provided
    B(int a) : A{a} {} // Delegated constructor - it calls parent constructor
    int b;
};

struct C
{
    C(); // User-provided
    C(int i, int j)
    try : x{i}, y{j} // can throw exception
    {
    }
    catch (...)
    {
        // Constructor re-throws the exception
        // If anything is initialized, the deconstructor will run
    }

    int c;
    int x{0};
    int y = 0;
    // int z(0); // Can't use it here because it function syntax
};

C::C() = default; // Still user-provided

class Date
{
public:
    Date();                            // Default constructor
    Date(int y, int m = 1, int d = 1); // Inititalizer constructor
    explicit Date(const char *s);      // Explicit constructor

    Date &operator=(const Date &other); // Assignment operator: Steps = 1. Allocate. 2. Copy. 3. Release.
    // Virtual assignment operators are not work properly = override is only possible to the base class
    int operator[](int p);
    int operator()(int p);
    Date &operator+(const Date &other);

    ~Date() = default; // Can't throw exception, default - hint for auto generation
    //~Date() = delete; // Can't throw exception, delete - hint for not generate
    // virtual ~Date() = default; // Can be virtual for the inheritance
    // Arrays are not polymorphic

    virtual Date &clone(); // It preferred to cloning - virtual constructors are not exist

private:
    int year;
    int month;
    int day;
    // The members are initialized in the order in the class definition file: year, then month, then day (the constructor initialized list is reordered by the compiler to this)
};

inline bool operator==(const Date &lhs, const Date &rhs); // Inline function's body will be copied to the using places
bool operator<(const Date &lhs, const Date &rhs);         // This is global because
// if (today < date(2016)) works
// if (today < 2016) works
// if (2016 < today) works (not works if the operator is not global) => symmery support

int main()
{
    A a1;       // default initialization
    A a2{};     // Value initialization
    A a3 = A(); // Value initialization
    A a4 = A{}; // Value initialization
    A a5();     // Function declaration
    new A;      // Default initialization
    new A();    // Value initialization
    new A{};    // Value initialization

    int i1{1};    // Direct initialization
    int i2 = 1;   // Copy initialization
    int i3 = {1}; // Copy-list initialization
    int i4{1};    // Direct-list initialization

    int iarr1[] = {1, 2, 3};
    int iarr2[4] = {1, 2, 3}; // 4th is zero initialized

    std::atomic<int> at{0};
    std::atomic<int> at(0);
    // std::atomic<int> at = 0; // Not copyable

    std::vector<double> v = {1, 2, 3.2};
    std::list<std::pair<std::string, std::string>> langs = {{"Somebody", "C"}, {"Other", "C++"}};
    std::map<std::vector<std::string>, std::vector<int>> years = {{{"Alma", "Korte"}, {1, 2}},
                                                                  {{"Barack", "Banan"}, {3, 4}}};

    auto x1 = 5; // int
    auto x2(5);  // int
    auto x3{5};  // int
    // auto x4{5, 4};  // error
    auto x4 = {5}; // std::initialized_list<int>

    std::vector v1{1, 2};
    std::vector v2(v1.begin(), v1.end()); // This copies the values between the begin and end (cosntructor)
    std::vector v3{v1.begin(), v1.end()}; // this created a vector what contains iterators

    for (auto i : {1, 2, 3, 4}) // Range for
    {
    }

    B b{}; // Zero initialized then value initialized - b is 0
    C c{}; // Value initialized - c is undefined

    const int ci = [&]
    {
        int value;
        return value;
    }(); // Immediately executed

    return 0;
}
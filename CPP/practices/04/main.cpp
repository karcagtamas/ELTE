#include <iostream>
#include <list>
#include <vector>
#include "Date.h"
#include "S.h"
// #include <fstream>

int S::cnt = 0;

void f1(int x, int y) {}   // Passing parameter by value (copy)
void f1(int &x, int &y) {} // Passing parameter by reference (bind)

int i = 0;
int *f2() { return &i; } // Return pointer - lvalue
int &f3() { return i; }  // Return reference - lvalue
int f4()
{
    int k = i;
    return k;
} // Return value - rvalue

int main()
{
    int t[6] = {0, 1, 2, 3, 4, 5}; // Arrays works like a pointer to the first element
    // The array is sequential stored
    int *p = t;
    std::cout << sizeof(t) << std::endl; // But if the compiler knows that it is an array, it works like an array
    std::cout << t[0] << std::endl;

    std::cout << sizeof(p) << std::endl; // In that case it work like an pointer, and compiler use like that
    std::cout << p[1] << std::endl;      // But the compiler can create a correct element reaching - if the compiler does not know that the pointer is the first element of the array, then create wrong element calculation
    // Pointer are not equal to arrays

    if (p) // Pointer is not null_ptr then 1 (true) otherwise 0 (false)
    {
    }

    // Pointer arithmetic
    std::cout << t[0] + 1 << std::endl; // Second element
    std::cout << t[0] + 3 << std::endl; // Fourth element
    std::cout << t[3] - 3 << std::endl; // First element

    // Member pointers
    // Data member pointer: referencing to an offset inside a class
    // Member function pointer: referencing to a (possible virtual) member function of the class

    // Date
    Date d;
    d.set(2023, 5, 21);
    d.hu();
    std::cout << d << std::endl;
    d.us();
    std::cout << d << std::endl;

    // Pointer can nullptr
    // Reference can be only valid - if not, it throws exception

    // Move semantics - rvalue can be moved
    // 1. Two copy (copy constructor, copy assignment) are independent. Define one of them, will not prevent the generate of the other.
    // 2. Move operation are not independent. Define one of the, will prevent the generate of the other.
    // 3. If any copy is declared, then none of the move will be generated.
    // 4. If any move is declared, then none of the copy will be generated.
    // 5. If a destructor is declared, then non of the move will be generated.
    // 6. Default constructor will be generated when no constructor is declared.

    std::list<S> sl = {S(), S(), S()};
    std::vector<S> sv(3);
    std::move(sl.begin(), sl.end(), sv.begin());

    return 0;
}
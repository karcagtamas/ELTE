# For ZH

## Keywords

- stejmp/longjmp
- try/catch
  - H (handler) catches E (exception) if
    - H and E the same type
    - H is unambiguous base type of E
    - H and E are pointers or references and some of the above stands
  - Exception hiearchies
    - First catch
  - Re-throw only inside the catch block (original exception)
  - throw specifier (defines the list of throwable exceptions - can be empty)
  - noexcept specifier (can hold expression)
    - for optimization
  - noexcept operator
    - can be in the function template noexcept specifier
    - compile time check
    - false if: expression throws or has dynamic_cast or has typeid or has a function which is no noexcept(true) and not constexpr
  - destructors dont throw
- exception_ptr
- current_exception()
- nested_exception
- rewthrow_exception()
- Schwartz error
  - first attempt cin.operator int()
    - std::cin >> i works correctly
    - std::cin << i run-time error not compile-time
  - second attempt cin.operator void\*()
    - std::cin >> i works correctly
    - std::cin << i compile-time error, but delete std::cin is callable
  - solution
    - explicit bool operator
- Constants can be initialized compile time
  - Optimization can create undefined behaviour
  - Can use volatile to prevent optimization

```cpp
int main()
{
  const int ci = 10;
  int *ip = const_cast<int*>(&ci); // undefined behavior - because of optimalization
  ++*ip;
  cout << ci << " " << *ip << endl;
  return 0;
}
```

- Yoda condition
  - Use const literals first in equalization - if you use simple = it will be compile time

```cpp
int my_strlen(char *s)
{
  char *p = s;
  // “Yoda condition”
  while ( ! (0 = *p) ) ++p; // compile-time error!
  return p – s;
}
```

- Const - pointer cheat sheet
  - const keyword left to \* means pointer to const
    - Can point the const variable
    - Can be changed
    - Pointed element is handled as constant
    - const int \* cip;
  - const keyword right to \* means pointer is constant
    - Must be initialized
    - Can not be changed
    - Can modify pointed element
    - int \* const ipc;
- Derived\*\* <> Base\*\*

- Const
  - Const is overloadable
  - Const methods can be called on const variables
  - Mutable elements are editable on const variables
  - Static has to be const when initialezed with const
  - Cant be const if the value not const (like method what is not constexpr)
  - Const must be literal, constexpr variables, constexpr function
    - Used constructor, has to be also constexpr
- Constexpr functions

  - can produce constexpr value when called with compile time constants - otherwise no constexpr
  - cant be virtual
  - Return type is literal
  - Parameters are literal
  - Template functions can be constexpr

- Constructor

  - Creates object
  - Allocate memory
  - Can throw exception

- Destructor

  - Destroy object
  - Free memory
  - Should be virtual if used in polymorphic, or multiple inheritance is available
  - Can't throw exception

- Initialization

  - Default
    - if T is a class: default constructor called
    - If an array, each element default initialized
    - Otherwise no init
  - Value
    - If T is a class: default initialized
      - after zero initialized if T default constructor is not used defined or deleted
    - If and array, each element value initialized
    - Othervise zero initialized
  - Zero

    - Static and thread local variables before any init
    - if T is scalar (number, enum, pointer) set to 0

    - If Z is a class, all subobjects zero initialzed

- Operators

  - Mostly member operators
  - Some can't be member like std::ostream& operator<<(std::ostream&, const X&)
  - Some members created unwanted dependencies: other streams, string, etc.
  - Sometime operator should be symmetric (today < 2016 (this always works) and 2016 < today also works)

- Inline functions

  - Inserted into the code in compile time

- Arrays are not polymorphic
- Default and deleted constructors, destructors, operators
- Delegated constructors - use base class's constructor in the initialization list
- Operators can be virtual
- Braced initialization and initialization list

- Arrays

  - Strictly continuous memory area
  - Does not know own size
  - Names can be convert to pointers
  - Not multi-dimensional
  - No operation

- Array decay
  - Array to pointer
  - Reference binding can avoid decay
- Pointers

  - Refers to a memory location (any valid)
  - nullptr
  - Non-null pointers are refer to TRUE
  - Arithmetics
    - Intergers can be added and substracted
    - Pointers can be add or substract
    - No arithmetics on void\*
  - Not equivalent to arrays

- Reference

  - Allocate memory for a variable
  - Bind name with a special scope
  - Always should refer to a valid memory or exception (no null)

- Left value
  - Is an expression that refers to a memory location and allows us to take the address of that memory location via & operator.
- Right value

  - Expression what is not an lvalue

- Value semantics

  - Clear memory area separation
  - Performance loss when copying

- Move semantics

  - Use of temporary objects
  - You need to give rvalue reference'
  - Steal resources
  - Rule of 3 becomes rule of 5
  - Rvalue does not work with constness

  ```cpp
  void f(X& arg_)
  // lvalue reference parameter
  void f(X&& arg_)
  // rvalue reference parameter
  void f(const X& arg_) // const lvalue reference parameter
  X x;
  X g();
  f(x);
  f(g());
  // lvalue argument --> f(X&)
  // rvalue argument --> f(X&&)
  ```

- Generation of special member functions

  - The two copy operations are independent
    - Declaring copy constructor does not prevent to generate copy assignment
  - Move operations are not independent
    - Declare eather, the compile wont generate the other
  - If any copy operation declared, none of the move operations will be generated
  - If any move operation declared, none of the copy operations will be generated
  - If a destructor is declared, none of the move operations will be generated
  - Default constructor generated only no constructor is declared
  - Reverse compatibility
    - Move generated only
      - No copy operations are declared
      - No move operations are declared
      - No destructor is declared
  - Function templates
    - Templated copy constructor, assignment does not prevent move operations generation

- Functor

  - Struct with operator()

- Lamda
  - Capture by value or reference
    - Can capture this and this\*
      - Problem if the original object is destroyed - can't capture
  - Globals are not capture - available by default
  - Mutable
  - [=] captures this
  - Init capture `auto func = [up = std::move(up)] {return ip->f()}`
  - Can be constexpr
- Generalized lamdas
  - auto - like templates

```cpp
auto L = [](const auto& x, auto& y) {return x + y;}
```

- Temporaries
  - Created during expression
  - Life time until the end of the full expression
- Lifetime extension
  - When a (const) reference is set to a temporary or member of a temporary, the temporary will live until the reference goes out of scope
- New and delete

  - New operator
  - New expression
    - Allocate memory for X
    - Call constructor of X
    - Converts pointer from void\* to X\*
    - Guaranties no leak
  - New can throw error
  - Delete operator
  - Delete expression
  - Delete is noexcept
  - Operators are overloadable

- Unique Pointer

  - Single ownership pointer
  - Movable, not copyable
  - Deleter is a type parameter
  - Polymorphism - deleter not copied
  - Inheritance works with types, but the two pointer not inherit from the other
  - State: raw pointer + deleter
  - No downcast

- Shared pointer

  - Shared ownership pointer with reference counter
  - Copy constructable and assignable
  - Deleter type parameter copied
  - From this
    - **You need to use std::enable_shared_from_this<> as base class and use shared_from_this() function**
    - Dont store shared_ptr in this. Because there will be at least one reference to the memory, and wont destroy (never).
      - Use instead weak_ptr
  - Aliasing
    - Can use child element
      - Reference child element
      - Shared reference counter with the parent
        - The object will live until the parent or the child is referenced

- Weak Pointer

  - Not owns memory
  - Part of sharing group
  - No direct memory access
  - Can be converted to shared_ptr with lock()

- Exception safety trap

  - If the expression cannot fully express (something throws exception) and the std::unique<> has been made -> possible memory leak
  - Prefer use std::make_unique<>() instead - safe

- Templates

  - Laxi instantiation
  - Partial specialization
  - Default parameters are alloweed
  - Template class - all memebr functions are templates
  - `typename` for types. If wee meean to use the type: `typename T::SubType * ptr;`
  - Base class methods use `this->`
  - Two phase lookup
  - Typedef do not work

- Mixin

  - Class inheriting own template
  - Inheritance reversing
    - Policy/Strategy

- Liskov substitutional principle

  - Mixin\<Derived\> is not inherited from Mixin\<Base\>

- Curiously Recurring Template Pattern

  - Base class got as typeparam the Derived class
  - `struct Derived : Base<Derived>`
  - Operator generation, enable_shared_from_this, polymorphic chaining
    - Operator generation: we define common operator in Base, and define specialized operators in Derived
  - Static polymorph
    - Separate interface and impl.
    - Base is the interface, Derived class is the impl.

- Using

  - `using myint = int`
  - Introduce type alias

- Variadic templates
  - Type pack, defines sequence of type parameters
  - Recursive processing pack
    - Pattern(Args)... is replaced by Pattern(Arg1), Pattern(Arg2),...
  - Fold expressions
    - (t + ...)

```cpp
template <typename ...T>
auto sum(T... t)
{
  // typename std::common_type<T...>::type result{};
  // std::initializer_list<int>{ (result += t, 0)... };
  return ( t + ... ); // from C++17 e.g. clang-3.8
}
```

- Expression problem
  - Hard to expand the base classess/interfaces
- STL solution
  - Separated algorithms and containers
    - Connection through the iterators
  - Iterators const save
    - If the container const, the begin() and end() give back const_iterator
    - Always const_iterator for cbegin() and cend()
  - Alrogirthms use functors
- Iterator invalidation
  - std::vector - when capacity changed or elements are modified
  - unordered - after rehash
    - Load factor
      - size() / bucket_count() // default 1
      - Buckets
- Par algorithms

  - Can be sequentiel
  - Can be parallel on two or more thread
  - This are permissionsm not obligations
  - Minimal requirement is the forward iterator
  - Programmer's task to ensure that won't cause dead lock or data race
  - std::reduce can run paralel
    - Lamda has to be commutative

- Template metaprogramming

  - Compile-time
  - Compile-time recursion
  - Specialization
  - Trait
    - Copy with memcpy for POD types
      - Define POD types in compile-time
        - is_pod template
        - Typelist and helper functions - IndexOf, Length
    - Copy assignment for other types

- Run-time

  - Functions
  - Values, literals
  - Data structures
  - If/else
  - Loop
  - Assignment
  - May depend on input
  - Imperative
  - Object-oriented
  - Generative
  - Functional

- Compile-time
  - Metafunctions (type)
  - Const, enum, constexpr
  - Typelist (type)
  - Pattern matching
  - Recursion
  - Ref. Transparancy
  - Deterministic
  - Pure Functional

```cpp
template <int N>
struct Factorial
{
  enum { value = Factorial<N-1>::value * N };
};
template <>
struct Factorial<0>
{
  enum { value = 1 };
};
```

- Problems

  - Greedy - to much recursion in compile-time
  - Easy to tyop

- Structured bindings

  - Array-like
    - `auto& [x,y] = arr;`
  - Tuple-like
    - `auto& [x,y,z] = tuple;`
  - Member
    - `auto [x,y] = obj;`
    - static members not used

- Optional

  - Contains or not a value with the given type
  - Convertible to bool
  - Pointer using could cause problem

- Variant

  - Type-safe union
  - No value or one of the alternative types
  - Can hold the same type more than once
  - Type index == 0 by default - default construct
  - Can't hold a reference or an array

- String view

  - Char sequence
  - Iterator supporting
  - Not the owner of the string, just referencing

- Double checked locking pattern
  - Pointer assignment, constructor may not atomic

```cpp
Singleton *Singleton::instance()
{
  if ( 0 == pinstance )
  {
    Guard<Mutex> guard(lock_); // constructor acquires lock_
    // this is now the critical section
    if ( 0 == pinstance )
    // re-check pinstance
    {
      pinstance = new Singleton; // lazy initialization
    }
  }
  // destructor releases lock_
  return pinstance;
}
```

- Memory Model

  - Guaranties
    - Unblocked thread will make progress
    - Implementation should ensure that write in a thread should be visible in other threads "in a finite amount of time"
  - A happens before B relationships
    - A is sequenced before B
    - A inter-thread happens before B == tehre is a syn point between A and B
  - Sync point
    - Thread creation sync
    - Thread completion sync with return of join
    - Unlocking a muutext sync with the next locking
  - Data race == undefined behaviour
    - If two action in differen threads, at leas on is not atmoic and netiher happens before the other
  - Two thread can access and use different part of the memory in paralel
  - Mutex lock/unlock or std::atomic (same)
    - Fix order
  - Memory ordering
    - Seq. consistency
    - Relaxed
      - Original
    - Acquire - release
      - Store - release
      - Load - acquire
      - Relesing thread happens before the acquire
    - Consume - release
      - Store - release
      - Load - consume
      - Releasing threas happens before operation X in the consuming thread where X has a data dependency on the loaded value

- Thread

  - join()
  - detach()
  - These operations not implicit

- Mutex

  - lock_guard
  - unique_lock
  - shared_lock
  - scoped_lock

- Meyers singleton

  - Local static is initialized in a thread safe way

- Future/Promise

## Links

- [https://github.com/dutow/elte-cpp-examples](https://github.com/dutow/elte-cpp-examples)
- [https://github.com/arepsz/elte_cppadvanced](https://github.com/arepsz/elte_cppadvanced)
- [https://github.com/Seeker04/elte-ik-cpp](https://github.com/Seeker04/elte-ik-cpp)

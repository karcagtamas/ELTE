#include <memory>

struct Base
{
};

struct Derived1 : public Base
{
};

struct Derived2 : public Base
{
};

auto delBase = [](Base *pBase)
{ delete pBase; };

// Abstract Factory Pattern for unique_ptr
template <typename... Ts>
std::unique_ptr<Base, decltype(delBase)> makeBase(Ts &&...params)
{
    std::unique_ptr<Base, decltype(delBase)> pBase(nullptr, delBase);

    if (false /*Derived 1*/)
    {
        pBase.reset(new Derived1(std::forward<Ts>(params)...));
    }
    else if (false /*Derived 2*/)
    {
        pBase.reset(new Derived2(std::forward<Ts>(params)...));
    }
    return pBase;
}

template <typename Derived, typename Base, typename Del>
std::unique_ptr<Derived, Del> dynamic_unique_ptr_cast(std::unique_ptr<Base, Del> &&p)
{
    if (Derived *r = dynamic_cast<Derived *>(p.get()))
    {
        p.release();
        return std::unique_ptr<Derived, Del>(r, std::move(p.get_deleter()));
    }

    return std::unique_ptr<Derived, Del>(nullptr, p.get_deleter());
}

int main()
{
    // Smart pointers
    // Owner: responsible for releasing (single owner or referenc counting)
    // std::vector, std::array, std::shared_ptr, std::string, std::lock_guard, std::ifstream
    // Overserver
    // std::weak_ptr, std::string_view

    // unique_ptr
    // Single ownership
    // Movable, not copyable
    // Has a delete type parameter (cannot changed in run-time)
    {
        std::unique_ptr<int> up1{new int{1}};    // * and ->
        std::unique_ptr<int[]> up2{new int[10]}; // []

        // std::unique_ptr<int> up3(up1); // Not work, not copyable
        std::unique_ptr<int> up4;                   // nullptr => no owner
        const std::unique_ptr<int> up5{new int{2}}; // Const pointer

        // up4 = up1; Not work, not copy assignable
        up4 = std::move(up1); // Movable

        auto up6 = std::make_unique<int>(new int{42});

    } // delete called here

    int *ip = new int{42};
    std::unique_ptr<int> uip1{ip};
    // std::unique_ptr<int> uip2{ip}; // Cannot reference twice

    // Size of unique_ptr is size of raw pointer and deleter size
    // If deleter has state the size is increasing
    // unique_ptr is prefered

    // For the polymorph, the destructors have to be virtual - Deleter type is not copied during cast
    // Because unique_ptr<Derived> is not inherited from unique_ptr<Base>
    // It works with shared_ptr => it copied the Deleter type

    // shared_ptr
    // Shared ownership pointer with reference counter
    // Copy constructable ans assignable
    // Deleter type is copied
    {
        std::shared_ptr<int> sp1{new int{1}};
        std::shared_ptr<int[]> sp2{new int[]{12, 12}};

        int *ip2 = new int{42};
        std::shared_ptr<int> sp3{ip2};
        std::shared_ptr<int> sp4 = sp3;

        auto sp5 = std::make_shared<int>(new int{42});
    }

    // weak_ptr
    // Not owns the memory
    // Part of the sharing group
    // No direct operation to access the memory
    // Can be convert to shared_ptr with lock()

    {
        int *ip2 = new int{42};
        std::shared_ptr<int> sp1{ip2};
        std::shared_ptr<int> sp2 = sp1;

        std::weak_ptr<int> wp1 = sp1;

        if (!wp1.expired())
        {
        }

        if (auto sp = wp1.lock())
        {
        } // sp will be destructed here
        else
        {
            // expired
        }
    }

    // When not to use make_
    // You need custome deleter
    // You want to use braces initializer
    // std::unique_ptr - you want custom allocator
    // std::shared_ptr - long living weak_ptr-s, class-specific new and delete, potential false sharing of the object and the reference counter

    // Until there is a shared_ptr what is reference the object, or there is a pointer what is reference the part of the object, the object will be alive
    // Until there is a weak_ptr what is reference the object, the pointer will be alive, but the object will be erased when the last shared_ptr destructs

    return 0;
}
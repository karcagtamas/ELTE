#include <iostream>
#include <optional>
#include <string>
#include <memory>
#include <stdexcept>
#include "Item.h"

int main()
{
    std::cout << "Hello" << std::endl;

    // auto item = Item{"Me"};
    Item item{"Me"};
    auto *item2 = new Item("Korte");
    Item *item3 = &item;
    Item i = Item(item2);

    std::cout << item.getName() << std::endl;
    // std::cout << (*item2).getName() << std::endl;
    std::cout << item2->getName() << std::endl;
    // std::cout << (*item3).getName() << std::endl;
    std::cout << item3->getName() << std::endl;
    std::cout << i.getName() << std::endl;

    delete item2;

    std::cout << __cplusplus << std::endl;

    std::optional<int> opt;
    std::cout << opt.value_or(-1) << "\n";

    opt = std::optional<int>{42};
    std::cout << opt.value() << "\n";

    std::unique_ptr<Item> ptr{new Item{"Alma"}};

    std::exception_ptr eptr;

    try
    {
        throw std::invalid_argument{"ERROR"};
    }
    catch (std::invalid_argument &ex) // Same type or derived matching (this is the super)
    {
        eptr = std::current_exception(); // extend ex lifetime
        // throw ex;
        throw; // re-throw current exception
        // Exception destructs after try-catch
    }
    catch (...) // catch all
    {
    }

    return 0;
}
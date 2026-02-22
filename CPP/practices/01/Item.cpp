#include "Item.h"

std::string Item::getName() const noexcept
{
    if (item != nullptr)
    {
        return item->getName();
    }

    // throw std::bad_alloc();
    return name;
}
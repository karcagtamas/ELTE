#include <string>

class Item
{
    const std::string name;
    const Item *item;

public:
    Item(const std::string name) : name(name) {}
    Item(const Item *item) : item(item), name("") {}

    std::string getName() const noexcept;
    virtual ~Item() {}
};
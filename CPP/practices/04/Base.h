class Base
{
public:
    Base(const Base &rhs); // Copy constructor for lvalue - non-move
    Base(Base &&rhs);      // Move constructor for rvalue - move - can't be const => can't move
};
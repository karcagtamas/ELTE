#include <iostream>

void f()
{
  int i = 1;
  std::cout << i << ++i << std::endl;
}

int main() {
    std::cout << "Hello, World!" << std::endl;

    f();
    return 0;
}

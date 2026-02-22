#include <iostream>

class Date
{
public:
    void set(int y, int m, int d);
    int getYear() const { return _year; };
    int getMonth() const { return _month; };
    int getDay() const { return _day; };

    void print(std::ostream &os) const;
    void hu();
    void us();

private:
    int _year;
    int _month;
    int _day;

    int Date::*p1;
    int Date::*p2;
    int Date::*p3;

    char sep;
};

std::ostream &operator<<(std::ostream &os, const Date &d);
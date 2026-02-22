#include "Date.h"

void Date::hu()
{
    sep = '.';
    p1 = &Date::_year;
    p2 = &Date::_month;
    p3 = &Date::_day;
}

void Date::us()
{
    sep = '/';
    p1 = &Date::_day;
    p2 = &Date::_month;
    p3 = &Date::_year;
}

void Date::set(int y, int m, int d)
{
    _year = y;
    _month = m;
    _day = d;
}

void Date::print(std::ostream &os) const
{
    os << this->*p1 << sep << this->*p2 << sep << this->*p3;
}

std::ostream &operator<<(std::ostream &os, const Date &d)
{
    d.print(os);
    return os;
}
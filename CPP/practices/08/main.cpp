#include <vector>
#include <algorithm>

// Template based find
template <typename T>
T *ffind(T *begin, T *end, const T &x)
{
    while (begin != end)
    {
        if (*begin == x)
        {
            return begin;
        }
        ++begin;
    }

    return nullptr;
}

// Iterator based find
template <typename It, typename T>
It ffind(It begin, It end, const T &x)
{
    while (begin != end)
    {
        if (*begin == x)
        {
            return begin;
        }
        ++begin;
    }

    return end;
}

int main()
{
    int t[]{1, 2, 3, 4, 5};
    auto r1 = ffind(t, t + sizeof(t) / sizeof(t[0]), 1);

    std::vector<int> v{1, 2, 3, 4, 5};
    auto r2 = ffind(v.begin(), v.end(), 1);

    auto r3 = std::find(v.begin(), v.end(), 1);
    auto r4 = std::find_if(v.begin(), v.end(), [](auto a)
                           { return a == 1; });
    auto r5 = std::find_if(v.begin(), v.end(), [cnt = 0](auto a) mutable
                           {if (a < 55) ++cnt; return 3 == cnt; }); // Or we can use a functor (class), what has a private date member for cnt

    // Vector - fix capacity, if it reached -> the capacity expand
    // Arrays - continously stored

    // Hashed based containers
    // - Unordered_map
    // - Unordered_set
    // - Unordered_multimap
    // - Unordered_multiset
    // The iterator invalidates when rehash happened
    // They use buckets - by default load factor == size() / bucket_count() (default 1.0)

    // Parallel STL
    // Execution policy
    // - std::execution::seq
    // - std::execution::par
    // - std::execution::par_unseq
    // - std::execution::unseq
    // These are permissions, not obligations. Compiler may use this
    // Programmer's task to ensure the element access functions will not cause dead lock or data race
    // Minimal requirement: forward iterator
    // In case of paralelization: access must not use any blocking synchronization

    // Accumuluate is guaranted left associative
    // Reduce can work parallel - has to be commutative
    // Can use transform_reduce - first transfrom, then reduce (commutative) form in paralell if (possible or needed)

    return 0;
}
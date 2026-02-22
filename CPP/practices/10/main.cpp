#include <mutex>
#include <atomic>
#include <thread>
#include <memory>
#include <future>
#include <iostream>

// Double checked locking pattern
class Singleton
{
public:
    static Singleton *instance()
    {
        if (0 == pinstance)
        {
            std::lock_guard l(lock_); // Automatic lock acquired and released on destroy (end of if)

            if (0 == pinstance)
            {
                pinstance = new Singleton;
                // new expression is not atomic
                // It allocates memory, run constructor and return a pointer
            }
        }

        return pinstance;
    }

private:
    static Singleton *pinstance;
    static std::mutex lock_;
};

template <typename T>
class Singleton2
{
public:
    std::shared_ptr<T> instance()
    {
        std::call_once(flag, init);
        return ptr;
    }

private:
    void init()
    {
        ptr.reset(new T);
    }
    std::shared_ptr<T> ptr;
    std::once_flag flag;
};

class MySingleton
{
};

// Meyers Singleton
// Local static guarantees the thread safe initialization
MySingleton &MySingletonInstance()
{
    static MySingleton _instance;
    return _instance;
}

void f()
{
}

int main()
{
    // Memory modell describes the interactions of threads through memory
    // Describes well defined behaviour
    // Constrainst compiler for code generation
    // Contract: programmer ensures that program not has data race, system guarantees the sequentially consistent execution

    // Terminiology
    // - Guarantiees: unblocked threads will make progress and thread write should be visisble in other threads in a finite amount of time
    // - A happens B: if A is sequenced before B or A inter-thread  happens before B ==> there is a sync point between A and B
    // Sync point
    // - Thread creation sync with start of thread execution
    // - Thread completion sync with the return of join()
    // - Unblocking a mutex sync with the next locking of that mutex
    // Data race == undefined behaviour
    // - A program contains data race if contaisn two action in different threads, at least one is not "atomic" and neither happens before other
    // Two threads of execution can update and access separate memory location without intergering each others

    // Sequential consistency
    // - Each threads are executed in sequential order
    // - The operations of each thread appear in this sequence for the other threads in that order

    std::atomic<bool> flag = false;
    // it uses mutex lock() and unlock() buil-in
    // store-load is a sync point
    // Guarantees code order
    flag.store(true);
    auto f = flag.load();

    // Memory orders

    // Relaxed memory order
    // - Memory operations performed by the same thread on the same memory location are not reordered with respect of modification order

    // Acquire - release memory order
    // - Sync point all stored value reading
    // - Releasing thread happens before the load acquire
    // - Some platform is cheaper with this method

    // Consume - release memory order
    // - Releasing thread happens before an operation in the consuming thread where has a data dependency on the loaded value

    // Threads
    // std::thread t1(f);
    std::thread t2([]() {});

    // t1.join();
    t2.join();

    // No implicit join
    // No implicit detach
    // If not joinable the thread, throw exception

    std::jthread scoped_thread([]() {}); // Automaticly joins on destruct

    // join() - wait
    // detach() - not wait - maybe the main thread ends and stops

    // std::thread works with containers

    {
        std::mutex mut1;
        std::mutex mut2;

        // lock two or more
        std::lock(mut1, mut2); // Can be try_lock
        std::lock_guard lg1(mut1, std::adopt_lock);
        std::lock_guard lg2(mut2, std::adopt_lock);

        // Lock guard
        // - simple scoped wrapper around a mutex, non-copyable, non-movable
    }

    {
        std::mutex mut1;
        std::mutex mut2;

        // lock two or more
        std::unique_lock ul1(mut1, std::defer_lock);
        std::unique_lock ul2(mut1, std::defer_lock);
        std::lock(mut1, mut2); // Can be try_lock

        // Unique lock only moveable
        // - simple scoped wrapper around a mutex, non-copyable, movable
    }

    // Shared lock
    // - lock the mutex in shared mode
    // - shared_timed_mutex
    // - non-copyable, moveable

    // Scoped lock
    // - variadic tempalte class RAAI to own one or more mutexes
    // - non-copyable, owning multiple mutexes with std::lock

    // Future - Promise
    std::future<int> fut = std::async([]()
                                      { return 1; });

    std::cout << fut.get() << std::endl;

    // std::async has parameters for thread initialization settings
    // std::launch::async - start a new thread
    // std::launch::deffered - run on the thread wher wait() or get() called
    // by default the implementation chooses

    return 0;
}
# Eiffel

## Imperative programming

### Variables

- class member
- local variable
- formal parameter

```eiffel
class PERSON
create set_name
feature
    name: attached STRING
    set_name(new_name: attached STRING)
        local
            tmp : STRING
        do
            tmp := new_name.mirrored
            name := tmp.mirrored

            -- the new_name is a reference
            -- name := new_name.twin
        end
    set_friends_name(friend: attached PERSON)
        do
            friend.set_name(name)
        end
end
```

- storing
  - heap
  - execution stack

```eiffel
-- reference
class PERSON
...
end

-- expanded
expanded class INTEGER
...
end
```

- creating
  - reference will be `Void` by initial
  - expanded will be a default value (like `INTEGER` will be `0`)

```eiffel
john: PERSON
id: INTEGER

create john.set_name("John")
create id

create{PERSON}.set_name("Peter") -- expression

jack: ANY

create{PERSON}.set_name("Jack")
```

- editing
  - only class member or local variable
  - function parameters (formal) cannot be edited
- we are using getters and setters

```eiffel
class PERSON
create set_name
feature
    name: STRING assign set_name
    set_name(new_name: STRING)
        do
            name := new_name.twin
        end
    set_friends_name(friend:PERSON)
        do
            friend.name := name -- friend.set_name(name) - syntax sugar
        end
```

```eiffel
gcd (a,b: INTEGER) : INTEGER -- formal parameters cannot be written
local
    number: INTEGER
do
    from
        Result := a -- return parameter
        number := b
    until
        Result = number
    loop
        if Result > number
        then Result := Result - number
        else number := number - Result
        end
    end
end
```

### Statements

- elseif

```eiffel
szokoev: BOOLEAN
    do
        if ev \\ 400 = 0 then Result := True -- // = div | \\ = mod
        else if ev \\ 100 = 0 then Result := False
        elseif ev \\ 4 = 0 then Result := True
        else Result := False
        end
    end
```

- inspect (switch)

```eiffel
napok_szama_a_honapban: INTEGER
    do
        inspect honap
            when 1,3,5,7,8,10,12 then Result := 31
            when 4,6,9,11 then Result := 30
            when 2 then
                if szokoev then Result := 29
                else Result := 28
                end
        end
    end
```

- iterate

```eiffel
across <<1969, 7, 20, 17, 40>> as i
loop
    print(i.item.out)
    print("%N")
end
```

- iterate expression

```eiffel
across <<7, 20, 20, 17, 40>> as i all i.item > 0 end
across <<7, 20, 20, 17, 40>> as i some i.item = 17 end
```

## Naming conventions

- keywords: small characters
- used keywords like: Result, Current, Void, Tre, False, Precursor - cannot be used
- constants: `Line_width: INTEGER = 256`
- class names: upper case
- other identifiers: lower case

## Contract based programming

- Deign by contract
  - `check [assertion] end`

```eiffel
check
    size_is_not_too_large: size <= capacity
end
```

- Loop also can have contract
  - `invariant`, `variant`
- And rutine also can have contract

```eiffel
gcd (a,b: attached INTEGER): attached INTEGER
require -- REQ: A -> BOOLEAN (A contains formal parameters and the actual object members)
    0 < a; 0 < b
local
    number: INTEGER
do
    from
        Result := a
        number := b
    invariant 0 < Result; 0 < number; -- INV: A -> BOOLEAN (A contains formal parameters, local variables and the actual object members)
    variant Result + number -- VAR: A -> INTEGER (A contains formal parameters, local variables and the actual object members)
    until Result = number loop
        if Result > number
        then Result := Result - number
        else number := number - Result
        end
    end
ensure -- ENS: A -> BOOLEAN (A contains formal parameters and the actual object members)
    Result > 0; a \\ Result = 0; b \\ Result = 0;
end
```

### Weakest pre-condition

- `lf(S,P)` or `wp(S,P)`
- From a S kind of state, when the S program is evaluated then the program will terminate and the result will be an P kind of state

### Hoare-triple

- Axiomatic semantic
- Parcial and total correctness
- `{pre-condition} program {post-condition}` => `{REQ} rutine {ENS}`

## OOP

```eiffel
class DATUM
create
    make, make_masnap, from_array -- creation procedure (constructor)
feature
    ev, honap, nap: attached INTEGER -- attributes
    attr: attached INTEGER attribute Result := 1999 end -- initialize attribute
    Januar: attached INTEGER = 1 -- constant
    szokoev: attached BOOLEAN -- function (no `()`)
        do ... end
    make (ev_, honap_, nap_: attached INTEGER) -- method
        do ... end
    make_masnap(d: attached DATUM)
        do
            if d.nap = d.napok_szama_a_honapban then
                if d.honap = December then
                    ev := d.ev + 1
                    honap := Januar
                    nap := 1
                else
                    ev := d.ev
                    honap := d.honap + 1
                    nap := 1
                end
            else
                ev := d.ev
                honap := d.honap
                nap := d.nap + 1
            end
        end
    masnap: attached DATUM
        -- Documenting this method
        do
            create Result.make_masnap(Current) -- Result is a `variable`, so we can call constructor on it
        end
    masnapra_lep
        do
            make_masnap(Current) -- Current is the current object instance (like `this`)
        end
    from_array( arr: attached ARRAY[INTEGER])
        require
            arr.count = 3
        do ...
        ensure
            ev = arr[arr.lower]
            honap = 1 + (arr[arr.lower + 1].abs - 1) \\ 12
            nap = 1 + (arr[arr.lower + 2].abs - 1) \\ napok_szama_a_honapban
        end
invariant
    honap_nem_tul_kicsi: honap >= Januar -- name is not required
    honap_nem_tul_nagy: honap <= December
    nap >= 1
    nap <= napok_szama_a_honapban -- we can write this on one row: separated by ';' or 'and'
end -- class DATUM
```

- Empty parameter list: there is not `()` after function or method name
- Classes also has `invariant`
- `{REQcp} cp {ENScp and INVc}` - cp - creation procedure, c - class
- `{REQr and INVc} r {ENSr and INVc}` - r - other procedure, c - class

### References

- Empty reference: `Void`
  - Derefering is exception
- Indirect access
- Dynamic memory allocation
- Polimorf variables with dynamic binding
- Aliasing
  - Can two variables point to same reference
- Garbage collecting
- Security by types
  - `attached ACCOUNT` - cannot be `Void` - REQUIRED in exam
  - `detachable ACCOUNT` - can be `Void` - REQUIRED in exam
- Static type checking

```eiffel
class PERSON
create
    set_name
feature
    name: attached STRING
    set_name( str: attached STRING)
        do
            name := str.twin
        end
    ...
end -- class PERSON
```

- `attached ACCOUNT` <: `detachable ACCOUNT` => `attached ACCOUNT` is sub type of `detachable ACCOUNT`

```eiffel
if attached d as ad then -- d is a `detachable` type; check it's `attached` (not `Void`)
    a := ad
    ad.deposit(100)
end
```

## Procedural programming

- parameters
  - expanded types: call-by-value
  - reference types: call-by-sharing
    - threat: `f.divide_by(f)` -> f will be modifed by itself, but it is changing (references)
      - solution: convert f's type to expanded or don't let same reference (`required other /= Current`)

```eiffel
class FRACTION
create set
feature
    numerator: attached INTEGER
    denominator: attached INTEGER attribute Result := 1 end
    ...
    divide_by( other: attached FRACTION ) -- imperative style
        require
            other.numerator /= 0
            other /= Current -- close out aliasing
        do
            numerator := numerator * other.denominator
            denominator := denominator * other.numerator
        end
    divided_by alias "/" ( other: attached FRACTION): attached FRACTION -- functional style + overload operator `/`
        require
            other.numerator /= 0
        do
            create Result.set(numerator * other.denominator, denominator * other.numerator)
        end

    reciprocal alias "|" : attached FRACTION -- our own operator
        require
            numerator /= 0
        do
            create Result.set(denominator, numerator)
        end
invariant
    denominator /= 0
end

...

-- Calling it from main

local
    p, q, r: attached FRACTION
do
    create p.set(3,4)
    create q.set(5,3)
    r := p.divided_by(q) -- create a new FRACTION and save it to `r`
    r := p / q -- same as previously
    p.divide_by(q) -- write result into `p`
```

- In that case, we have another solution

```eiffel
if Current = other then
    numerator := 1
    denominator := 1
else
    numerator := numerator * other.denominator
    denominator := denominator * other.numerator
end
```

- operators:
  - arithmetic
    - i / j; i // j; i \\ j; i ^ j
  - logic
    - not; and; or; xor; and then; or else; implies
  - relation
    - <; <=; >; >=; =; /=; ~; /~
  - others
    - .; ..; old; [,]
- `old` operator
  - only in `ensure` part
    - it referes to the previous state (before method execution)
  - can be used for the checking of the changes (before <=> after)

```eiffel
class ACCOUNT
...
feature
    balance: attached INTEGER
    id: attached INTEGER

    deposit( amount: attached INTEGER)
        require
            amount > 0
        do
            balance := balance + amount
        ensure
            balance_updated: balance = old balance + amount
            frame: id = old id -- ensuring `id` is not changed
            -- frame: only balance
            -- frame: strip (balance) ~ old strip (balance)
        end
```

- we can check the `not changing`
  - we ensuring about, that some data member is not changed during the method/function execution
  - we can use `only`
    - it defines what can changed (others not)
    - not supported by Eiffel Studio yet
  - or we can use `strip`
    - supported by Eiffel Studio
- we can define our own operators:

```eiffel
class POINT
create set
feature
    x,y: attached REAL_64
    ...
    distance alias "|-|" (other: attached POINT): attached POINT
    do ... end
end
```

```eiffel
max_place(arr: attached ARRAY[INTEGER]): INTEGER
    require
        arr.count > 0
    do
        from
            Result := arr.lower -- get first index
            m := arr.item(Result) -- get first element (by index)
            i := Result
        invariant
            arr.lower <= Result; Result <= arr.upper
            arr.lower <= i; i <= arr.upper + 1
            m = arr.item(Result)
            across (arr.lower |..| (i-1)) as c all arr[c.item] <= m end
        variant arr.upper - i + 1
        until i > arr.upper
        loop
            if arr.item(i) > m then
                Result := i
                m := arr.item(Result)
            end
            i := i + 1
    ensure
        arr.lower <= Result
        Result <= arr.upper
        arr ~ old arr -- deep equations
        across arr as cur all cur.item <= arr[Result] end -- foreach expression
```

## Generic programming

- Generic class
  - what we define (can be generic)
- Type
  - can be class, can be parameterized generic class

```eiffel
class ARRAY[G]
...
-- a class can have multiple feature part (different accessibility too)
feature
    lower, upper: INTEGER
    count, capacity: INTEGER
feature
    make_empty
    make_filled(a_default_value:G;min_index,max_index: INTEGER)
    make(min_index, max_index: INTEGER) obsolete
feature
    item alias "[]" (i: INTEGER): G assign put
feature
    put (v: G; i: INTEGER)
```

```eiffel
class MATRIX
create
    make
feature
    rows, cols: INTEGER

    item alias "[]" (i, j: INTEGER): REAL assign put
        require 1 <= i; i <= rows; 1 <= j; j <= cols
        do
            Result := data[(i-1)*cols+j]
        end

    put (val: REAL; i,j: INTEGER)
        require 1 <= 1; i <= rows; 1 <= j; j <= cols
        do
            data[(i-1)*cols+j] := val
        ensure val ~ item(i,j)
        end
feature {NONE} -- private visibility
    data: attached ARRAY[REAL]
    make(nr_rows, nr_cols: INTEGER)
        require nr_rows > 0; nr_cols > 0
        do
            rows := nr_rows
            cols := nr_cols
            create data.make_filled(0.0, 1, rows * cols)
        ensure rows = nr_rows; cols = nr_cols
        end
invariant
    rows > 0 and cols > 0
    data.lower = 1; data.upper = rows*cols
end -- class MATRIX
```

```eiffel
class STACK[T]
create make
feature
    size: INTEGER
    capacity: INTEGER
    push (element: attached T)
        require size < capacity
        do
            size := size + 1
            data.put(element,size)
        ensure top = element;size = old size + 1
        end

    top: attached T
        require size /= 0
        do
            Result := data.item(size)
        ensure size = old size
        end

    pop
        require size /= 0
        do
            size := size - 1
        ensure size = old size - 1
        end
feature {NONE}
    data: attached ARRAY[attached T]

    make (capacity_: INTEGER)
        require capacity_ > 0
        do
            create data.make(1,capacity_)
            capacity := capacity_
        ensure
            size = 0; capacity = capacity_
        end
invariant
    0 <= size; size <= capacity
    data.lower = 1 ; data.upper = capacity
end
```

```eiffel
class MAYBE[T]
create
    nothing, just
feature
    has: BOOLEAN
    item: attached T
        require has_item: has
        do
            check attached value as attached_value then
                Result := attached_value
            end
        end

feature {NONE}
    value: detachable T
    nothing:
        do
            has := False
        ensure not has
        end
    just(v: attached T)
        do
            has := True
            value := v
        ensure has and item ~ v
        end
invariant
    has implies attached value
end
```

```eiffel
local
    s: STACK[INTEGER]
    x: MAYBE[INTEGER]
do
    create x.just(121)
    create s.make(10)
    if x.has then s.push(x.item) end
    s.push(42)
    s.pop
    print (s.top.out)
```

## Inheritance

- Part of the OOP paradigm
- Inherit a type from another
  - Define only difference
  - Extend the original one, or redefine some of them
- Sub-types
- Single or multi inheritance
- Open-closed principle

```eiffel
class ACCOUNT
create make
feature
    balance: INTEGER
    id: INTEGER

    deposit( amount: INTEGER )
        require
            amount > 0
        do
            balance := balance + amount
        ensure
            balance_updated: balance = old balance + amount
            frame: id = old id -- ensuring `id` is not changed
        end

    withdraw ( sum: INTEGER) ...
feature {NONE}
    make( id_: INTEGER ) ...
invariant
    balance >= 0; ...
end -- class ACCOUNT
```

```eiffel
class SAVINGS_ACCOUNT
inherit
    ACCOUNT
        rename make as make_account
    end
create
    make -- inherited creation procedure (when not use rename)
    make_with_interest -- cannot be make, name collidtion
feature
    interest: INTEGER assign set_interest
    set_interest( interest_: INTEGER )
        require
            interest_ >= 0
        do
            interest := interest_
        ensure
            interest = interest_
            only interest
        end -- set_interest
    pay_interest
        do
            deposit(balance * interest // 100)
        ensure
            balance = old (balance + balance * interest // 100)
            only balance
        end -- pay_interest
feature {NONE}
    make_with_interest( id_, interest_: INTEGER)
        require
            interest_ >= 0
        do
            -- make(id_)
            make_account(id_)
            set_interest(interest_)
        ensure
            id = id_
            interest = interest_
        end -- make_with_interest
invariant
    interest >= 0
end -- class SAVINGS_ACCOUNT
```

- Default base class is the `ANY`
- All class has a default creation procedure: `default_create` => it's in the `ANY`
  - If we are using `default_create` then the explicit call is leaveable: `create {POINT}` instead of `create {POINT}.default_create`
    - This is true after renaming (`default_create` to `make` f.i.)

```eiffel
local
    sa: SAVINGS_ACCOUNT
    a: ACCOUNT
do
    create sa.make(1919112)
    a.make(121212)
    create {SAVINGS_ACCOUNT} a.make(191212)
    a.deposit(1000)
    a.set_interest(10) -- compilation error -> a reference is an `ACCOUNT`

    if attached {SAVINGS_ACCOUNT} a as sa2 then
        sa.set_interest(10)
    end
```

### LSP

- Liskov's Substitution Principle
  - `A` is sub-type of `B` (base) if we can use `A` elements instead of `B` elements without causing problem

### Visibility of features

- `feature` - visible to everyone
- `feature {ANY}` - visible to the elements who are inherited from `ANY`
- `feature {NONE}` - visible to the elements who are inherited from `NONE` -> nobody

### Redefine

```eiffel
class CIRCLE
inherit ANY
        rename default_create as make
        redefine default_create
    end
-- create make -- it is used by default (default_create is from `ANY` (it's just renamed))
feature
    x, y, r: REAL
    default_create
        do
            r:=1.0 -- x and y is 0.0 by default - REAL is expanded class
        end
end -- class CIRCLE
```

```eiffel
class TIME
inherit DATUM
        redefine make_masnap, from_array
    end
create
    make, make_masnap, from_array
feature
    hour, min: INTEGER
    make_masnap(d: attached DATUM)
        do
            Precursor(d) -- call original (redefined) function (parent)
            if attached {IDOPOINT} d as ip then
                or := ip.ora
                perc := ip.perc
            end
        end
    from_array( arr: attached ARRAY[INTEGER])
        require else -- append additional requirements (OR connection)
            arr.count = 5
        do ...
        ensure then -- append additional invariant conditions (AND connection)
            ora = 0 or else ora = arr[arr.lower+3] \\ 24
            perc = 0 or else perc = arr[arr.lower+4] \\ 60
invariant
    ora_nem_tul_kicsi: ora >= 0
    ora_nem_tul_nagy: ora < 24
    perc_nem_tul_kicsi: perc >= 0
    perc_nem_tul_nagy: perc < 60
end -- class TIME
```

- Child class invariant
  - INV(TIME) = INV(DATUM) and invariant(TIME)
- In the derived class (and the redefined functions/methods) the REQ (pre-condition, `require`) can be weakened and the ENS (post-condition, invariant) can be stricted
- `require else` and `ensure then`
  - r = inherited, r' redefined
  - PRE(r') = PRE(r) OR require_else(r')
  - POST(r') = POST(r) AND ensure_then(r')
- The modified contract:
  - C = class
  - `{PRE(r') AND INV(C)} C.r' {POST(r') AND INV(C)}`
  - For creation procedure: `{PRE(r')} C.r' {POST(r') AND INV(C)}`
- Missing contracts
  - `require` -> `require True`
  - `require else` -> `require else False`
  - `ensure` -> `ensure True`
  - `ensure then` -> `ensure then True`

## Abstract classes

- Goal is: create a class for inheriting from it (cannot be instatiated)
  - Reduce the code redundance
  - Same abstraction, different defines
- Fully abstract: like interface
- Partly abstract

```eiffel
deferred class ANIMAL -- Abstract class
feature
    talk: attached STRING
        deferred -- abstract feature
        end
end -- class ANIMAL

class CAT
inherit ANIMAL
feature
    talk: STRING
        do -- can be `attribute` too or can be `once`
            Result := "Miaow"
        end
end -- class CAT

class OTHER_CAT
inherit ANIMAL
        redefine
            default_create
        end
feature
    talk: attached STRING
    default_create
        do
            talk := "Miaow"
        end
end -- class OTHER_CAT
```

```eiffel
deferred class COMPLEX
inherit MATH -- With inheritance we import other modules like Math
feature
    re, im: REAL deferred end
    r, arg: REAL deferred end

    from_cart(re_, im_: REAL) deferred end
    from_polar(r_, arg_: REAL) deferred end
feature
    -- Using of derived class
    polar: POLAR_COMPLEX
        do
            create Result.from_polar(r,arg)
        end
    cart: CART_COMPLEX
        do
            create Result.from_cart(re, im)
        end
feature -- arithmetics
    times alias "*" ( other: COMPLEX ): COMPLEX
        deferred
        end

    divided_by alias "/" ( other: COMPLEX ): COMPLEX
        require
            nonzero_divisor: other.r /= 0
        deferred
        ensure
            inverse_of_times: Current ~ Result * other
        end
feature {NONE} -- conversion helpers
    frozen r_from_cart(re_, im_: REAL) : REAL do ... end
    frozen arg_from_cart(re_, im_: REAL) : REAL
        do
            if re_ = 0 then
                if im_ >= 0 then
                    Result := Pi / 2
                else
                    Result := 3 * Pi / 2
                end
            else
                Result := arc_tangent(im_/re_)
                if re_ < 0 then
                    Result := Result + Pi
                elseif im_ < 0 then
                    Result := 2 * Pi + Result
                end
            end
        end
    frozen re_from_polar(r_, arg_: REAL) : REAL
        do
            Result := r_ * cosine(arg_)
        end
    frozen r_from_cart(re_, im_: REAL) : REAL
        do
            Result := r_ * sine(arg_)
        end
...
invariant
    arg < 2*Pi
    arg >= 0
end -- class COMPLEX
```

```eiffel
class POLAR_COMPLEX
inherit COMPLEX
feature
    r: REAL assign set_r
    arg: REAL assign set_arg

    re: REAL
        do
            Result := re_from_polar(r, arg)
        end

    im: REAL
        do
            Result := im_from_polar(r, arg)
        end

feature
    from_polar(r_, arg_: REAL)
        do
            set_r(r_)
            set_arg(arg_)
        end
    from_cart(re_, im_: REAL)
        do
            r := r_from_cart(re_, im_)
            arg := arg_from_cart(re_, im_)
        end
    set_r(r_: REAL)
        do
            r := r_
        end
    set_arg(arg_: REAL)
        do
            from
                arg := arg_.abs
            invariant
                arg >= 0
            until
                arg < 2 * Pi
            loop
                arg := arg - 2 * Pi
            variant
                arg.truncated_to_integer
            end

            if arg_ < 0 then
                arg := 2 * Pi - arg
            end
        end

feature
    times alias "*" ( other: COMPLEX ): POLAR_COMPLEX
        do
            create {POLAR_COMPLEX} Result.from_polar(r * other.r, arg + other.arg)
        end
    divided_by alias "/" ( other: COMPLEX ): POLAR_COMPLEX
        -- require else False
        do
            create {POLAR_COMPLEX} Result.from_polar(r / other.r, arg - other.arg)
        -- ensure then True
        end
...
end -- class POLART_COMPLEX
```

- `frozen` methods: cannot be redefined
- `forzen` classes: cannot inherit from them

```eiffel
local
    cc: CART_COMPLEX
    pc: POLAR_COMPLEX
    c: COMPLEX
do
    c := cc * cp -- ok
    c := c * c -- ok
    cc := cc * cp -- compilation error - the return type is `COMPLEX`
```

- Use covariant return types: `POLAR_COMPLEX` instead of `COMPLEX`

```eiffel
local
    cc: CART_COMPLEX
    pc: POLAR_COMPLEX
    c: COMPLEX
do
    c := cc * cp -- ok
    c := c * c -- ok
    cc := cc * cp -- ok
```

## Variance

- Covariant return type

```eiffel
deferred class FOOD end
class MILK inherit FOOD...

class ANIMAL
feature
    prefers: detachable FOOD do end
...

class CAT
inherit ANIMAL redefine prefers end
feature
    prefers: attached MILK do create Result end
...
```

### Covariant

- `A` <: `B` and we have a `f` function with `B` return type in `T`
- Az `S` <: `T` status also exist if `S` redefine `f` with `A` return type
- LSP: `object_S.f(params)` instead of `object_T.f(params)`
- The visibility can expand

```eiffel
class T
feature f : B

class S inherit T redefine f end
feature f : A
```

- Parameter covariance is permitted in Eiffel
  - It's agains LSP
  - Math error but it can be useful
- Rutine parameters can be covariant
- Generic type parameters can be covariant
- In contrats only contravariant

### Anchored type

- No need re-declaration
- An adaptive type
- `like` keyword
  - Can be connected to `Current` or to an attribute

```eiffel
class ANY
...
feature
    frozen twin: attached like Current
        do
            [magic]
        end
...
end -- class ANY
```

```eiffel
class HOLDER[T]
create
    set
feature
    item: attached T assign set

    set( value: like item )
        do
            item := value
        ensure
            item = value
        end
end -- class HOLDER
```

### LSP with anchored type

- if `Int <: Real` then `Real -> Int <: Int -> Real`
- **Contravariant parameter type** and **covariant return type**

### Contravariant

- `object_S.r(param_B)` instead of `object_T.r(param_A)`
- That's not supported on the most of the cases (programming languages)
  - hidin, overload
  - Type against contracts
- `A` <: `B` and we have a `r` function with `A` return type in `T`
- Az `S` <: `T` status also exist if `S` redefine `r` with `B` return type

```eiffel
class BANK_CARD
feature
    withdraw( amount: INTEGER )
        require no_overdraw: amount <= balance
        ensure balance = old balance - amount
...
end -- class BANK_CARD
```

```eiffel
class CREDIT_CARD
inherit
    BANK_CARD redefine wihdraw end
feature
    withdraw( amount: INTEGER )
        require else True
...
end -- class CREDIT_CARD
```

### CAT-call

```eiffel
local
    a_cat: CAT
    some_grass: GRASS
    polymorphic: ANIMAL
do
    create a_cat
    create some_grass
    a_cat.feed( some_grass ) -- compilation error

    polymorphic := cat
    polymorphic.feed( some_grass ) --> CAT call
```

- Because of covariant parameter types and polymorphism we are able to do invalid operation
  - What would be illegal and compilation error, that compiled successfully

```eiffel
class SKIER
feature
    -- roommate: detachable SKIER assign share
    roommate: detachable like Current assign share -- adaptive field type
    -- share (s : detachable SKIER) do roommate := s end
    share (s : like roommate) do roommate := s end -- adaptive parameter type
    ...
end -- class SKIER

class GIRL
-- inherit SKIER redefine roommate, share end
inherit SKIER -- no need to redefien because of the adaptive types in `SKIER`
feature
    -- roommate: detachable GIRL assign share -- covariant field
    -- share(g: detachable GIRL) do roommate := g end -- covariant parameter
    ...
end -- class GIRL
```

```eiffel
local
    g: GIRL
    b: BOY
do
    ...
    g.share(b) -- compilation error
```

```eiffel
local
    g: SKIER
    b: BOY
do
    ...
    create {GIRL} g
    g.share(b) -- no compilatio error -> Catcall error
```

- CAT - Changed Availability or Type
  - If inherited feature has smaller visibility or a field or parameter type will be smaller type (a base)
  - Polimorph variable
    - The base type variable can point to a derived type
- We need to trick the static analyzers -> we will get runtime error
  - We can't be sure about the derived types in compilation time

## Equality

- With binary operation
- monomorf
- static typesystem
  - covariant parameter
  - `like Current`
- static typesafety

```eiffel
class ANY
...
feature
    frozen twin: attached like Current
        ...
    is_equal( other: attached like Current ): BOOLEAN
        ...

    frozen equal( a: detachable ANY; b: like a ): BOOLEAN
        do
            if a = Void then
                Result := b = Void
            else
                Result := b /= Void and then a.is_equal(b)
            end
end -- class ANY
```

- With reference types
  - equality of references
    - `a = b`
  - object (content) equality
    - custom
      - `a ~ b`
    - shallow
      - `a ~ b`
    - deep
- With expanded types
  - object (content) equality
    - custom
      - `a ~ b`
      - `a = b`
    - shallow
      - `a ~ b`
      - `a = b`
    - deep
- Shallow
  - 2 objects' field are equals (`=`)
  - `standard_equal(a,b)`
  - `a.standard_is_equal(b)`
- Deep
  - 2 objects' field are deeply equals (recursive)
  - `deep_equal(a,b)`
  - `a.is_deep_equal(b)`
- Custom
  `a ~ b`
  `equal(a,b)`
  `a.is_equal(b)`
- `is_equal` is redefinable
- Same with copy
  - `standard_copy(b)`: we copy b fields to Current
    - ensure `standard_equal(Current, b)`
  - `deep_copy(b)`: we copy b fields into Currrent (deeply)
    - ensure `deep_equal(Current, b)`
  - `copy(b)`
    - default in `ANY`: `standard_copy`
    - ensure `equal(Current,b)`

## Types

### Private inheritance

- Does not provide sub-type relation
- Only code inheritance

```eiffel
deferred class COMPLEX
inherit {NONE}
    MATH
feature
...
invariant
    arg < 2 * Pi
    arg >= 0
end
```

- `Complex` not <: `Math`

### Expanded type inheritance

- Expanded classes do not have sub-types
- Expanded class can be sub-type of reference types like `PAIR` <: `ANY`

```eiffel
expanded class PAIR
feature
    a, b: INTEGER
end

(expanded) class TRIPLE
inherit PAIR
feature
    c: INTEGER
end
```

- `TRIPLE` not <: `PAIR`

### Type conversions

- Upcast
- Downcast
- Other conversions
- Eplicit or implicit
- Conversion or reinterpretation

#### Upcast

- Through sub-types
- `POLAR_COMPLEX` <: `COMPLEX`
- Implicit, reinterpretation

```eiffel
local
    c: attached COMPLEX
    pc: attached POLAR_COMPLEX
do
    create {POLAR_COMPLEX} c
    create pc
    c := pc
end
```

#### Downcast

- With dynamic typechecking
- Explicit, reinterpretation

```eiffel
local
    c: attached COMPLEX
    pc: attached POLAR_COMPLEX
do
    create {POLAR_COMPLEX} c
    pc := c -- compilation error
    if attached {POLAR_COMPLEX} c as p then
        pc := p
    end
end
```

#### Conversion methods/functions

- Automatic conversion

```eiffel
class DATUM
create make, make_masnap, from_array
convert
    from_array( {ARRAY[INTEGER]} ) -- conversion method
feature
    from_array(arr: attached ARRAY[INTEGER])
        require arr.count = 3
        ...
        end
...
end

d: DATUM
...
d := <<1848,3,15>>
```

```eiffel
class FRACTION
create set,from_integer
convert from_integer({INTEGER}),to_real:{REAL_64}
feature
    numerator, denominator: INTEGER

    set(n,d:INTEGER)
        require
            d /= 0
        do
            numerator := n; denominator := d
        end

    from_integer(i:INTEGER)
        do
            set (i, 1)
        end

    to_real: REAL_64
        do
            Result := numerator / denominator
        end

    divided_by alias "/" convert (f: attached like Current): attached like Current
        ...
invariant
    denominator /= 0
end

f: attached FRACTION
r: REAL_64
...
f := 3
f := f / 4
r := f / 4
f := 4 / f -- only if `divided_by` has convert flag
```

#### Type compatibility

- Conformity (sub-type)
  - Introduce it with inheritance
  - Exceptions: private inheritance, extended types
- Convertability
- Type equivalence
  - Nominal: if we define in the code the equality
    - Only defined relations
    - Typical through OOP
  - Structural: if the structures are the same
    - Inductive definition
    - Contravariant arguments with functions

#### Type constructions

- Element type
- Array, queue
- Tuples
- Records
  - Orders of the members are not important
- Function
- Classes

```eiffel
class SKIER
create
    set
feature
    roommate: detachable like Current
feature {NONE}
    set( make: detachable like roommate ) -- unmodifiable reference (cannot be override) - better than like Current
        do
            roommate := mate
        end
end

class GIRL inherit SKIER create set end
```

#### Duck-typing

- Dynamic types
- In interpreted languages (like Python)
- Similar to structural sub-types

#### Prototype base languages

- Like JS
- We are creating new objects with cloning other objects
- The objects are dynamically extendables (no inheritance required)
- Typical in interpreted languages

## Multiple Inheritance

- It is supported by Eiffel
- Public or private inheritance (paralell)
- Maximum one conform (public), multiple private
- Repeated inheritance (`ANY`)

### Independent base classes

```eiffel
class CELL [G]
create put
feature
    item: G
    put, replace (v: like item)
        do
            item := v
        ensure
            item_inserted: item = v
        end
end -- class CELL
```

```eiffel
class LINKED
feature
    next: detachable like Current assign set
    set(v:detachable like Current)
        do
            next := v
        ensure
            next = v
        end
end -- class LINKED
```

```eiffel
class LIST[T]
inherit {NONE}
    CELL[T]
    LINKED
end
```

```eiffel
class FRACTION inherit NUMERIC COMPARABLE HASHABLE ... end
```

- All features should be different from the others
  - We can rename the features

```eiffel
class STATEMENT
feature
    is_right: BOOLEAN
end

class PARTY
feature
    is_right: BOOLEAN
end

class CAMPAIGN_PROMISE
inherit
    STATEMENT
        rename is_right as holds
        redefine holds
    end
    PART
end

local
    s: STATEMENT
do
    create {CAMPAIGN_PROMISE} s
    if s.is_right then ...
```

- We can inherit the same feature with the same name and same implementation from the same place
  - like `is_equal` from `ANY`
- But we cannot inherit with different implementation
  - Maximum one implementation/feature
  - We can inherit them (both of them), with different names

### Dynamic binding

```eiffel
class FRACTION
inherit NUMERIC rename is_equal as eq end
inherit COMPARABLE select is_equal end
end

local
    a: ANY
    n: NUMERIC
    c: COMPARABLE
    f: FRACTION
do
    create f; a := f; n := f; c := f
    f.is_equal(f)
    c.is_equal(c)
    n.is_equal(n)
    a.is_equal(a) -- we need the `select` for this
```

- If we inherit with same name from different ways
  - We only get one of them (`join`)
- If the names are different: we got more of them
- If we inherit different implementation then we can't `join`
- We can delete implementation during inheritance with `undefine`
- We can't join different features

### Repeated inheritance

```eiffel
class BINTREE[T]
inherit CELL[T] -- provides item and put
inherit {NONE}
    LINKED
        rename
            next as left,
            set as set_left
        end
    LINKED
        rename
            next as right,
            set as set_right
        end
create put
end
```

## Visibility

- Control visibility in selective mode
  - We can define the visibilit to other classes and sub-types

```eiffel
create {A,B,C} make
feature {A,B}
end
```

- {ANY} or nothing
  - public
- {A} to class A
  - protected like
- {NONE}
  - secret
  - object private - for instance
  - A {NONE} feature/create can be se by the object itself, but it cannot us to other objects' same method

```eiffel
class BASE
feature {NONE}
    v: INTEGER
feature
    query(other: BASE): INTEGER
    do
        Result := other.v -- compilation error
    end
end

class SUB
inherit BASE
feature
    mine: INTEGER
        do
            Result := v -- ok
        end
end
```

### Private inheritance extended

- non-conforming
- Not create sub-type relation
- Can inherite from `frozen` class too (becase `frozen` class cannot have sub-types, and its not creating)

```eiffel
frozen class SEQUENCE[T]
end

class QUEUE[T]
inherit {NONE} SEQUENCE[T]
end
```

- We also can change visibility during the inheritance

```eiffel
class QUEUE[T]
inherit {NONE} SEQUENCE[T]
    export {ANY} hiext, lov, lorem, size;
        {QUEUE} all
    end
end

class DEQUE[T]
inherit QUEUE[T] export {ANY} hirem, hiv, loext end
end
```

- Covariant visibility
  - Contravariant parameter types
  - Covariant return types
  - Covariant exception types
  - Covariant visibility
- We can decrease the visibility
  - It's against the LSP
  - CAT problem
  - Through polymorphic dynamic binding
    - It is possible that the visibility of an attribute or feature is hidden in the derived class

### Changing attributes

- An object has right to edit own attributes
  - Also the secret inherited
- Other objects just can request (with rutine calling)
- Hiding of the attributes
  - Not Eiffel style - don't do that
- Don't let references destroy an object's state from outside

```eiffel
class PERSON
create
    make
feature
    name: STRING
feature {NONE}
    make( str: STRING )
        do
            name := str.twin
        ensure
            name ~ str
        end
end

p: PERSON
p2: PERSON
str: STRING
...
create p.make("Buffalo Bill")
p.name[10] := 'u' -- access to the inside state
str := "Buffalo Bill"
create p2.make(str)
str[10] := 'u' -- access to the inside state
```

## Type parameters

- Parametric polymorphism
- Generic construction
- Only class can be generic (rutines are not)
- There is no existence quantal
  - Exists a type that we used for List, but we don't know that type: `?`

### Universal quantal

- `class STACK[T]`
- We define the `STACK` class for all `T` type

### Restricted parametric polymorphism

- Bounded quantification / constrained genericity
- We can give restrictions for types
- `class HASHTABLE [K -> HASHABLE, V]`

### Generic parameter variance

- Covariant the type parameter
  - If `STACK[T]` then
    - `STACK[INTEGER]` <: `STACK[ANY]`
    - not safety type system
  - If the type is `frozen` then invariant
    - `STACK[frozen T]` then
      - `STACK[INTEGER]` not <: `STACK[ANY]`

### Generic type examples

- `VECTOR[G -> ADDABLE]` - ADDABLE features usable on G
- `HASHTABLE[K -> HASHABLE, V]` - multiple type parameters
- `VECTOR[G -> {ADDABLE, HASHABLE}]` - more constraints on type parameters
- `VECTOR[G -> ADDABLE create make end]` - instantiation ok
- `VECTOR[?G -> ADDABLE]` - self-initializing type required
- `VECTOR[G -> ADDABLE rename add as plus end]` - new feature name
- `VECTOR[G -> {A rename v as w, B}]` -- avoid name clashes
- `VECTOR[frozen G -> ADDABLE]` -- invariant generic param
- `VECTOR[frozen ?G -> {A rename v as w, B} create make end]`

### Tuples

- Built-in type
- Like the generics but it can have any type parameters

```eiffel
t2: TUPLE[INTEGER, INTEGER]
t2 := [1,3]
t3: TUPLE[i,j: INTEGER; r: REAL]
t3 := [1,3,0.0]
t2.item(0) -- ANY type
t3.i -- INTEGER type
```

- covariant sub-type system
- `TUPLE[INTEGER,STRING]` <: `TUPLE[INTEGER,ANY]` <: `TUPLE[INTEGER]` <: `TUPLE[ANY]` <: `TUPLE`

### Mixins

- Inherit from type parameter
- It's not possible in Eiffel -> Linear inheritance

## Exceptions

- Extreme event agains the program workflow
  - Computer or operation system signal
  - Dynamic semantic error
  - Contract breaking
  - Or our program raise the exception
    - Rare
- If we not handle it, it will spreading through the call chain
- It can cause the stopping our program
- Stack trace
- Robust applications
  - Exception handling
- In Eiffel
  - We plan forward, not handle after
  - We provide the prerequisitions for the PRE conditions
  - Liability management instead of Exception handling
- `rescue` clause
  - It connects to the rutines
  - It can contain `retry`
- If an exception raise
  - The rutine's catch it and redirects to the `rescue` clause
    - If we call `retry` then the rutine re-execute itself
      - The `local` state won't chang between the executions
      - We can have multiple `retry` or zero
    - If not call `retry` then the exception goes to the caller

```eiffel
my_routine
    local
        already_tried: BOOLEAN
    do
        if not already_tried then
            -- exectue normal operation
        else
            -- execute plan B
        end
    rescue
        if not already_tried then
            already_tried := True
            retry
        end
    end
```

```eiffel
attempt_transmission(message: STRING)
    local
        failures: INTEGER -- zero by default
    do
        if failures < 50 then
            transmit (message)
            successful := True
        else
            successful := False
        end
    rescue
        failures := failures + 1
        retry
    end
```

### Exception correct program

- Organized panic
  - Finish `rescue` without `retry`
  - We can't reach the post-condition (`ensure` part)
  - We has to reset the class invariant
  - `{True} rescue_without_retry_r {INVc}`
    - INVc - class invariant
- Retrying
  - the rutine re-exectues itself after the `retry`
  - We need to ensure about the pre-condition
  - `{True} rescue_with_retry_r {INVc and PREr}`
    - INVc - class invariant
    - PREr - r routine's pre-condition (`require` part)

### Default rescue clause

- If a rutine does not have explicit `rescue`, then it will inherit from `ANY` - `default_rescue` rutine (maybe its renamed)
- In `ANY` the `default_rescue` is empty
- We can redefine the `default_rescue`
  - It cannot contain `retry`
  - The default class exception handling strategy
  - It can be `default_create`

## Program correctness

- Proved correct codes
  - correct-by-construction
- Modell check
- Formal static correctness proving
- Or run-time correctness proving

### Static checking

- With logical tool
  - External language or tool
  - Metaprogramming or language process tools
  - Or inside the language

### Contracts

- By developer
  - From the documentation
  - Static
  - Dynamic
    - `no`, `require`, `ensure`, `invariant`, `all`
    - `debug`
- pre-condition, post-condition
- class invariant
- loop invariant, loop variant function
- check
- `require`, `require else`, `ensure`, `ensure then`, `invariant`, `variant`, `old`, `strip`
- logical operations: `implies`
- clauses: `and` connections, optional names and optional `;`
- Inheritance
  - class invariant: `and` connections
  - redefine
    - pre-condition: `or` connections (`require else`)
    - post-condition: `and` connections (`ensure then`)

### Class check

- Class correct, loop correct, check correct, exception correct
- Handling contracts (pre-conditions)
  - The exception handling is the last solution

# Exam

## Titkositasi sema

- 3 alg.: *Gen, Enc, Dec*
  - *Gen*: kulcsgeneralas, valoszinusegi alg.
  - *Enc*: titkositas, valoszinusegi alg.
  - *Dec*: visszafejtes, determinisztikus alg.
- *M* uzenet ter
- *K* kulcs ter
- *C* titkosuzenet ter

## Tökéletes biztonság

> Egy titkosítási séma tökéletesen biztonságos `M` felett, ha `∀M` feletti eloszlásra, `∀m ∈ M`, `∀c ∈ C`

`P r(M = m) = P r(M = m|C = c)`

## Tökéletes megkülönböztethetetlenség

> Egy titkosítási séma tökéletesen biztonságos `M` felett, ha `∀M` feletti eloszlásra, `∀m1` , `m2 ∈ M`, `∀c ∈ C`

`P r(C = c|M = m1 ) = P r(C = c|M = m2 )`

## Véletlen sorozatok generálása

- Hatékony támadó -> Értelmes időben
  - Probabilisztikus polimon idejű (**PPT**) támadó.
- Esélytelen támadó ->  Értelmes eséllyel
  - Elhanyagolható valószínűséggel sikeres a törés.
- Egy rendszer `(t, ε)`-biztonságos, ha `∀` legfeljebb `t` futási idejű támadó legfeljebb `ε` valséggel töri a rendszert.

## Támadó

### 1 lehallgatás

> Egy `Π` = (*Gen*, *Enc*, *Dec*) titkosítás megkülönböztethetetlen 1 lehallgatás esetén, ha `∀A` `PPT` támadóra `∃e(.)` elhanyagolható függvény, amire: `P(PrivK(n) = 1) <= 1/2 + e(n)`

### Szabadon választott üzenetek

- Orákulumként hozzáfér `Enck (.)`-hez

> Egy `Π` = (*Gen*, *Enc*, *Dec*) titkosítás megkülönböztethetetlen választott nyíltszöveges támadás esetén (CPA-biztonságos), ha `∀A` `PPT` támadóra `∃e(.)` elhanyagolható függvény, amire: `P(PrivK(n) = 1) <= 1/2 + e(n)`

## Pszeudovéletlenség (**PR**)

> Pszeidovéletlen sorozat egyenletes valódi véletlennek látszik (PPT szemszögből)

### Next-bit teszt

- A sorozat `∀i`:
  - Ha ismeri a sorozat első `i` bitet, akkor a kovetkezo bitet `1/2 + e` valószínűséggel tudja csak megtippelni.
  
## Kongruenciák

> `a, b, m ∈ Z` esetén `a ≡ b (mod m)`, ha `m|a − b`.

### Lineáris kongruenciák

> `a, b, m ∈ Z, m > 1` esetén keresünk `x ∈ Z` értékeket, amire `ax ≡ b (mod m)`

- `a, b, m ∈ Z, m > 1` esetén az `ax ≡ b (mod m)` lineáris kongruencia pontosan akkor oldható meg, ha `(a, m)|b`.

## Maradékrendszerek

- Maradékosztályok halmaza: Egy `a ∈ Z` által reprezentált osztály: `a = {x ∈ Z : x ≡ a (mod m)}`

## Folyam-titkosítók

- Tetszőleges hosszúságú üzenet(folyam) titkosítása
- One-time pad számítási közelítése `PRG`-vel + randomizálás
- ha `G` PRG, akkor ez több lehallgatás ellen biztonságos titkosítás
- One-time pad minta

## Pszeudovéletlen függvény-család (PRF)

- Hossztartó fv-család
- Fix `k ∈ {0, 1}n` -re `Fk (.)` a fv-család egy eleme
- Egy random elem a családból `PPT` megkülönböztethetelen egy random fv-től a fv-ek ismeretében

## Erős pszeudovéletlen permutáció-család (erős PRP)

- Specialis `PRF`
- Hossztartó fv-család, ami bijekció
- Fix `k ∈ {0, 1}n` -re `Fk (.)` a fv-család egy eleme
- Egy random elem a családból `PPT` megkülönböztethetelen egy random fv-től a fv-ek és az inverzeik ismeretében

## Blokk-titkosítók

- `m = (m1 , . . . , ml )` amire `∀i : |mi | = n` (padding)
- Jobban vizsgált, kevesebb törés, de a folyamtitkosító hatékonyabb

### ECB - Electronic Code Book

- Fk (.) erős `PRP`
- Fk (.)−1 hatekony szamolas
- Determinisztikus => nem CPA bizt.
- Lehallgatás ellen nem véd

### CBC - Cipher Block Chaining

- `IV ∈R {0, 1}n` inicializáló vektor - valodi random
- Probabilisztikus
- Fk (.) erős `PRP` => CPA bizt.
- Szekvenciális

### OFB - Output Feedback

- `IV ∈R {0, 1}n` inicializáló vektor - valodi random
- Probabilisztikus
- Fk (.) `PRF` => CPA bizt.
- Szekvenciális
- Előzetes számítások

### CTR - Counter

- `IV ∈R {0, 1}n` inicializáló vektor - ctr
- Probabilisztikus
- Fk (.) `PRF` => CPA bizt.
- Előzetes számítások
- Párhuzamosítható
- Random lekérdezés (csak az i. blokk visszafejtése)

## Feistel hálózatok

- m ∈ {0, 1}n titkosítása, n a blokkhossz
- t + 1 körös iterált titkosító
- k kulcsból generált részkulcsok minden körre
- F round function (nem kell invertalhatonak lennie)
- blokkok részblokkokra bontása + keverése
- a F (.) PRF ⇒ 3 kör után PRP, 4 kör után erős PRP
- Formátum megőrző titkosítás

## Substitution-permutation hálózatok

- m ∈ {0, 1}n titkosítása, n a blokkhossz
- több körös
- k kulcsból generált részkulcsok
- körönként változó S(ubst)-boxok és P(ermut)-boxok
- S-box: helyettesítéses fvek (bijektiv)
- P-box: permutáció (egyenletes)
- egyszerű, hardverben hatékony bitműveletek
- Confusion-diffusion
- S-P párhuzamosítható

## Hash

- Kompressziós függvény, adat tömörítés
- Tetszőleges input-hossz
- `H : {0, 1}∗ 7→ {0, 1}n`
- ütközés: `x /= x0 : H(x) = H(x0 )`
- „jó” hash függvény, ha kevés ütközés van - megfelelően szétszórja

> A H(.) függvény ütközés-mentes, ha bármely PPT támadó csak elhanyagolható valószínűséggel talál ütközést.

> Második őskép biztonság: adott x-hez PPT támadó nem képes találni x0 6= x : H(x0 ) = H(x)

> Őskép biztonság: adott y = H(x)-hez, random (és ismeretlen) x esetén PPT támadó nem képes találni x0 : H(x0 ) = y

### Lavina hatás

- kis változás az inputban ⇒ nagy változás az outputban
- Szigorú lavina kritérium: ha egy input bitet megváltoztaunk ⇒ minden output bit 1/2 valószínűséggel megváltozik
- Bit függetlenség kritérium: ∀i, j, k : ha az i-ik input bit megváltozik ⇒ a j, k output bitek megváltozása egymástól független

### Születésnap támadás

- Egy H : {0, 1}∗ 7→ {0, 1}n hash-függvényre ütközés található 1/2 valószínűséggel, ha 2n/2 hash értéket kiszámítunk.
- Ha gyorsabban találunk ütközést, mint a születésnap támadás =⇒ a hash-t "feltörtük"

### Merkle-Damgård transzformáció

- Tetszőleges inputú hash függvényekre
- Iteratív konstrukció
- Daraboljuk m-et n hosszú blokkokra
- Inicializáló vektor – IV : z0 szabadon választható
- Biztonság:ha h(.) ütközésmentes, akkor H(.) is az
- Osszenyomás mennyisége mindegy

## Integritás

- Nyílt kommunikációs csatornán
- Autenticitás (hívó-ID, email cím)
- Integritás

## Message Authentication Code (MAC)

- Egy üzenet autentikációs kód egy (*Gen*, *Mac*, *Vrfy*) hármas
- *Gen*: kulcsgeneralas 1^n bizt. param -> k kulcs
- *Mac*: cimke generalas -> t := Mac_k(m)
- *Vrfy*: ellenorzes -> b := Vrfy_k(m, t) -> ha ervenyes akkor b=1, kulonben b=0
- Korrektseg: `Vrfy_k(m, Mac_k(m))=1`

> Egy autentikációs kód adaptív választott nyíltszöveges támadás ellen biztonságos (vagy röviden biztonságos), ha minden `PPT` támadó egy `m` üzenetre egy érvényes `t` MAC címkét csak elhanyagolható valószínűséggel tud készíteni több `t'` címke lekérdezése után `m'` /= `m` üzenetekre.

## Szimmetrikus kulcsú kripto

- közös k titkos kulcs
- titkosítás és visszafejtés mindkét félnek

## Nyilvános kulcsú kripto

- pk, sk nyilvános-titkos kulcspár
- lassabb, tobb kuldovel kommunikacio
- `Π = (Gen, Enc, Dec)`
- *Gen*: kulcsgeneralas - pk, sk
- *Enc*: titkositas - c := Enc_pk(m)
- *Dec*: visszafejtes - Dec_sk(c)
- Korrektsg: Dec_sk(Enc_pk(m)) = m

> Egy `Π = (Gen, Enc, Dec)` nyilvános kulcsú titkosítás megkülönböztethetetlen választott nyíltszöveges támadás esetén (CPA-biztonságos), ha `∀A` `PPT` támadóra `∃e(.)` elhanyagolható függvény

## RSA

- Textbook edition: nem jo mert az *Enc* determinisztikus, nem valoszinusegi alg.
- *Gen*:
  - 1^n bizt. param
  - p,q n-bites primek, N = pq
  - e ∈ {2, . . . , N − 1} : (e, ϕ(N )) = 1
  - d ∈ {2, . . . , N − 1} : ed ≡ 1 mod ϕ(N )
  - pk = (N, e), sk = (p, q, d)
- *Enc*: c ≡ m^e mod N
- *Dec*: m ≡ c^d mod N

### Faktorizáció feladat

- Adott random választott `N` -hez találjunk `p, q : N = pq`.

### RSA feladat

- Adott random választott `N, e, c`-hez találjunk `m : me ≡ c mod N`

## Csoportok

- Legyen G halmaz, · binér művelet G-n. Ekkor a (G, ·) rendezett pár
  1. grupoid
  2. ha · asszociatív is G-n, akkor félcsoport
  3. ha ezen felül ∃s ∈ G : ∀g ∈ G : s · g = g · s = g, akkor semleges elemes félcsoport és s a semleges elem
  4. ha ezen felül ∀g ∈ G∃g −1 ∈ G : g · g −1 = g −1 · g = s, akkor csoport és g −1 a g inverze
  5. ha · kommutatív is G-n, akkor Abel-csoport
  
### Ciklikus csoport

- az összes csoportelem előáll egy fix elem valamilyen hatványaként
- (G, ·) csoport ciklikus, ha
- `∃g ∈ G : G =< g >= {s, g, g 2 , . . . , g i , . . . }`
- `g` a csoport generátora

### Diszkrét logaritmus probléma (DLOG)

- Adott `(G, ·)` ciklikus és `g ∈ G` generátor, valamint `h ∈ G`. Keressünk `x`-et, amire `g^x = h`.

## Diffie-Hellman

- `(G, ·), |G| = q, g ∈ G : G =< g >`
- Aliz választ a ∈_R Z_q−1 kitevőt és elküldi Bobnak g^a -t
- Bob választ b ∈_R Z_q−1 kitevőt és elküldi Aliznak g^b -t
- a közös kulcs g^ab

### Számítási Diffie-Hellman probléma (CDH)

- Adott `(G, ·)` ciklikus és `g ∈ G` generátor, valamint `g^a` , `g^b` , ahol `a, b ∈R Z_q−1` . Számítsuk ki `g^ab` -t

### Eldöntési Diffie-Hellman probléma (DDH)

- Adott `(G, ·)` ciklikus és `g ∈ G` generátor, valamint `g^a` , `g^b` , `h`, ahol `a, b ∈R Z_q−1` , `h ∈ G`. Döntsük el, hogy `h = g^ab` igaz-e.

## Digitális aláírás

- TTP nélkül
- Autentikus
- Hamisíthatatlan
- Nem használható többször
- Integritás
- Letagadhatatlan
- Digitális aláírás = nyilvános kulcsú megfelelője a MAC-nek
- Egyszerubb kulcs kezelés, tobb fogado
- Aláírás nyilvánosan ellenőrizhető
- Aláírás átadható
- MAC-ek 2-3 nagysáégrenddel gyorsabbak
- Aláírási séma egy `(Gen, Sign, Vrfy)` hármas
- Korrektsg: `Vrfy_pk(m, Sign_sk(m)) = 1`

> Egy aláírási séma biztonságos, ha `∀` `PPT` támadó egy m üzenethez tartozó érvényes `σ` aláírást csak elhanyagolható valószínuséggel tud generálni `σ'` aláírások lekérdezése után `m'` /= `m` esetén.
# Lectures

## 02 - Bevezetes

- Nyelvek
  - Termeszetes
    - Complex
    - Nem egyertelmu
  - Mesterseges
- Programozasi nyelvek
  - Mesterseges nyelv
  - Komponensek
    - Szintaxis - Formai stilus
    - Szemantika - Jelentes
    - Pragmatika - Olvashatosag, konvenciok
- Informalis szemantika
  - Nem preciz
- Formalis szemantika
  - Bonyolult, preciz
  - Tulajdonsag, ekivialencia, helyesseg biztositas
  - Alapveto dokumentacio
  - Felre ertesek elkerulese
- Statikus szemantika
  - Nem lehet kornyezet fuggetlen grammatikaval megadni
  - Kornyezet fuggo szintaxis
  - Nevkotesek, tipushelyesseg
- Dinamikus szemantika
  - Hogyan kell vegrehajtani a programot?
  - Mi lesz az eredmenye a vegrehajtasnak?
- Megkozelitesek
  - Attributum grammatikak
  - Operacios (miveleti) szemantika
    - Programtulajdonsagok belatasa
    - Definialja a vegrehajtas modjat
    - Induktivan ad meg atmenetrendszert
    - Jobban v. kevesbe reszletes
  - Denotacios szemantika
    - Matematikai lekepezes
    - Absztraktabb operacios szemantikanal
    - Kompozocionalis nyelvi elemek
    - Van folytatasos stilusa is
  - Axiomatikus szemantika

## 03 - Egyszeru kifejezesnyelv

- Konkret szintaxis
  - Definialja a jol formazott mondatok leirasat
  - Nyelvi elemek preciz, konkret leirasat
- Absztrakt szintaxis
  - Nyelvi szerkezetek irja le es hogy milyen mintak menten epulnek fel
  - Szintaxis fat ad meg
  - Kimaradnak
    - Konkret kulcsszavak
    - Precedencial, asszoc. szabalyok
    - Zarojelek
    - Elvalaszto, terminalo szimbolumok
    - Olvasast segito szimbolumok

> ```s ∈ State = Var -> Z```

- Allapot
  - Olvasas memoriabol nev alapjan
  - Allpot frissitesi irasok
  - Egy fuggveny
- Operacios szemantika
  - Atmeneteket definial allapotok (konfiguracio) kozott
- Konfiguracio
  - Ket forma: Egy kifejezes es allpot parja vagy a kifejezes eredmenye
- Kovetkeztetsi szabalyok
  - Ezek segitsegevel adjuk meg a konfiguracio valtozast
  - Harom resz: Premissza, konkluzio, kiegeszito feltetelek
    - A konkluzio akkor ervenyes, ha premissza levezetheto es a feltetelek teljesulnek
  - Premissza nelkuli szabalyok az axiomak
- Denotacios szemantika
  - Matematikai objektumok
  - Fuggvenyek
    - Altalaban totalisan es kompozicionalisak
- Determinisztikussag

> ```Ha ⟨a, s⟩ ⇒ γ és ⟨a, s⟩ ⇒ γ′ akkor γ =```

- Optimalizacio
  - Helyes, ha nem valtoztatja meg a kifejezesek jelenteset

## 04 - Strukturalis szemantika

- Allapotok kozotti relacio
- Az utasitas eredmenye egy uj allapot
- Megadja hogyan lehet lepesrol lepesre vegrehajtani a programot
  - Atmenetrendszert definialunk konfiguraciok kozott
  - Atmeneteket kovetkeztetesi szabalyokkal adunk meg
  - Termeszetes levezetes
- Atmenetrendszer
  - Vegrehajtas allapotai - konfiguraciok

> ```⟨S, s⟩ ⇒ ⟨S′, s′⟩ - s, s′ ∈ State```
> ```⟨S, s⟩ ⇒ s′ - s, s′ ∈ State```

- Beragadt konfiguracio
  - Ha nincs olyan c konfiguracio, amire a kifejezes kitudna ertekelodni, vagyis nincs olyan c, amire igaz hogy: ⟨S, s⟩ ⇒ c

- S allapothoz tartozo levezetesi lanc vagy:
  - veges konfiguracio sorozat: c0, c1, c2 ... ck (k ≥ 0)
    - es ck terminalo vagy beragadt konfiguracio
  - vegtelen konfiguracio sorozat: c0, c1, c2 ...
- c0 ⇒∗ ci akkor all fent, ha letezik veges sok lepesbol allo atmenetsorozat a konfiguraciok kozott
  - ci terminalo vagy zsakutca konfiguracio

> ```Ha ⟨S1; S2, s⟩ ⇒k s′′ akkor
> létezik egy s′ állapot és k1, k2 természetes számok,
> hogy ⟨S1, s⟩ ⇒k1 s′ és ⟨S2, s′⟩ ⇒k2 s′′, továbbá k = k1 + k2.```

- bizonyitas indukcioval

> ```Ha ⟨S1, s⟩ ⇒k s′ akkor ⟨S1; S2, s⟩ ⇒k ⟨S2, s′⟩```
> ```⟨S1; S2, s⟩ ⇒∗ ⟨S2, s′⟩ nem implikálja, hogy ⟨S1, s⟩ ⇒∗ s′```

- ...

> ```Ha ⟨S1; S2, s⟩ ⇒k s′′ akkor létezik s′ állapot és k1, k2 természetes számok,
> hogy ⟨S1, s⟩ ⇒k1 s′ és ⟨S2, s′⟩ ⇒k2 s′′ és k = k1 + k2.```

- ...

> ```Ha ⟨S1, s⟩ ⇒k s′, akkor ⟨S1; S2, s⟩ ⇒k ⟨S2, s′⟩```

- Fogalmak levezetesi lancokkal kapcsolatban
  - Terminal
    - Ha letezik az ⟨S, s⟩ konfiguracioval veges levezetesi lanc
      - Sikeresen terminal ha letezik olyan s' allapot, amelyre igaz `⟨S, s⟩ ⇒∗ s′`
      - Elakad (abortal)
        - Ha van olyan S' maradekprogram es s' allapot, amelyre `⟨S, s⟩ ⇒∗ ⟨S′, s′⟩` es `⟨S′, s′⟩` egy beragadt konfiguracio
  - Divergal
    - Ha letezik `⟨S, s⟩` konfiguraciobol indulo vegtelen levezetesi lanc: `⟨S, s⟩ ⇒∗ ∞`
- S program vegrehajtasa
  - Mindig terminal, ha minden s allapotbol terminal
  - Mindig divergal, ha minden s allapotbol divergal
- Minden nem terminalo konfiguraciohoz letezik legalabb egy levezetesi lanc
- Determinisztikus: pontosan egy levezetesi lanc tartozik a konfiguraciohoz
- Szemantikus ekvivalencia
  - Megadja, hogy ket utasitas jelentese egyezik-e
  - Ekvivalens S1 es S2 ha minden s allapotra igaz:

> S1 és S2 szemantikusan ekvivalensek `(S1 ≡ S2)` , ha minden s állapotra
> `⟨S1, s⟩ ⇒∗ c` akkor és csak akkor `⟨S2, s⟩ ⇒∗ c`
> `⟨S1, s⟩ ⇒∗ ∞` akkor és csak akkor `⟨S2, s⟩ ⇒∗ ∞`
> ahol c termináló vagy zsákutca konfiguráció.

- Ha az egyik terminal az adott allapotban, akkor a masiknak is kell. Ha nem terminal adott konfiguracioban, akkor a masik nem sem szabad.
- Szemantikus fuggveny
  - `Ssos : Stm → (State ,→ State)`
  - Ha s allapotban elakad vagy divergal, akkor a fuggveny nem definialt

> `Ssos[[S]]s` = s′ ha `⟨S, s⟩ ⇒∗ s′`
> `Ssos[[S]]s` = undefined egyébként

## 06 - Termeszetes szemantika

- Kezdo es vegkonfiguracios kozott atmenetrelaciojakent adjuk meg a jelentest
  - Kulonbozo absztrakcios szint
  - Mindig egyetlenlepessel megadja a vegallapotot
  - Az atmenetrelaciot maskepp adjuk meg
  - Kovetkeztetett atmenet mindig megadja a vegallapotot
    - Csak egyetlen atmenetet kell bizonyitani, de azt nehezebb
- Atmenetrendszer
  - Itt nincsenek koztes atmenetek
  - Nem juthat beragadt konfogiracioba - igazabol itt kiertekelhetetlen lesz a program
- S programm s allapotbol indulva
  - Terminal ha letezik s' allapot, amelyre igaz `⟨S, s⟩ → s′`
    - Mindig terminal, ha minden s allapotbol inditiva terminal
  - Divergal ha nem letezik `⟨S, s⟩ → s′`
    - Mindig divergal, ha minden s allapotbol inditiva divergal
- Levezetesi fak
  - Itt nem agak vannak, hanem levezetesi fak
  - Fa gyokereben a levezetni kivant atmenet szerepel
  - A levelek mindig axiomak
  - Koztes csucsok levezetesi szabalyok konkluzioi, ugy hogy kozvetlen gyerekeik a premisszak
  - Gyokertol epitjuk oket, amig olyan axiomat vagy szabalyt nem talalunk ami illeszkedik a konfiguraciora
    - Ha van ilyen axioma es feltetelei teljesulnek, akkor a vegallapotot meghatarozza a konkluzio jobb oldala, a resz be elkeszult
    - Ha van ilyen kovetkeztetesi szabaly akkor a premisszaihoz is keszitunk levezetesi fakat, ha sikerul es feltetelek is teljesulnek, akkor a vegallapotot meghatarozza a konkluzio jobb oldala es a fa epites kesz
  - Small step-hez kepest sokkal tomorebb, absztraktabb
- Determinisztikus
- Ciklusszemantika szinten rekurziv
- Relaciok levezetese szerinti indukcio
- Szemantikus ekvivalenca
  - S1 es S2 ekivalensek `(S1 ≡ S2)` ha minden s es s' allapotra igaz `⟨S1, s⟩ → s′` akkor és csak akkor, ha `⟨S2, s⟩ → s′`
- Szemantikus fuggveny
  - Parcialis fuggveny: `Sns : Stm → (State ,→ State)`
  - Minden utasithashoz van egy parcialis fuggveny: `Sns[[S]] ∈ State ,→ State`
  - Ha a vegrehajtas terminal s allapotbol, akkor a levezetett s' allapot adja meg az erdemenyt
  - Ha kiertekeles vegtelen ciklus eredmenyes, akkor a szemantikai nem definialt

> `Sns[[S]]s` = s′ ha `⟨S, s⟩ ⇒∗ s′`
> `Sns[[S]]s` = undefined egyébként

- Szemantikai ekvivalencia
  - `Ssos[[S]] = Sns[[S]]`
  - `∀S : Ssos[[S]] = Sns[[S]`
    - Ha az S utasitas vegrehajtasa terminal az egyikben, terminalnia kell a masikban is
    - Ha az S utasitas vegrehajtasa divergal az egyikben, divergalnia kell a masikban is
  - `⟨S, s⟩ ⇒∗ s′ implikálja, hogy ⟨S, s⟩ → s′`
  - `⟨S, s⟩ → s′ implikálja, hogy ⟨S, s⟩ ⇒∗ s′`
  - Ugyanazon pontokon, ugyanugy definialt a szemantika
    - Ssos es Sns mint szemantikus fuggvenyek minden pontos megegyeznek

## 07 - Denotacios szemantika

- A szemantikat fuggvenyek adjak meg
- Nem azt adjuk meg hogy hogyan mukodik, hanem hogy mi a hatasa
- Matematikai objektumokkal jellemezzuk egy-egy konstrukcio jelenteset
- Kornyezetre gyakorolt hatasa az erdekes, tehat hogy mi valtoztatja meg az allapotot
- Parcial fuggveny allapotok kozott - denotacio
- Megadunk egy szemantikus domain halmazt
  - Majd a szintaktikus domain elemeihez a szemantikus domain elemeit rendeljuk a denotacios fuggvennyel
- Denotacios fuggvenyek
  - Teljesek: a szemantikus fuggvenyeket a szintaktikus kategoriak minden mintajara megadjuk
  - Kompozicionalisak: Osszetett kifejezesek jelenteset reszkifejezesek jelentesebol komponaljuk
- Minden S utasitashoz tartozni fog egy parcialis fuggveny
  - `Sds : Stm → (State ,→ State)`
  - `Sds[[S]] ∈ State ,→ State`
- cond segedfuggveny
  - Esetszetvalasztast definial
  - Harom parametere van - feltetel es a ket ag
  - `cond(p, g1, g2)s = g1 s ha p s = tt`
  - `cond(p, g1, g2)s = g2 s ha p s = ff`
  - Ha feltetel igaz, akkor az elso agat hasznalja, egyebkent a masodikat
- Szemantikus fuggveny megadasa nem kiegeszito lepes, hanem maga a szemantikadefinicio
- Specialis zarojelek
  - `[[]]`
  - Az adott szemantikus fuggveny alkalmazva a zarojelek kozott megadjuk a szintaktikus definiciot, ami tartalmazhat metavaltozokat
- Szekvencia denotacios szemantika
  - Fuggveny kompoziciot kepzunk
  - Akkor definialt, ha mind a ket tag definialt az adott allapotban (elso az eredetiben, masodik a modositottban)
  - Ha valamelyik komponens nem definialt, akkor a szekvencia sem (akar az elso vagy a masodik divergal)
- Ciklus denotacios szematika
  - Nem rekurziv, mert az nem kompozicionalis
  - Meg alkotjuk g-t: `g = Sds[[while b do S]]`
    - `g = cond(B[[b]], g ◦ Sds[[S]], idState)`
    - g a fixpont, ezer alkalmazzuk az F funkcionalt
    - `F(g) = cond(B[[b]], g ◦ Sds[[S]], idState)`
    - F legkisebb fixpontjat fogjuk hasznalni
    - `F(g)s = (g ◦ Sds[[S]])s ha B[[b]]s = tt`
    - `F(g)s = s ha B[[b]]s = ff`
    - Fixpont kiszamitasahoz egy fixpont-kombinatort (FIX) hasznalunk, ami egy tetszolegesen sok fixpont kozul kivalasztja a legkisebbet
- Szemantikus ekvivalencia
  - S1 es S2 ekvivalensek (`S1 ≡ S2`) akkor es csak akkor ha `Sds[[S1]] = Sds[[S2]]`
    - Minden s es s' allapotra igaz
      - `Sds[[S1]]s = s′` akkor es csak akkor `Sds[[S2]]s = s′`
      - `Sds[[S1]]s = undef` akkor es csak akkor `Sds[[S2]]s = undef`
- Bizonyithato, hogy az eddigi szemantikadefiniciok (Sds, Ssos es Sns) ekvivalensek
  - Mas absztrakcios szinten definialjak ugyanazt
  - Denotacios a legabsztraktabb
    - Es teljesen kompozicionalis

## 08 - Fixpont elmelet

- `Sds[[program]] = effect`
  - Megadja a szintaktikus elem jelenteset
  - Sds teljesen kompozicionalis
  - Altalaban mintaillesztessel definialjuk
- Pontosabb definicio, csak megfelelo helyeken rendel jelentest
  - `g s = s[x 7→ 0] ha s[x] ≥ 0`
  - `g s = undef egyébként`
- Domain-ek
  - Objektumokat tartalmazo almaz es az elemein vegzett muveletek egyuttese
  - Rendelkezik minimalis (bottom) elemmel
  - Fixpont elmelet: hogy lehet meghatarozni fuggvenyek fixpontjat
  - Domain elmelet: hogyan lehet a fixpont elmeletben hasznalhato domaineket es rajtuk folytonos fuggvenyeket konstrualni
  - `(State ,→ State,⊑,⊥) ahol State = Var → Z`
    - ahol `⊑` rendezes a parcial fuggvenyeket (`State ,→ State`) a kovetkezokeppen rendezi (g1 kevesbe definialt mint g2: `g1 ⊑ g2`)
    - Reflexiv `g1 ⊑ g2`
    - Tranzitiv `g1 ⊑ g2 és g2 ⊑ g3 implikálja g1 ⊑ g3`
    - Antiszimmetrikus `g1 ⊑ g2 és g2 ⊑ g1 implikálja g1 = g2`
  - `⊥` minimalis elem: `⊥s = undef minden s állapotra`
    - Egy ures fuggveny
    - Minden halmazbeli fuggveny jobban definialt, ezert adodik: `⊥ ⊑ g minden g ∈ State ,→ State függvényre`
- Ciklus szemantikaja
  - `Sds[[while b do S]] = cond(B[[b]], Sds[[while b do S]] ◦ Sds[[S]], idState)`
  - `g = cond(B[[b]], g ◦ Sds[[S]], idState)`
    - g behelyetesitese
    - g egy generalo fuggveny
  - `F : (State ,→ State) → (State ,→ State)`
  - `F g = cond(B[[b]], g ◦ Sds[[S]], idState) = g`
    - F finomito fuggveny
    - F fixpontjanak kiszamitasaval megkapjuk a formula megoldasait
  - `Sds[[while b do S]] = FIX F`
- Fixpont kiszamitasa
  - Ha azt szeretnenk, hogy a denotacio a leheto legkevesebb helyen legyen definialva, akkor valojaban `⊑` rendezes szerinti legkisebb fixpontot kell meghatarozni az F fuggveny eseteben
  - A ciklus informalis szemantikaja szerint a ciklusmag hatasat addig ismeteljuk, amig a feltetel hamissa nem valik
  - Leiro szemantika szerint, az F ismetelt alkalmazasaval kozelitjuk, majd az F legkisebb fixpontjaban megkapjuk a szemantika legpontosabb kozeliteset
  - Mivel `⊥` a legkisebb elem, ezert `⊥ ⊑ F(⊥)`, mivel F monoton
    - `⊥ ⊑ F(⊥) ⊑ F(F(⊥)) ⊑ F(F(F(⊥))) ⊑ ...` egyre pontosabb kozelitest add
      - A legkisebb felsokorlat megadja a ciklus szemantikajat
      - `⊥ ⊑ F(⊥) ⊑ F(F(⊥)) ⊑ ... ⊑ FIX F`
        - A legkisebb fixpont egyertelmu
- Valojaban most is egy rekurziv fuggvenyek szemantikajat adtuk meg, hiszen a ciklus kifejezesevel egy rekurzuv formulat kapun, amit rekurziv fuggvenydefiniciok jelentesenek meghatarozasakor kapunk

## 09 - Szemantika definiciok ekvivalenciaja

- A leiro szemantika absztraktabb, magasabb szintu leiras
- A muveleti szemantika kozelebb all a tenyleges vegrehajtashoz. Lepesrol lepesre irja le a program vegrehajtasat
- `Ssos[[S]] = Sds[[S]]`
  - Egyenloseghez (`g1 = g2`) eleg belatni a `g1 ⊑ g2` es `g2 ⊑ g1`
  - `Ssos[[S]] ⊑ Sds[[S]] és Sds[[S]] ⊑ Ssos[[S]]`
- `Ssos[[S]] ⊑ Sds[[S]]`
  - Belathato levezetesi lancok hossza szerinti indukcioval
    - Megmutatjuk hogy 1 hosszu lancokra teljesul
    - Majd felteszzuk, hogy maximum k hosszu lancokra teljesul
    - Majd belatjuk, hogy k + 1 hosszuakra is
- `Sds[[S]] ⊑ Ssos[[S]]`
  - Mivel a denotacios szemantikat kompozicionalisan definialtuk, bizonyithatunk strukturalis indukcio segitsegevel
- Kovetkezes kepp: `Sds[[S]] = Ssos[[S]]`
  - A small-step es big-step ekvivalencia es belathato => mind harom szemantika ekivalens

## 11 - Nyelvi kiegeszitesek az operacios szemantikaban

- Abort
  - Altalaban akkor er veget a vegrehajtas, ha az osszes utasitas elfogyott
  - Ne viszont szukseges lehet az abnormalis leallitas
  - Nem ekvivalens a skippel v. a vegtelen ciklussal
  - Szemantika
    - Nem valtoztatunk a szemantikan, nem irunk fel kovetkeztetesi szabalyt
    - A vegrehajtas megfog akadni
  - Small-step
    - Beregadt konfiguracio jelzik a program elakadasat
      - Beragadt konfiguracio, ha nem tudunk atmenetet levezetni
      - Nincs olyan c konfiguracio amelyre `⟨S, s⟩ ⇒ c`
    - Az abort beragad, mert nem adtunk meg kovetkezo lepes atmenetet
    - Veges levezetesi lancot eredmenyez
  - Big-step
    - Nincsenek beragado konfiguraciok
    - Vagy sikeresen terminalnak vagy nem terminalnak
    - Az abort utasitast tartalmazo program nem szamithatoak ki, mert nem futtathatoak
    - Az abort es while true do skip utasitasok szemantikusan ekivalensek
    - Nem tud kulonbseget tenni az abnormalis terminalas es a divergalas kozott
      - Hiba konfiguracio bevezetese segithet
- Nemdeterminisztikussag
  - Olyan algoritmus, amely kulonbozo futtatasok eseten kulonbozo viselkedest mutathat
  - Nemdeterminisztikus valasztas
  - Big-step
    - `x := 1 or (while true do skip)`
    - Mivel a vegtelen ciklus nem vezetheto le big-step eseten, ezert ez sosem kerulhet valasztasra (nem lehet levezetesi fat epiteni) => elkeruli a szemantika
  - Small-step
    - Ebben az esetben megtortenhet a vegtelen ciklus is
    - `⟨x := 1 or (while true do skip), s⟩ ⇒∗ s[x 7→ 1]`
    - `⟨x := 1 or (while true do skip), s⟩ ⇒∗ ∞`
    - "Rossz" uton is elvegezheto a vegrehajtas
- Konkurens programok
  - Parhuzamos vegrehajtas osszefesuleses technikaval
- Big-step
  - Nem lehet leirni az osszefesulest, mivel teljes kiertekeles tortni
    - Mas parhuzamos konstrukcio kellene

## 12 - Kivetelkezeles szemantikaja

- Ugro (nem strukturalt) utasitasok leiro szemantikaja
  - Milyen domainnel definialhato?
- try...catch szerkezet kivetelkezelo blokkot vezet be
- Az el nem kapott kivetelek tovabbterjednek a kulsobb blokkok fele
- throw: kivetel kivaltasa
  - Megszakitja a blokk futasat, a hatralevo utasitasok nem kerulnek vegrehajtasra
  - A vezerles atadodik egy megfelelo kivetelkezelo kodra
  - A kiertekeles, a kivetelkezelo kod utan normalisan folytatodik a kivetel kezelo blokk utani resszel
- Folytatasos szemantika
  - A kivetel kivaltodasakor tudnunk kell, hogy hogyan folytatodik a programvegrehajtas a kivetelkezelo blokk utan
  - `S′′cs : Stm → State → (State ,→ State) ,→ State`
  - `Cont = State ,→ State`
  - `S′cs : Stm → (Cont → Cont)`
- A direkt szemantikaban azt adjuk meg ami az adott konstrukcio vegrehajtasanak hatasa
- A folytatasos szemantikaban "visszafele" haladva allitjuk elo a konstrukcio jelenteset
  - A folytatas fuggvenyeben adjuk meg mi az utasitas jelentese, ha a megadott folytatas koveti a vegrehajtasban
- `S′cs[[S]]c = c ◦ Sds[[S]]`
- A kivetelkezelt blokk tetszolegesen komplex lehet
- A throw utasitas hatasa fugg attol, hogy a kornyezetben milyen kivetelkezelo blokkokat definialtunk
- A throw viselkedes csak a kornyezet jelentesenek ismereteben adhato meg
  - Ahany kivetelkezelo blokk, annyi lehetseges folytatas
- A kivetelek jelenteset kivetelkornyezetben tartjuk nyilvan
  - `EnvE = Exception → Cont`
  - Definialja mi tortenik a kivetel kivaltasa eseten
  - Ez fugg a kornyezettol
  - `Scs : Stm→ EnvE → (Cont → Cont)`
- Operacios szemantika
  - Kiegeszitjuk a lehetseges konfiguraciokat kivetel-allapot parosokkal
  - Az osszes utasitas eseteben delegalni kell a kiveteleket

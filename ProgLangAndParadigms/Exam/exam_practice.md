# Irányított gráfot reprezentáló adattípus

Készítsünk egy `DIGRAPH` osztályt, amely egy irányított gráfot ábrázol. A gráf csúcspontjaiban tárolt elemek típusát sablonparaméterként kapjuk. Ez az elemtípus `HASHABLE` kell legyen. A gráfot ábrázoljuk hasítótáblával a következőképpen: a kulcsok értelemszerűen a csúcsok lesznek, egy kulcshoz pedig azon csúcsok halmazát rendeljük, ahova vezet él. Használjuk az Eiffel beépített `HASH_TABLE` és `ARRAYED_SET` típusát.

- Valósítsuk meg a legfontosabb gráfműveleteket: csúcs hozzáadása, él létrehozása, és egy feature-t, ami eldönti, hogy van-e él két csúcs között.
- Biztosítsuk azt, hogy élet csak akkor tudunk létrehozni, ha a végpontjai ebben a gráfban vannak.
- A gráf a creation feature-ét örökölje a hasítótáblából (csak nevezzük át init-nek!), amely paraméterként a hasítótábla kapacitását kapja.

## Irányítatlan gráf

Készítsünk egy olyan GRAPH osztályt, amelyet a DIGRAPH osztályból származtatunk, és egy irányítatlan gráfot valósít meg. Ezt úgy érhetjük el, hogy az élet mindkét irányba felvesszük.

## Unió

Készítsünk olyan creation feature-t a DIGRAPH osztályban, amely két gráfot kap paraméterként, és egy olyat hoz létre, amely a két paraméter uniója. A típushelyesség biztosítása mellett (azaz egy irányítatlan gráf nem kaphat irányított gráfot) oldjuk meg, hogy az implementációt ne kelljen felüldefiniálni a GRAPH osztályban.

## Bejárás

Készítsünk egy feature-t, amely a gráf mélységi bejárását végezi el. A feature egy ágenst kap paraméterben, és ezt az ágenst hívja meg minden csúcsra a bejárás során.

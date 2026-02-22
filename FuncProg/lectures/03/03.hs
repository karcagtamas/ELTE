qeq :: Double -> Double -> Double -> (String, [Double])
qeq a b c
    | a == 0.0 = ("Nem masodfoku", [])
    | d < 0.0 = ("Komplexgyokok", [])
    | d == 0.0 = ("Egy gyok", [(negate b) / (2.0 * a)])
    | d > 0.0 = ("Ket gyok", [((negate b) + r) / (2.0 * a), ((negate b) - r) / (2.0 * a)])
    where
        d = b * b - 4.0 * a * c
        r = sqrt d --Radix: sqrt of discrimination

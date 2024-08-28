# README - Problem matričnih napolnitev preko optimizacije na Riemannovih mnogoterostih

## Namen

Ta projekt vključuje MATLAB in Python kodo za izvajanje nizko-rangovne dopolnitve matrike. MATLAB koda je namenjena optimizaciji z uporabo geometrijskega konjugiranega gradienta (CG), medtem ko Python koda služi za pripravo in obdelavo podatkov, kar omogoča pripravo vhodnih podatkov za MATLAB optimizacijo.

## MATLAB Koda

MATLAB koda vsebuje funkcijo `example`, kjer vnesete svoje parametre in datoteke za optimizacijo z uporabo geometrijskega konjugiranega gradienta (CG).

## Python Koda

Python koda se uporablja za pripravo podatkov. Vključuje skripte:

1. **`compute_LR.py`**
   - Naloži matriko iz datoteke, izvede SVD, in shrani rezultate v datoteke za matrične faktorje.

2. **`compute_rang.py`**
   - Izračuna in izpiše rang matrike, shranjene v `.txt` datoteki.

3. **`image_to_txt.py`**
   - Procesira slike v določenem imeniku, pretvori vsako sliko v matriko in shrani te matrike v `.txt` datoteke.

4. **`lower_image_rank.py`**
   - Pretvori sliko v sivo barvo, zmanjša njen rang z uporabo SVD ter shrani in prikaže tako izvirno kot spremenjeno sliko.

5. **`make_noise.py`**
   - Prebere sivo sliko, naključno nastavi določen odstotek pikslov na 0, shrani spremenjeno sliko in matriko, ter shranjuje tudi indekse neničelnih elementov (Omega, Omega_i, Omega_j) in njihove vrednosti v besedilne datoteke.


## Navodila za Uporabo

1. **Python: Priprava podatkov**
   - **Zmanjšanje ranga matrike:** Uporabite skripto `lower_image_rank.py` za zmanjšanje ranga matrike na želeno število. 
   - **Pretvorba v `.txt` datoteko:** Nato uporabite skripto `image_to_txt.py` za pretvorbo slike v `.txt` datoteko.
   - **Izračun komponent L in R:** Uporabite skripto `compute_LR.py` za izračun L in R komponent matrike z zmanjšanim rangom.
   - **Dodajanje šuma:** Z uporabo skripte `make_noise.py` dodajte šum na matriko z zmanjšanim rangom in pridobite potrebne komponente.

2. **MATLAB: Optimizacija**
   - **Nastavitev parametrov:** Odprite datoteko `example.m` in nastavite vrednost `k` (rang matrike) ter preverite poti do L in R komponent, Omega, Omega_i, Omega_j in values.
   - **Konfiguracija:** Ustrezno prilagodite parameter `prob.temp_omega` glede na svoje datoteke.
   - **Shranjevanje rezultatov:** Določite pot in ime za shranjevanje rekonstruirane slike.
   - **Izračun PSNR:** Po potrebi navedite pot do `reference_matrix_path` za izračun PSNR (Peak Signal-to-Noise Ratio).

## Kontakt

Za vprašanja ali težave, prosimo, kontaktirajte ap3956@student.uni-lj.si.
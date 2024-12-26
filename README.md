# README - Problem matričnih napolnitev preko optimizacije na Riemannovih mnogoterostih

## Kazalo
- [Namen](#namen)
- [MATLAB Koda](#matlab-koda)
- [Python Koda](#python-koda)
- [Kontakt](#kontakt)
- [English Version](#readme---matrix-completion-problem-using-optimization-on-riemannian-manifolds)
  - [Purpose](#purpose)
  - [MATLAB Code](#matlab-code)
  - [Python Code](#python-code)
  - [Contact](#contact)

## Namen

Ta projekt je bil pripravljen v okviru [moje diplomske naloge](https://repozitorij.uni-lj.si/Dokument.php?id=190219). Vključuje MATLAB in Python kodo za izvajanje nizko-rangovne dopolnitve matrike. MATLAB koda je namenjena simulaciji optimizacije z uporabo geometrijskega konjugiranega gradienta (CG), medtem ko Python koda služi za pripravo in obdelavo podatkov ter omogoča pripravo vhodnih podatkov za MATLAB optimizacijo.

## MATLAB Koda

MATLAB koda vsebuje štiri primere za simulacijo algoritma:

1. **`example_nakljucna_matrika_multiple_runs`**  
   Primer izvedbe algoritma za rekonstrukcijo matrike z več ponovitvami naključnih matrik.

2. **`example_nakljucna_matrika`**  
   Primer naključne matrike z eno samo ponovitvijo.

3. **`example_slika_gray`**  
   Rekonstrukcija za 2D sliko z enim kanalom (siva slika).

4. **`example_slika_rgb`**  
   Rekonstrukcija za RGB sliko.

Pri simulaciji bodite pozorni, da:
- Nastavite pravilne poti do datotek Omega in datoteke z vrednostmi pikslov.
- Ustrezno določite dimenzije in rang matrike.

## Python Koda

Python koda vsebuje številne skripte za različne korake predobdelave in postobdelave podatkov. Rezultati in izvorne slike, uporabljene za testiranje, so shranjeni v mapi **`podatki`**. Glavne skripte so:

1. **`barvna_obdelava.py`**  
   Procesira barvne slike.

2. **`barvna_rekonstrukcija_ortogonalna_preslikava.py`**  
   Izvaja barvno rekonstrukcijo z uporabo ortogonalne preslikave.

3. **`barvna_rekonstrukcija.py`**  
   Standardna barvna rekonstrukcija brez ortogonalne preslikave.

4. **`bernoullijev_sum.py`**  
   Dodaja Bernoullijev šum v matriko.

5. **`gaussov_sum.py`**  
   Dodaja Gaussov šum v matriko.

6. **`izracun_psnr.py`**  
   Izračuna PSNR (Peak Signal-to-Noise Ratio) za rekonstruirano sliko.

7. **`izracun_rang.py`**  
   Izračuna rang matrike iz datoteke.

8. **`naredi_kvadratno_omego.py`**  
   Doda šum v obliki kvadrata v matriko.

9. **`obdelava_slika_tekst.py`**  
    Naredi matriko iz slike s šumom v obliki besedila.

10. **`siva_obdelava_ortogonalna_preslikava.py`**  
    Procesira sivo sliko z uporabo ortogonalne preslikave.

11. **`slika_v_tekst.py`**  
    Pretvori slike v matrike in jih shrani kot `.txt` datoteke.

12. **`sliki_zmanjsa_rang.py`**  
    Zmanjša rang slike z uporabo SVD ter shrani spremenjeno sliko.

## Kontakt

Za vprašanja ali težave pišite na ap3956@student.uni-lj.si.

---

# README - Matrix Completion Problem Using Optimization on Riemannian Manifolds

## Purpose

This project is part of [my bachelor's thesis](https://repozitorij.uni-lj.si/Dokument.php?id=190219) and includes MATLAB and Python code for performing low-rank matrix completion. The MATLAB code focuses on optimization using the geometric conjugate gradient (CG) method, while the Python code serves for data preparation and processing, enabling input preparation for MATLAB optimization.

## MATLAB Code

The MATLAB code includes four examples for simulations:

1. **`example_nakljucna_matrika_multiple_runs`**  
   An example for reconstructing a matrix with multiple runs using a random matrix.

2. **`example_nakljucna_matrika`**  
   An example for reconstructing a random matrix with a single run.

3. **`example_slika_gray`**  
   Example for reconstructing a 2D image with a single color channel (grayscale).

4. **`example_slika_rgb`**  
   Example for reconstructing an RGB image with multiple color channels.

When running the simulations, ensure that:
- The paths to the `omega` file and pixel values file are correctly set.
- The dimensions and rank of the matrix are appropriately defined.

## Python Code

The Python code provides several scripts for different preprocessing and postprocessing steps. Results and original images used for testing are stored in the `podatki` folder. The available scripts are:

1. **`barvna_obdelava.py`**  
   Processes color images for further analysis.

2. **`barvna_rekonstrukcija_ortogonalna_preslikava.py`**  
   Performs color image reconstruction using orthogonal mapping.

3. **`barvna_rekonstrukcija.py`**  
   Performs color image reconstruction without orthogonal mappings.

4. **`bernoullijev_sum.py`**  
   Adds Bernoulli noise to image data.

5. **`gaussov_sum.py`**  
   Adds Gaussian noise to image data.

6. **`izracun_psnr.py`**  
   Calculates PSNR (Peak Signal-to-Noise Ratio) to evaluate the quality of reconstructed images.

7. **`izracun_rang.py`**  
   Calculates the rank of a matrix stored in a file.

8. **`naredi_kvadratno_omego.py`**  
   Generates a square noise matrix and creates the `omega` file.

9. **`obdelava_slika_tekst.py`**  
    Converts a noisy image into a matrix and saves it as a text file.

10. **`siva_obdelava_ortogonalna_preslikava.py`**  
    Processes grayscale images with orthogonal mappings.

11. **`slika_v_tekst.py`**  
    Converts an image to text format for analysis.

12. **`sliki_zmanjsa_rang.py`**  
    Converts an image to a grayscale version, reduces its rank using SVD, and saves the results.

## Contact

For questions or issues, please contact ap3956@student.uni-lj.si.


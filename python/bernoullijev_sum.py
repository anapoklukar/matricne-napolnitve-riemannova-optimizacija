import numpy as np
from PIL import Image

def modify_and_save_image(image_path, percentage, output_img_path, output_txt_path, omega_file, omega_i_file, omega_j_file, values_file):
    # Odpri sivinsko sliko
    img = Image.open(image_path).convert('L')  # Zagotovi, da je slika v sivinskem formatu
    matrix = np.array(img, dtype=np.float64) / 255.0  # Normaliziraj vrednosti med 0 in 1
    
    # Zagotovi, da je odstotek med 0 in 100
    if not (0 <= percentage <= 100):
        raise ValueError("Odstotek mora biti med 0 in 100")

    # Pretvori odstotek v frakcijo
    fraction = percentage / 100.0

    # Določi skupno število elementov v matriki
    num_elements = matrix.size

    # Izračunaj število elementov, ki jih je treba nastaviti na 0
    num_zeros = int(num_elements * fraction)

    # Ustvari seznam vseh indeksov v matriki
    indices = np.arange(num_elements)
    
    # Naključno premešaj indekse in izberi prvih num_zeros indeksov, da jih nastaviš na 0
    np.random.shuffle(indices)
    zero_indices = indices[:num_zeros]

    # Poglobljena matrika za lažje indeksiranje
    flattened_matrix = matrix.flatten()

    # Nastavi izbrane indekse na 0
    flattened_matrix[zero_indices] = 0

    # Obnovi matriko nazaj v njen prvotni format
    modified_matrix = flattened_matrix.reshape(matrix.shape)

    # Shrani spremenjeno matriko v besedilno datoteko (vrednosti med 0 in 1)
    np.savetxt(output_txt_path, modified_matrix, fmt='%.6f')
    print(f"Spremenjena matrika shranjena na {output_txt_path}")

    # Pretvori spremenjeno matriko nazaj v razpon 0-255 za shranjevanje kot sliko
    modified_img_matrix = (modified_matrix * 255).astype(np.uint8)

    # Shrani spremenjeno sliko
    modified_img = Image.fromarray(modified_img_matrix)
    modified_img.save(output_img_path)
    print(f"Spremenjena slika shranjena na {output_img_path}")

    # Izračunaj Omega (indeksi elementov, ki niso nastavljeni na 0)
    omega_indices = np.setdiff1d(indices, zero_indices)  # Indeksi ne-nul elementov

    # Shrani Omega (1-bazirano indeksiranje za združljivost)
    np.savetxt(omega_file, omega_indices + 1, fmt='%d')
    print(f"Omega shranjena na {omega_file}")

    # Izračunaj Omega_i in Omega_j (indeksi vrstic in stolpcev ne-nul elementov)
    omega_i, omega_j = np.unravel_index(omega_indices, matrix.shape)

    # Shrani Omega_i (1-bazirani indeksi za združljivost)
    np.savetxt(omega_i_file, omega_i + 1, fmt='%d')
    print(f"Omega_i shranjena na {omega_i_file}")

    # Shrani Omega_j (1-bazirani indeksi za združljivost)
    np.savetxt(omega_j_file, omega_j + 1, fmt='%d')
    print(f"Omega_j shranjena na {omega_j_file}")

    # Izloči vrednosti, ki ustrezajo ne-nul pikslom
    non_zero_values = flattened_matrix[omega_indices]

    # Shrani vrednosti ne-nul pikslov v besedilno datoteko
    np.savetxt(values_file, non_zero_values, fmt='%.6f')
    print(f"Vrednosti, ki ustrezajo Omega, shranjene na {values_file}")

# Primer uporabe
image_path = 'tokyo_podatki/knjige_rank60.jpg'  # Pot do vaše sivinske slike
percentage = 10 # Nastavi 10% pik na 0
output_img_path = 'tokyo_podatki/knjige_rank60_noise10.jpg'  # Pot za shranjevanje spremenjene slike
output_txt_path = 'tokyo_podatki/knjige_rank60_noise10.txt'  # Pot za shranjevanje spremenjene matrike
omega_file = 'tokyo_podatki/omega.txt'  # Pot za shranjevanje Omega (indeksi, ki niso nastavljeni na 0)
omega_i_file = 'tokyo_podatki/omega_i.txt'  # Pot za shranjevanje Omega_i
omega_j_file = 'tokyo_podatki/omega_j.txt'  # Pot za shranjevanje Omega_j
values_file = 'tokyo_podatki/values.txt'  # Pot za shranjevanje vrednosti ne-nul pikslov

modify_and_save_image(image_path, percentage, output_img_path, output_txt_path, omega_file, omega_i_file, omega_j_file, values_file)

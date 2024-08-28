import numpy as np
from PIL import Image

def modify_and_save_image(image_path, percentage, output_img_path, output_txt_path, omega_file, omega_i_file, omega_j_file, values_file):
    # Odpri sivo sliko
    img = Image.open(image_path).convert('L')  # Zagotovi, da je slika v sivi barvi
    matrix = np.array(img)

    # Preveri, da je odstotek med 0 in 100
    if not (0 <= percentage <= 100):
        raise ValueError("Odstotek mora biti med 0 in 100")

    # Pretvori odstotek v delež
    fraction = percentage / 100.0

    # Določi skupno število elementov v matrici
    num_elements = matrix.size

    # Izračunaj število elementov, ki jih bomo nastavili na 0
    num_zeros = int(num_elements * fraction)

    # Ustvari seznam indeksov vseh elementov v matrici
    indices = np.arange(num_elements)
    
    # Naključno premešaj indekse in izberi prvih num_zeros indeksov, ki jih bomo nastavili na 0
    np.random.shuffle(indices)
    zero_indices = indices[:num_zeros]

    # Poenostavi matrico za lažje indeksiranje
    flattened_matrix = matrix.flatten()

    # Nastavi izbrane indekse na 0
    flattened_matrix[zero_indices] = 0

    # Preoblikuj matrico nazaj v njeno izvirno obliko
    modified_matrix = flattened_matrix.reshape(matrix.shape)

    # Pretvori spremenjeno matrico nazaj v sliko
    modified_img = Image.fromarray(modified_matrix.astype(np.uint8))

    # Shrani spremenjeno sliko
    modified_img.save(output_img_path)
    print(f"Spremenjena slika shranjena v {output_img_path}")

    # Shrani spremenjeno matrico v besedilno datoteko
    np.savetxt(output_txt_path, modified_matrix, fmt='%d')
    print(f"Spremenjena matrica shranjena v {output_txt_path}")

    # Izračunaj Omega (indeksi nenicelnih elementov v poenostavljeni matriki)
    non_zero_indices = np.nonzero(flattened_matrix)[0]  # Indeksi nenicelnih elementov

    # Shrani Omega (1-podani indeksi za združljivost)
    np.savetxt(omega_file, non_zero_indices + 1, fmt='%d')  # Pretvori v 1-podane indekse
    print(f"Omega shranjena v {omega_file}")

    # Izračunaj Omega_i in Omega_j
    num_rows, num_cols = matrix.shape
    omega_i, omega_j = np.unravel_index(non_zero_indices, (num_rows, num_cols))

    # Shrani Omega_i (1-podani indeksi za združljivost)
    np.savetxt(omega_i_file, omega_i + 1, fmt='%d')  # Pretvori v 1-podane indekse
    print(f"Omega_i shranjena v {omega_i_file}")

    # Shrani Omega_j (1-podani indeksi za združljivost)
    np.savetxt(omega_j_file, omega_j + 1, fmt='%d')  # Pretvori v 1-podane indekse
    print(f"Omega_j shranjena v {omega_j_file}")

    # Izvleči vrednosti, ki ustrezajo nenicelnim pikslom
    non_zero_values = matrix.flatten()[non_zero_indices]

    # Shrani vrednosti nenicelnih pikslov v besedilno datoteko
    np.savetxt(values_file, non_zero_values, fmt='%d')
    print(f"Vrednosti, ki ustrezajo Omegi, shranjene v {values_file}")

# Primer uporabe
image_path = 'tokyo_podatki/tokyo_rank15.jpg'  # Pot do vaše sive slike
percentage = 50  # Nastavite 50% pikslov na 0
output_img_path = 'tokyo_podatki/tokyo_rank15_noise50.jpg'  # Pot za shranjevanje spremenjene slike
output_txt_path = 'tokyo_podatki/tokyo_rank15_noise50.txt'  # Pot za shranjevanje spremenjene matrice
omega_file = 'tokyo_podatki/omega.txt'  # Pot za shranjevanje Omega
omega_i_file = 'tokyo_podatki/omega_i.txt'  # Pot za shranjevanje Omega_i
omega_j_file = 'tokyo_podatki/omega_j.txt'  # Pot za shranjevanje Omega_j
values_file = 'tokyo_podatki/values.txt'  # Pot za shranjevanje vrednosti nenicelnih pikslov

modify_and_save_image(image_path, percentage, output_img_path, output_txt_path, omega_file, omega_i_file, omega_j_file, values_file)

import numpy as np
from PIL import Image

def process_image(image_path, omega_file, values_file):
    # Odpri sivinsko sliko
    img = Image.open(image_path).convert('L')  # Prepričaj se, da je slika v sivinskem načinu
    img_array = np.array(img, dtype=np.float64)  # Pretvori sliko v numpy matriko

    # Normaliziraj vrednosti pikslov med 0 in 1
    img_array_normalized = img_array / 255.0

    # Najdi ne-črne piksle (kjer je vrednost piksla večja od 0)
    non_black_indices = np.nonzero(img_array)
    
    # Pretvori indekse in vrednosti v enotno dimenzionalne za lažje obdelovanje
    flat_indices = np.ravel_multi_index(non_black_indices, img_array.shape)
    flat_values = img_array_normalized[non_black_indices]

    # Prilagodi indekse, da se začnejo od 1
    flat_indices_one_based = flat_indices + 1

    # Shrani Omega (indeksi ne-črnih pikslov) z začetkom pri 1
    np.savetxt(omega_file, flat_indices_one_based, fmt='%d')
    print(f"Omega shranjena na {omega_file}")

    # Shrani vrednosti ne-črnih pikslov
    np.savetxt(values_file, flat_values, fmt='%.6f')
    print(f"Vrednosti shranjene na {values_file}")

# Primer uporabe
image_path = 'tokyo_podatki/volna_rank60_text_large.jpg'  # Pot do tvoje sivinske slike
omega_file = 'tokyo_podatki/omega.txt'  # Pot za shranjevanje Omega (indeksi ne-črnih pikslov)
values_file = 'tokyo_podatki/values.txt'  # Pot za shranjevanje vrednosti ne-črnih pikslov

process_image(image_path, omega_file, values_file)

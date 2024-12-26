import numpy as np
from PIL import Image
from scipy.linalg import svd

def reduce_rank(matrix, k):
    """Zmanjša rang dane matrike na k z uporabo SVD."""
    U, S, Vt = svd(matrix, full_matrices=False)
    S = np.diag(S[:k])
    U = U[:, :k]
    Vt = Vt[:k, :]
    return np.dot(U, np.dot(S, Vt))

def process_image(image_path, k, square_size, square_position, output_image_path, omega_file, values_file):
    # Odpri sliko in jo pretvori v sivinsko
    img = Image.open(image_path).convert('L')
    img_array = np.array(img, dtype=np.float64)

    # Normaliziraj sliko v razpon [0, 1]
    img_array_normalized = img_array / 255.0

    # Zmanjšaj rang slike
    img_reduced = reduce_rank(img_array_normalized, k)

    # Postavi črn kvadrat na sliko
    x_start, y_start = square_position
    x_end, y_end = x_start + square_size, y_start + square_size
    img_reduced[y_start:y_end, x_start:x_end] = 0

    # Shrani sliko s črnim kvadratom
    img_with_square = Image.fromarray((img_reduced * 255).astype(np.uint8))
    img_with_square.save(output_image_path)
    print(f"Sliko s črnim kvadratom shranjena na {output_image_path}")

    # Ustvari Omega (vse pike razen kvadrata)
    omega = np.ones_like(img_array, dtype=bool)
    omega[y_start:y_end, x_start:x_end] = False
    omega_indices = np.nonzero(omega.flatten())[0]

    # Shrani Omega (indeksi piksla, ki niso v kvadratu)
    np.savetxt(omega_file, omega_indices + 1, fmt='%d')
    print(f"Omega shranjena na {omega_file}")

    # Shrani vrednosti ne-kvadratnih pikslov
    values = img_array_normalized.flatten()[omega_indices]
    np.savetxt(values_file, values, fmt='%.6f')
    print(f"Vrednosti shranjene na {values_file}")

# Primer uporabe
image_path = 'tokyo_podatki/volna.jpg'  # Pot do vhodne slike
k = 60  # Želena redukcija ranga
square_size = 200  # Velikost kvadrata (npr. 50x50 pik)
square_position = (100, 100)  # Zgornji levi kot kvadrata (x, y)
output_image_path = 'tokyo_podatki/volna_rank60_square_large.jpg'  # Pot za shranjevanje obdelane slike
omega_file = 'tokyo_podatki/omega.txt'  # Pot za shranjevanje Omega
values_file = 'tokyo_podatki/values.txt'  # Pot za shranjevanje vrednosti ne-kvadratnih pikslov

process_image(image_path, k, square_size, square_position, output_image_path, omega_file, values_file)

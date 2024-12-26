import numpy as np
from PIL import Image
from scipy.linalg import svd

def reduce_rank(matrix, k):
    """Zmanjša rang dane matrike na k s pomočjo SVD."""
    U, S, Vt = svd(matrix, full_matrices=False)
    S = np.diag(S[:k])
    U = U[:, :k]
    Vt = Vt[:k, :]
    return np.dot(U, np.dot(S, Vt))

def process_channel(channel, k):
    """Obdeluje posamezen barvni kanal z zmanjšanjem njegovega ranga."""
    return reduce_rank(channel, k)

def save_omega_and_values(channel, omega_indices, omega_i_file, omega_j_file, values_file):
    """Shrani omega indekse in ustrezne vrednosti za kanal."""
    # Poenostavi matriko za lažje indeksiranje
    flattened_channel = channel.flatten()

    # Izračunaj Omega_i in Omega_j (vrstični in stolpični indeksi ne-nul elementov)
    omega_i, omega_j = np.unravel_index(omega_indices, channel.shape)
    
    # Shrani Omega_i in Omega_j (indeksiranje, ki se začne pri 1)
    np.savetxt(omega_i_file, omega_i + 1, fmt='%d')
    np.savetxt(omega_j_file, omega_j + 1, fmt='%d')
    
    # Shrani vrednosti ne-nul pikslov
    non_zero_values = flattened_channel[omega_indices]
    np.savetxt(values_file, non_zero_values, fmt='%.6f')

def modify_and_save_color_image(image_path, percentage, k, output_img_path, omega_dir):
    # Odpri barvno sliko
    img = Image.open(image_path).convert('RGB')
    img_array = np.array(img, dtype=np.float64) / 255.0  # Normaliziraj vrednosti med 0 in 1

    # Razdeli sliko na R, G, B kanale
    R, G, B = img_array[:, :, 0], img_array[:, :, 1], img_array[:, :, 2]

    # Zmanjšaj rang vsakega kanala
    R_k = process_channel(R, k)
    G_k = process_channel(G, k)
    B_k = process_channel(B, k)

    # Rekonstruiraj sliko iz kanalov z zmanjšanim rangom
    img_reconstructed = np.stack((R_k, G_k, B_k), axis=-1)

    # Pretvori rekonstruirano sliko nazaj v obseg 0-255 in jo shrani
    img_reconstructed = (img_reconstructed * 255).astype(np.uint8)
    img_output = Image.fromarray(img_reconstructed)
    img_output.save(output_img_path)
    print(f"Rekonstruirana slika shranjena na {output_img_path}")

    # Poenostavi enega izmed kanalov (R_k) za generiranje enega niza Omega
    num_elements = R_k.size
    num_zeros = int(num_elements * percentage / 100)
    indices = np.arange(num_elements)
    np.random.shuffle(indices)
    omega_indices = indices[num_zeros:]  # Indeksi ne-nul elementov

    # Shrani skupni Omega datoteko
    np.savetxt(f"{omega_dir}/omega.txt", omega_indices + 1, fmt='%d')
    print(f"Omega shranjena na {omega_dir}/omega.txt")

    # Shrani Omega in ustrezne vrednosti za vsak kanal
    save_omega_and_values(R_k, omega_indices, f"{omega_dir}/omega_i_R.txt", f"{omega_dir}/omega_j_R.txt", f"{omega_dir}/values_R.txt")
    save_omega_and_values(G_k, omega_indices, f"{omega_dir}/omega_i_G.txt", f"{omega_dir}/omega_j_G.txt", f"{omega_dir}/values_G.txt")
    save_omega_and_values(B_k, omega_indices, f"{omega_dir}/omega_i_B.txt", f"{omega_dir}/omega_j_B.txt", f"{omega_dir}/values_B.txt")

    print(f"Omega in vrednosti za vsak kanal shranjene v {omega_dir}")

# Primer uporabe
image_path = 'tokyo_podatki/streha.jpg'  # Pot do vaše barvne slike
percentage = 55  # Delež pikslov, ki jih nastavimo na 0
k = 60  # Rang, na katerega zmanjšamo vsak kanal
output_img_path = 'tokyo_podatki/streha_rank60.jpg'  # Pot za shranjevanje rekonstruirane slike
omega_dir = 'tokyo_podatki'  # Mapa za shranjevanje Omega in vrednosti za vsak kanal

modify_and_save_color_image(image_path, percentage, k, output_img_path, omega_dir)

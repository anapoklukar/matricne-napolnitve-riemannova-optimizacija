import numpy as np
from PIL import Image

def load_matrix_from_file(file_path, shape):
    """Naloži matriko iz besedilne datoteke in jo preoblikuje v dano obliko."""
    flat_matrix = np.loadtxt(file_path)
    return flat_matrix.reshape(shape)

def reconstruct_image(R_path, G_path, B_path, U_path, output_image_path):
    # Naloži ortogonalno matriko U
    U = np.loadtxt(U_path)
    size = U.shape[0]  # Predpostavljamo, da je U kvadratna matrika in enake velikosti kot matrike kanalov

    # Naloži in preoblikuj matrike barvnih kanalov
    R = load_matrix_from_file(R_path, (size, size))
    G = load_matrix_from_file(G_path, (size, size))
    B = load_matrix_from_file(B_path, (size, size))

    # Uporabi transformacijo U^T B U za vsak kanal
    def transform_channel(channel):
        return U.T @ channel @ U

    R_reconstructed = transform_channel(R)
    G_reconstructed = transform_channel(G)
    B_reconstructed = transform_channel(B)

    # Združi kanale, da ustvari končno RGB sliko
    reconstructed_image_array = np.stack([R_reconstructed, G_reconstructed, B_reconstructed], axis=-1)

    # Normaliziraj na obseg 0-255 in pretvori v uint8
    reconstructed_image_array = np.clip(reconstructed_image_array, 0, 1)  # Poskrbi, da so vrednosti v [0, 1]
    reconstructed_image_array_255 = (reconstructed_image_array * 255).astype(np.uint8)

    # Shrani rekonstruirano sliko
    reconstructed_image = Image.fromarray(reconstructed_image_array_255)
    reconstructed_image.save(output_image_path)
    print(f"Rekonstruirana slika shranjena na {output_image_path}")

# Primer uporabe
R_path = '../matlab/X_reconstructed_..txtX_reconstructed_R.txt'
G_path = '../matlab/X_reconstructed_..txtX_reconstructed_G.txt'
B_path = '../matlab/X_reconstructed_..txtX_reconstructed_B.txt'
U_path = 'tokyo_podatki/mavrica_novametoda_noise25_orthogonal_matrix.txt'
output_image_path = 'tokyo_podatki/reconstructed_image_color_newmethod_noise25.jpg'

reconstruct_image(R_path, G_path, B_path, U_path, output_image_path)

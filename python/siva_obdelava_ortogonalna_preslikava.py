import numpy as np
from PIL import Image

def load_matrix_from_file(file_path, shape):
    """Naloži matriko iz besedilne datoteke in jo preoblikuj v dano obliko."""
    flat_matrix = np.loadtxt(file_path)
    return flat_matrix.reshape(shape)

def reconstruct_grayscale_image(image_path, U_path, output_image_path):
    # Naloži ortogonalno matriko U
    U = np.loadtxt(U_path)
    size = U.shape[0]  # Predpostavljamo, da je U kvadratna in enake velikosti kot kanalne matrike

    # Naloži in preoblikuj matriko sivinske slike
    image_matrix = load_matrix_from_file(image_path, (size, size))

    # Uporabi transformacijo U^T B U na sivinsko sliko
    def transform_matrix(matrix):
        return U.T @ matrix @ U

    image_reconstructed = transform_matrix(image_matrix)

    # Normaliziraj na razpon 0-255 in pretvori v uint8
    image_reconstructed = np.clip(image_reconstructed, 0, 1)  # Zagotovi, da so vrednosti znotraj [0, 1]
    image_reconstructed_255 = (image_reconstructed * 255).astype(np.uint8)

    # Shrani rekonstruirano sliko
    reconstructed_image = Image.fromarray(image_reconstructed_255, mode='L')
    reconstructed_image.save(output_image_path)
    print(f"Rekonstruirana sivinska slika shranjena na {output_image_path}")

# Primer uporabe
image_path = '../matlab/X_reconstructed_G.txt'
U_path = 'tokyo_podatki/gray_image_processed_orthogonal_matrix.txt'
output_image_path = 'tokyo_podatki/reconstructed_image_gray_noise55.jpg'

reconstruct_grayscale_image(image_path, U_path, output_image_path)

import numpy as np
from PIL import Image

def normalize_image_to_01(image_array):
    """
    Normalizira slikovno matriko v obseg 0-1.
    Ta funkcija predvideva, da je vhodna slika v obsegu 0-255.
    """
    if image_array.max() > 1.0:
        # Če je slika v obsegu 0-255, jo skaliraj na 0-1
        return image_array / 255.0
    return image_array

def flip_image_values(image_array):
    """
    Obrne vrednosti pikslov slikovne matrike.
    """
    return 1.0 - image_array

def save_matrix_to_file(matrix, file_path):
    """
    Shrani numpy matriko v besedilno datoteko.
    """
    np.savetxt(file_path, matrix, fmt='%.6f')

def compute_psnr(image1_path, image2_path, flip_image1=False, save_matrices=False):
    # Naloži slike
    img1 = Image.open(image1_path).convert('L')
    img2 = Image.open(image2_path).convert('L')

    # Pretvori slike v numpy matrike
    img1_array = np.array(img1, dtype=np.float64)
    img2_array = np.array(img2, dtype=np.float64)

    # Normaliziraj slike na obseg 0-1
    img1_array = normalize_image_to_01(img1_array)
    img2_array = normalize_image_to_01(img2_array)

    # Po želji obrni vrednosti pikslov ene slike
    if flip_image1:
        img1_array = flip_image_values(img1_array)

    # Po želji shrani matrike v datoteke
    if save_matrices:
        save_matrix_to_file(img1_array, 'image1_matrix.txt')
        save_matrix_to_file(img2_array, 'image2_matrix.txt')

    # Preveri, ali imata slike enake dimenzije
    if img1_array.shape != img2_array.shape:
        raise ValueError("Vhodni sliki morata imeti enake dimenzije.")

    # Izračunaj Povprečno Kvadratno Napako (MSE)
    mse = np.mean((img1_array - img2_array) ** 2)

    if mse == 0:
        return float('inf')  # Če je MSE enak 0, je PSNR neskončen

    # Izračunaj maksimalno vrednost piksla (1.0 za normalizirane slike)
    max_pixel = 1.0

    # Izračunaj PSNR
    psnr = 20 * np.log10(max_pixel / np.sqrt(mse))
    
    return psnr

if __name__ == "__main__":
    # Primer uporabe
    image1_path = 'tokyo_podatki/tokyo_rank60.jpg'
    image2_path = 'tokyo_podatki/reconstructed_image_gray_noise55.jpg'
    
    psnr_value = compute_psnr(image1_path, image2_path, flip_image1=True, save_matrices=True)
    print(f"PSNR: {psnr_value:.2f} dB")

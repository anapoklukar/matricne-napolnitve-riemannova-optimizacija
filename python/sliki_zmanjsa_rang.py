import numpy as np
from PIL import Image
from scipy.linalg import svd

def convert_to_grayscale(image_path, save_path):
    # Odpri sliko in jo pretvori v sivino
    img = Image.open(image_path).convert('L')
    
    # Pretvori sliko v numpy matriko z vrednostmi v [0, 255]
    grayscale_matrix = np.array(img)
    
    # Normaliziraj sivinsko matriko na [0, 1]
    normalized_matrix = grayscale_matrix / 255.0
    
    # Shrani sivinsko sliko z normaliziranimi vrednostmi
    normalized_image = Image.fromarray((normalized_matrix * 255).astype(np.uint8))
    normalized_image.save(save_path)
    
    return normalized_matrix

def lower_rank(matrix, k):
    # Izvedi Singular Value Decomposition (SVD)
    U, S, Vt = svd(matrix, full_matrices=False)
    
    # Ohrani le prvih k singularnih vrednosti
    S_k = np.zeros_like(S)
    S_k[:k] = S[:k]
    
    # Rekonstruiraj matriko z zmanjšanim rangom k
    low_rank_matrix = np.dot(U, np.dot(np.diag(S_k), Vt))
    
    # Normaliziraj matriko z nizkim rangom na [0, 1]
    low_rank_matrix = np.clip(low_rank_matrix, 0, 1)
    
    return low_rank_matrix

def save_image(matrix, output_image_path):
    # Pretvori matriko v uint8 za shranjevanje slike (prilagojeno na [0, 255])
    matrix_uint8 = (matrix * 255).astype(np.uint8)
    
    # Ustvari sliko iz matrike in jo shrani
    img = Image.fromarray(matrix_uint8)
    img.save(output_image_path)

def save_matrix(matrix, output_matrix_path):
    # Shrani matriko v besedilno datoteko z vrednostmi v [0, 1]
    np.savetxt(output_matrix_path, matrix, fmt='%.6f')
    print(f"Matrika shranjena na {output_matrix_path}")

# Primer uporabe
image_path = 'tokyo_podatki/busan.jpg'  # Zamenjajte z vašo potjo do slike
output_image_path = 'tokyo_podatki/busan_rank60.jpg'  # Pot za shranjevanje končne slike
output_matrix_path = 'tokyo_podatki/busan_rank60.txt'  # Pot za shranjevanje matrike
k = 60  # Želeni rang

# Pretvori sliko v sivino in jo normaliziraj
normalized_grayscale_matrix = convert_to_grayscale(image_path, 'tokyo_podatki/busan_gray.jpg')

# Zmanjšaj rang matrike
low_rank_matrix = lower_rank(normalized_grayscale_matrix, k)

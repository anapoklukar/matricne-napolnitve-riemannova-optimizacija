import cv2
import numpy as np
import os

def image_to_matrix(image_path):
    # Naloži sivo sliko
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    
    # Preveri, ali je bila slika pravilno naložena
    if image is None:
        raise ValueError(f"Ne morem odpreti ali najti slike: {image_path}")
    
    return image

def save_matrix_to_txt(image_matrix, output_txt_path):
    # Shrani matriko v .txt datoteko z vrednostmi ločenimi z vejicami
    np.savetxt(output_txt_path, image_matrix, fmt='%d', delimiter=' ')

def process_images_in_directory(directory_path):
    # Obdelaj vsako sliko v imeniku z vzorcem poimenovanja
    for filename in os.listdir(directory_path):
        if filename.startswith("tokyo_rank") and filename.endswith(".jpg"):
            # Izlušči rang iz imena datoteke
            rank = filename.split("rank")[1].split(".jpg")[0]
            
            # Konstruiraj polno pot do slike
            image_path = os.path.join(directory_path, filename)
            
            # Pretvori sliko v matriko
            image_matrix = image_to_matrix(image_path)
            
            # Določi pot do izhodne .txt datoteke
            output_txt_path = os.path.join(directory_path, f"tokyo_matrix_rank{rank}.txt")
            
            # Shrani matriko v .txt datoteko
            save_matrix_to_txt(image_matrix, output_txt_path)
            
            print(f"Obdelana in shranjena matrika za {filename} kot {output_txt_path}")

# Primer uporabe
directory_path = 'tokyo_podatki/'  # Nastavite pot do imenika, ki vsebuje slike
process_images_in_directory(directory_path)

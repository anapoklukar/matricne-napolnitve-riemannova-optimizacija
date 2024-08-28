import numpy as np
import cv2
import matplotlib.pyplot as plt

def image_to_grayscale(image_path):
    # Naloži sliko
    image = cv2.imread(image_path)

    # Pretvori sliko v sivo barvo
    grayscale_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    return grayscale_image

def reduce_rank(image, k):
    # Izračunaj SVD (Singular Value Decomposition) sive slike
    U, S, Vt = np.linalg.svd(image, full_matrices=False)

    # Obdrži samo prvih k singularnih vrednosti
    S_k = np.zeros_like(S)
    S_k[:k] = S[:k]

    # Rekonstruiraj sliko z zmanjšanim rangom
    reduced_image = np.dot(U, np.dot(np.diag(S_k), Vt))

    return reduced_image

def save_image(image, output_path):
    # Zagotovi, da so vrednosti pikslov v razponu [0, 255] in pretvori v uint8
    image = np.clip(image, 0, 255).astype(np.uint8)
    cv2.imwrite(output_path, image)

def main(image_path, k, output_path):
    # Pretvori sliko v sivo barvo
    grayscale_image = image_to_grayscale(image_path)

    # Zmanjšaj rang sive slike
    reduced_image = reduce_rank(grayscale_image, k)

    # Shrani zmanjšano sliko
    save_image(reduced_image, output_path)

    # Prikaži izvirno in zmanjšano sliko
    plt.figure(figsize=(10, 5))

    plt.subplot(1, 2, 1)
    plt.title("Izvirna siva slika")
    plt.imshow(grayscale_image, cmap='gray')

    plt.subplot(1, 2, 2)
    plt.title(f"Zmanjšana rang slika (k={k})")
    plt.imshow(reduced_image, cmap='gray')

    plt.show()

# Primer uporabe
image_path = 'tokyo_podatki/tokyo.jpg'  # Pot do vhodne slike
output_path = 'tokyo_podatki/tokyo_rank5.jpg'  # Pot do izhodne slike
k = 5  # Nastavite želeni rang

main(image_path, k, output_path)

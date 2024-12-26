import numpy as np
from PIL import Image
from sklearn.metrics import mean_squared_error
import math

def load_channel_image(channel_image_path):
    """Naloži sliko kanala in normalizira vrednosti pikslov v obseg [0, 1]."""
    img = Image.open(channel_image_path).convert('L')  # Pretvori sliko v sivinsko (en kanal)
    img_array = np.array(img, dtype=np.float64) / 255.0  # Normaliziraj vrednosti na [0, 1]
    return img_array

def compute_psnr(original, reconstructed):
    """Izračuna PSNR med izvirno in rekonstruirano sliko."""
    mse = mean_squared_error(original.flatten(), reconstructed.flatten())
    if mse == 0:
        return float('inf')
    max_pixel = 1.0  # Ker so slike normalizirane na [0, 1]
    psnr = 20 * math.log10(max_pixel / math.sqrt(mse))
    return psnr

def reconstruct_and_save_image(R_file, G_file, B_file, output_img_path, original_img_path):
    # Naloži rekonstruirane kanale kot slike
    R_reconstructed = load_channel_image(R_file)
    G_reconstructed = load_channel_image(G_file)
    B_reconstructed = load_channel_image(B_file)

    # Združi kanale nazaj v eno sliko
    img_reconstructed = np.stack((R_reconstructed, G_reconstructed, B_reconstructed), axis=-1)

    # Pretvori rekonstruirano sliko nazaj v obseg 0-255 in jo shrani
    img_reconstructed_uint8 = (img_reconstructed * 255).astype(np.uint8)
    img_output = Image.fromarray(img_reconstructed_uint8)
    img_output.save(output_img_path)
    print(f"Rekonstruirana slika shranjena na {output_img_path}")

    # Naloži izvirno sliko
    img_original = Image.open(original_img_path).convert('RGB')
    img_original = np.array(img_original, dtype=np.float64) / 255.0  # Normaliziraj vrednosti med 0 in 1

    # Izračunaj PSNR za vsak kanal
    psnr_R = compute_psnr(img_original[:, :, 0], R_reconstructed)
    psnr_G = compute_psnr(img_original[:, :, 1], G_reconstructed)
    psnr_B = compute_psnr(img_original[:, :, 2], B_reconstructed)

    # Izračunaj povprečni PSNR
    psnr_avg = (psnr_R + psnr_G + psnr_B) / 3

    print(f"PSNR za R kanal: {psnr_R:.2f} dB")
    print(f"PSNR za G kanal: {psnr_G:.2f} dB")
    print(f"PSNR za B kanal: {psnr_B:.2f} dB")
    print(f"Povprečni PSNR: {psnr_avg:.2f} dB")

    return psnr_R, psnr_G, psnr_B, psnr_avg

# Primer uporabe
R_file = '../matlab/X_reconstructed_R.png'  # Pot do rekonstruirane slike R kanala
G_file = '../matlab/X_reconstructed_G.png'  # Pot do rekonstruirane slike G kanala
B_file = '../matlab/X_reconstructed_B.png'  # Pot do rekonstruirane slike B kanala
output_img_path = 'tokyo_podatki/streha_reconstructed_noise55.jpg'  # Pot za shranjevanje rekonstruirane slike
original_img_path = 'tokyo_podatki/streha_rank60.jpg'  # Pot do izvirne slike za primerjavo PSNR

reconstruct_and_save_image(R_file, G_file, B_file, output_img_path, original_img_path)

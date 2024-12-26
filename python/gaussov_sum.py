import numpy as np

def generate_indices_outside_gaussian(matrix_size, sigma, threshold=0.1, output_file='indices_outside_gaussian.txt'):
    # Dimenzije matrike
    m, n = matrix_size

    # Ustvari mrežo indeksov
    I, J = np.meshgrid(np.arange(1, m+1), np.arange(1, n+1), indexing='ij')

    # Določi sredino Gaussove porazdelitve
    center_i = m / 2
    center_j = n / 2

    # Generiraj Gaussovo območje
    gaussian_region = np.exp(-((I - center_i) ** 2 + (J - center_j) ** 2) / (2 * sigma ** 2))

    # Ustvari binarno masko za prepoznavanje točk zunaj Gaussovega območja
    mask = gaussian_region < threshold

    # Izvleči indekse zunaj Gaussovega območja
    indices_outside_gaussian = np.where(mask)

    # Poenostavi indekse in jih pretvori v enotni indeks na podlagi indeksiranja, ki se začne pri 1
    flattened_indices = indices_outside_gaussian[0] * n + indices_outside_gaussian[1] + 1

    # Shrani indekse v datoteko
    with open(output_file, 'w') as f:
        for index in flattened_indices:
            f.write(f"{index}\n")
    
    print(f"Indeksi zunaj Gaussovega območja so shranjeni v {output_file}")

# Primer uporabe
generate_indices_outside_gaussian(matrix_size=(1000, 1000), sigma=200, threshold=0.1)

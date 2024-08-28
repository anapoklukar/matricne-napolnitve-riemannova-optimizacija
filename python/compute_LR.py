import numpy as np

def compute_low_rank_matrices(matrix_file, k, L_output_file, R_output_file):
    # Naloži matriko iz besedilne datoteke
    A = np.loadtxt(matrix_file)
    
    # Izvedi SVD (Singular Value Decomposition)
    U, Sigma, Vt = np.linalg.svd(A, full_matrices=False)
    
    # Obdrži samo prvih k komponent
    U_k = U[:, :k]           # U_k bo m x k
    Sigma_k = np.diag(Sigma[:k])  # Sigma_k bo k x k
    V_k = Vt[:k, :]          # V_k bo k x n
    
    # Izračunaj L in R
    L = U_k @ Sigma_k  # L bo m x k
    R = Sigma_k @ V_k  # R bo k x n
    
    # Transponiraj R
    R_transposed = R.T  # Transponiraj R, da bo n x k
    
    # Shrani L in R matriki v besedilne datoteke
    np.savetxt(L_output_file, L)
    np.savetxt(R_output_file, R_transposed)  # Shrani transponiran R
    
    print(f"L matrika shranjena v {L_output_file}")
    print(f"R matrika (transponirana) shranjena v {R_output_file}")

# Primer uporabe:
matrix_file = 'tokyo_podatki/tokyo_matrix_rank15.txt'  # Vhodna datoteka z matriko
k = 15  # Želeni rang
L_output_file = 'tokyo_podatki/L_matrix.txt'  # Izhodna datoteka za L matriko
R_output_file = 'tokyo_podatki/R_matrix.txt'  # Izhodna datoteka za transponirano R matriko

compute_low_rank_matrices(matrix_file, k, L_output_file, R_output_file)

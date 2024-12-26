import numpy as np

def compute_matrix_rank(txt_file_path):
    # Naloži matriko iz besedilne datoteke
    matrix = np.loadtxt(txt_file_path, dtype=np.uint8)
    
    # Izračunaj rang matrike
    rank = np.linalg.matrix_rank(matrix)
    
    # Izpiši rang matrike
    print(f"Rang matrike je: {rank}")
    return rank

# Primer uporabe
txt_file_path = 'low_rank_matrix.txt'  # Zamenjajte s potjo do vaše besedilne datoteke
compute_matrix_rank(txt_file_path)

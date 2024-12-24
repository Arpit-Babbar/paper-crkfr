import numpy as np
import pandas as pd
from numpy import genfromtxt

def csv2txt(csv_file, txt_file):
    csv = genfromtxt(csv_file, delimiter=',')
    x = csv[1:, 3]
    sol = csv[1:, 0]
    a = np.dstack((x, sol)).squeeze()
    np.savetxt(txt_file, a, delimiter=' ')

nu0_csv = pd.read_csv("./reference_solns/line_cut_nu0.csv")
nu1_csv = pd.read_csv("./reference_solns/line_cut_nu1.csv")

csv2txt("./reference_solns/line_cut_nu0.csv", "./reference_solns/line_cut_nu0.txt")
csv2txt("./reference_solns/line_cut_nu1.csv", "./reference_solns/line_cut_nu1.txt")

csv2txt("./paper_results/tenmom_realistic_nuT0.0/line_cut.csv",
        "./paper_results/tenmom_realistic_nuT0.0/line_cut.txt")


csv2txt("./paper_results/tenmom_realistic_nuT1.0/line_cut.csv",
        "./paper_results/tenmom_realistic_nuT1.0/line_cut.txt")
# -*- coding: utf-8 -*-
"""
Created on Wed Nov 18 18:25:13 2020

@author: Dani
"""
import pandas as pd

chemprop = pd.read_csv('chemprop.csv')

from rdkit import Chem

chemprop['smiles'][4]

m = Chem.MolFromSmiles(chemprop['smiles'][4])

Chem.MolToSmiles(m)

Chem.MolFromSmiles

cd D:\MRC_Postdoc\Pangenomic\Chem_space\chemprop


## regression

# hyperparameters optimization
chemprop_hyperopt --data_path chemprop.csv --dataset_type regression --num_iters 10 --config_save_path hyperopt.json --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0 --split_type cv  --num_folds 10
# training
chemprop_train --data_path chemprop.csv --dataset_type regression --save_dir ./regression/biolog_model_test --num_folds 10 --split_type cv --ensemble_size 20 --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0 --config_path ./regression/hyperopt.json
# prediction
chemprop_predict --test_path predict.csv --checkpoint_dir ./regression/biolog_model_test --preds_path predictions_test.csv --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0 

# prediction large set
chemprop_predict --test_path predict_drug_rep_hub.csv --checkpoint_dir ./regression/biolog_model_test --preds_path ./regression/predictions_drug_rep_hub_reg.csv --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0 

# interpretation
chemprop_interpret --data_path predict.csv --checkpoint_dir biolog_model_test/fold_0/ --property_id 1 --features_generator rdkit_2d_normalized --no_features_scaling 

# tensorboard
tensorboard --logdir=biolog_model_test



## multiclass
# hyperparameters optimization
chemprop_hyperopt --data_path chemprop_class.csv --dataset_type multiclass --num_iters 10 --split_type cv --config_save_path hyperopt_multiclass.json --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0
# training
chemprop_train --data_path chemprop_class.csv --dataset_type multiclass --save_dir biolog_model_multiclass  --num_folds 10 --ensemble_size 20 --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0 --config_path hyperopt_multiclass.json
# prediction
chemprop_predict --test_path predict.csv --checkpoint_dir biolog_model_multiclass --preds_path predictions_multiclass.csv --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0

# prediction for a larger set
chemprop_predict --test_path predict_drug_rep_hub.csv --checkpoint_dir biolog_model_multiclass --preds_path predictions_drug_rep_hub_multiclass.csv --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0

# interpretation
chemprop_interpret --data_path predict.csv --checkpoint_dir biolog_model_multiclass/ --property_id 1 --features_generator rdkit_2d_normalized --no_features_scaling


## LINUX

chemprop_hyperopt --data_path chemprop_class.csv --dataset_type multiclass --num_iters 10 --split_type cv --config_save_path hyperopt_multiclass.json --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0

chemprop_train --data_path chemprop_class.csv --dataset_type multiclass --save_dir biolog_model_multiclass  --num_folds 10 --ensemble_size 20 --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0 --config_path hyperopt_multiclass.json

chemprop_interpret --data_path predictions_drug_rep_hub_multiclass.csv --checkpoint_dir biolog_model_multiclass/ --features_generator rdkit_2d_normalized --no_features_scaling
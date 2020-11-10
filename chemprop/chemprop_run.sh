cd D:\MRC_Postdoc\Pangenomic\Chem_space\chemprop


## regression

# hyperparameters optimization
chemprop_hyperopt --data_path chemprop.csv --dataset_type regression --num_iters 15 --config_save_path hyperopt --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0
# training
chemprop_train --data_path chemprop.csv --dataset_type regression --save_dir biolog_model_test --num_folds 10 --ensemble_size 10 --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0 --config_path hyperopt.json
# prediction
chemprop_predict --test_path predict.csv --checkpoint_dir biolog_model_test --preds_path predictions_test.csv --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0
# interpretation
chemprop_interpret --data_path predict.csv --checkpoint_dir biolog_model_test/fold_0/ --property_id 1 --features_generator rdkit_2d_normalized --no_features_scaling

# tensorboard
tensorboard --logdir=biolog_model_test



## multiclass
# hyperparameters optimization
chemprop_hyperopt --data_path chemprop_class.csv --dataset_type multiclass --num_iters 15 --config_save_path hyperopt_multiclass.json --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0
# training
chemprop_train --data_path chemprop_class.csv --dataset_type multiclass --save_dir biolog_model_multiclass --num_folds 10 --ensemble_size 10 --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0 --config_path hyperopt_multiclass.json
# prediction
chemprop_predict --test_path predict.csv --checkpoint_dir biolog_model_multiclass --preds_path predictions_multiclass.csv --features_generator rdkit_2d_normalized --no_features_scaling --gpu 0
# interpretation
chemprop_interpret --data_path predict.csv --checkpoint_dir biolog_model_multiclass/ --property_id 1 --features_generator rdkit_2d_normalized --no_features_scaling
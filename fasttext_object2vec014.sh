#!/bin/bash
# Train object2vec models using and edited version of fasttext in which the full context window is used in all training batches
# 
# NOTE: I am using a version of fasttext in which the following change was made to fasttext.cc before compiling the code
# Line 292 (note this is line 361 in the version of fasttext as of 10/24/19):
# std::uniform_int_distribution<> uniform(1, args_->ws);
# Changed to:
# std::uniform_int_distribution<> uniform(args_->ws, args_->ws);

# Output directory
file_name="$(basename $0)"
results_name=${file_name%.*}
output_dir=../analyses/$results_name
mkdir -p $output_dir

# Image annotations
annotations=../analyses/bagofobjects002/annotations.txt

# Train model
for n in `seq 10 20 100`; 
do
    for i in {1..100}; 
    do
        echo Training version $i
        version_name=dims$( printf '%02d' $n)_v$( printf '%02d' $i)
        output_fname=model_$version_name
        output=$output_dir/$output_fname
        fasttext cbow -input $annotations -output $output -minCount 1 -minn 0 -maxn 0 -dim $n -ws 70 -epoch 1000 -neg 20 -saveOutput 1 -thread 4
    done
done



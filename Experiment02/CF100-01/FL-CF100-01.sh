#!/bin/bash
#SBATCH --job-name=test_nb_01
#SBATCH --partition=gpu-week-long    
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

set -e  # stop on first error

cd "$SLURM_SUBMIT_DIR"

module load anaconda3 2>/dev/null || true

# 1) Choose and create your output folder (relative to submit dir)
OUTPUT_DIR="$SLURM_SUBMIT_DIR/output"
mkdir -p "$OUTPUT_DIR"

# 2) Run nbconvert and send the executed notebook there
python -m jupyter nbconvert \
    --to notebook \
    --execute \
    --ExecutePreprocessor.timeout=-1 \
    FL-CIFAR-100-Alpha=01.ipynb \
    --output=FL-CIFAR-100-Alpha=01_executed \
    --output-dir="$OUTPUT_DIR"
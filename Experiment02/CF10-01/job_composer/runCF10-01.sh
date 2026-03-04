#!/bin/bash
#SBATCH --job-name=nb_batch_run
#SBATCH --partition=gpu-week-long
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --gres=gpu:1
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

set -e  # stop if anything fails

cd "$SLURM_SUBMIT_DIR"
module load anaconda3 2>/dev/null || true

OUTPUT_DIR="$SLURM_SUBMIT_DIR/output"
mkdir -p "$OUTPUT_DIR"

run_nb () {
    local NB="$1"
    local BASE="${NB%.ipynb}"           # strip .ipynb
    echo "=== Running $NB ==="
    python -m jupyter nbconvert \
        --to notebook \
        --execute \
        --ExecutePreprocessor.timeout=-1 \
        ../"$NB" \
        --output="${BASE}_executed" \
        --output-dir="$OUTPUT_DIR"
}

run_nb Centralize_Baseline-CF10-01.ipynb
run_nb FL-CF10-01.ipynb
run_nb FOT-CF10-01.ipynb
run_nb SFLV2_Projected-CF10-01.ipynb
run_nb SFLV2-CF10-01.ipynb
run_nb SL_Projected-CF10-01.ipynb
run_nb SL-CF10-01.ipynb
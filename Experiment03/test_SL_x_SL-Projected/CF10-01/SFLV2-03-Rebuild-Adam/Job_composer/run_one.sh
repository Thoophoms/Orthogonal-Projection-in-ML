#!/bin/bash
#SBATCH --job-name=SFLV2_Projected-CF10-01_100EP_5WP_3RB
#SBATCH --partition=gpu-week-long    
#SBATCH --time=7-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --gres=gpu:1
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

set -e  # stop on first error

cd "$SLURM_SUBMIT_DIR"
module load anaconda3 2>/dev/null || true


# Parent directory of job_composer/ -> CF10-01/
PROJECT_DIR="$(dirname "$SLURM_SUBMIT_DIR")"

# Assign JOB_NAME
JOB_NAME="SFLV2_Projected-CF10-01_100EP_5WP_3RB"

# 1) Choose and create your output folder (relative to submit dir)
OUTPUT_DIR="$SLURM_SUBMIT_DIR/output"
mkdir -p "$OUTPUT_DIR"

echo "=== Running ${JOB_NAME} ==="

# 2) Run nbconvert and send the executed notebook there
python -m jupyter nbconvert \
    --to notebook \
    --execute \
    --ExecutePreprocessor.timeout=-1 \
    "$PROJECT_DIR/SFLV2_Projected-CF10-01_100EP_5WP_3RB.ipynb" \
    --output="${JOB_NAME}_executed" \
    --output-dir="$OUTPUT_DIR"
    

echo "=== Finished ${JOB_NAME} ==="
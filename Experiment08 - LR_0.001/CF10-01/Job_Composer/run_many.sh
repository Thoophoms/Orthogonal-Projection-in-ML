#!/bin/bash
#SBATCH --job-name=200EP_CF10-01_LR=0-001
#SBATCH --partition=gpu-week-long
#SBATCH --time=7-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --gres=gpu:1
#SBATCH --array=0-6
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err


set -e  # stop if anything fails


cd "$SLURM_SUBMIT_DIR"
module load anaconda3 2>/dev/null || true


# Parent directory of job_composer/ -> CF10-01/
PROJECT_DIR="$(dirname "$SLURM_SUBMIT_DIR")"


NOTEBOOKS=(
  "Centralize_Baseline-CF10-01.ipynb"
  "FL-CF10-01.ipynb"
  "FOT-CF10-01.ipynb"
  "SFLV2_Projected-CF10-01.ipynb"
  "SFLV2-CF10-01.ipynb"
  "SL_Projected-CF10-01.ipynb"
  "SL-CF10-01.ipynb"
)


NB="${NOTEBOOKS[$SLURM_ARRAY_TASK_ID]}"
BASE="${NB%.ipynb}"


# Outputs will go into: CF10-01/output/<notebook-name>/
OUTPUT_DIR="$PROJECT_DIR/output/$BASE"
mkdir -p "$OUTPUT_DIR"


echo "=== Running ${NB} on array task ${SLURM_ARRAY_TASK_ID} ==="


python -m jupyter nbconvert \
    --to notebook \
    --execute \
    --ExecutePreprocessor.timeout=-1 \
    "$PROJECT_DIR/$NB" \
    --output="${BASE}_executed" \
    --output-dir="$OUTPUT_DIR"


echo echo "=== Finish ${NB} on array task ${SLURM_ARRAY_TASK_ID} ==="
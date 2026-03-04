#!/bin/bash
#SBATCH --job-name=SL-CF10-05
#SBATCH --partition=gpu-week-long
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --gres=gpu:1
#SBATCH --array=0-2               # 3 tasks: 0, 1, 2
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

set -e

cd "$SLURM_SUBMIT_DIR"
module load anaconda3 2>/dev/null || true

NOTEBOOKS=(
  "Centralize_Baseline-CF10-05.ipynb"
  "FL-CF10-05.ipynb"
  "FOT-CF10-05.ipynb"
  "SFLV2_Projected-CF10-05.ipynb"
  "SFLV2-CF10-05.ipynb"
  "SL_Projected-CF10-05.ipynb"
  "SL-CF10-05.ipynb"
)

NB="${NOTEBOOKS[$SLURM_ARRAY_TASK_ID]}"
BASE="${NB%.ipynb}"

OUTPUT_DIR="$SLURM_SUBMIT_DIR/output/$BASE"
mkdir -p "$OUTPUT_DIR"

echo "=== Running ${NB} on array task ${SLURM_ARRAY_TASK_ID} ==="

python -m jupyter nbconvert \
    --to notebook \
    --execute \
    --ExecutePreprocessor.timeout=-1 \
    "$NB" \
    --output="${BASE}_executed" \
    --output-dir="$OUTPUT_DIR"
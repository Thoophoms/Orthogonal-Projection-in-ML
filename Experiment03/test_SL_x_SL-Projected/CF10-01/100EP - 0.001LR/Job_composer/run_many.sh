#!/bin/bash
#SBATCH --job-name=100-EP_01_05_001_005_2048FM_4096FM
#SBATCH --partition=gpu-week-long
#SBATCH --time=7-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --gres=gpu:1
#SBATCH --array=0-19
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err


set -e  # stop if anything fails


cd "$SLURM_SUBMIT_DIR"
module load anaconda3 2>/dev/null || true


# Parent directory of job_composer/ -> CF10-01/
PROJECT_DIR="$(dirname "$SLURM_SUBMIT_DIR")"


NOTEBOOKS=(
  "SFLV2_Projected-CF10-01-100EP-5WP-3RB-0-001LR-2048FM.ipynb"
  "SFLV2_Projected-CF10-01-100EP-5WP-3RB-0-001LR-4096FM.ipynb"
  "SFLV2_Projected-CF10-01-100EP-5WP-3RB-0-005LR-2048FM.ipynb"
  "SFLV2_Projected-CF10-01-100EP-5WP-3RB-0-005LR-4096FM.ipynb"
  "SFLV2_Projected-CF10-01-100EP-5WP-3RB-0-01LR-2048FM.ipynb"
  "SFLV2_Projected-CF10-01-100EP-5WP-3RB-0-05LR-2048FM.ipynb"
  "SFLV2_Projected-CF10-01-100EP-5WP-3RB-0-05LR-4096FM.ipynb"
  "SFLV2-CF10-01-100EP-0-001LR.ipynb"
  "SFLV2-CF10-01-100EP-0-005LR.ipynb"
  "SFLV2-CF10-01-100EP-0-05LR.ipynb"
  "SL_Projected-CF10-01-100EP-5WU-3RB-0-001-2048FM.ipynb"
  "SL_Projected-CF10-01-100EP-5WU-3RB-0-001-4096FM.ipynb"
  "SL_Projected-CF10-01-100EP-5WU-3RB-0-005-2048FM.ipynb"
  "SL_Projected-CF10-01-100EP-5WU-3RB-0-005-4096FM.ipynb"
  "SL_Projected-CF10-01-100EP-5WU-3RB-0-01-2048FM.ipynb"
  "SL_Projected-CF10-01-100EP-5WU-3RB-0-05-2048FM.ipynb"
  "SL_Projected-CF10-01-100EP-5WU-3RB-0-05-4096FM.ipynb"
  "SL-CF10-01-100EP-0-001LR.ipynb"
  "SL-CF10-01-100EP-0-005LR.ipynb"
  "SL-CF10-01-100EP-0-05LR.ipynb"
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
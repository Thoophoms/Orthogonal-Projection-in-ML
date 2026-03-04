#!/bin/bash
#SBATCH --job-name=SL_Projected-CF100-05
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


# Parent directory of job_composer/ -> CF10-05/
PROJECT_DIR="$(dirname "$SLURM_SUBMIT_DIR")"


# 1) Choose and create your output folder (relative to submit dir)
OUTPUT_DIR="$SLURM_SUBMIT_DIR/output"
mkdir -p "$OUTPUT_DIR"


# 2) Run nbconvert and send the executed notebook there
python -m jupyter nbconvert \
    --to notebook \
    --execute \
    --ExecutePreprocessor.timeout=-1 \
    "$PROJECT_DIR/SL_Projected-CF100-05.ipynb" \
    --output=SL_Projected-CF100-05_executed \
    --output-dir="$OUTPUT_DIR"
    
    
echo "Finished Task(s)"
#!/usr/bin/env bash
#SBATCH --job-name=flint
#SBATCH -A OD-217087 
#SBATCH -n 1
#SBATCH --cpus-per-task=36
#SBATCH --time=1-00:00:00
#SBATCH --mem=8GB
#SBATCH -o logs/flint_%j.log
#SBATCH -e logs/flint_%j.log

module load apptainer

# I trust nothing
export OMP_NUM_THREADS=1
export PREFECT_API_URL="http://jones.it.csiro.au:4200/api"
export WORKDIR=$(pwd)
export PREFECT_HOME="${WORKDIR}/prefect"
export PREFECT_LOGGING_EXTRA_LOGGERS="flint,fixms"
export PREFECT_LOGGING_LEVEL="INFO"
export PREFECT_RESULTS_PERSIST_BY_DEFAULT=true


echo "Sourcing home"
source /home/$(whoami)/.bashrc
conda activate flint


flint_flow_continuum_pipeline \
    --cli-config cli_config.yaml \
    70731

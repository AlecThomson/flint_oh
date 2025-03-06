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
    --split-path 70731_flint \
    --cluster-config petrichor.yaml \
    --flagger-container containers/flint-containers_aoflagger.sif \
    --calibrate-container containers/flint-containers_calibrate.sif \
    --casa-container containers/flint-containers_casa.sif \
    --expected-ms 36 \
    --wsclean-container containers/flint-containers_wsclean.sif \
    --yandasoft-container containers/flint-containers_askapsoft.sif \
    --potato-container containers/flint-container_potato.sif \
    --holofile akpb.iquv.closepack36.48.1655MHz.SB70497.cube.fits \
    --run-aegean \
    --aegean-container containers/flint-containers_aegean.sif \
    --reference-catalogue-directory catalogues \
    --linmos-residuals \
    --pb-cutoff 0.1 \
    --imaging-strategy gaskap_oh.yaml \
    --coadd-cubes \
    --use-beam-masks \
    --use-beam-masks-from 1 \
    --rounds 4 \
    70731

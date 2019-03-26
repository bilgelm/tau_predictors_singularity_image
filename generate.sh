set -e

generate_singularity() {
  singularity run docker://kaczmarj/neurodocker:0.4.3 generate singularity \
  --base neurodebian:stretch-non-free \
  --pkg-manager apt \
  --install make gcc g++ graphviz less emacs-nox default-jre gnupg \
            xorg libssl-dev libcurl4-openssl-dev libssh2-1-dev \
            texlive-latex-base texlive-latex-recommended texlive-latex-extra \
            texlive-fonts-recommended \
            texlive-publishers \
  --spm12 version=r7219 \
  --fsl version=5.0.11 \
  --miniconda \
    conda_install="python pandas matplotlib scipy ipython
                   nibabel scikit-image scikit-learn" \
    pip_install="https://github.com/nipy/nipype/tarball/master
                 nilearn atlasreader duecredit xlrd
                 https://github.com/bilgelm/nanslice/tarball/annotate" \
    create_env="neuro" \
    activate=true \
  --run 'conda install -y -q --name neuro -c r rstudio \
         r-devtools r-codetools r-roxygen2 r-testthat \
         r-png \
         r-ggplot2' \
  --run 'conda install -y -q --name neuro -c conda-forge r-ggpubr r-kableextra' \
  --run 'sync && conda clean -tipsy && sync' \
  --run 'mkdir -p /opt/talairach' \
  --run 'curl -fsSL --retry 5 -o /opt/talairach/talairach.jar http://www.talairach.org/talairach.jar' \
  --run 'mkdir -p /opt/bisweb' \
  --run 'curl -fsSL --retry 5 -o /opt/bisweb/colin_talairach_lookup_xy.png https://raw.githubusercontent.com/bioimagesuiteweb/bisweb/master/web/images/colin_talairach_lookup_xy.png' \
  --run "bash -c \"source activate neuro && Rscript -e 'install.packages(\\\"stargazer\\\", repos=\\\"https://cran.rstudio.com\\\")'\"" \
  --run "ln -s /bin/tar /bin/gtar" \
  --run "bash -c \"source activate neuro && Rscript -e 'devtools::install_gitlab(\\\"bilgelm/blsacog\\\")'\"" \
  --run 'mkdir /input /output /code /templates' \
  --run 'rm -rf /opt/conda/pkgs/*' \
  --run 'rm -rf /var/lib/apt/lists/*'
}

generate_singularity > Singularity.nipypeR

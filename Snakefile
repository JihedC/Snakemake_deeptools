################## Import libraries ##################

import pandas as pd
import os
import sys
from subprocess import call
import itertools
from snakemake.utils import R


################## Configuration file and PATHS##################

configfile: "config.yaml"

WORKING_DIR         = config["working_dir"]
RESULT_DIR          = config["result_dir"]
DATA_DIR            = config["data_dir"]

units = pd.read_table(config["units"], dtype=str).set_index(["bed"], drop=False)

SAMPLES = units.index.get_level_values('bed').unique().tolist()

bed_table = pd.read_table(config["sample"], dtype=str).set_index(["bed"], drop=False)

BED = bed_table.index.get_level_values('bed').unique().tolist()

##############
# Wildcards
##############
wildcard_constraints:
    sample = "[A-Za-z0-9]+"

wildcard_constraints:
    unit = "[A-Za-z0-9]+"

################## DESIRED OUTPUT ##################

HEATMAP             =   expand(RESULT_DIR + "heatmap/reference_point/{bed}/heatmap_{samples}_{bed}.pdf", samples = SAMPLES, bed=BED)
HEATMAP_SCALE       =   expand(RESULT_DIR + "heatmap/scale_region/{bed}/heatmap_{samples}_{bed}.pdf", samples = SAMPLES, bed=BED)
################## RULE ALL ##################

rule all:
    input:
        HEATMAP,

    message : "Analysis is complete!"
    shell:""


################## INCLUDE RULES ##################


include: "heatmap_repeats.smk"

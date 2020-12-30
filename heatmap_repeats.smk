rule computeMatrix:
    input:
        bigwig  = DATA_DIR + "{samples}.bw",
        bed     = "/exports/humgen/jihed/Coordinate_TOKEEP/mm10_rm/IAP/{bed}.bed"
    output:
        WORKING_DIR + "Matrix_{samples}_centered_{bed}.gz"
    threads: 10
    params:
        binSize     = str(config['computeMatrix']['binSize']),
        upstream    = str(config['computeMatrix']['upstream']),
        downstream  = str(config['computeMatrix']['downstream']),
        regionbody  = str(config['computeMatrix']['downstream'])
    conda:
        "envs/deeptools.yaml"
    shell:
        "computeMatrix \
        reference-point \
        -S {input.bigwig} \
        -R {input.bed} \
        --afterRegionStartLength {params.upstream} \
        --beforeRegionStartLength {params.downstream} \
        --referencePoint center \
        --numberOfProcessors {threads} \
        --binSize {params.binSize} \
        --skipZeros \
        -o {output} \
        "


rule plotHeatmap:
    input:
        WORKING_DIR + "Matrix_{samples}_centered_{bed}.gz"
    output:
        RESULT_DIR + "heatmap/{bed}/heatmap_{samples}_{bed}.pdf"
    params:
        kmeans = str(config['plotHeatmap']['kmeans']),
        color  = str(config['plotHeatmap']['color']),
        plot   = str(config['plotHeatmap']['plot']),
        #cluster = "{treatment}_vs_{control}.bed"
    conda:
        "envs/deeptools.yaml"
    message:
        "Preparing Heatmaps..."
    shell:
        "plotHeatmap \
        --matrixFile {input} \
        --outFileName {output} \
        --kmeans {params.kmeans} \
        --colorMap {params.color} "

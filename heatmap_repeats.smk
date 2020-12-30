rule computeMatrix:
    input:
        bigwig  = DATA_DIR + "{samples}.bw",
        bed     = "/exports/humgen/jihed/Coordinate_TOKEEP/mm10_rm/IAP/{bed}.bed"
    output:
        WORKING_DIR + "reference_point/Matrix_{samples}_centered_{bed}.gz"
    threads: 32
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
        WORKING_DIR + "reference_point/Matrix_{samples}_centered_{bed}.gz"
    output:
        RESULT_DIR + "heatmap/reference_point/{bed}/heatmap_{samples}_{bed}.pdf"
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


rule computeMatrix_scale:
    input:
        bigwig  = DATA_DIR + "{samples}.bw",
        bed     = "/exports/humgen/jihed/Coordinate_TOKEEP/mm10_rm/IAP/{bed}.bed"
    output:
        RESULT_DIR + "scale/{sample}.scale-regions_{bed}.gz"
    threads: 32
    params:
        binSize     = str(config['computeMatrix']['binSize']),
        afterRegion = str(config['computeMatrix']['afterRegion']),
        beforeRegion= str(config['computeMatrix']['beforeRegion'])
    conda:
        "envs/deeptools.yaml"
    shell:
        "computeMatrix \
        scale-regions \
        -S {input.bigwig} \
        -R {input.bed} \
        --afterRegionStartLength {params.afterRegion} \
        --beforeRegionStartLength {params.beforeRegion} \
        --numberOfProcessors {threads} \
        --binSize {params.binSize} \
        -o {output} \
        2> {log}"

rule plotHeatmap_scale:
    input:
        RESULT_DIR + "scale/{sample}.scale-regions.gz"
    output:
        RESULT_DIR + "heatmap/scale_region/{bed}/heatmap_{samples}_{bed}.pdf"
    params:
        kmeans = str(config['plotHeatmap']['kmeans']),
        color  = str(config['plotHeatmap']['color']),
        plot   = str(config['plotHeatmap']['plot']),
        cluster = RESULT_DIR + "heatmap/{sample}.bed"
    conda:
        "envs/deeptools.yaml"
    shell:
        "plotHeatmap \
        --matrixFile {input} \
        --outFileName {output} \
        --colorMap {params.color} "

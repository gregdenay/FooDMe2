process BLAST_FILTER_BITSCORE {
    tag "${meta.sample_id}"
    label 'short_serial'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/bioinfokit:2.1.3--pyh7cba7a3_0' :
        'quay.io/biocontainers/bioinfokit:2.1.3--pyh7cba7a3_0' }"

    input:
    tuple val(meta), path(report)

    output:
    path('*.filtered.tsv')   , emit: tsv
    path 'versions.yml'     , emit: versions

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: report.getSimpleName()

    """
    filter_blast.py --report $report --output ${prefix}.filtered.tsv $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version  | sed -e "s/Python //")
    END_VERSIONS
    """
}

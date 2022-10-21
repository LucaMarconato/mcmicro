import mcmicro.*

process spatialdata_post_illumination {
    container "${params.contPfx}${module.container}:${module.version}"

    // Specify the project subdirectory for writing the outputs to
    // The pattern: specification must match the output: files below
    // TODO: replace the pattern to match the output: clause below
    publishDir "${params.in}/spatialdata", mode: 'copy', pattern: "*"

    // Provenance
    publishDir "${Flow.QC(params.in, 'provenance')}", mode: 'copy', 
      pattern: '.command.{sh,log}',
      saveAs: {fn -> fn.replace('.command', "${module.name}-${task.index}")}
    
    // Inputs for the process
  input:
    val mcp
    val module
    //val process-name
    tuple path(raw), val(relPath)
    '''
    path markers
    path ffp //flat-field profiles
    path dfp // dark-field profiles
    '''

    // Process outputs that should be captured and 
    //  a) returned as results
    //  b) published to the project directory
    // TODO: replace *.html with the pattern of the tool output files
  output:
    path("*"), emit: spatialdata_post_illumination

    // Provenance files -- no change is needed here
    tuple path('.command.sh'), path('.command.log')

  when: mcp.workflow["spatialdata"]

    // The command to be executed inside the tool container
    // The command must write all outputs to the current working directory (.)
    // Opts.moduleOpts() will identify and return the appropriate module options --markers $markers --ffp $ffp --dfp $dfp
    """    
    python /home/scripts/converter.py -i $relPath -p "illumination" -o .  ${Opts.moduleOpts(module, mcp)}
    """
}

'''
process spatialdata_post_registration {
    container "${params.contPfx}${module.container}:${module.version}"

    // Specify the project subdirectory for writing the outputs to
    // The pattern: specification must match the output: files below
    // TODO: replace the pattern to match the output: clause below
    publishDir "${params.in}/spatialdata", mode: 'copy', pattern: "*"

    // Provenance
    publishDir "${Flow.QC(params.in, 'provenance')}", mode: 'copy', 
      pattern: '.command.{sh,log}',
      saveAs: {fn -> fn.replace('.command', "${module.name}-${task.index}")}
    
    // Inputs for the process
  input:
    val mcp
    val module
    //val process-name
    path registered_image

    // Process outputs that should be captured and 
    //  a) returned as results
    //  b) published to the project directory
    // TODO: replace *.html with the pattern of the tool output files
  output:
    path("*"), emit: spatialdata_post_registration

    // Provenance files -- no change is needed here
    tuple path('.command.sh'), path('.command.log')

  when: mcp.workflow["spatialdata"]

    // The command to be executed inside the tool container
    // The command must write all outputs to the current working directory (.)
    // Opts.moduleOpts() will identify and return the appropriate module options --markers $markers --ffp $ffp --dfp $dfp
    """    
    python /home/scripts/converter.py -i $registered_image -p "registration" -o .  ${Opts.moduleOpts(module, mcp)}
    """
}
'''




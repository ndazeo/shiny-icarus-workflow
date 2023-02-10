#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Score predictions file

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
    - $(inputs.script)
        


inputs:
  - id: script
    type: File
  - id: input
    type: File
  - id: goldstandard
    type: File
  - id: check_validation_finished
    type: boolean?

outputs:
  - id: results
    type: File
    outputBinding:
      glob: results.json
  - id: status
    type: string
    outputBinding:
      glob: results.json
      outputEval: $(JSON.parse(self[0].contents)['submission_status'])
      loadContents: true

baseCommand: python
arguments:
  - valueFrom: score.py
  - prefix: -ref
    valueFrom: $(inputs.goldstandard.path)
  - prefix: -pred
    valueFrom: $(inputs.input.path)
  - prefix: -r
    valueFrom: results.json

hints:
  DockerRequirement:
    dockerPull: ndazeo/shiny-icarus-evaluation

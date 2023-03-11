#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Prints results
baseCommand: python3


inputs:
  - id: script
    type: File
  - id: results
    type: File
  - id: submissionid
    type: int

arguments: 
  - valueFrom: $(inputs.script.path)
  - valueFrom: $(inputs.results)
    prefix: -f
  - valueFrom: $(inputs.submissionid)
    prefix: -s

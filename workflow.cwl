#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: shiny-icarus Evaluation
doc: >
  This workflow will run and evaluate Docker submissions to the
  shiny-icarus Challenge (syn123). Metrics returned are x, y, z.

requirements:
  - class: StepInputExpressionRequirement

inputs:
  submissionId:
    label: Submission ID
    type: int
  synapseConfig:
    label: filepath to .synapseConfig file
    type: File
  input:
    label: tar.gz with input data
    type: File
  goldstandard:
    label: tar.gz with goldstandard
    type: File

outputs: {}

steps:
  get_docker_submission:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/ChallengeWorkflowTemplates/v3.1/cwl/get_submission.cwl
    in:
      - id: submissionid
        source: "#submissionId"
      - id: synapse_config
        source: "#synapseConfig"
    out:
      - id: filepath
      - id: docker_repository
      - id: docker_digest
      - id: entity_id
      - id: entity_type
      - id: results

  get_docker_config:
    run: https://raw.githubusercontent.com/Sage-Bionetworks/ChallengeWorkflowTemplates/v3.1/cwl/get_docker_config.cwl
    in:
      - id: synapse_config
        source: "#synapseConfig"
    out: 
      - id: docker_registry
      - id: docker_authentication

  run_docker:
    run: steps/run_docker.cwl
    in:
      - id: docker_repository
        source: "#get_docker_submission/docker_repository"
      - id: docker_digest
        source: "#get_docker_submission/docker_digest"
      - id: submissionid
        source: "#submissionId"
      - id: docker_registry
        source: "#get_docker_config/docker_registry"
      - id: docker_authentication
        source: "#get_docker_config/docker_authentication"
      - id: synapse_config
        source: "#synapseConfig"
      - id: input_dir
        source: "#input"
      - id: docker_script
        default:
          class: File
          location: "scripts/run_docker.py"
    out:
      - id: predictions

  score:
    run: steps/score.cwl
    in:
      - id: input
        source: "#run_docker/predictions"
      - id: goldstandard
        source: "#goldstandard"
      - id: script
        default:
          class: File
          location: "scripts/score.py"
    out:
      - id: results

  print_results:
    run: steps/print_results.cwl
    in:
      - id: submissionid
        source: "#submissionId"
      - id: results
        source: "#score/results"
      - id: script
        default:
          class: File
          location: "scripts/print_results.py"
    out: []

outputs:
  scores:
    source: "#score/results"
  predictions:
    source: "#run_docker/predictions"
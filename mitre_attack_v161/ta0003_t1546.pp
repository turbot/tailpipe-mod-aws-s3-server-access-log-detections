locals {
  mitre_attack_v161_ta0003_t1546_common_tags = merge(local.mitre_attack_v161_ta0003_common_tags, {
    mitre_attack_technique_id = "T1546"
  })
}


benchmark "mitre_attack_v161_ta0003_t1546" {
  title = "T1546 Event Triggered Execution"
  type = "detection"
  documentation = file("./mitre_attack_v161/docs/ta0003_t1546.md")
  children = [
    detection.s3_object_accessed_publicly,
  ]

  tags = local.mitre_attack_v161_ta0003_t1546_common_tags
}
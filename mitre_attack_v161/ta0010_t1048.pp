locals {
  mitre_attack_v161_ta0010_t1048_common_tags = merge(local.mitre_attack_v161_ta0010_common_tags, {
    mitre_attack_technique_id = "T1048"
  })
}

benchmark "mitre_attack_v161_ta0010_t1048" {
  title         = "T1048 Exfiltration Over Alternative Protocol"
  type          = "detection"
  documentation = file("./mitre_attack_v161/docs/ta0010_t1048.md")
  children = [
    detection.s3_object_accessed_with_large_request_size,
    detection.s3_object_accessed_with_large_response_size,
  ]

  tags = local.mitre_attack_v161_ta0010_t1048_common_tags
}
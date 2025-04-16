locals {
  mitre_attack_v161_ta0009_t1119_common_tags = merge(local.mitre_attack_v161_ta0009_common_tags, {
    mitre_attack_technique_id = "T1119"
  })
}

benchmark "mitre_attack_v161_ta0009_t1119" {
  title         = "T1119 Automated Collection"
  type          = "detection"
  documentation = file("./mitre_attack_v161/docs/ta0009_t1119.md")
  children = [
    detection.s3_object_accessed_using_suspicious_user_agent,
  ]

  tags = local.mitre_attack_v161_ta0009_t1119_common_tags
}
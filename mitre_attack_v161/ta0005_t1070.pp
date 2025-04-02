locals {
  mitre_attack_v161_ta0005_t1070_common_tags = merge(local.mitre_attack_v161_ta0005_common_tags, {
    mitre_attack_technique_id = "T1070"
  })
}

benchmark "mitre_attack_v161_ta0005_t1070" {
  title         = "T1070 Indicator Removal"
  type          = "detection"
  documentation = file("./mitre_attack_v161/docs/ta0005_t1070.md")
  children = [
    detection.s3_bucket_acl_granted_public_access,
    detection.s3_bucket_logging_disabled,
    detection.s3_bucket_policy_granted_public_access,
    detection.s3_bucket_public_access_block_disabled,
  ]

  tags = local.mitre_attack_v161_ta0005_t1070_common_tags
}


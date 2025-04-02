locals {
  mitre_attack_v161_ta0001_t1190_common_tags = merge(local.mitre_attack_v161_ta0001_common_tags, {
    mitre_attack_technique_id = "T1190"
  })
}

benchmark "mitre_attack_v161_ta0001_t1190" {
  title         = "T1190 Exploit Public-Facing Application"
  type          = "detection"
  documentation = file("./mitre_attack_v161/docs/ta0001_t1190.md")
  children = [
    detection.s3_bucket_acl_granted_public_access,
    detection.s3_bucket_policy_granted_public_access,
    detection.s3_bucket_public_access_block_disabled,
  ]

  tags = local.mitre_attack_v161_ta0001_t1190_common_tags
}

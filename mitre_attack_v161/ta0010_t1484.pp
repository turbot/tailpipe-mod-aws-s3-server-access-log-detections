locals {
  mitre_attack_v161_ta0010_t1484_common_tags = merge(local.mitre_attack_v161_ta0010_common_tags, {
    mitre_attack_technique_id = "t1484"
  })
}

benchmark "mitre_attack_v161_ta0010_t1484" {
  title         = "T1484 	Domain or Tenant Policy Modification"
  type          = "detection"
  documentation = file("./mitre_attack_v161/docs/ta0010_t1484.md")
  children = [
    detection.s3_bucket_acl_granted_public_access,
    detection.s3_bucket_policy_granted_public_access,
    detection.s3_bucket_public_access_block_disabled,
  ]

  tags = local.mitre_attack_v161_ta0010_t1484_common_tags
}

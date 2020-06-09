# Create Key Pairss
resource "aws_key_pair" "key_pairs" {
  for_each = var.key-pairs-vars
  key_name = each.value["key_name"]
  public_key = each.value["pub_key"]
}

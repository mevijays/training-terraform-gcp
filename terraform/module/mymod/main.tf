resource "local_file" "foo" {
    content  = "foo! content is this ${var.name}"
    filename = "${path.module}/foo${var.name}.txt"
}

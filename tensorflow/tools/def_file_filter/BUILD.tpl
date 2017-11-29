# Description:
# Tools for filtering DEF file for TensorFlow on Windows

package(default_visibility = ["//visibility:public"])

py_binary(
    name = "def_file_filter",
    srcs = ["def_file_filter.py"],
    srcs_version = "PY2AND3",
)

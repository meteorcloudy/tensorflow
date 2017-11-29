"""Repository rule for def file filter autoconfiguration.

`def_file_filter_config` depends on the following environment variables:
  * `BAZEL_VC`
  * `BAZEL_VS`
  * `VS90COMNTOOLS`
  * `VS100COMNTOOLS`
  * `VS110COMNTOOLS`
  * `VS120COMNTOOLS`
  * `VS140COMNTOOLS`
"""

load("@bazel_tools//tools/cpp:windows_cc_configure.bzl", "find_vc_path")
load("@bazel_tools//tools/cpp:windows_cc_configure.bzl", "find_msvc_tool")
load("@bazel_tools//tools/cpp:lib_cc_configure.bzl", "auto_configure_fail")

def _def_file_filter_configure_impl(repository_ctx):
  vc_path = find_vc_path(repository_ctx)
  if vc_path == "visual-studio-not-found":
    auto_configure_fail("Visual C++ build tools not found on your machine")
  undname_bin_path = find_msvc_tool(repository_ctx, vc_path, "undname.exe").replace("\\", "\\\\")

  repository_ctx.template(
    "def_file_filter.py",
    Label("//tensorflow/tools/def_file_filter:def_file_filter.py.tpl"),
    {
      "%{undname_bin_path}": undname_bin_path,
    })
  repository_ctx.symlink(Label("//tensorflow/tools/def_file_filter:BUILD.tpl"), "BUILD")


def_file_filter_configure = repository_rule(
    implementation = _def_file_filter_configure_impl,
    environ = [
        "BAZEL_VC",
        "BAZEL_VS",
        "VS90COMNTOOLS",
        "VS100COMNTOOLS",
        "VS110COMNTOOLS",
        "VS120COMNTOOLS",
        "VS140COMNTOOLS"
    ],
)

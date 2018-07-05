# Copyright 2015 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

load(
    "@bazel_tools//tools/cpp:lib_cc_configure.bzl",
    "auto_configure_fail",
    "auto_configure_warning",
    "escape_string",
    "get_env_var",
    "which_cmd",
)

load(
    "@bazel_tools//tools/cpp:windows_cc_configure.bzl",
    "setup_vc_env_vars",
    "find_msvc_tool",
    "find_vc_path",
)

def find_python_on_windows(repository_ctx):
    """Find where python is on Windows."""
    if "BAZEL_PYTHON" in repository_ctx.os.environ:
        python_binary = repository_ctx.os.environ["BAZEL_PYTHON"]
        if not python_binary.endswith(".exe"):
            python_binary = python_binary + ".exe"
        return python_binary
    auto_configure_warning("'BAZEL_PYTHON' is not set, start looking for python in PATH.")
    python_binary = which_cmd(repository_ctx, "python.exe")
    auto_configure_warning("Python found at %s" % python_binary)
    return python_binary

def get_nvcc_tmp_dir(repository_ctx):
    """Return the tmp directory for nvcc to generate intermediate source files."""
    escaped_tmp_dir = escape_string(
        get_env_var(repository_ctx, "TMP", "C:\\Windows\\Temp").replace("\\", "\\\\"),
    )
    return escaped_tmp_dir + "\\\\nvcc_inter_files_tmp_dir"

def get_msvc_compiler(repository_ctx):
    vc_path = find_vc_path(repository_ctx)
    return find_msvc_tool(repository_ctx, vc_path, "cl.exe").replace("\\", "/")

def get_win_cuda_defines(repository_ctx, is_windows):
    """Return CROSSTOOL defines for Windows"""
    # If we are not on Windows, return empty vaules for Windows specific fields.
    # This ensures the CROSSTOOL file parser is happy.
    if not is_windows:
        return {
            "%{msvc_env_tmp}": "",
            "%{msvc_env_path}": "",
            "%{msvc_env_include}": "",
            "%{msvc_env_lib}": "",
            "%{msvc_cl_path}": "",
            "%{msvc_ml_path}": "",
            "%{msvc_link_path}": "",
            "%{msvc_lib_path}": "",
            "%{cxx_builtin_include_directory}": "",
    }

    vc_path = find_vc_path(repository_ctx)
    if not vc_path:
        auto_configure_fail("Visual C++ build tools not found on your machine." +
                            "Please check your installation following https://docs.bazel.build/versions/master/windows.html#using")
        return {}

    env = setup_vc_env_vars(repository_ctx, vc_path)
    escaped_paths = escape_string(env["PATH"])
    escaped_include_paths = escape_string(env["INCLUDE"])
    escaped_lib_paths = escape_string(env["LIB"])
    escaped_tmp_dir = escape_string(
        get_env_var(repository_ctx, "TMP", "C:\\Windows\\Temp").replace("\\", "\\\\"),
    )

    msvc_cl_path = "windows/wrapper/msvc_cl.bat"
    msvc_ml_path = find_msvc_tool(repository_ctx, vc_path, "ml64.exe").replace("\\", "/")
    msvc_link_path = find_msvc_tool(repository_ctx, vc_path, "link.exe").replace("\\", "/")
    msvc_lib_path = find_msvc_tool(repository_ctx, vc_path, "lib.exe").replace("\\", "/")

    # nvcc will generate some temporary source files under %{nvcc_tmp_dir_name}
    # The generated files are guranteed to have unique name, so they can share the same tmp directory
    escaped_cxx_include_directories = ["cxx_builtin_include_directory: \"%s\"" % get_nvcc_tmp_dir(repository_ctx)]
    for path in escaped_include_paths.split(";"):
        if path:
            escaped_cxx_include_directories.append("cxx_builtin_include_directory: \"%s\"" % path)

    return {
            "%{msvc_env_tmp}": escaped_tmp_dir,
            "%{msvc_env_path}": escaped_paths,
            "%{msvc_env_include}": escaped_include_paths,
            "%{msvc_env_lib}": escaped_lib_paths,
            "%{msvc_cl_path}": msvc_cl_path,
            "%{msvc_ml_path}": msvc_ml_path,
            "%{msvc_link_path}": msvc_link_path,
            "%{msvc_lib_path}": msvc_lib_path,
            "%{cxx_builtin_include_directory}": "\n".join(escaped_cxx_include_directories),
    }

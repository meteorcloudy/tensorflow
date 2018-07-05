licenses(["restricted"])  # MPL2, portions GPL v3, LGPL v3, BSD-like

package(default_visibility = ["//visibility:public"])

config_setting(
    name = "using_nvcc",
    values = {
        "define": "using_cuda_nvcc=true",
    },
)

config_setting(
    name = "using_clang",
    values = {
        "define": "using_cuda_clang=true",
    },
)

# Equivalent to using_clang && -c opt.
config_setting(
    name = "using_clang_opt",
    values = {
        "define": "using_cuda_clang=true",
        "compilation_mode": "opt",
    },
)

config_setting(
    name = "darwin",
    values = {"cpu": "darwin"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "freebsd",
    values = {"cpu": "freebsd"},
    visibility = ["//visibility:public"],
)

config_setting(
    name = "windows",
    values = {"cpu": "x64_windows"},
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cuda_headers",
    hdrs = [
        "cuda/cuda_config.h",
        %{cuda_headers}
    ],
    includes = [
        ".",
        "cuda/include",
        "cuda/include/crt",
    ],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cudart_static",
    srcs = ["cuda/lib/%{cudart_static_lib}"],
    linkopts = select({
        ":freebsd": [],
        "//conditions:default": ["-ldl"],
    }) + [
        "-lpthread",
        %{cudart_static_linkopt}
    ],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "cuda_driver",
    %{library_attribute_name} = "cuda/lib/%{cuda_driver_lib}",
    system_provided = 1,
    visibility = ["//visibility:public"],
)

cc_import(
    name = "cudart",
    %{library_attribute_name} = "cuda/lib/%{cudart_lib}",
    system_provided = 1,
    visibility = ["//visibility:public"],
)

cc_import(
    name = "cublas",
    %{library_attribute_name} = "cuda/lib/%{cublas_lib}",
    system_provided = 1,
    visibility = ["//visibility:public"],
)

cc_import(
    name = "cusolver_import",
    %{library_attribute_name} = "cuda/lib/%{cusolver_lib}",
    system_provided = 1,
)

cc_library(
    name = "cusolver",
    deps = [":cusolver_import"],
    linkopts = ["-lgomp"],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "cudnn",
    %{library_attribute_name} = "cuda/lib/%{cudnn_lib}",
    system_provided = 1,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cudnn_header",
    includes = [
        ".",
        "cuda/include",
    ],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "cufft",
    %{library_attribute_name} = "cuda/lib/%{cufft_lib}",
    system_provided = 1,
    visibility = ["//visibility:public"],
)

cc_import(
    name = "curand",
    %{library_attribute_name} = "cuda/lib/%{curand_lib}",
    system_provided = 1,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "cuda",
    visibility = ["//visibility:public"],
    deps = [
        ":cublas",
        ":cuda_headers",
        ":cudart",
        ":cudnn",
        ":cufft",
        ":curand",
    ],
)

cc_library(
    name = "cupti_headers",
    hdrs = [
        "cuda/cuda_config.h",
        ":cuda-extras",
    ],
    includes = [
        ".",
        "cuda/extras/CUPTI/include/",
    ],
    visibility = ["//visibility:public"],
)

cc_import(
    name = "cupti_dsos",
    %{library_attribute_name} = "cuda/lib/%{cupti_lib}",
    system_provided = 1,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "libdevice_root",
    data = [":cuda-nvvm"],
    visibility = ["//visibility:public"],
)

%{cuda_include_genrules}

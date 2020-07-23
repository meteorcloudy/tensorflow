licenses(["notice"])

filegroup(
    name = "LICENSE",
    visibility = ["//visibility:public"],
)

cc_library(
    name = "crypto",
    linkopts = ["-L/usr/lib/x86_64-linux-gnu/android", "-lcrypto"],
    visibility = ["//visibility:public"],
)

cc_library(
    name = "ssl",
    linkopts = ["-L/usr/lib/x86_64-linux-gnu/android", "-lssl"],
    visibility = ["//visibility:public"],
    deps = [
        ":crypto",
    ],
)

/* Copyright 2020 The TensorFlow Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

#include <memory>
#include <stdexcept>
#include <string>
#include <unordered_map>

#include "pybind11/pybind11.h"
#include "tensorflow/core/common_runtime/device.h"
#include "tensorflow/core/common_runtime/device_factory.h"
#include "tensorflow/core/framework/device_attributes.pb.h"
#include "tensorflow/core/framework/device_base.h"
#include "tensorflow/core/framework/graph.pb.h"
#include "tensorflow/core/framework/graph_def_util.h"
#include "tensorflow/core/grappler/clusters/cluster.h"
#include "tensorflow/core/grappler/clusters/utils.h"
#include "tensorflow/core/grappler/grappler_item.h"
#include "tensorflow/core/grappler/grappler_item_builder.h"
#include "tensorflow/core/grappler/optimizers/meta_optimizer.h"
#include "tensorflow/core/protobuf/config.pb.h"
#include "tensorflow/core/protobuf/device_properties.pb.h"
#include "tensorflow/core/protobuf/meta_graph.pb.h"
#include "tensorflow/core/public/session_options.h"
#include "tensorflow/python/lib/core/pybind11_status.h"

int main() {
  tensorflow::grappler::MetaOptimizer optimizer(nullptr, "");
  return 0;
}

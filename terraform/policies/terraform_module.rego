package terraform.module

deny contains msg if {
	some r
	desc := resources[r].values.description
	contains(desc, "HTTP")
	msg := sprintf("No security groups should be using HTTP. Resource in violation: %v", [r.address])
}

resources contains r if {
	some path, value

	# Walk over the JSON tree and check if the node we are
	# currently on is a module (either root or child) resources
	# value.
	walk(input.planned_values, [path, value])

	# Look for resources in the current value based on path
	some r in module_resources(path, value)
}

# Variant to match root_module resources
module_resources(path, value) := value if {
	# Expect something like:
	#
	#     {
	#     	"root_module": {
	#         	"resources": [...],
	#             ...
	#         }
	#         ...
	#     }
	#
	# Where the path is [..., "root_module", "resources"]

	reverse_index(path, 1) == "resources"
	reverse_index(path, 2) == "root_module"
}

# Variant to match child_modules resources
module_resources(path, value) := value if {
	# Expect something like:
	#
	#     {
	#     	...
	#         "child_modules": [
	#         	{
	#             	"resources": [...],
	#                 ...
	#             },
	#             ...
	#         ]
	#         ...
	#     }
	#
	# Where the path is [..., "child_modules", 0, "resources"]
	# Note that there will always be an index int between `child_modules`
	# and `resources`. We know that walk will only visit each one once,
	# so we shouldn't need to keep track of what the index is.

	reverse_index(path, 1) == "resources"
	reverse_index(path, 3) == "child_modules"
}

reverse_index(path, idx) := path[count(path) - idx]
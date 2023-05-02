using PerforatedCylinder

# Paths
const project_root = "../.."
const data_dir = project_root * "/data"
const OVERWRITE = true

# Define cases
println("Generating meshes...")
n = 12:13

mesh_cases = PerforatedCylinder.generate_meshes(; nperf=n, do_mesh=true)

using DelimitedFiles
writedlm("generated_meshes.txt", mesh_cases)
